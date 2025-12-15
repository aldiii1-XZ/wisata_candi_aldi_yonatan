import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/screens/home_screen.dart';
import '/screens/search_screen.dart';
import '/widgets/profile_info_item.dart';
import '../services/auth_service.dart';
import 'signin_screen.dart';
import '../data/candi_data.dart';
import '/screens/favorites_screen.dart';
import '../utils/profile_photo_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _navIndex = 3; // Profile tab
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _profileImagePath = AuthService.instance.photoPath;
  }

  void signOut() {
    AuthService.instance.signOut();
    AuthService.instance.syncFavorites(candiList);
    setState(() {
      _profileImagePath = null;
    });
  }

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        );
        break;
      case 3:
        setState(() => _navIndex = index);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance;
    final user = auth.currentUser;
    final isSignedIn = auth.isSignedIn;
    final imageProvider = buildProfileImageProvider(_profileImagePath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
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
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.deepPurple,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: imageProvider,
                          ),
                          IconButton(
                            onPressed: _changePhoto,
                            icon: Icon(
                              isSignedIn
                                  ? Icons.camera_alt
                                  : Icons.login_rounded,
                            ),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSignedIn
                              ? Icons.verified_user
                              : Icons.person_outline,
                          color: isSignedIn ? Colors.deepPurple : Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isSignedIn
                                ? 'Selamat datang, ${user?.name?.isNotEmpty == true ? user!.name : user?.username ?? 'Pengguna'}'
                                : 'Mode tamu aktif. Masuk untuk menyimpan favorit dan profil.',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 4),
                  ProfileInfoItem(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    icon: Icons.lock,
                    label: 'Username',
                    value: user?.username ?? '-',
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
                    value:
                        (user?.name?.isNotEmpty ?? false) ? user!.name! : '-',
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
                    value: auth.favoriteCount == 0
                        ? isSignedIn
                            ? 'Belum ada favorit'
                            : 'Tidak tersimpan di mode tamu'
                        : '${auth.favoriteCount} favorit',
                    showEditIcon: false,
                    onEditPressed: null,
                    iconColor: Colors.redAccent,
                  ),
                  const SizedBox(height: 4),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSignedIn
                            ? Colors.deepPurple
                            : Colors.green.shade600,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isSignedIn
                          ? signOut
                          : () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignInScreen()),
                              );
                            },
                      child: Text(isSignedIn ? 'Keluar' : 'Masuk / Daftar'),
                    ),
                  ),
                  if (!isSignedIn)
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Anda berada di mode tamu. Login untuk menyimpan data.'),
                          ),
                        );
                      },
                      child: const Text('Tetap gunakan mode tamu'),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _changePhoto() async {
    final auth = AuthService.instance;
    if (!auth.isSignedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masuk terlebih dahulu untuk mengubah foto.'),
        ),
      );
      return;
    }

    final source = await _selectPhotoSource();
    if (source == null) return;

    final picker = ImagePicker();
    try {
      final picked = await picker.pickImage(source: source);
      if (picked == null) return;

      auth.updatePhoto(picked.path);
      if (!mounted) return;
      setState(() {
        _profileImagePath = picked.path;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? 'Gagal mengambil foto. Periksa izin kamera Anda.'
                : 'Gagal mengambil foto. Periksa izin galeri Anda.',
          ),
        ),
      );
    }
  }

  Future<ImageSource?> _selectPhotoSource() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari galeri'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Ambil dengan kamera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
