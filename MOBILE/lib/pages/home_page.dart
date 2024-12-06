import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/controller_bottom_navbar.dart';
import '../models/data.dart';
import '../models/fetch_match_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMatchData();
  }

  void scrollToUpcomingMatch() {
    Future.delayed(const Duration(milliseconds: 10), () {
      final index = matchData.indexWhere((match) => match['status'] == 'TIMED');
      if (index != -1) {
        final position = index * 70.0;
        // Pastikan _scrollController terhubung dengan ListView
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            position,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadMatchData() async {
    List<Map<String, dynamic>> fetchedMatches = await fetchMatchData();
    if (mounted) {
      // Periksa apakah widget masih terpasang
      setState(() {
        matchData = fetchedMatches;
        isLoading = false;
      });
      // Panggil fungsi scroll setelah data dimuat
      scrollToUpcomingMatch();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        scrollToUpcomingMatch();
      }
    });
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/second');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout gagal: $e')),
        );
      }
    }
  }

  void navigateToProfile() {
    if (mounted) {
      Navigator.pushNamed(context, '/profil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Winning Score'),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : widgetOptions(context, setState, _scrollController, logout,
              navigateToProfile)[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.scoreboard_outlined),
            label: 'Score',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'Standing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_outlined),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
