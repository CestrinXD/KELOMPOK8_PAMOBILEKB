import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> fetchFavorites() async {
  try {
    // Query untuk 'head' == 'team'
    final teamQuerySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('head',
            isEqualTo: 'team') // Mengambil dokumen dengan 'head' == 'team'
        .get();

    // Query untuk 'head' == 'competition'
    final competitionQuerySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('head',
            isEqualTo:
                'competition') // Mengambil dokumen dengan 'head' == 'competition'
        .get();

    // List untuk menyimpan data favorit
    List<Map<String, dynamic>> allFavorites = [];

    // Memproses data dari 'team' documents
    for (var doc in teamQuerySnapshot.docs) {
      if (doc['head'] == 'team') {
        final teams = doc['teams'] as List;
        allFavorites.addAll(List<Map<String, dynamic>>.from(teams));
      }
    }

    // Memproses data dari 'competition' documents
    for (var doc in competitionQuerySnapshot.docs) {
      if (doc['head'] == 'competition') {
        final competitions = doc['competitions'] as List;
        allFavorites.addAll(List<Map<String, dynamic>>.from(competitions));
      }
    }

    // Mengembalikan daftar favorit gabungan
    return allFavorites;
  } catch (e) {
    throw Exception('Failed to fetch favorites: $e');
  }
}
