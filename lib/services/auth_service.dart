import 'package:shared_preferences/shared_preferences.dart';

import '../models/candi.dart';
import 'local_storage_service.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();
  static const _kLastUserKey = 'last_user';

  final Map<String, _User> _users = {};
  _User? _currentUser;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await LocalStorageService.instance.init();
    final storedUsers = await LocalStorageService.instance.loadUsers();
    for (final stored in storedUsers) {
      final key = stored.username.toLowerCase();
      _users[key] = _User(
        id: stored.id,
        username: stored.username,
        password: stored.password,
        name: stored.name,
        photoPath: stored.photoPath,
        favorites: stored.favorites,
      );
    }
    final prefs = await SharedPreferences.getInstance();
    final lastUser = prefs.getString(_kLastUserKey);
    if (lastUser != null) {
      _currentUser = _users[lastUser];
    }
    _initialized = true;
  }

  Future<bool> register({
    required String username,
    required String password,
    String? fullName,
  }) async {
    final key = username.trim().toLowerCase();
    if (key.isEmpty || password.isEmpty) return false;
    if (_users.containsKey(key)) return false;
    final userId = await LocalStorageService.instance.insertUser(
      username: username.trim(),
      password: password,
      name: fullName,
    );
    _users[key] = _User(
      id: userId,
      username: username.trim(),
      password: password,
      name: fullName,
    );
    return true;
  }

  bool userExists(String username) {
    final key = username.trim().toLowerCase();
    return _users.containsKey(key);
  }

  bool validate(String username, String password) {
    final key = username.trim().toLowerCase();
    final user = _users[key];
    if (user == null) return false;
    return user.password == password;
  }

  Future<bool> signIn({required String username, required String password}) async {
    if (!validate(username, password)) return false;
    final key = username.trim().toLowerCase();
    _currentUser = _users[key];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastUserKey, key);
    return true;
  }

  Future<void> signOut() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLastUserKey);
  }

  _User? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;
  int get favoriteCount => _currentUser?.favorites.length ?? 0;
  String? get photoPath => _currentUser?.photoPath;

  /// Toggle favorite status for the given candi. Returns the new favorite value.
  Future<bool> toggleFavorite(String candiName) async {
    if (!isSignedIn) return false;
    final user = _currentUser!;
    final name = candiName.trim();
    if (user.favorites.contains(name)) {
      user.favorites.remove(name);
      await LocalStorageService.instance.setFavorite(
        userId: user.id,
        candiName: name,
        isFavorite: false,
      );
      return false;
    } else {
      user.favorites.add(name);
      await LocalStorageService.instance.setFavorite(
        userId: user.id,
        candiName: name,
        isFavorite: true,
      );
      return true;
    }
  }

  /// Apply stored favorites to the provided candi list so UI reflects user data.
  void syncFavorites(Iterable<Candi> candis) {
    final favoriteNames = _currentUser?.favorites ?? <String>{};
    for (final c in candis) {
      c.isFavorite = favoriteNames.contains(c.name);
    }
  }

  Future<void> updatePhoto(String path) async {
    if (!isSignedIn) return;
    _currentUser!.photoPath = path;
    await LocalStorageService.instance.updateUserPhoto(
      userId: _currentUser!.id,
      photoPath: path,
    );
  }
}

class _User {
  _User({
    required this.id,
    required this.username,
    required this.password,
    this.name,
    Set<String>? favorites,
    this.photoPath,
  }) : favorites = favorites ?? <String>{};

  final int id;
  final String username;
  final String password;
  final String? name;
  final Set<String> favorites;
  String? photoPath;
}
