import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'home_screen.dart';

const List<String> kCandiRecommendations = [
  'Candi Borobudur',
  'Candi Prambanan',
  'Candi Sewu',
  'Candi Mendut',
  'Candi Plaosan',
  'Candi Kalasan',
  'Candi Ijo',
];

void main() {
  runApp(const MyApp());
}

Future<void> showProfessionalAlert(
  BuildContext context, {
  required String title,
  required String message,
  bool isSuccess = false,
}) {
  final Color accent = isSuccess ? Colors.teal : Colors.deepOrange;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, accent.withOpacity(0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSuccess ? Icons.verified_rounded : Icons.info_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Oke, mengerti'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class DestinationSearchDelegate extends SearchDelegate<String> {
  DestinationSearchDelegate(this.items);

  final List<String> items;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    final lower = query.toLowerCase();
    final List<String> matches =
        items.where((item) => item.toLowerCase().contains(lower)).toList();

    if (matches.isEmpty) {
      return const Center(child: Text('Tidak ada hasil'));
    }

    return ListView.separated(
      itemCount: matches.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = matches[index];
        return ListTile(
          leading:
              const Icon(Icons.location_on_outlined, color: Colors.blueAccent),
          title: Text(item),
          subtitle: const Text('Cari info candi terkait'),
          onTap: () => close(context, item),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Sign In',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
      ),
      home: const SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSignInReady = false;
  double _scaleSignIn = 1.0;
  int _navIndex = 1; // default to Home tab

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateSignInReady);
    _passwordController.addListener(_updateSignInReady);
  }

  void _updateSignInReady() {
    final isReady = _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
    if (isReady != _isSignInReady) {
      setState(() => _isSignInReady = isReady);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _openSearch() async {
    final result = await showSearch<String>(
      context: context,
      delegate: DestinationSearchDelegate(kCandiRecommendations),
    );

    if (!mounted || result == null || result.isEmpty) return;

    showProfessionalAlert(
      context,
      title: 'Destinasi dipilih',
      message: 'Anda memilih $result. Mulai jelajahi informasi lebih lanjut.',
      isSuccess: true,
    );
  }

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        _openSearch();
        break;
      case 1:
        showProfessionalAlert(
          context,
          title: 'Beranda',
          message: 'Masuk terlebih dahulu untuk melihat beranda utama.',
        );
        break;
      case 2:
        showProfessionalAlert(
          context,
          title: 'Favorit kosong',
          message: 'Tambahkan destinasi favorit setelah kamu login.',
        );
        break;
      case 3:
        showProfessionalAlert(
          context,
          title: 'Profil',
          message: 'Masuk untuk mengelola akun dan profil kamu.',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: _openSearch,
            tooltip: 'Cari candi',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blueGrey,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Nama Pengguna",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Kata Sandi",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTapDown: (_) => setState(() => _scaleSignIn = 0.95),
                onTapUp: (_) => setState(() => _scaleSignIn = 1.0),
                onTapCancel: () => setState(() => _scaleSignIn = 1.0),
                onTap: () {
                  if (_isSignInReady) {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const HomeScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    );
                  } else {
                    showProfessionalAlert(
                      context,
                      title: 'Data belum lengkap',
                      message:
                          'Masukkan username dan kata sandi terlebih dahulu untuk melanjutkan.',
                    );
                  }
                },
                child: AnimatedScale(
                  scale: _scaleSignIn,
                  duration: const Duration(milliseconds: 100),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isSignInReady ? Colors.blueAccent : Colors.grey,
                        foregroundColor: Colors.white,
                        elevation: _isSignInReady ? 2 : 0,
                      ),
                      onPressed: null,
                      child: const Text("Sign In"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: "Belum punya akun? ",
                  style: const TextStyle(color: Colors.black87),
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SignUpScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSignUpReady = false;
  double _scaleSignUp = 1.0;
  int _navIndex = 1; // default to Home tab

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateSignUpReady);
    _usernameController.addListener(_updateSignUpReady);
    _passwordController.addListener(_updateSignUpReady);
  }

  void _updateSignUpReady() {
    final isReady = _nameController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
    if (isReady != _isSignUpReady) {
      setState(() => _isSignUpReady = isReady);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _openSearch() async {
    final result = await showSearch<String>(
      context: context,
      delegate: DestinationSearchDelegate(kCandiRecommendations),
    );

    if (!mounted || result == null || result.isEmpty) return;

    showProfessionalAlert(
      context,
      title: 'Referensi ditemukan',
      message: 'Gunakan $result sebagai inspirasi kunjungan berikutnya.',
      isSuccess: true,
    );
  }

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        _openSearch();
        break;
      case 1:
        showProfessionalAlert(
          context,
          title: 'Beranda',
          message: 'Selesaikan pendaftaran untuk menuju beranda.',
        );
        break;
      case 2:
        showProfessionalAlert(
          context,
          title: 'Favorit kosong',
          message: 'Tambahkan destinasi favorit setelah akun dibuat.',
        );
        break;
      case 3:
        showProfessionalAlert(
          context,
          title: 'Profil',
          message: 'Akun akan siap setelah pendaftaran selesai.',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: _openSearch,
            tooltip: 'Cari candi',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blueGrey,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Nama Pengguna",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Kata Sandi",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTapDown: (_) => setState(() => _scaleSignUp = 0.95),
                onTapUp: (_) => setState(() => _scaleSignUp = 1.0),
                onTapCancel: () => setState(() => _scaleSignUp = 1.0),
                onTap: () {
                  if (!_isSignUpReady) {
                    showProfessionalAlert(
                      context,
                      title: 'Data belum lengkap',
                      message:
                          'Pastikan nama, username, dan kata sandi terisi sebelum melanjutkan.',
                    );
                  } else {
                    showProfessionalAlert(
                      context,
                      title: 'Pendaftaran siap',
                      message:
                          'Data sudah lengkap. Kamu bisa lanjutkan proses pendaftaran atau kembali ke halaman sebelumnya.',
                      isSuccess: true,
                    );
                  }
                },
                child: AnimatedScale(
                  scale: _scaleSignUp,
                  duration: const Duration(milliseconds: 100),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isSignUpReady ? Colors.blueAccent : Colors.grey,
                        foregroundColor: Colors.white,
                        elevation: _isSignUpReady ? 2 : 0,
                      ),
                      onPressed: null,
                      child: const Text("Sign Up"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
