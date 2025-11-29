import '/models/candi.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final Map<String, _User> _users = {};
  _User? _currentUser;

  bool register({
    required String username,
    required String password,
    String? fullName,
  }) {
    final key = username.trim().toLowerCase();
    if (key.isEmpty || password.isEmpty) return false;
    if (_users.containsKey(key)) return false;
    _users[key] = _User(username: username.trim(), password: password, name: fullName);
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

  bool signIn({required String username, required String password}) {
    if (!validate(username, password)) return false;
    final key = username.trim().toLowerCase();
    _currentUser = _users[key];
    return true;
  }

  void signOut() {
    _currentUser = null;
  }

  _User? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;
  int get favoriteCount => _currentUser?.favorites.length ?? 0;
  String? get photoPath => _currentUser?.photoPath;

  /// Toggle favorite status for the given candi. Returns the new favorite value.
  bool toggleFavorite(String candiName) {
    if (!isSignedIn) return false;
    final user = _currentUser!;
    final name = candiName.trim();
    if (user.favorites.contains(name)) {
      user.favorites.remove(name);
      return false;
    } else {
      user.favorites.add(name);
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

  void updatePhoto(String path) {
    if (!isSignedIn) return;
    _currentUser!.photoPath = path;
  }
}

class _User {
  _User({
    required this.username,
    required this.password,
    this.name,
    Set<String>? favorites,
    this.photoPath,
  }) : favorites = favorites ?? <String>{};

  final String username;
  final String password;
  final String? name;
  final Set<String> favorites;
  String? photoPath;
}
