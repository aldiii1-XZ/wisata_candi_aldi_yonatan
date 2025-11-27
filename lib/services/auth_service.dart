class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final Map<String, _User> _users = {};

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
}

class _User {
  _User({required this.username, required this.password, this.name});

  final String username;
  final String password;
  final String? name;
}
