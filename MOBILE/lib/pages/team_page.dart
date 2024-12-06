import 'package:flutter/material.dart';
import 'package:sofa_score/models/fetch_favorite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sofa_score/models/fetch_teams_page.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  late Future<List<Map<String, dynamic>>> teams;
  late Future<List<Map<String, dynamic>>> favorites;

  @override
  void initState() {
    super.initState();
    teams = fetchTeamsPage(); // Fetch teams from your API or database
    favorites = fetchFavorites(); // Fetch favorites once on init
  }

  // Fungsi untuk menambahkan tim ke favorit
  Future<void> addTeamToFavorites(Map<String, dynamic> team) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('head', isEqualTo: 'team')
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Jika tidak ada dokumen dengan 'head': 'team', buat dokumen baru
        await FirebaseFirestore.instance.collection('favorites').add({
          'head': 'team',
          'teams': [
            {
              'id': team['id'],
              'teamName': team['teamName'],
              'crestUrl': team['crestUrl'],
              'area': team['area'],
            }
          ],
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team added to favorites!')),
          );
        }
      } else {
        final documentId = querySnapshot.docs.first.id;
        final existingTeams = querySnapshot.docs.first['teams'] as List;

        // Menentukan apakah tim sudah ada dalam daftar favorit
        final isAlreadyFavorite = existingTeams.any(
          (favTeam) => favTeam['teamName'] == team['teamName'],
        );

        if (isAlreadyFavorite) {
          await FirebaseFirestore.instance
              .collection('favorites')
              .doc(documentId)
              .update({
            'teams': FieldValue.arrayRemove([{
              'id': team['id'],
              'teamName': team['teamName'],
              'crestUrl': team['crestUrl'],
              'area': team['area'],
            }]),
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Team removed from favorites!')),
            );
          }
        } else {
          await FirebaseFirestore.instance
              .collection('favorites')
              .doc(documentId)
              .update({
            'teams': FieldValue.arrayUnion([{
              'id': team['id'],
              'teamName': team['teamName'],
              'crestUrl': team['crestUrl'],
              'area': team['area'],
            }]),
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Team added to favorites!')),
            );
          }
        }
      }

      // Refreshing the favorites after update
      setState(() {
        favorites = fetchFavorites(); // Refresh favorites list after update
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update team: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([teams, favorites]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final teamsList = snapshot.data![0] as List<Map<String, dynamic>>; // First element is the teams list
            final favoriteTeams = snapshot.data![1] as List<Map<String, dynamic>>; // Second element is the favorites list

            return ListView.builder(
              itemCount: teamsList.length,
              itemBuilder: (context, index) {
                final team = teamsList[index];
                final isFavorite = favoriteTeams.any(
                  (favTeam) => favTeam['teamName'] == team['teamName'],
                );

                return ListTile(
                  leading: team['crestUrl'] != null
                      ? Container(
                          width: 40, // Ukuran kotak gambar
                          height: 40, // Ukuran kotak gambar
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle, // Menjadikan gambar berbentuk kotak
                            image: DecorationImage(
                              image: NetworkImage(team['crestUrl'] ?? ''),
                              fit: BoxFit.cover, // Menyesuaikan gambar dengan ukuran kotak
                            ),
                          ),
                        )
                      : const CircleAvatar(), // Gambar default jika tidak ada URL
                  title: Text(team['teamName']),
                  subtitle: Text(team['area']),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.pink : null,
                    ),
                    onPressed: () {
                      addTeamToFavorites(team);
                    },
                  ),
                  onTap: () {
                    // Navigasi ke halaman Team dengan mengirimkan ID dan nama tim
                    Navigator.pushNamed(
                      context,
                      '/team',
                      arguments: {
                        'id': team['id'],
                        'name': team['teamName'],
                        'crest': team['crestUrl'],
                      },
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No teams found.'));
          }
        },
      ),
    );
  }
}
