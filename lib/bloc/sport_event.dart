// lib/bloc/sport_event.dart
import 'package:equatable/equatable.dart';

abstract class SportEvent extends Equatable {
  SportEvent();

  final initialTime = DateTime.now();
  @override
  List<Object?> get props => [initialTime];
}

class FetchSports extends SportEvent {
  final String matchDate;
  final String matchLeague;

  FetchSports(this.matchDate, {this.matchLeague = "NBA"});
}

class UpdateMatch extends SportEvent {
  final String matchId;
  final double? homeTeamOdds;
  final double? awayTeamOdds;
  final double? drawOdds;
  final String? predictedWinner;

  UpdateMatch({
    required this.matchId,
    this.homeTeamOdds,
    this.awayTeamOdds,
    this.drawOdds,
    this.predictedWinner,
  });

}

class ShowDatePicker extends SportEvent {
  final String matchLanguage;

  ShowDatePicker(this.matchLanguage);
}

class UpdateAllMatches extends SportEvent {}
