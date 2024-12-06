import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sofa_score/models/fetch_match_team.dart';
import '../build/build_score.dart';
import '../models/fetch_team.dart';

List<Widget> teamWidgetOptions(
  BuildContext context,
  Function(void Function()) setState,
  ScrollController scrollController,
) {
  final arguments =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  final idTeam = arguments['id'];

  return [
    // Tab Pertandingan
    FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchMatchesForTeam(idTeam),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          var matches = snapshot.data!;
          if (matches.isEmpty) {
            return const Center(child: Text('No matches data available.'));
          }
          return ListView.builder(
            controller: scrollController,
            itemCount: matches.length,
            itemBuilder: (context, index) {
              var match = matches[index];
              return buildScoreCard(
                  context,
                  match['id'],
                  match['id'],
                  match['id'],
                  match['homeTeam'],
                  match['awayTeam'],
                  match['scoreA'],
                  match['scoreB'],
                  match['utcDate'],
                  match['status'],
                  match['homeCrest'],
                  match['awayCrest'], (action) {
                if (action == 'delete') {
                  setState(() {
                    matches.removeAt(index); // Remove match from list
                  });
                } else if (action == 'mute') {
                  if (kDebugMode) {
                    print(
                        'Match muted: ${match['homeTeam']} vs ${match['awayTeam']}');
                  }
                }
              });
            },
          );
        }
        return const Center(child: Text('No matches data available.'));
      },
    ),
    // Tab Squad
    FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchTeam(idTeam),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var squad =
              snapshot.data!.first['squad'] as List<Map<String, dynamic>>;
          return ListView.builder(
            controller: scrollController,
            itemCount: squad.length,
            itemBuilder: (context, index) {
              var player = squad[index];
              return ListTile(
                title: Text(player['name']),
                subtitle: Text('Position: ${player['position']}'),
              );
            },
          );
        }
        return const Center(child: Text('No squad data available.'));
      },
    ),
    FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchTeam(idTeam), // Tipe data sesuai fungsi fetchTeam
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // Mengambil elemen pertama karena fetchTeam mengembalikan List
          var teamInfo = snapshot.data!.first;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${teamInfo['name'] ?? "Unknown"}'),
                Text('Short Name: ${teamInfo['shortName'] ?? "Unknown"}'),
                Text('Area: ${teamInfo['area'] ?? "Unknown"}'),
                Text(
                    'Competitions: ${teamInfo['competitions'] != null ? (teamInfo['competitions'] as List<dynamic>).join(', ') : "None"}'),
              ],
            ),
          );
        }
        return const Center(child: Text('No team description available.'));
      },
    ),
  ];
}

fetchTeamSquad() {
  // Implement the API call to fetch team squad data.
}
