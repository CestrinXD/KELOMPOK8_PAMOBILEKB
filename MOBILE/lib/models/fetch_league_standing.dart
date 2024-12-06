import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sofa_score/models/data.dart';

Future<List<Map<String, dynamic>>> fetchLeagueStandings() async {
  const url = 'https://api.football-data.org/v4/competitions/PL/standings';
  const headers = {
    'X-Auth-Token': '998b16130d4c49dd93253380d7284154',
  };

  leagueData.clear();

  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List standing = data['standings'][0]['table'] ?? [];
      if (kDebugMode) {
        print("Received standings count: ${standing.length}");
      }

      for (var team in standing) {
        leagueData.add({
          'position': team['position'],
          'teamName': team['team']['shortName'] ?? team['team']['name'],
          'points': team['points'],
          'playedGames': team['playedGames'],
          'wins': team['won'],
          'draws': team['draw'],
          'losses': team['lost'],
          'goalsFor': team['goalsFor'],
          'goalsAgainst': team['goalsAgainst'],
          'goalDifference': team['goalDifference'],
          'form': team['form'],
          'crestUrl': team['team']['crest'],
        });
      }
      print(leagueData);

      return leagueData;
    } else {
      if (kDebugMode) {
        print('Failed to load matches: ${response.statusCode}');
      }
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching match data: $e');
    }
    return [];
  }
}

Future<Map<String, dynamic>> fetchStanding(int idHome, int idAway) async {
  try {
    // Ambil data liga
    List<Map<String, dynamic>> standings = await fetchLeagueStandings();

    // Cari tim home berdasarkan `idHome`
    var homeTeam = standings.firstWhere(
      (team) => team['teamId'] == idHome,
      orElse: () => {},
    );

    // Cari tim away berdasarkan `idAway`
    var awayTeam = standings.firstWhere(
      (team) => team['teamId'] == idAway,
      orElse: () => {},
    );

    if (homeTeam.isNotEmpty && awayTeam.isNotEmpty) {
      return {
        "homeTeamGol": homeTeam['goalsFor'] ?? 0, // Gol yang dicetak oleh tim home
        "awayTeamGol": awayTeam['goalsFor'] ?? 0, // Gol yang dicetak oleh tim away
        "homeTeamPoint": homeTeam['points'] ?? 0, // Poin tim home
        "awayTeamPoint": awayTeam['points'] ?? 0, // Poin tim away
        "goalDifferents": homeTeam['goalDifference'] ?? 0, // Selisih gol tim home
      };
    } else {
      // Jika salah satu tim tidak ditemukan, kembalikan nilai default
      return {
        "homeTeamGol": 0,
        "awayTeamGol": 0,
        "homeTeamPoint": 0,
        "awayTeamPoint": 0,
        "goalDifferents": 0,
      };
    }
  } catch (error) {
    debugPrint('Error in fetchStanding: $error');
    return {
      "homeTeamGol": 0,
      "awayTeamGol": 0,
      "homeTeamPoint": 0,
      "awayTeamPoint": 0,
      "goalDifferents": 0,
    };
  }
}
