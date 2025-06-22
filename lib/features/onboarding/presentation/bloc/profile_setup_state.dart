import 'package:equatable/equatable.dart';

enum FormSubmissionStatus { initial, submitting, success, failure }

class ProfileSetupState extends Equatable {
  const ProfileSetupState({
    this.name = '',
    this.goal = '',
    this.interests = const [],
    this.status = FormSubmissionStatus.initial,
  });

  final String name;
  final String goal;
  final List<String> interests;
  final FormSubmissionStatus status;

  ProfileSetupState copyWith({
    String? name,
    String? goal,
    List<String>? interests,
    FormSubmissionStatus? status,
  }) {
    return ProfileSetupState(
      name: name ?? this.name,
      goal: goal ?? this.goal,
      interests: interests ?? this.interests,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [name, goal, interests, status];
}
