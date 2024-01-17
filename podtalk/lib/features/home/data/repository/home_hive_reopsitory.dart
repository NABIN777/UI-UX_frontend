// import 'dart:io';

// import 'package:dartz/dartz.dart';
// import 'package:dio/src/response.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:podtalk/features/home/domain/entity/podcast_entity.dart';
// import 'package:podtalk/features/home/domain/repository/home_repository.dart';

// import '../../../../core/failure/failure.dart';
// import '../../../../core/network/local/hive_service.dart';
// import '../data_source/home_local_data_source.dart';

// final homeLocalRepositoryProvider = Provider<IHomeRepository>((ref) {
//   return HomeLocalRepository(
//     ref.read(hiveServiceProvider as ProviderListenable<HomeLocalDataSource>),
//   );
// });

// class HomeLocalRepository implements IHomeRepository {
//   HomeLocalRepository(HomeLocalDataSource read);

//   get _homeLocalDataSource => null;

//   @override
//   // Future<Either<Failure, bool>> postAudio(PodcastEntity podcast) {
//   //   return _homeLocalDataSource.addpodcast(podcast);
//   // }

//   @override
//   Future<Either<Failure, String>> uploadAlbumSound(File file) {
//     // TODO: implement uploadAlbumSound
//     throw UnimplementedError();
//   }

//   @override
//   Future<Either<Failure, String>> uploadProfilePicture(File file) {
//     // TODO: implement uploadProfilePicture
//     throw UnimplementedError();
//   }

//   @override
//   Future<Either<Failure, bool>> postAudio(PodcastEntity podcast) {
//     return _homeLocalDataSource.addpodcast(podcast);
//     // }
//   }

//   @override
//   Future<Either<Failure, Response>> getAllPodcasts() {
//     return _homeLocalDataSource.hi(getAllPodcasts());
//   }

//   @override
//   Future<Either<Failure, bool>> deletePodcast(String id) {
//     // TODO: implement deletePodcast
//     throw UnimplementedError();
//   }

//   @override
//   Future<Either<Failure, Response>> getAllPodcastsById() {
//     // TODO: implement getAllPodcastsById
//     throw UnimplementedError();
//   }

//   @override
//   Future<Either<Failure, bool>> updatePodcast(id, PodcastEntity podcast) {
//     // TODO: implement updatePodcast
//     throw UnimplementedError();
//   }

//   @override
//   Future<Either<Failure, Response>> getFavorite() {
//     // TODO: implement getFavorite
//     throw UnimplementedError();
//   }

//   @override
//   Future<Either<Failure, bool>> createFavorite(String id) {
//     // TODO: implement createFavorite
//     throw UnimplementedError();
//   }
// }
