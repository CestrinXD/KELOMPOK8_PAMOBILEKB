import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sofa_score/models/data.dart';

Future<List<Map<String, dynamic>>> fetchMatchesForTeam(int teamId) async {
  const url = 'https://api.football-data.org/v4/competitions/PL/matches';
  const headers = {
    'X-Auth-Token': '998b16130d4c49dd93253380d7284154',
  };

  matchTeam.clear();

  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print(data);
      }

      // Menyaring pertandingan berdasarkan ID tim (cari di homeTeam atau awayTeam)
      for (var match in data['matches']) {
        if (match['homeTeam']['id'] == teamId ||
            match['awayTeam']['id'] == teamId) {
          // Cek apakah match dengan ID ini sudah ada di matchTeam
          final existingMatch = matchTeam.any((item) => item['id'] == match['id']);
          if (!existingMatch) {
            matchTeam.add({
              'id': match['id'],
              'idHome': match['homeTeam']['id'],
              'idAway': match['awayTeam']['id'],
              'homeTeam': match['homeTeam']['shortName'],
              'awayTeam': match['awayTeam']['shortName'],
              'scoreA': match['score']['fullTime']['home'] ?? 0,
              'scoreB': match['score']['fullTime']['away'] ?? 0,
              'utcDate': match['utcDate'],
              'status': match['status'],
              'matchday': match['matchday'],
              'stage': match['stage'],
              'homeCrest': match['homeTeam']['crest'],
              'awayCrest': match['awayTeam']['crest'],
              'area': match['area']['name'],
              'competition': match['competition']['name'],
            });
          }
        }
      }

      if (kDebugMode) {
        print('Filtered matches: $matchTeam');
      }

      return matchTeam;
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
