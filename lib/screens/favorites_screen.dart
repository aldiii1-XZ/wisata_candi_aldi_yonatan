import 'package:flutter/material.dart';
import '../data/candi_data.dart';
import '../models/candi.dart';
import '../services/auth_service.dart';
import '/screens/home_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/search_screen.dart';
import '/screens/detail_screen.dart';
import '/screens/signin_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _navIndex = 2; // Favorites tab

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;
      case 2:
        setState(() => _navIndex = index);
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
    final auth = AuthService.instance;
    final isSignedIn = auth.isSignedIn;
    final List<Candi> favorites =
        candiList.where((c) => c.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: !isSignedIn
            ? _GuestPlaceholder(onSignIn: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignInScreen(),
                  ),
                );
              })
            : favorites.isEmpty
                ? _EmptyFavorites()
                : ListView.separated(
                    itemCount: favorites.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final candi = favorites[index];
                      return _FavoriteTile(
                        candi: candi,
                        onRemove: () {
                          AuthService.instance
                              .toggleFavorite(candi.name)
                              .then((nowFavorite) {
                            setState(() {
                              candi.isFavorite = nowFavorite;
                            });
                          });
                        },
                        onOpen: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(candi: candi),
                            ),
                          ).then((_) => setState(() {}));
                        },
                      );
                    },
                  ),
      ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({
    required this.candi,
    required this.onRemove,
    required this.onOpen,
  });

  final Candi candi;
  final VoidCallback onRemove;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        onTap: onOpen,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            candi.imageAsset,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          candi.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${candi.location}\n${candi.type}'),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: onRemove,
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.favorite_border,
              size: 64, color: Colors.deepPurpleAccent),
          SizedBox(height: 12),
          Text(
            'Belum ada favorit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            'Tambahkan candi ke favorit dari halaman detail.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _GuestPlaceholder extends StatelessWidget {
  const _GuestPlaceholder({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline,
              size: 64, color: Colors.deepPurpleAccent),
          const SizedBox(height: 12),
          const Text(
            'Masuk untuk menyimpan favorit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Mode tamu tidak menyimpan daftar favorit.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Masuk / Daftar'),
          ),
        ],
      ),
    );
  }
}
