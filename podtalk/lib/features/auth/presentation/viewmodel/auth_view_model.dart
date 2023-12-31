import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/core/common/snackbar/my_snackbar.dart';
import 'package:podtalk/features/auth/domain/entity/user_entity.dart';
import 'package:podtalk/features/auth/domain/use_case/auth_usecase.dart';
import 'package:podtalk/features/auth/presentation/state/auth_state.dart';

import '../../../../config/routers/app_route.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(
    ref.read(authUseCaseProvider),
  );
});

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthUseCase _authUseCase;

  AuthViewModel(this._authUseCase) : super(AuthState(isLoading: false));

  Future<void> registerUser(BuildContext context, UserEntity user) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.registerUser(user);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        // showSnackBar(
        //     message: failure.error, context: context, color: Colors.red);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        // showSnackBar(message: "Successfully registered", context: context);
      },
    );
  }

  Future<void> loginUser(
    BuildContext context, // yo kaile pani na lekhne
    String username,
    String password,
  ) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.loginUser(username, password);
    data.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.error);
        // showSnackBar(
        //     message: 'Incorrect username or password${failure.error}',
        //     context: context,
        //     color: Colors.red);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        Navigator.popAndPushNamed(context, AppRoute.dashRoute);
        showSnackBar(message: "Successfully logged in", context: context);
      },
    );
  }

  Future<void> changeuser(BuildContext context, UserEntity user) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.changeuser(user, user.id!);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        // showSnackBar(
        //     message: failure.error, context: context, color: Colors.red);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        showSnackBar(message: "Successfully registered", context: context);
      },
    );
  }
}
