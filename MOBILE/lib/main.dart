import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofa_score/pages/profil.dart';
import 'package:sofa_score/pages/auth.dart';
import 'package:sofa_score/pages/competition_page.dart';
import 'package:sofa_score/pages/home_page.dart';
import 'package:sofa_score/pages/landing_page.dart';
import 'package:sofa_score/pages/league_standings.dart';
import 'package:sofa_score/pages/match_detail.dart';
import 'package:sofa_score/pages/team.dart';
import 'package:sofa_score/pages/team_page.dart';
import 'package:sofa_score/pages/top_score.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system; // Default: sistem perangkat

  @override
  void initState() {
    super.initState();
    _initializeTheme();
    _initializeSplashScreen();
  }

  /// Menginisialisasi tema dari preferensi pengguna
  Future<void> _initializeTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  /// Fungsi untuk mengubah tema secara global
  void setThemeMode(ThemeMode themeMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', themeMode == ThemeMode.dark);
    setState(() {
      _themeMode = themeMode;
    });
  }

  /// Menghapus splash screen setelah penundaan
  void _initializeSplashScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  /// Fungsi untuk logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LandingPage();
          }
        },
      ),
      routes: {
        '/landing': (context) => const LandingPage(),
        '/second': (context) => const Auth(),
        '/home_page': (context) => const HomePage(),
        '/profil': (context) => ProfilePage(logout: logout),
        '/match_detail': (context) => const MatchDetailPage(),
        '/league_standing': (context) => const LeagueStandings(),
        '/top_score': (context) => const TopScore(),
        '/team': (context) => Team(),
        '/team_page': (context) => const TeamPage(),
        '/competition_page': (context) => const CompetitionPage(),
      },
    );
  }
}
