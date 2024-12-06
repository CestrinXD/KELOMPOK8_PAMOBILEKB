import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofa_score/main.dart';

class ProfilePage extends StatefulWidget {
  final Future<void> Function() logout;

  const ProfilePage({super.key, required this.logout});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _updateThemePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      isDarkMode = value;
    });

    final ThemeMode themeMode = value ? ThemeMode.dark : ThemeMode.light;
    if (mounted) {
      MyApp.of(context)?.setThemeMode(themeMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                User user = snapshot.data!;
                String? photoURL = user.photoURL;
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: photoURL != null && photoURL.isNotEmpty
                          ? NetworkImage(photoURL)
                          : const AssetImage('assets/default_profile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.displayName ?? 'Nama Pengguna',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(user.email ?? 'Email Pengguna'),
                  ],
                );
              } else {
                return const Text('Tidak ada data pengguna');
              }
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Akun'),
                  onTap: () {},
                ),
                // Opsi Dark Mode
                SwitchListTile(
                  value: isDarkMode,
                  title: const Text('Mode Gelap'),
                  secondary: const Icon(Icons.dark_mode),
                  onChanged: (value) => _updateThemePreference(value),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Pilih Laman Beranda Anda'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: const Text('Semua Kompetisi'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Semua Berita'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.tips_and_updates),
                  title: const Text('Tip Harian'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text('Peluang'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifikasi'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.web),
                  title: const Text('Export Selections to Web'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
                await widget.logout();
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamedAndRemoveUntil('/landing', (route) => false);
                  });
                }
              } catch (e) {
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout gagal: $e')),
                    );
                  });
                }
              }
            },
            child: const Text('Logout'),
          )
        ],
      ),
    );
  }
}
