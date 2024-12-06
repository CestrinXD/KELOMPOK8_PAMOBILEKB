import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchCompetition() async {
  const url = 'https://api.football-data.org/v4/competitions';
  const headers = {
    'X-Auth-Token': '998b16130d4c49dd93253380d7284154',
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Mengambil data kompetisi dari respons
      List competitions = data['competitions'] ?? [];
      List<Map<String, dynamic>> competitionsData =
          []; // Variabel untuk menyimpan data kompetisi

      if (kDebugMode) {
        print("Received competitions count: ${competitions.length}");
      }

      // Loop untuk mengambil data setiap kompetisi
      for (var competition in competitions) {
        competitionsData.add({
          'competitionName': competition['name'],
          'area': competition['area']['name'],
          'crestUrl': competition['emblem'],
        });
      }

      return competitionsData;
    } else {
      if (kDebugMode) {
        print('Failed to load competitions: ${response.statusCode}');
      }
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching competition data: $e');
    }
    return [];
  }
}
