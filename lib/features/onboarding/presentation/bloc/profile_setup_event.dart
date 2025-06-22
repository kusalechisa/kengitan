import 'package:equatable/equatable.dart';

abstract class ProfileSetupEvent extends Equatable {
  const ProfileSetupEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends ProfileSetupEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class GoalChanged extends ProfileSetupEvent {
  const GoalChanged(this.goal);

  final String goal;

  @override
  List<Object> get props => [goal];
}

class InterestSelected extends ProfileSetupEvent {
  const InterestSelected(this.interest);

  final String interest;

  @override
  List<Object> get props => [interest];
}

class FormSubmitted extends ProfileSetupEvent {}
