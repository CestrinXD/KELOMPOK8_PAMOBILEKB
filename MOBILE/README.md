# Sofa Score

## Pendahuluan

Sofa Score adalah aplikasi mobile yang dirancang untuk memberikan informasi skor sepak bola secara
real-time. Aplikasi ini memungkinkan pengguna untuk mengakses data pertandingan, melihat statistik, dan
mendapatkan pembaruan terbaru dari berbagai liga di seluruh dunia.

## Struktur Proyek

1. main.dart : Entry point dari aplikasi yang berisi untuk route aplikasi
2. pages/landing_page.dart : Halaman untuk menampilkan bagian awal dari aplikasi
3. pages/auth.dart : Halaman untuk login dan register
4. pages/home_page : Halaman utama yang menampilkan daftar pertandingan dan beberapa widget dari bottom navigation bar

### 1. 'main.dart'

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const LandingPage(),
      '/second': (context) => const Auth(),
      '/homePage': (context) => const HomePage(),
    },
  );
}
```

Mengembalikan widget MaterialApp sebagai antarmuka pengguna utama.
Menetapkan rute awal aplikasi yaitu LandingPage dan mendefinisikan rute untuk halaman landing, autentikasi yaitu Auth, dan halaman utama yaitu HomePage.

### 2. 'landing_page.dart'

```dart
class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sofa Score'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Image.network(
                  'https://databar.ai/media/external_source_logo/Sofascore.png',
                  height: 300,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                const SizedBox(
                  width: 320,
                  child: Text(
                    'Welcome to Sofa Score',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF18191A),
                      fontSize: 24,
                      fontFamily: 'Work Sans',
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(
                  width: 320,
                  child: Text(
                    'Discover live scores, stats, and news for your favorite sports teams and players!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF18191A),
                      fontSize: 16,
                      fontFamily: 'Work Sans',
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF18191A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Work Sans',
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

1. Menggunakan Scaffold untuk menyediakan struktur dasar halaman, termasuk AppBar dengan judul "Sofa Score".
2. Menggunakan ListView untuk menampilkan gambar logo aplikasi, judul sambutan, dan deskripsi singkat tentang aplikasi.
3. Menggunakan Padding untuk mengatur ElevatedButton agar sesuai dengan yang diinginkan
4. Menggunakan ElevatedButton untuk mengarahkan pengguna ke halaman login dan registrasi ketika tombol "Get Started" ditekan dengan mengambil info dari route sebelumnya di 'main.dart'.

### 3. 'auth.dart'

Halaman ini memungkinkan pengguna untuk melakukan login atau registrasi ke aplikasi Sofa Score. Pengguna dapat memilih untuk login dengan email atau nomor telepon dan memasukkan kata sandi. Di sisi registrasi, pengguna dapat mengisi data pribadi seperti nama pengguna, tanggal lahir, jenis kelamin, dan negara. Halaman ini juga memiliki fitur untuk menunjukkan atau menyembunyikan kata sandi dan mengingat akun pengguna.

- Membuat variabel untuk mengatur isi widget Sign In dan Sign Up

```dart
  late TabController _tabController;
  bool _isObscured = true;
  bool _showPassword = false;
  bool _agreedToTerms = false;
  bool _autoLogin = false;
  var gender = "";
  DateTime? _selectedDate;
  String? _country;
```

Dalam Flutter kita dapat memakai fungsi 'Future' untuk melakukan tugas asinkron yang dimana setelah
tugas selesai, tidak akan mengembalikan nilai apapun, fungsi ini menunggu hasil suatu proses tanpa harus
menghentikan ekseskusi program, merepresentasikan nilai yang akan tersedia di masa depan seperti API,
pengambilan data dari database ataupun menampilkan dialog.

```dart
Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
```

* Membuat AppBar yang berisi title, teks dinamis yang berubah tergantung kondisi TabBar, dan TabBar itu sendiri
* Membuat TabBar dengan isi Sign In dan Sign Up sesuai dengan panjang yang diinsialisasi sebelumnya di TabController

```dart
appBar: AppBar(
  title: const Text('Sofa Score'),
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(100),
    child: Column(
      children: [
        Text(
          _tabController.index == 0
              ? 'Welcome Back'
              : "Let's Get Started",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          _tabController.index == 0
              ? 'Please login with your account'
              : "Please create your account",
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 6),
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Sign In"),
            Tab(text: "Sign Up"),
          ],
        ),
      ],
    ),
  ),
),
```

* Menyimpan informasi dari TabController untuk mengatur tab mana yang akan di isi elemen sesuai dengan index di dalam body menggunakan children
* Membuat isi dari setiap tab dengan padding agar memiliki jarak yang baik antar elemen serta menampilkan dua tampilan yang berbeda yaitu halaman login dan registrasi
* Membuat TextFormField yang berisi Email or Phone, Password, CheckBox Show Password, Switch Remember Me dan ElevatedButton di bagian Tab Sign In
* Membuat TextFormField yang berisi Username, Email or Phone, Tanggal Lahir, Radio Button, Password, CheckBox Show Password, DropDownButton pilih negara, CheckBox Persetujuan dan ElevatedButton di bagian Tab Sign Up

```dart
body: TabBarView(
  controller: _tabController,
  children: [
    // sign in
    Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Or Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: _isObscured,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Checkbox(
              value: _showPassword,
              onChanged: (bool? value) {
                setState(() {
                  _showPassword = value ?? false;
                  _isObscured = !_showPassword;
                });
              },
            ),
            title: const Text('Show Password'),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Remember Me'),
            trailing: Switch(
              value: _autoLogin,
              onChanged: (bool value) {
                setState(() {
                  _autoLogin = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage()),
                );
              },
              child: const Text('Login'),
            ),
          )
        ],
      ),
    ),
    // sign up
    Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        // physics: const NeverScrollableScrollPhysics(),
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Or Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Tanggal Lahir"),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    _selectedDate == null
                        ? 'Pilih Tanggal'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Gender"),
          const SizedBox(height: 5),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Pria'),
            leading: Radio(
              value: 'Pria',
              groupValue: gender,
              onChanged: (String? value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Wanita'),
            leading: Radio(
              value: 'Wanita',
              groupValue: gender,
              onChanged: (String? value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: _isObscured,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Checkbox(
              value: _showPassword,
              onChanged: (bool? value) {
                setState(() {
                  _showPassword = value ?? false;
                  _isObscured = !_showPassword;
                });
              },
            ),
            title: const Text('Show Password'),
          ),
          const Text("Pilih Negara"),
          DropdownButtonFormField<String>(
            value: _country,
            items: <String>[
              'Indonesia',
              'Malaysia',
              'Singapore',
              'Thailand'
            ].map((String value) {
              return DropdownMenuItem<String>(
                  value: value, child: Text(value));
            }).toList(),
            hint: const Text('Select Country'),
            onChanged: (String? newValue) {
              setState(() {
                _country = newValue;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('I agree to the terms and conditions'),
            leading: Checkbox(
              value: _agreedToTerms,
              onChanged: (bool? value) {
                setState(() {
                  _agreedToTerms = value ?? false;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage()),
                );
              },
              child: const Text('Register'),
            ),
          )
        ],
      ),
    ),
  ],
),
```

### 4. 'home_page.dart'

Halaman ini adalah halaman utama aplikasi yang menampilkan informasi skor, berita terbaru, dan daftar favorit pengguna. Halaman ini juga menggunakan BottomNavigationBar untuk navigasi antar tab.

* Membuat Variabel _selectedIndex untuk mengatur berada di index ke berapa saat ini
* Membuat beberapa final List Map yang kompleks untuk mengatur isi widget ke bentuk card yaitu matchData, newsData dan favData

```dart
int _selectedIndex = 0;

final List<Map<String, dynamic>> matchData = [
{'teamA': 'Sevilla', 'teamB': 'Valladolid', 'scoreA': 2, 'scoreB': 1},
{'teamA': 'Valencia', 'teamB': 'Osasuna', 'scoreA': 0, 'scoreB': 0},
{'teamA': 'Real Madrid', 'teamB': 'Alaves', 'scoreA': 3, 'scoreB': 2},
{'teamA': 'Atalanta', 'teamB': 'Como', 'scoreA': 2, 'scoreB': 3},
{'teamA': 'Manchester United', 'teamB': 'Twente', 'scoreA': 1, 'scoreB': 1},
{'teamA': 'FC barcelona', 'teamB': 'Getafe', 'scoreA': 1, 'scoreB': 0},
{'teamA': 'Girona', 'teamB': 'Rayo Vallecano', 'scoreA': 0, 'scoreB': 0},
];

final List<Map<String, dynamic>> newsData = [
{
  'jurnalis': 'Daily Star',
  'headline':
      'Haaland left bleeding after tackle as fans say ankle looks like a dog gnawed on it',
  'dateline': '7 Minutes Ago'
},
{
  'jurnalis': 'The Sun',
  'headline':
      'Arsenal Vs Leicester LIVE SCORE: Gunners host Foxes looking to keep up the pressure on league leaders Man City',
  'dateline': '14 Minutes Ago'
},
{
  'jurnalis': 'BBC',
  'headline': "Ten Hag hasn't improved any individual at Man Utd",
  'dateline': '21 Minutes Ago'
},
];

final List<Map<String, dynamic>> favData = [
{
  'head': 'My Favorite',
  'avatar': [
    'FC Barcelona',
    'Lionel Messi',
  ],
},
{
  'head': 'Following Team',
  'avatar': [
    'Fc Barcelona',
    'Spain',
    'Indonesia',
  ],
},
{
  'head': 'Following Competitions',
  'avatar': [
    'La Liga',
    'Champions League',
    'Premiere League',
  ],
},
{
  'head': 'Following Players',
  'avatar': [
    'Lionel Messi',
    'Lamine Yamal',
    'Frenkie De Jong',
  ],
},
];
```

* Mengatur style

```dart
static const styleKu1 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 10, 52, 87),
);

static const styleKu2 = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 84, 15, 27),
);

static const styleKu3 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 84, 15, 27),
);

static const styleKu4 = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 84, 15, 27),
);
```

* Membuat widget card yang menampilkan hasil pertandingan antara dua tim yang mengambil data dari final List Map matchData
* Membuat widget card yang menampilkan informasi seperti jurnalis, judul berita dan tanggal berita yang mengambil data dari final List Map newsData
* Membuat widget card yang menampilkan daftar avatar yang mengambil data dari final List Map favData (TBC)




```dart
Widget buildScoreCard(String teamA, String teamB, int scoreA, int scoreB) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(teamA, style: styleKu1),
              const Text('vs', style: TextStyle(fontSize: 16)),
              Text(teamB, style: styleKu1),
            ],
          ),
          Text('$scoreA - $scoreB', style: styleKu1),
        ],
      ),
    ),
  );
}

Widget buildNewsCard(String jurnalis, String headline, String dateline) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(jurnalis, style: styleKu2),
              const SizedBox(height: 4),
              Text(headline, style: styleKu3),
              const SizedBox(height: 4),
              Text(dateline, style: styleKu2),
              const SizedBox(height: 4),
            ],
          ),
          const Placeholder(
            fallbackHeight: 200,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}

Widget buildFavoriteCard(String head, List<String> avatar) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(head, style: styleKu2),
            const SizedBox(height: 4),
            Wrap(
              spacing: 1,
              alignment: WrapAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                ...List.generate(
                  avatar.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 6),
                    child: Column(
                      children: [
                        const CircleAvatar(),
                        const SizedBox(height: 4),
                        Text(
                          avatar[index],
                          style: styleKu4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    ),
  );
}
```

* Membuat List of widgets yang artinya kita akan menampilkan konten pada tab berbeda dalam aplikasi
* Fungsi ini yang akan mengisi konten/widget pada saat menekan BottomNavigationBar
* Fungsi get widgetOptions ini yang akan mengembalikan daftar widget yag digunakan untuk masing-masing tab
* Simpelnya :
    * Tab 1 menampilkan card skor pertandingan
    * Tab 2 menampilkan card berita
    * Tab 3 menampilkan card favorit user
    * Tab 4 menampilkan card informasi profil yang berada di halaman lain

```dart
// Update the list to include relevant content for each tab
  List<Widget> get widgetOptions {
    return [
      ListView.builder(
        itemCount: matchData.length,
        itemBuilder: (context, index) {
          final match = matchData[index];
          return buildScoreCard(
            match['teamA'],
            match['teamB'],
            match['scoreA'],
            match['scoreB'],
          );
        },
      ),
      ListView.builder(
        itemCount: newsData.length,
        itemBuilder: (context, index) {
          final news = newsData[index];
          return buildNewsCard(
            news['jurnalis'],
            news['headline'],
            news['dateline'],
          );
        },
      ),
      ListView.builder(
        itemCount: favData.length,
        itemBuilder: (context, index) {
          final fav = favData[index];
          final avatars = fav['avatar'] ?? [];
          return buildFavoriteCard(
            fav['head'],
            List<String>.from(avatars),
          );
        },
      ),
      // Profile Tab
      const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 60,
            ),
            SizedBox(height: 10),
            Text(
              'Your Profile',
              style: styleKu1,
            ),
            SizedBox(height: 10),
            Text(
              'Username: your_username',
              style: styleKu2,
            ),
            Text(
              'Email: your_email@example.com',
              style: styleKu2,
            ),
          ],
        ),
      ),
    ];
  }
```

* Fungsi '_onItemTapped(int index)' digunakan untuk menangani logika ketika salah satu item BottomNavigationBar ditekan oleh user. Fungsi ini mengubah navbar yang sedang aktif berdasarkan nilai index yang diterima sebagai argumen

```dart
void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}
```

* Membuat navigasi BottomNavigationBar
* 'currentIndex' menunjukkan indeks yang aktif saat ini
* 'OnTap' dihubungkan dengan fungsi '_onItemTapped' yang menangani logika ketika BottomNavigationBar ditekan
* 'type' diatur ke 'BottomNavigationBarType.fixed' yang berarti semua item akan ditampilkan di bar navigasi tanpa disembunyikan atau ditampilkan secara dinamis

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Sofa Score'),
    ),
    body: Center(
      child: widgetOptions.elementAt(_selectedIndex),
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.scoreboard_outlined),
          label: 'Score',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper_outlined),
          label: 'News',
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
```