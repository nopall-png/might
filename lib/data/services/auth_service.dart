import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'appwrite_service.dart';

class AuthUser {
  final String uid;
  final String? email;
  AuthUser({required this.uid, this.email});
}

class UserCredential {
  final AuthUser? user;
  UserCredential({this.user});
}

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _controller = StreamController<AuthUser?>.broadcast();
  Stream<AuthUser?> get authStateChanges => _controller.stream;
  AuthUser? _currentUser;
  AuthUser? get currentUser => _currentUser;

  Account get _account => AppwriteService.instance.account;

  /// Restore session on app start if Appwrite has an active session.
  /// This ensures users skip onboarding when they already logged in previously.
  Future<void> restoreSessionIfAny() async {
    try {
      final user = await _account.get();
      _currentUser = AuthUser(uid: user.$id, email: user.email);
      _controller.add(_currentUser);
      // ignore: avoid_print
      print('[AuthService] session restored for uid=${user.$id}');
    } on AppwriteException catch (e) {
      // No active session or unable to fetch; treat as logged out
      _currentUser = null;
      _controller.add(null);
      // ignore: avoid_print
      print('[AuthService] no existing session: code=${e.code}, message=${e.message}');
    } catch (e) {
      _currentUser = null;
      _controller.add(null);
      // ignore: avoid_print
      print('[AuthService] restoreSessionIfAny unexpected error: $e');
    }
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final user = await _account.get();
      _currentUser = AuthUser(uid: user.$id, email: user.email);
      _controller.add(_currentUser);
      return UserCredential(user: _currentUser);
    } on AppwriteException catch (e) {
      // Logging detil untuk diagnosa cepat
      // Contoh kode error: user_already_exists, invalid_credentials, general
      // Pesan akan dipakai di UI agar lebih informatif
      // ignore: avoid_print
      print(
        '[AuthService] signUp failed: code=${e.code}, message=${e.message}',
      );
      throw Exception(e.message ?? 'Gagal registrasi (Appwrite)');
    } catch (e) {
      // ignore: avoid_print
      print('[AuthService] signUp unexpected error: $e');
      throw Exception('Terjadi kesalahan saat registrasi');
    }
  }

  Future<UserCredential> signUpOrSignIn({
    required String email,
    required String password,
  }) async {
    try {
      return await signUp(email: email, password: password);
    } on Exception catch (e) {
      final msg = e.toString().toLowerCase();
      // Jika user sudah ada (409), fallback ke sign in
      if (msg.contains('already exists')) {
        // ignore: avoid_print
        print('[AuthService] signUp conflict, fallback to signIn');
        return await signIn(email: email, password: password);
      }
      rethrow;
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final user = await _account.get();
      _currentUser = AuthUser(uid: user.$id, email: user.email);
      _controller.add(_currentUser);
      return UserCredential(user: _currentUser);
    } on AppwriteException catch (e) {
      // Jika sesi sudah aktif, anggap login sukses dan ambil user saat ini
      final msg = (e.message ?? '').toLowerCase();
      if (e.code == 401 && msg.contains('session is active')) {
        // ignore: avoid_print
        print(
          '[AuthService] signIn: session already active, using existing session',
        );
        final user = await _account.get();
        _currentUser = AuthUser(uid: user.$id, email: user.email);
        _controller.add(_currentUser);
        return UserCredential(user: _currentUser);
      }
      // ignore: avoid_print
      print(
        '[AuthService] signIn failed: code=${e.code}, message=${e.message}',
      );
      throw Exception(e.message ?? 'Gagal login (Appwrite)');
    } catch (e) {
      // ignore: avoid_print
      print('[AuthService] signIn unexpected error: $e');
      throw Exception('Terjadi kesalahan saat login');
    }
  }

  Future<void> signOut() async {
    try {
      await _account.deleteSessions();
    } finally {
      _currentUser = null;
      _controller.add(null);
    }
  }
}
