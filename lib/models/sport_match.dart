import 'package:equatable/equatable.dart';

class SportMatch extends Equatable {
  final String awayTeamName;
  final double? awayTeamOdds;
  final int? awayTeamScore;
  final double? drawOdds;
  final String homeTeamName;
  final double? homeTeamOdds;
  final int? homeTeamScore;
  final int isComplete;
  final DateTime? lastUpdated;
  final DateTime matchDate;
  final String matchId;
  final String matchLeague;
  final int? oddsCount;
  final String? predictedWinner;
  final double? predictedWinnerOdds;
  final String sport;
  final int? t10m;
  final int? t12h;
  final int? t24h;
  final int? t4h;

  const SportMatch({
    required this.awayTeamName,
    required this.awayTeamOdds,
    this.awayTeamScore,
    this.drawOdds,
    required this.homeTeamName,
    required this.homeTeamOdds,
    this.homeTeamScore,
    required this.isComplete,
    this.lastUpdated,
    required this.matchDate,
    required this.matchId,
    required this.matchLeague,
    required this.oddsCount,
    this.predictedWinner,
    this.predictedWinnerOdds,
    required this.sport,
    this.t10m,
    this.t12h,
    this.t24h,
    this.t4h,
  });

  factory SportMatch.fromJson(Map<String, dynamic> json) {
    return SportMatch(
      awayTeamName: json['awayTeamName'],
      awayTeamOdds: json['awayTeamOdds']?.toDouble(),
      awayTeamScore: json['awayTeamScore'],
      drawOdds: json['drawOdds']?.toDouble(),
      homeTeamName: json['homeTeamName'],
      homeTeamOdds: json['homeTeamOdds']?.toDouble(),
      homeTeamScore: json['homeTeamScore'],
      isComplete: json['isComplete'],
      lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated']) : null,
      matchDate: DateTime.parse(json['matchDate']),
      matchId: json['matchId'],
      matchLeague: json['matchLeague'],
      oddsCount: json['oddsCount'],
      predictedWinner: json['predictedWinner'],
      predictedWinnerOdds: json['predictedWinnerOdds']?.toDouble(),
      sport: json['sport'],
      t10m: json['t10m'],
      t12h: json['t12h'],
      t24h: json['t24h'],
      t4h: json['t4h'],
    );
  }

  @override
  List<Object?> get props => [
        awayTeamName,
        awayTeamOdds,
        awayTeamScore,
        drawOdds,
        homeTeamName,
        homeTeamOdds,
        homeTeamScore,
        isComplete,
        lastUpdated,
        matchDate,
        matchId,
        matchLeague,
        oddsCount,
        predictedWinner,
        predictedWinnerOdds,
        sport,
        t10m,
        t12h,
        t24h,
        t4h,
      ];
}