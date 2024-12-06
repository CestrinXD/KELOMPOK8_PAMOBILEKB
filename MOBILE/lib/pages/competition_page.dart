import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/fetch_competition.dart';
import '../models/fetch_favorite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionPage extends StatefulWidget {
  const CompetitionPage({super.key});

  @override
  State<CompetitionPage> createState() => _CompetitionPageState();
}

class _CompetitionPageState extends State<CompetitionPage> {
  late Future<List<Map<String, dynamic>>> competitions;
  late Future<List<Map<String, dynamic>>> favorites;

  @override
  void initState() {
    super.initState();
    competitions = fetchCompetition();
    favorites = fetchFavorites();
  }

  // Fungsi untuk menambahkan kompetisi ke favorit
  Future<void> addCompetitionToFavorites(
      Map<String, dynamic> competition) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('head', isEqualTo: 'competition')
          .get();

      if (kDebugMode) {
        print('Query Snapshot: ${querySnapshot.docs.length} documents found.');
      }
      if (querySnapshot.docs.isEmpty) {
        // Jika tidak ada dokumen dengan 'head': 'competition', buat dokumen baru
        await FirebaseFirestore.instance.collection('favorites').add({
          'head': 'competition',
          'competitions': [
            {
              'area': competition['area'],
              'competitionName': competition['competitionName'],
              'crestUrl': competition['crestUrl'],
            }
          ],
        });
        if (kDebugMode) {
          print(
              'Added competition to favorites: ${competition['competitionName']}');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Competition added to favorites!')),
          );
        }
      } else {
        final documentId = querySnapshot.docs.first.id;
        final existingCompetitions =
            querySnapshot.docs.first['competitions'] as List;

        // Menentukan apakah kompetisi sudah ada dalam daftar favorit
        final isAlreadyFavorite = existingCompetitions.any(
          (favCompetition) =>
              favCompetition['competitionName'] ==
              competition['competitionName'],
        );

        if (isAlreadyFavorite) {
          await FirebaseFirestore.instance
              .collection('favorites')
              .doc(documentId)
              .update({
            'competitions': FieldValue.arrayRemove([
              {
                'area': competition['area'],
                'competitionName': competition['competitionName'],
                'crestUrl': competition['crestUrl'],
              }
            ]),
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Competition removed from favorites!')),
            );
          }
        } else {
          await FirebaseFirestore.instance
              .collection('favorites')
              .doc(documentId)
              .update({
            'competitions': FieldValue.arrayUnion([
              {
                'area': competition['area'],
                'competitionName': competition['competitionName'],
                'crestUrl': competition['crestUrl'],
              }
            ]),
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Competition added to favorites!')),
            );
          }
        }
      }

      // Refreshing the favorites after update
      setState(() {
        favorites = fetchFavorites(); // Refresh favorites list after update
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding competition to favorites: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update competition: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competitions'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([competitions, favorites]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final competitionsList = snapshot.data![0];
            final favoriteCompetitions = snapshot.data![1];
            return ListView.builder(
              itemCount: competitionsList.length,
              itemBuilder: (context, index) {
                final competition = competitionsList[index];
                final isFavorite = favoriteCompetitions.any(
                  (favCompetition) =>
                      favCompetition['competitionName'] ==
                      competition['competitionName'],
                );

                if (kDebugMode) {
                  print(
                    'Competition: ${competition['competitionName']}, IsFavorite: $isFavorite');
                }

                return ListTile(
                  title: Text(competition['competitionName']),
                  subtitle: Text(competition['area']),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.pink : null,
                    ),
                    onPressed: () {
                      addCompetitionToFavorites(competition);
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No competitions found.'));
          }
        },
      ),
    );
  }
}
