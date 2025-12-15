import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();

  Database? _db;
  bool _useMemory = false;
  final List<StoredUser> _memoryUsers = [];
  int _memoryId = 1;

  Future<void> init() async {
    if (_db != null || _useMemory) return;
    if (kIsWeb) {
      // sqflite is not available on web; fall back to in-memory store.
      _useMemory = true;
      return;
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wisata_candi.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT,
            name TEXT,
            photoPath TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            candiName TEXT,
            UNIQUE(userId, candiName)
          );
        ''');
      },
    );
  }

  Future<int> insertUser({
    required String username,
    required String password,
    String? name,
    String? photoPath,
  }) async {
    if (_useMemory) {
      final user = StoredUser(
        id: _memoryId++,
        username: username,
        password: password,
        name: name,
        photoPath: photoPath,
        favorites: <String>{},
      );
      _memoryUsers.add(user);
      return user.id;
    }
    final db = _ensureDb();
    return db.insert(
      'users',
      {
        'username': username,
        'password': password,
        'name': name,
        'photoPath': photoPath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUserPhoto({
    required int userId,
    required String? photoPath,
  }) async {
    if (_useMemory) {
      final idx = _memoryUsers.indexWhere((u) => u.id == userId);
      if (idx != -1) {
        _memoryUsers[idx] =
            _memoryUsers[idx].copyWith(photoPath: photoPath);
      }
      return;
    }
    final db = _ensureDb();
    await db.update(
      'users',
      {'photoPath': photoPath},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<StoredUser>> loadUsers() async {
    if (_useMemory) {
      return List<StoredUser>.from(_memoryUsers);
    }
    final db = _ensureDb();
    final rows = await db.query('users');
    final users = <StoredUser>[];
    for (final row in rows) {
      final id = row['id'] as int;
      final favorites = await _loadFavorites(id);
      users.add(
        StoredUser(
          id: id,
          username: row['username'] as String,
          password: row['password'] as String,
          name: row['name'] as String?,
          photoPath: row['photoPath'] as String?,
          favorites: favorites,
        ),
      );
    }
    return users;
  }

  Future<Set<String>> _loadFavorites(int userId) async {
    if (_useMemory) {
      final user = _memoryUsers.firstWhere(
        (u) => u.id == userId,
        orElse: () => StoredUser(
          id: userId,
          username: '',
          password: '',
          name: null,
          photoPath: null,
          favorites: <String>{},
        ),
      );
      return user.favorites;
    }
    final db = _ensureDb();
    final rows = await db.query(
      'favorites',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return rows
        .map((row) => row['candiName'] as String)
        .toSet();
  }

  Future<void> setFavorite({
    required int userId,
    required String candiName,
    required bool isFavorite,
  }) async {
    if (_useMemory) {
      final idx = _memoryUsers.indexWhere((u) => u.id == userId);
      if (idx != -1) {
        final favorites = {..._memoryUsers[idx].favorites};
        if (isFavorite) {
          favorites.add(candiName);
        } else {
          favorites.remove(candiName);
        }
        _memoryUsers[idx] = _memoryUsers[idx].copyWith(favorites: favorites);
      }
      return;
    }
    final db = _ensureDb();
    if (isFavorite) {
      await db.insert(
        'favorites',
        {'userId': userId, 'candiName': candiName},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } else {
      await db.delete(
        'favorites',
        where: 'userId = ? AND candiName = ?',
        whereArgs: [userId, candiName],
      );
    }
  }

  Database _ensureDb() {
    final db = _db;
    if (db == null) {
      throw StateError('LocalStorageService not initialized');
    }
    return db;
  }
}

class StoredUser {
  StoredUser({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.photoPath,
    required this.favorites,
  });

  final int id;
  final String username;
  final String password;
  final String? name;
  final String? photoPath;
  final Set<String> favorites;

  StoredUser copyWith({
    String? photoPath,
    Set<String>? favorites,
  }) {
    return StoredUser(
      id: id,
      username: username,
      password: password,
      name: name,
      photoPath: photoPath ?? this.photoPath,
      favorites: favorites ?? this.favorites,
    );
  }
}
