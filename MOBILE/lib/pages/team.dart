import 'package:flutter/material.dart';
import 'package:sofa_score/models/fetch_team.dart';

import '../controller/controller_tab_team.dart';

class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController(); // Inisialisasi ScrollController
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose(); // Jangan lupa dispose ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil idTeam dan teamName dari arguments route
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final idTeam = arguments['id'];
    final teamName = arguments['name'];
    final crest = arguments['crest'];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: AppBar(
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (crest != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.network(
                      crest,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                Text(
                  teamName,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Pertandingan'),
                Tab(text: 'Squad'),
                Tab(text: 'Deskripsi'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab Pertandingan
          teamWidgetOptions(
            context,
            setState,
            _scrollController,
          )[0], // Panggil Tab Pertandingan

          // Tab Squad
          teamWidgetOptions(
            context,
            setState,
            _scrollController,
          )[1], // Panggil Tab Squad

          // Tab Deskripsi
          teamWidgetOptions(
            context,
            setState,
            _scrollController,
          )[2], // Panggil Tab Deskripsi
        ],
      ),
    );
  }
}
