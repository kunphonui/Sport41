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

  const SportLoaded(this.sports);

  @override
  List<Object> get props => [sports];
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