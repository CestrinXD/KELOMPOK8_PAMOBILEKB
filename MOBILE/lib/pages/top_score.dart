import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sofa_score/models/data.dart';
import 'package:sofa_score/models/fetch_top_score.dart';

class TopScore extends StatefulWidget {
  const TopScore({super.key});

  @override
  State<TopScore> createState() => _TopScoreState();
}

class _TopScoreState extends State<TopScore> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTopScore();
  }

  Future<void> loadTopScore() async {
    try {
      final List<Map<String, dynamic>> standings = await fetchTopScorers();
      setState(() {
        topScoreData =
            standings; // Simpan data yang diambil ke variabel leagueData
        isLoading = false; // Set loading ke false setelah data dimuat
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading ke false jika terjadi error
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : topScoreData.isEmpty
              ? const Center(child: Text('No Top Score data available.'))
              : ListView.builder(
                  itemCount: topScoreData.length,
                  itemBuilder: (context, index) {
                    final scorer = topScoreData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      scorer['playerName'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      scorer['position'],
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  '${scorer['goals']} Gol',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${scorer['teamName']}',
                                    style: const TextStyle(color: Colors.grey)),
                                Text('${scorer['assist']} Assist'),
                                Text('${scorer['penalties']} Penalti'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
