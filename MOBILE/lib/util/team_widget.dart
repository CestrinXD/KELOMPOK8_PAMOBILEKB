// team_widget.dart
import 'package:flutter/material.dart';

import 'font.dart';

class TeamWidget extends StatelessWidget {
  final List<dynamic> teams;
  final Set<String> uniqueItems;
  final BuildContext context;

  const TeamWidget({
    required this.teams,
    required this.uniqueItems,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: teams.map((teamData) {
        final idTeam = teamData['id'] ?? 0;
        final teamName = teamData['teamName'] ?? 'Unknown Team';
        final crestUrl = teamData['crestUrl'] ?? '';

        if (uniqueItems.contains(teamName)) {
          return const SizedBox.shrink();
        } else {
          uniqueItems.add(teamName);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/team',
                      arguments: {
                        'id': idTeam,
                        'name': teamName,
                        'crest': crestUrl,
                      },
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: crestUrl.isNotEmpty
                            ? NetworkImage(crestUrl)
                            : const AssetImage('assets/images/default.png')
                                as ImageProvider,
                        fit: BoxFit.contain,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  teamName,
                  style: styleKu4(context),
                ),
              ],
            ),
          );
        }
      }).toList(),
    );
  }
}
