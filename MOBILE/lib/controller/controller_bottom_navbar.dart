import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sofa_score/models/fetch_league_standing.dart';
import '../build/build_favorite.dart';
import '../build/build_score.dart';
import '../models/data.dart';
import '../util/group_matches_by_matchday.dart';

List<Widget> widgetOptions(
  BuildContext context,
  Function(void Function()) setState,
  ScrollController scrollController,
  Future<void> Function() logout,
  VoidCallback navigateToProfile,
) {
  Map<int, List<Map<String, dynamic>>> groupedMatches =
      groupMatchesByMatchday(matchData);
  return [
    // Menampilkan daftar pertandingan
    ListView.builder(
      controller: scrollController,
      itemCount: groupedMatches.keys.length,
      itemBuilder: (context, index) {
        int matchDay = groupedMatches.keys.elementAt(index);
        List<Map<String, dynamic>> matchesForDay = groupedMatches[matchDay]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Matchday $matchDay", // Menampilkan match day
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...matchesForDay.map((match) {
              return buildScoreCard(
                context,
                match['id'],
                match['idHome'],
                match['idAway'],
                match['homeTeam'],
                match['awayTeam'],
                match['scoreA'],
                match['scoreB'],
                match['utcDate'],
                match['status'],
                match['homeCrest'],
                match['awayCrest'],
                (action) {
                  if (action == 'delete') {
                    setState(() {
                      matchData.remove(match); // Menghapus pertandingan
                    });
                  } else if (action == 'mute') {
                    if (kDebugMode) {
                      print(
                          'Pertandingan ${match['homeTeam']} vs ${match['awayTeam']} disenyapkan');
                    }
                  }
                },
              );
            }),
          ],
        );
      },
    ),
    // Menampilkan daftar standings liga
    FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchLeagueStandings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final standingsData = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection:
                Axis.vertical, // Gulir vertikal untuk seluruh layar
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Gulir horizontal untuk tabel
              child: DataTable(
                columnSpacing: 15,
                columns: const [
                  DataColumn(label: Text('Pos')),
                  DataColumn(label: Text('Team')),
                  DataColumn(label: Text('P')),
                  DataColumn(label: Text('GK')),
                  DataColumn(label: Text('+/-')),
                  DataColumn(label: Text('PTS')),
                  DataColumn(label: Text('M')),
                  DataColumn(label: Text('S')),
                  DataColumn(label: Text('K')),
                ],
                rows: standingsData.asMap().entries.map(
                  (entry) {
                    final index = entry.key + 1;
                    final team = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text('$index')),
                        DataCell(
                          Row(
                            children: [
                              Image.network(
                                team['crestUrl'],
                                width: 20,
                                height: 20,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error, size: 20),
                              ),
                              const SizedBox(width: 8),
                              Text(team['teamName']),
                            ],
                          ),
                        ),
                        DataCell(Text('${team['playedGames']}')),
                        DataCell(Text(
                            '${team['goalsFor']}:${team['goalsAgainst']}')),
                        DataCell(Text('${team['goalDifference']}')),
                        DataCell(Text('${team['points']}')),
                        DataCell(Text('${team['wins']}')),
                        DataCell(Text('${team['draws']}')),
                        DataCell(Text('${team['losses']}')),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          );
        }
        return const Center(child: Text('No standings data available.'));
      },
    ),
    // Menampilkan daftar favorit
    StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No favorite data available.'));
        }

        var favData = snapshot.data!.docs;

        return ListView.builder(
          itemCount: favData.length,
          itemBuilder: (context, index) {
            var favItem = favData[index];
            var head = favItem['head'] ?? 'No Title';
            return buildFavoriteCard(head: head, context: context);
          },
        );
      },
    ),

    // Menampilkan loading indicator sementara navigasi ke halaman profil
    Builder(
      builder: (context) {
        // Pastikan navigasi hanya dipanggil sekali
        Future.microtask(() {
          navigateToProfile();
        });
        return const Center(
          child:
              CircularProgressIndicator(), // Menampilkan loader sementara navigasi
        );
      },
    ),
  ];
}
