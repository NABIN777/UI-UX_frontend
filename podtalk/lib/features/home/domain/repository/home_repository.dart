import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/features/home/domain/entity/podcast_entity.dart';

import '../../../../core/failure/failure.dart';
import '../../data/repository/home_remote_repository.dart';

final homeRepositoryProvider = Provider<IHomeRepository>((ref) {
  return ref.read(homeRemoteRepositoryProvider);
});

abstract class IHomeRepository {
  Future<Either<Failure, bool>> postAudio(PodcastEntity podcast);

  Future<Either<Failure, String>> uploadProfilePicture(File file);
  Future<Either<Failure, String>> uploadAlbumSound(File file);
  // Stream<List<PodcastEntity>?> getSubscriptions();
  Future<Either<Failure, Response>> getAllPodcasts();
  Future<Either<Failure, Response>> getAllPodcastsById();
  // Future<Either<Failure, Response>> addFavoritePodcast(String id);
  Future<Either<Failure, bool>> createFavorite(String id);
  Future<Either<Failure, bool>> updatePodcast(String id, PodcastEntity podcast);
  Future<Either<Failure, Response>> getFavorite();
  Future<Either<Failure, bool>> deletePodcast(String id);
  Future<Either<Failure, bool>> deleteFavorite(String id);
  Future<Either<Failure, Response>> getcategory(String category);
}
