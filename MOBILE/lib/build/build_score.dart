import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildScoreCard(
  BuildContext context,
  int matchId,
  int idHome,
  int idAway,
  String homeTeam,
  String awayTeam,
  int scoreA,
  int scoreB,
  String utcDate,
  String status,
  String homeCrest,
  String awayCrest,
  Function onDismiss,
) {
  DateTime dateTime = DateTime.parse(utcDate);
  String formattedDate = DateFormat('HH:mm').format(dateTime);

  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        '/match_detail',
        arguments: {
          'id': matchId,
          'idHome' : idHome,
          'idAway' : idAway,
          }, // Ambil ID dari data match
      );
    },
    child: Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.volume_off, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onDismiss('delete');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pertandingan Dihapus')),
          );
        } else if (direction == DismissDirection.endToStart) {
          onDismiss('mute');
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pertandingan Disenyapkan')));
        }
      },
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        homeTeam,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.network(homeCrest, width: 25, height: 25),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    status == 'FINISHED' ? '$scoreA - $scoreB' : formattedDate,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Image.network(awayCrest, width: 25, height: 25),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        awayTeam,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
