import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sofa_score/models/data.dart';
import 'package:sofa_score/models/fetch_league_standing.dart';

class LeagueStandings extends StatefulWidget {
  const LeagueStandings({super.key});

  @override
  State<LeagueStandings> createState() => _LeagueStandingsState();
}

class _LeagueStandingsState extends State<LeagueStandings> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStandings();
  }

  Future<void> loadStandings() async {
    try {
      final List<Map<String, dynamic>> standings = await fetchLeagueStandings();
      setState(() {
        leagueData = standings;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print('Error fetching standings: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final area = arguments['area'];
    final competition = arguments['competition'];

    return Scaffold(
      appBar: AppBar(
        title: Text('$competition Standings - $area'),
        actions: [
          IconButton(
            icon: const Icon(Icons.score),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/top_score',
                arguments: {
                  'area': area,
                  'competition': competition,
                },
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : leagueData.isEmpty
              ? const Center(child: Text('No standings data available.'))
              : ListView(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
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
                          DataColumn(label: Text('Formulir')),
                        ],
                        rows: leagueData.asMap().entries.map(
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
                                        errorBuilder: (context, error,
                                                stackTrace) =>
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
                                DataCell(Text(team['form'] ?? 'N/A')),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
    );
  }
}
