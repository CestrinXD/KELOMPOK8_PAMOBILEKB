import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sofa_score/models/data.dart';
import 'package:sofa_score/models/fetch_match_detail.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../models/fetch_last_five.dart';

class MatchDetailPage extends StatefulWidget {
  const MatchDetailPage({super.key});

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  bool isLoading = true;
  bool isPredictionLoading =
      false; // State untuk menandakan prediksi sedang dimuat
  late int idHome;
  late int idAway;
  List<String> results = [];
  List<Map<String, dynamic>> lastFiveMatches = [];
  String? predictionResult;

  @override
  void initState() {
    super.initState();
  }

  // Fungsi untuk mengirim data ke API Synapse dan mendapatkan hasil prediksi
  Future<void> sendDataForPrediction() async {
    const apiUrl =
        'http://127.0.0.1:8000/api/predict'; // Ganti dengan URL API Synapse yang sesuai
    final headers = {'Content-Type': 'application/json'};

    // Data yang akan dikirim sesuai format yang disebutkan
    final Map<String, dynamic> inputData = {
      "data": [
        1.0,
        0.5,
        1,
        1,
        2,
        ...results.take(6),
      ]
    };

    try {
      setState(() {
        isPredictionLoading = true;
      });

      // Kirim POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          predictionResult =
              'Home Win: ${responseData['prediction'][0][0].toStringAsFixed(2)}%, Away Win: ${responseData['prediction'][0][1].toStringAsFixed(2)}%';
        });
      } else {
        setState(() {
          predictionResult = 'Failed to fetch prediction';
        });
      }
    } catch (error) {
      setState(() {
        predictionResult = 'Error: $error';
      });
    } finally {
      setState(() {
        isPredictionLoading = false;
      });
    }
  }

  List<String> extractMatchResults(List<Map<String, dynamic>> matches) {
    for (var matchGroup in matches) {
      for (var match in matchGroup['matches']) {
        String result = match['result']; // Ambil hasil pertandingan
        if (result == 'W') {
          results.add('W');
        } else if (result == 'L') {
          results.add('L');
        } else if (result == 'D') {
          results.add('D');
        }
      }
    }
    return results;
  }

  Future<void> loadMatchData(int matchId) async {
    List<Map<String, dynamic>> fetchedMatches =
        await fetchMatchDetails(matchId);
    print(fetchedMatches);
    setState(() {
      matchDetail = fetchedMatches[0]['data'];
      isLoading = false;
    });
  }

  void fetchMatches(int idHome, int idAway) async {
    try {
      var homeResults = await getLastFiveHomeMatchResults(idHome);
      await Future.delayed(const Duration(seconds: 1));
      var awayResults = await getLastFiveAwayMatchResults(idAway);

      setState(() {
        lastFiveMatches = [
          {'label': 'Home Matches', 'matches': homeResults},
          {'label': 'Away Matches', 'matches': awayResults},
        ];
        print('Last Five Matches: $lastFiveMatches');
      });
    } catch (error) {
      print('Error fetching matches: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final matchId = arguments['id'] as int?;
    final area = arguments['area'];
    final competition = arguments['competition'];

    if (matchId != null && isLoading) {
      idHome = arguments['idHome'];
      idAway = arguments['idAway'];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          fetchMatches(idHome, idAway);
          loadMatchData(matchId);
          // sendDataForPrediction(); // Memanggil fungsi untuk mengirim data ke API
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/league_standing', arguments: {
                'area': area,
                'competition': competition,
              });
            },
            child: matchDetail.isNotEmpty
                ? Text(
                    '${matchDetail[0]['area']}, ${matchDetail[0]['competition']}, Ronde ${matchDetail[0]['matchday']}',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  )
                : const Text('Loading match details...'),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : matchDetail.isEmpty
              ? const Center(child: Text('No match data available.'))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                          'Tanggal: ${_formatDate(matchDetail[0]['utcDate'])}'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/team',
                                arguments: {
                                  'id': matchDetail[0]['idHome'],
                                  'name': matchDetail[0]['homeTeamF'],
                                  'crest': matchDetail[0]['homeCrest'],
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Image.network(
                                  matchDetail[0]['homeCrest'],
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${matchDetail[0]['homeTeam']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${matchDetail[0]['scoreHome']} - ${matchDetail[0]['scoreAway']}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/team',
                                arguments: {
                                  'id': matchDetail[0]['idAway'],
                                  'name': matchDetail[0]['awayTeamF'],
                                  'crest': matchDetail[0]['awayCrest'],
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Image.network(
                                  matchDetail[0]['awayCrest'],
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${matchDetail[0]['awayTeam']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Status: ${matchDetail[0]['status']}'),
                      Text('Matchday: ${matchDetail[0]['matchday']}'),
                      Text('Wasit: ${matchDetail[0]['referee']}'),
                      const SizedBox(height: 20),
                      lastFiveMatches.isEmpty
                          ? const Text('Loading last five matches...')
                          : Column(
                              children: lastFiveMatches.map((matchData) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(matchData['label']),
                                    ...matchData['matches'].map((match) {
                                      return Text(
                                          'Home: ${match['homeTeam']} vs Away: ${match['awayTeam']} - Score: ${match['scoreA']} - ${match['scoreB']} Result: ${match['result']}');
                                    }).toList(),
                                  ],
                                );
                              }).toList(),
                            ),
                      if (isPredictionLoading)
                        const CircularProgressIndicator(),
                      if (predictionResult != null) ...[
                        const SizedBox(height: 20),
                        Text('Prediction: $predictionResult'),
                      ],
                    ],
                  ),
                ),
    );
  }

  // Fungsi untuk memformat tanggal
  String _formatDate(String utcDate) {
    DateTime dateTime = DateTime.parse(utcDate);
    return DateFormat('d MMMM yyyy').format(dateTime);
  }
}
