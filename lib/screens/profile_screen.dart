import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import '/screens/search_screen.dart';
import '/widgets/profile_info_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSignedIn = true;
  String fullName = "";
  String userName = "";
  int favoriteCandiCount = 0;
  int _navIndex = 3; // Profile tab

  void toggleSignIn() {
    setState(() {
      isSignedIn = !isSignedIn;
    });
  }

  void signIn() => toggleSignIn();
  void signOut() => toggleSignIn();

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Favorit akan tersedia setelah fitur ini diaktifkan.'),
          ),
        );
        break;
      case 3:
        setState(() => _navIndex = index);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.deepPurple,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              AssetImage('images/placeholder_image.png'),
                        ),
                        if (isSignedIn)
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt),
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.grey),
                const SizedBox(height: 4),
                ProfileInfoItem(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  icon: Icons.lock,
                  label: 'Pengguna',
                  value: fullName,
                  showEditIcon: false,
                  onEditPressed: null,
                  iconColor: Colors.amber,
                ),
                const SizedBox(height: 4),
                const Divider(color: Colors.grey),
                const SizedBox(height: 4),
                ProfileInfoItem(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  icon: Icons.person,
                  label: 'Nama',
                  value: userName,
                  showEditIcon: isSignedIn,
                  onEditPressed: isSignedIn ? () {} : null,
                  iconColor: Colors.deepPurple,
                ),
                const SizedBox(height: 4),
                const Divider(color: Colors.grey),
                const SizedBox(height: 4),
                ProfileInfoItem(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  icon: Icons.favorite,
                  label: 'Favorit',
                  value: favoriteCandiCount == 0
                      ? '-'
                      : '$favoriteCandiCount favorites',
                  showEditIcon: false,
                  onEditPressed: null,
                  iconColor: Colors.redAccent,
                ),
                const SizedBox(height: 4),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: isSignedIn ? signOut : signIn,
                  child: Text(isSignedIn ? 'Sign Out' : 'Sign In'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
