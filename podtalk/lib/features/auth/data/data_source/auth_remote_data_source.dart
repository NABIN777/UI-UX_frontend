import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/config/constants/api_endpoint_1.dart';
import 'package:podtalk/core/failure/failure.dart';
import 'package:podtalk/core/network/remote/http_service.dart';
import 'package:podtalk/core/shared_prefs/user_shared_prefs.dart';
import 'package:podtalk/features/auth/domain/entity/user_entity.dart';

final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class AuthRemoteDataSource {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  AuthRemoteDataSource({required this.userSharedPrefs, required this.dio});

  Future<Either<Failure, bool>> registerUser(UserEntity user) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.register,
        data: {
          "username": user.username,
          "fullname": user.fullname,
          "email": user.email,
          "password": user.password,
        },
      );
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> loginUser(
    String username,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.login,
        data: {
          "username": username,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        // retrieve token
        String token = response.data["token"];
        await userSharedPrefs.setUserToken(token);
        String? fullName = response.data["name"];
        await userSharedPrefs.setUsername(fullName ?? "");
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> changeuser(UserEntity user, String id) async {
    try {
      Response response = await dio.patch(
        ApiEndpoints.patchusername + id,
        data: {
          "username": user.username,
        },
      );
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}
