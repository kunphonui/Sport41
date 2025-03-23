// lib/bloc/trade_state.dart
import 'package:equatable/equatable.dart';
import '../models/sport_match.dart';

abstract class SportState extends Equatable {
  SportState();

  final initialTime = DateTime.now();

  @override
  List<Object> get props => [initialTime];
}

class SportInitial extends SportState {}

class SportLoading extends SportState {}

class SportLoaded extends SportState {
  final List<SportMatch> sports;
  final String matchDate;
  final String matchLanguage;

  SportLoaded(this.sports, this.matchDate, this.matchLanguage);

}

class SportError extends SportState {
  final String message;

  SportError(this.message);
}

class MatchUpdated extends SportState {
  final String matchId;

  MatchUpdated(this.matchId);
}

class ShowDatePickerState extends SportState {
  final String matchLanguage;

  ShowDatePickerState({this.matchLanguage = "NBA"});
}

class UpdateAllMatchesSuccess extends SportState {}

class UpdateAllMatchesFailure extends SportState {
  final String message;

  UpdateAllMatchesFailure(this.message);
}