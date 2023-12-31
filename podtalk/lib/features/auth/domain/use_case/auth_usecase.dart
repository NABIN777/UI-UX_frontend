import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/core/failure/failure.dart';
import 'package:podtalk/features/auth/domain/entity/user_entity.dart';
import 'package:podtalk/features/auth/domain/repository/auth_repository.dart';

final authUseCaseProvider = Provider((ref) {
  return AuthUseCase(
    ref.read(authRepositoryProvider),
  );
});

class AuthUseCase {
  final IAuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<Either<Failure, bool>> registerUser(UserEntity user) async {
    return await _authRepository.registerUser(user);
  }

  Future<Either<Failure, bool>> loginUser(
      String username, String password) async {
    return await _authRepository.loginUser(username, password);
  }

  Future<Either<Failure, bool>> changeuser(UserEntity user, String id) async {
    return await _authRepository.changeuser(user, id);
  }
}
