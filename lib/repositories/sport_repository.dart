// lib/repositories/sport_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sport_match.dart';

class SportRepository {
  final String apiUrl = 'http://92.43.29.102:20230/get_data';

  Future<List<SportMatch>> fetchSports(String matchDate,
      {String matchLeague = "NBA"}) async {
    final response = await http.get(
        Uri.parse('$apiUrl?matchDate=$matchDate&matchLeague=$matchLeague'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      return jsonResponse.map((sport) => SportMatch.fromJson(sport)).toList();
    } else {
      throw Exception('Failed to load sports');
    }
  }

  Future<void> updateMatch(String matchId,
      {double? homeTeamOdds,
      double? awayTeamOdds,
      double? drawOdds,
      String? predictedWinner}) async {
    final response = await http.post(
      Uri.parse('http://92.43.29.102:20230/update_data'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'matchId': matchId,
        'homeTeamOdds': homeTeamOdds,
        'awayTeamOdds': awayTeamOdds,
        'drawOdds': drawOdds,
        'predictedWinner': predictedWinner,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update match');
    }
  }
}
