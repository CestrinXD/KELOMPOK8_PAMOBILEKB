import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sofa_score/models/data.dart';

Future<List<Map<String, dynamic>>> fetchMatchDetails(int matchId) async {
  final url = 'https://api.football-data.org/v4/matches/$matchId';
  final headers = {
    'X-Auth-Token': '998b16130d4c49dd93253380d7284154',
  };

  matchDetail.clear();

  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Memformat data JSON menjadi lebih mudah dibaca (pretty-print)
      final prettyJson = const JsonEncoder.withIndent('  ').convert(data);
      if (kDebugMode) {
        print(prettyJson); // Menampilkan data yang diformat
      }

      final referee = data['referees']?.firstWhere(
        (ref) => ref['type'] == 'REFEREE',
        orElse: () => null,
      )?['name'];

      // Mengambil informasi umum pertandingan
      var matchInfo = {
        'id': data['id'],
        'idHome': data['homeTeam']['id'],
        'idAway': data['awayTeam']['id'],
        'status': data['status'],
        'utcDate': data['utcDate'],
        'matchday': data['matchday'] ?? 0,
        'area': data['area']['name'],
        'competition': data['competition']['name'],
        'homeTeam': data['homeTeam']['shortName'],
        'homeTeamF': data['homeTeam']['name'],
        'awayTeam': data['awayTeam']['shortName'],
        'awayTeamF': data['awayTeam']['name'],
        'homeCrest': data['homeTeam']['crest'],
        'awayCrest': data['awayTeam']['crest'],
        'referee': referee,
        'scoreHome': data['score']['fullTime']['home'] ?? 0,
        'scoreAway': data['score']['fullTime']['away'] ?? 0,
      };

      if (kDebugMode) {
        print(matchInfo);
      }
      matchDetail.add(matchInfo);

      return [{'data': matchDetail}];
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
