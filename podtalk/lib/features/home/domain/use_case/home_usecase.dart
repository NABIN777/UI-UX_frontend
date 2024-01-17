import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/features/home/domain/entity/podcast_entity.dart';

import '../../../../core/failure/failure.dart';
import '../repository/home_repository.dart';

final homeUseCaseProvider = Provider((ref) {
  return HomeUseCase(ref.read(homeRepositoryProvider));
});

class HomeUseCase {
  final IHomeRepository _homeRepository;

  HomeUseCase(this._homeRepository);

  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    return await _homeRepository.uploadProfilePicture(file);
  }

  Future<Either<Failure, bool>> postAudio(PodcastEntity podcast) async {
    return await _homeRepository.postAudio(podcast);
  }

  Future<Either<Failure, String>> uplodAlbumSound(File file) async {
    return await _homeRepository.uploadAlbumSound(file);
  }

  Future<Either<Failure, Response>> getAllPodcasts() async {
    return await _homeRepository.getAllPodcasts();
  }

  Future<Either<Failure, bool>> updatepodcast(
      String id, PodcastEntity podcast) async {
    return _homeRepository.updatePodcast(id, podcast);
  }

  Future<Either<Failure, bool>> deletePodcast(String id) async {
    return _homeRepository.deletePodcast(id);
  }

  Future<Either<Failure, Response>> getAllPodcastsById() async {
    return _homeRepository.getAllPodcastsById();
  }

  Future<Either<Failure, Response>> getFavorite() async {
    return _homeRepository.getFavorite();
  }

  Future<Either<Failure, bool>> createFavorite(String id) async {
    return _homeRepository.createFavorite(id);
  }

  Future<Either<Failure, bool>> deleteFavorite(String id) async {
    return _homeRepository.deleteFavorite(id);
  }

  Future<Either<Failure, Response>> getcategory(String category) async {
    return _homeRepository.getcategory(category);
  }
}
