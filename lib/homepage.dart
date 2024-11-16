import 'package:flutter/material.dart';
import 'pokemon_list_page.dart';
import 'BidListPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Memulai dari tab Home

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text("Your Profile")),
    HomeContent(), // Konten Home yang berisi tombol navigasi
    PokemonListPage(), // Menampilkan halaman PokemonListPage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.blue),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {
                // Aksi untuk Edit Profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                // Aksi untuk Change Password
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                // Aksi untuk Log Out
              },
            ),
          ],
        ),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Battle',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigasi ke halaman koleksi (Your Collection)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PokemonListPage(),
                ),
              );
            },
            child: const Text("Your Collection"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigasi ke halaman lelang (Bids Card)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BidListPage(),
                ),
              );
            },
            child: const Text("Bids Card"),
          ),
        ],
      ),
    );
  }
}
