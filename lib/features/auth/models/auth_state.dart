import 'package:meta/meta.dart';

@immutable
final class AuthState {
  const AuthState({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.birthday,
    required this.isDemo,
  });

  final String? userId;
  final String? username;
  final String? displayName;
  final DateTime? birthday;
  final bool isDemo;

  bool get isLoggedIn => userId != null;

  static const AuthState guest = AuthState(
    userId: null,
    username: null,
    displayName: null,
    birthday: null,
    isDemo: false,
  );
}
