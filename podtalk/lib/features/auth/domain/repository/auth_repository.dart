import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/core/failure/failure.dart';
import 'package:podtalk/features/auth/data/repository/auth_remote_repository.dart';
import 'package:podtalk/features/auth/domain/entity/user_entity.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return ref.read(authRemoteRepositoryProvider);
});

abstract class IAuthRepository {
  Future<Either<Failure, bool>> registerUser(UserEntity user);
  Future<Either<Failure, bool>> loginUser(String username, String password);
  Future<Either<Failure, bool>> changeuser(UserEntity user, String id);
}
