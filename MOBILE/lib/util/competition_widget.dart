// competition_widget.dart
import 'package:flutter/material.dart';

import 'font.dart';

class CompetitionWidget extends StatelessWidget {
  final List<dynamic> competitions;
  final Set<String> uniqueItems;
  final BuildContext context;

  const CompetitionWidget({
    required this.competitions,
    required this.uniqueItems,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: competitions.map((competitionData) {
        final competitionName = competitionData['competitionName'] ?? 'Unknown Competition';
        final crestUrl = competitionData['crestUrl'] ?? '';

        if (uniqueItems.contains(competitionName)) {
          return const SizedBox.shrink();
        } else {
          uniqueItems.add(competitionName);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color.fromARGB(255, 254, 247, 255)
                        : Colors.white,
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
                const SizedBox(height: 4),
                Text(
                  competitionName,
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
