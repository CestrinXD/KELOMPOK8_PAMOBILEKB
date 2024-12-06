import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sofa_score/models/data.dart';

Future<List<Map<String, dynamic>>> fetchTeam(int idTeam) async {
  final url = 'https://api.football-data.org/v4/teams/$idTeam';
  final headers = {
    'X-Auth-Token': '998b16130d4c49dd93253380d7284154',
  };

  teamdata.clear();

  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) print('API Response: $data');

      // Mengambil informasi tim
      final teamInfo = {
        'id': data['id'],
        'name': data['name'],
        'shortName': data['shortName'],
        'crest': data['crest'],
        'area': data['area']['name'],
        'competitions': data['runningCompetitions']
            ?.map((competition) => competition['name'])
            .toList(),
        'squad': (data['squad'] as List<dynamic>?)
            ?.map((player) {
              // Validasi tipe data untuk setiap pemain
              if (player is Map<String, dynamic> &&
                  player.containsKey('name')) {
                return {
                  'name': player['name'],
                  'position': player['position'] ??
                      'Unknown', // Default jika tidak ada posisi
                };
              }
              return null; // Abaikan jika tidak valid
            })
            .where((player) => player != null) // Hapus null dari list
            .cast<Map<String, dynamic>>()
            .toList(),
      };

      if (kDebugMode) {
        print(teamInfo);
      }

      teamdata.add(teamInfo);

      return [teamInfo];
    } else {
      throw Exception('Failed to load team data');
    }
  } catch (e) {
    throw Exception('Error fetching team data: $e');
  }
}
