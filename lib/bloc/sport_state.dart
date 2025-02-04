// lib/bloc/sport_state.dart
import 'package:equatable/equatable.dart';
import '../models/sport_match.dart';

abstract class SportState extends Equatable {
  const SportState();

  @override
  List<Object> get props => [];
}

class SportInitial extends SportState {}

class SportLoading extends SportState {}

class SportLoaded extends SportState {
  final List<SportMatch> sports;
  final String matchDate;
  final String matchLanguage;

  const SportLoaded(this.sports, this.matchDate, this.matchLanguage);

  @override
  List<Object> get props => [sports, matchDate];
}

class SportError extends SportState {
  final String message;

  const SportError(this.message);

  @override
  List<Object> get props => [message];
}

class MatchUpdated extends SportState {
  final String matchId;

  const MatchUpdated(this.matchId);

  @override
  List<Object> get props => [matchId];
}

class ShowDatePickerState extends SportState {
  final String matchLanguage;

  const ShowDatePickerState({this.matchLanguage = "NBA"});
}