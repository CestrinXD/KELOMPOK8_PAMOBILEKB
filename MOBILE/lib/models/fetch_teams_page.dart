import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchTeamsPage() async {
  const url = 'https://api.football-data.org/v4/competitions/PL/teams';
  const headers = {
    'X-Auth-Token': '998b16130d4c49dd93253380d7284154',
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List teams = data['teams'] ?? [];
      List<Map<String, dynamic>> teamsData = []; // Variabel untuk menyimpan data tim

      if (kDebugMode) {
        print("Received teams count: ${teams.length}");
      }

      // Loop untuk mengambil data setiap tim
      for (var team in teams) {
        teamsData.add({
          'id': team['id'],
          'teamName': team['name'],
          'shortName': team['shortName'] ?? team['name'],
          'crestUrl': team['crest'],
          'area': team['area']['name'],
        });
      }

      return teamsData;
    } else {
      if (kDebugMode) {
        print('Failed to load teams: ${response.statusCode}');
      }
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching team data: $e');
    }
    return [];
  }
}
