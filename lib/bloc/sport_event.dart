// lib/bloc/sport_event.dart
import 'package:equatable/equatable.dart';

abstract class SportEvent extends Equatable {
  const SportEvent();

  @override
  List<Object?> get props => [];
}

class FetchSports extends SportEvent {
  final String matchDate;
  final String matchLeague;

  const FetchSports(this.matchDate, {this.matchLeague = "NBA"});

  @override
  List<Object> get props => [matchDate, matchLeague];
}

class UpdateMatch extends SportEvent {
  final String matchId;
  final double? homeTeamOdds;
  final double? awayTeamOdds;
  final double? drawOdds;
  final String? predictedWinner;

  const UpdateMatch({
    required this.matchId,
    this.homeTeamOdds,
    this.awayTeamOdds,
    this.drawOdds,
    this.predictedWinner,
  });

  @override
  List<Object?> get props => [matchId, homeTeamOdds, awayTeamOdds, drawOdds, predictedWinner];
}