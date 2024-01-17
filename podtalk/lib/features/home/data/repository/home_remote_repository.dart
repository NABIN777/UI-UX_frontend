import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/src/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/core/failure/failure.dart';
import 'package:podtalk/features/home/domain/entity/podcast_entity.dart';

import '../../domain/repository/home_repository.dart';
import '../data_source/home_remote_data_source.dart';

final homeRemoteRepositoryProvider = Provider<IHomeRepository>((ref) {
  return HomeRemoteRepository(
    ref.read(homeRemoteDataSourceProvider),
  );
});

class HomeRemoteRepository implements IHomeRepository {
  final HomeRemoteDataSource _homeRemoteDataSource;
  HomeRemoteRepository(this._homeRemoteDataSource);

  @override
  Future<Either<Failure, bool>> postAudio(PodcastEntity podcast) {
    return _homeRemoteDataSource.postAudio(podcast);
  }

  @override
  Future<Either<Failure, String>> uploadAlbumSound(File file) {
    return _homeRemoteDataSource.uploadPodcastAudio(file);
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) {
    return _homeRemoteDataSource.uploadProfilePicture(file);
  }

  @override
  Future<Either<Failure, Response>> getAllPodcasts() {
    return _homeRemoteDataSource.getAllPodcasts();
  }

  @override
  Future<Either<Failure, bool>> deletePodcast(String id) {
    print("deletePodcast");
    return _homeRemoteDataSource.deletePodcast(id);
  }

  @override
  Future<Either<Failure, Response>> getAllPodcastsById() {
    return _homeRemoteDataSource.getAllPodcastsById();
  }

  @override
  Future<Either<Failure, bool>> updatePodcast(
      String id, PodcastEntity podcast) {
    return _homeRemoteDataSource.updatePodcast(id, podcast);
  }

  @override
  Future<Either<Failure, Response>> getFavorite() {
    return _homeRemoteDataSource.getFavorite();
  }

  @override
  Future<Either<Failure, bool>> createFavorite(String id) {
    return _homeRemoteDataSource.createFavorite(id);
  }

  @override
  Future<Either<Failure, bool>> deleteFavorite(String id) {
    return _homeRemoteDataSource.delFavorite(id);
  }

  @override
  Future<Either<Failure, Response>> getcategory(String category) {
    return _homeRemoteDataSource.getcategory(category);
  }
}
