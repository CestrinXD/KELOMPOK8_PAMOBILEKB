import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sofa_score/models/data.dart';

Future<List<Map<String, dynamic>>> fetchTopScorers() async {
  const url = 'https://api.football-data.org/v4/competitions/PD/scorers';
  const headers = {
    'X-Auth-Token': '998b16130d4c49dd93253380d7284154',
  };

  topScoreData.clear();

  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List fetchedTopScored = data['scorers'] ?? [];

      for (var topScore in fetchedTopScored) {
        topScoreData.add({
          'playerName': topScore['player']['name'],
          'teamName': topScore['team']['shortName'],
          'position': topScore['player']['position'] ?? 'Unknown Position',
          'goals': topScore['goals'] ?? 0,
          'assist': topScore['assists'] ?? 0,
          'penalties': topScore['penalties'] ?? 0,
        });
      }

      return matchData;
    } else {
      if (kDebugMode) {
        print('Failed to load top score: ${response.statusCode}');
      }
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching top score: $e');
    }
    return [];
  }
}
