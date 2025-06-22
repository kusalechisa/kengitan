import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'profile_setup_event.dart';
import 'profile_setup_state.dart';

@injectable
class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  ProfileSetupBloc() : super(const ProfileSetupState()) {
    on<NameChanged>(_onNameChanged);
    on<GoalChanged>(_onGoalChanged);
    on<InterestSelected>(_onInterestSelected);
    on<FormSubmitted>(_onFormSubmitted);
  }

  void _onNameChanged(NameChanged event, Emitter<ProfileSetupState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onGoalChanged(GoalChanged event, Emitter<ProfileSetupState> emit) {
    emit(state.copyWith(goal: event.goal));
  }

  void _onInterestSelected(InterestSelected event, Emitter<ProfileSetupState> emit) {
    final interests = List<String>.from(state.interests);
    if (interests.contains(event.interest)) {
      interests.remove(event.interest);
    } else {
      interests.add(event.interest);
    }
    emit(state.copyWith(interests: interests));
  }

  Future<void> _onFormSubmitted(FormSubmitted event, Emitter<ProfileSetupState> emit) async {
    emit(state.copyWith(status: FormSubmissionStatus.submitting));
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request
    emit(state.copyWith(status: FormSubmissionStatus.success));
  }
} 