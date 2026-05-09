import 'package:flutter_riverpod/legacy.dart';

class SettingsState {
  final bool isLoading;

  const SettingsState({this.isLoading = false});

  SettingsState copyWith({bool? isLoading}) {
    return SettingsState(isLoading: isLoading ?? this.isLoading);
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    // Simulate API call for logout
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false);
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true);
    // Simulate API call for account deletion
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false);
  }
}
