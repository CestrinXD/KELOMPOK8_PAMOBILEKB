// favorite_card.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../util/font.dart';
import '../util/team_widget.dart';
import '../util/competition_widget.dart';

Widget buildFavoriteCard({
  required String head,
  required BuildContext context,
}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder: (context) {
              return Text(capitalizeFirst(head), style: styleKu2(context));
            },
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (head == 'team') {
                      Navigator.pushNamed(context, '/team_page');
                    } else if (head == 'competition') {
                      Navigator.pushNamed(context, '/competition_page');
                    }
                  },
                  icon: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('favorites')
                      .where('head', isEqualTo: head)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final favorites = snapshot.data!.docs;
                      Set<String> uniqueItems = {};

                      if (favorites.isEmpty) {
                        return const Center(child: Text('No data available.'));
                      }

                      return Row(
                        children: favorites.map((favoriteDoc) {
                          if (head == 'team') {
                            return TeamWidget(
                              teams: favoriteDoc['teams'] as List<dynamic>,
                              uniqueItems: uniqueItems,
                              context: context,
                            );
                          } else if (head == 'competition') {
                            return CompetitionWidget(
                              competitions:
                                  favoriteDoc['competitions'] as List<dynamic>,
                              uniqueItems: uniqueItems,
                              context: context,
                            );
                          }
                          return const SizedBox.shrink();
                        }).toList(),
                      );
                    } else {
                      return const Center(child: Text('No favorites found.'));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
