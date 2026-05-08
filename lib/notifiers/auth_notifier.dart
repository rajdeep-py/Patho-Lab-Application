import 'package:flutter_riverpod/legacy.dart';
import '../models/user.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (email.isNotEmpty && password.isNotEmpty) {
      final user = User(id: "1", email: email, name: "Patho Lab Admin");
      state = state.copyWith(user: user, isLoading: false);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: "Please enter valid credentials",
      );
    }
  }

  void logout() {
    state = AuthState();
  }
}
