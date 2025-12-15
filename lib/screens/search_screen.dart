import 'package:flutter/material.dart';
import '../models/candi.dart';
import '../data/candi_data.dart';
import '../services/auth_service.dart';
import '/screens/favorites_screen.dart';
import '/screens/home_screen.dart';
import '/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Candi> _filteredCandis = List.from(candiList);
  int _navIndex = 0; // Search tab

  void _filterCandis(String query) {
    final filtered = candiList.where((candi) {
      final search = query.toLowerCase();
      return candi.name.toLowerCase().contains(search) ||
          candi.location.toLowerCase().contains(search) ||
          candi.type.toLowerCase().contains(search);
    }).toList();

    setState(() {
      _filteredCandis = filtered;
    });
  }

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    switch (index) {
      case 0:
        setState(() => _navIndex = index);
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Candi'),
        backgroundColor: Colors.deepPurple,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.deepPurple.shade200,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Akun',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: _controller,
                onChanged: _filterCandis,
                decoration: const InputDecoration(
                  hintText: 'Cari candi ...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCandis.length,
              itemBuilder: (context, index) {
                final candi = _filteredCandis[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        candi.imageAsset,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      candi.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${candi.location}\n${candi.type}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(
                        candi.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: candi.isFavorite
                            ? Colors.red
                            : Colors.grey.shade600,
                      ),
                      onPressed: () {
                        if (!AuthService.instance.isSignedIn) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Masuk terlebih dahulu untuk menyimpan favorit.'),
                            ),
                          );
                          return;
                        }
                        AuthService.instance
                            .toggleFavorite(candi.name)
                            .then((nowFavorite) {
                          setState(() {
                            candi.isFavorite = nowFavorite;
                          });
                        });
                      },
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(candi.name),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(candi.imageAsset),
                                const SizedBox(height: 8),
                                Text(
                                  candi.description,
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 8),
                                Text('Dibangun: ${candi.built}'),
                                Text('Tipe: ${candi.type}'),
                                Text('Lokasi: ${candi.location}'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
