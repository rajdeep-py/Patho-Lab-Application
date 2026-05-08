import 'package:flutter_riverpod/legacy.dart';
import '../models/user.dart';

class ProfileState {
  final User? user;
  final bool isLoading;
  final bool isEditing;
  final String? error;

  ProfileState({
    this.user,
    this.isLoading = false,
    this.isEditing = false,
    this.error,
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    bool? isEditing,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      error: error ?? this.error,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState()) {
    _loadInitialProfile();
  }

  void _loadInitialProfile() {
    // Initial dummy profile for Patho Lab
    final initialUser = User(
      id: "1",
      name: "LifeLine Patho Lab",
      email: "admin@lifeline.com",
      profileImage: "https://images.unsplash.com/photo-1581594549595-35e6ed96102e?q=80&w=2070&auto=format&fit=crop",
      address: "Sector 5, Salt Lake City, Kolkata, West Bengal 700091",
      registrationNo: "REG-2024-LL-001",
      licenseNo: "LIC-WB-PATH-8899",
      phone: "9876543210",
      alternativePhone: "9123456789",
      password: "password123",
    );
    state = state.copyWith(user: initialUser);
  }

  void toggleEdit() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  Future<void> updateProfile(User updatedUser) async {
    state = state.copyWith(isLoading: true, error: null);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    state = state.copyWith(
      user: updatedUser,
      isLoading: false,
      isEditing: false,
    );
  }
}
