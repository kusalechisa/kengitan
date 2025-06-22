import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kengitan/core/di/injection.dart';
import 'package:kengitan/features/onboarding/presentation/bloc/profile_setup_bloc.dart';
import 'package:kengitan/features/onboarding/presentation/bloc/profile_setup_event.dart';
import 'package:kengitan/features/onboarding/presentation/bloc/profile_setup_state.dart';
import 'package:rive/rive.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final List<String> _interests = [
    'Lose weight',
    'Find love',
    'Learn to code',
    'Get a job',
    'Start a business'
  ];
  SMIInput<double>? _stateInput;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'controller');
    artboard.addController(controller!);
    _stateInput = controller.findInput<double>('state');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileSetupBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tell us about yourself')),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ProfileSetupBloc, ProfileSetupState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == FormSubmissionStatus.success) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Success!'),
                      content: const Text('Your profile has been created.'),
                      actions: [
                        TextButton(
                          onPressed: () => context.go('/home'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            BlocListener<ProfileSetupBloc, ProfileSetupState>(
              listenWhen: (previous, current) =>
                  previous.interests != current.interests,
              listener: (context, state) {
                if (state.interests.isNotEmpty) {
                  final lastInterest = state.interests.last;
                  final index = _interests.indexOf(lastInterest);
                  if (index != -1) {
                    _stateInput?.value = index.toDouble();
                  }
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 200,
                  child: RiveAnimation.asset(
                    'assets/rive/animated_character.riv',
                    onInit: _onRiveInit,
                    stateMachines: const ['controller'],
                  ),
                ),
                const SizedBox(height: 24),
                _NameField(),
                const SizedBox(height: 16),
                _GoalField(),
                const SizedBox(height: 24),
                const Text('What are your interests?',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
                  builder: (context, state) {
                    return Wrap(
                      spacing: 8.0,
                      children: _interests.map((interest) {
                        return ChoiceChip(
                          label: Text(interest),
                          selected: state.interests.contains(interest),
                          onSelected: (_) {
                            context
                                .read<ProfileSetupBloc>()
                                .add(InterestSelected(interest));
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
      builder: (context, state) {
        return TextFormField(
          onChanged: (value) =>
              context.read<ProfileSetupBloc>().add(NameChanged(value)),
          decoration: const InputDecoration(labelText: 'Name'),
        );
      },
    );
  }
}

class _GoalField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
      builder: (context, state) {
        return TextFormField(
          onChanged: (value) =>
              context.read<ProfileSetupBloc>().add(GoalChanged(value)),
          decoration: const InputDecoration(labelText: 'Goal'),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.status == FormSubmissionStatus.submitting
              ? null
              : () => context.read<ProfileSetupBloc>().add(FormSubmitted()),
          child: state.status == FormSubmissionStatus.submitting
              ? const CircularProgressIndicator()
              : const Text('Submit'),
        );
      },
    );
  }
}
