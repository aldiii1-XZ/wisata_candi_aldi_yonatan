import 'package:flutter/material.dart';
import 'package:wisata_candi_aldi_yonatan/services/auth_service.dart';
import '../data/candi_data.dart';
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
              color: accent.withValues(alpha: 0.25),
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
                  colors: [accent, accent.withValues(alpha: 0.85)],
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
                      color: Colors.white.withValues(alpha: 0.15),
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

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSignInReady = false;
  late final AnimationController _bgController;
  late final Animation<double> _bgAnimation;
  bool _animateIn = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateSignInReady);
    _passwordController.addListener(_updateSignInReady);
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
    _bgAnimation =
        CurvedAnimation(parent: _bgController, curve: Curves.easeInOutCubic);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _animateIn = true);
    });
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
    _bgController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Masuk",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: _openSearch,
            tooltip: 'Cari candi',
          ),
        ],
      ),
      body: Stack(
        children: [
          _AnimatedLuxuryBackdrop(
            height: 240,
            scheme: scheme,
            animation: _bgAnimation,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSlide(
                      offset: _animateIn ? Offset.zero : const Offset(0, 0.05),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      child: AnimatedOpacity(
                        opacity: _animateIn ? 1 : 0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            border: Border.all(
                              color: scheme.primary
                                  .withValues(alpha: 0.12),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor:
                                        scheme.primary.withValues(alpha: 0.1),
                                    child: const Icon(Icons.spa,
                                        color: Colors.deepPurple, size: 28),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Wisata Candi",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Masuk untuk simpan favorit & profil",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: "Nama Pengguna",
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: "Kata Sandi",
                                  prefixIcon: const Icon(Icons.lock_outline),
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
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: _isSignInReady ? 3 : 0,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ).copyWith(
                                    backgroundColor: WidgetStateProperty
                                        .resolveWith<Color?>(
                                      (states) {
                                        if (states
                                            .contains(WidgetState.disabled)) {
                                          return Colors.grey.shade400;
                                        }
                                        return scheme.primary;
                                      },
                                    ),
                                  ),
                                  onPressed: _isSignInReady
                                      ? () => _handleSignIn()
                                      : null,
                                  child: const Text("Masuk"),
                                ),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                icon: const Icon(Icons.travel_explore),
                                label: const Text('Lanjut sebagai Tamu'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: scheme.primary,
                                  side: BorderSide(
                                      color: scheme.primary
                                          .withValues(alpha: 0.4)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                onPressed: () => _continueAsGuest(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Belum punya akun? ",
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: _goToSignUp,
                                child: Text(
                                  "Daftar sekarang",
                                  style: TextStyle(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (!_isSignInReady) {
      showProfessionalAlert(
        context,
        title: 'Data belum lengkap',
        message:
            'Masukkan username dan kata sandi terlebih dahulu untuk melanjutkan.',
      );
      return;
    }
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (!AuthService.instance.userExists(username)) {
      showProfessionalAlert(
        context,
        title: 'Akun belum terdaftar',
        message:
            'Buat akun terlebih dahulu melalui halaman Sign Up sebelum masuk.',
      );
      return;
    }

    final signedIn = await AuthService.instance
        .signIn(username: username, password: password);
    if (!signedIn) {
      showProfessionalAlert(
        context,
        title: 'Kredensial salah',
        message: 'Periksa kembali username dan kata sandi kamu.',
      );
      return;
    }

    // Refresh favorite flags with user data before navigating.
    AuthService.instance.syncFavorites(candiList);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Future<void> _continueAsGuest() async {
    await AuthService.instance.signOut();
    AuthService.instance.syncFavorites(candiList);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _goToSignUp() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSignUpReady = false;
  int _navIndex = 1; // default to Home tab
  late final AnimationController _bgController;
  late final Animation<double> _bgAnimation;
  bool _animateIn = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateSignUpReady);
    _usernameController.addListener(_updateSignUpReady);
    _passwordController.addListener(_updateSignUpReady);
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
    _bgAnimation =
        CurvedAnimation(parent: _bgController, curve: Curves.easeInOutCubic);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _animateIn = true);
    });
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
    _bgController.dispose();
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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daftar Akun",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
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
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.primary.withValues(alpha: 0.4),
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
          _AnimatedLuxuryBackdrop(
            height: 220,
            scheme: scheme,
            animation: _bgAnimation,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AnimatedSlide(
                      offset: _animateIn ? Offset.zero : const Offset(0, 0.05),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      child: AnimatedOpacity(
                        opacity: _animateIn ? 1 : 0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            border: Border.all(
                              color: scheme.primary
                                  .withValues(alpha: 0.12),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Icon(Icons.rocket_launch,
                                        color: scheme.primary),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Buat akun baru",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: "Nama",
                                  prefixIcon: Icon(Icons.badge_outlined),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: "Nama Pengguna",
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: "Kata Sandi",
                                  prefixIcon: const Icon(Icons.lock_outline),
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
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: _isSignUpReady ? 3 : 0,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ).copyWith(
                                    backgroundColor: WidgetStateProperty
                                        .resolveWith<Color?>(
                                      (states) {
                                        if (states.contains(
                                            WidgetState.disabled)) {
                                          return Colors.grey.shade400;
                                        }
                                        return scheme.primary;
                                      },
                                    ),
                                  ),
                                  onPressed: _isSignUpReady
                                      ? () => _handleSignUp()
                                      : null,
                                  child: const Text("Daftar"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (!_isSignUpReady) {
      showProfessionalAlert(
        context,
        title: 'Data belum lengkap',
        message:
            'Pastikan nama, username, dan kata sandi terisi sebelum melanjutkan.',
      );
      return;
    }
    final registered = await AuthService.instance.register(
      username: _usernameController.text,
      password: _passwordController.text,
      fullName: _nameController.text,
    );
    if (registered) {
      showProfessionalAlert(
        context,
        title: 'Pendaftaran berhasil',
        message:
            'Akun sudah dibuat. Silakan kembali ke halaman Sign In untuk masuk.',
        isSuccess: true,
      );
    } else {
      showProfessionalAlert(
        context,
        title: 'Akun sudah ada',
        message:
            'Username ini sudah terdaftar. Gunakan username lain atau masuk dengan akun tersebut.',
      );
    }
  }
}

class _AnimatedLuxuryBackdrop extends StatelessWidget {
  const _AnimatedLuxuryBackdrop({
    required this.height,
    required this.scheme,
    required this.animation,
  });

  final double height;
  final ColorScheme scheme;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final t = animation.value;
        final begin = const Alignment(-0.8, -1);
        final end = const Alignment(0.9, 0.6);
        final glowShift = (t - 0.5) * 30;

        return SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                          scheme.primary, Colors.indigo.shade900, 0.15)!,
                      Color.lerp(
                          scheme.secondary, Colors.pink.shade200, 0.25)!,
                    ],
                    begin: Alignment.lerp(begin, end, t)!,
                    end: Alignment.lerp(const Alignment(1, -0.3),
                        const Alignment(-0.6, 1), t)!,
                  ),
                ),
              ),
              Positioned(
                top: 30 + glowShift,
                left: -20,
                child: _GlassGlow(
                  diameter: 160,
                  color: scheme.primary.withValues(alpha: 0.12),
                ),
              ),
              Positioned(
                bottom: -10 - glowShift,
                right: -30,
                child: _GlassGlow(
                  diameter: 200,
                  color: scheme.secondary.withValues(alpha: 0.12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlassGlow extends StatelessWidget {
  const _GlassGlow({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
