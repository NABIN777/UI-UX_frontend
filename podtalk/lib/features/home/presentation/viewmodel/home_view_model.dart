import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/config/routers/app_route.dart';
import 'package:podtalk/features/home/data/data_source/home_local_data_source.dart';
import 'package:podtalk/features/home/domain/entity/podcast_entity.dart';

import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/common/snackbar/my_snackbar.dart';
import '../../../../core/network/local/hive_service.dart';
import '../../domain/use_case/home_usecase.dart';
import '../state/home_state.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) => HomeViewModel(
          ref.read(homeUseCaseProvider),
        ));

class HomeViewModel extends StateNotifier<HomeState> {
  final HomeUseCase _homeUseCase;

  HomeViewModel(this._homeUseCase)
      : super(HomeState(isLoading: false, podcast: []));

  Future<void> uploadImage(File? file) async {
    state = state.copyWith(isLoading: true);
    var data = await _homeUseCase.uploadProfilePicture(file!);
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
      },
      (imageName) {
        state =
            state.copyWith(isLoading: false, error: null, imageName: imageName);
      },
    );
  }

  Future<void> uploadAudio(File? file) async {
    state = state.copyWith(isLoading: true);
    var data = await _homeUseCase.uplodAlbumSound(file!);
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
      },
      (audioName) {
        state =
            state.copyWith(isLoading: false, error: null, audioName: audioName);
      },
    );
  }

  Future<void> postAudio(BuildContext context, PodcastEntity podcast) async {
    state = state.copyWith(isLoading: true);
    var data = await _homeUseCase.postAudio(podcast);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        showSnackBar(
            message: failure.error, context: context, color: Colors.red);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        Navigator.popAndPushNamed(context, AppRoute.homeRoute);
        showSnackBar(message: "Successfully Added", context: context);
      },
    );
  }

  Future<void> getAllPodcasts(BuildContext context) async {
    final connectivity = InternetConnectivity();
    final isConnected = await connectivity.checkConnectivity();
    if (isConnected) {
      state = state.copyWith(isLoading: true);
      var data = await _homeUseCase.getAllPodcasts();
      data.fold((failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        showSnackBar(
            message: failure.error, context: context, color: Colors.red);
      }, (success) {
        final List<PodcastEntity> podcasts = [];
        print('start');
        // print(podcasts);
        print(success.data);
        print('end');

        if (success.data.containsKey('podcasts')) {
          final List<dynamic> items = success.data['podcasts'];

          print('items');
          print(items);
          print('end');

          podcasts.addAll(items.map<PodcastEntity>((item) => PodcastEntity(
                id: item['_id'],
                title: item['title'],
                description: item['description'],
                image: item['image'],
                audio: item['audioUrl'],
                author: item['author'],
                category: item['category'],
                duration: item['duration'],
              )));
        }

        state = state.copyWith(
          isLoading: false,
          error: null,
          podcast: podcasts,
        );
      });
    } else {
      showSnackBar(
          message: 'No Internet Connection',
          context: context,
          color: Colors.red);
      HomeLocalDataSource localDataSource = HomeLocalDataSource(
        hiveService: HiveService(),
      );
      final data = await localDataSource.retrieveDataFromHive();
      final List<PodcastEntity> podcasts = [];
      if (true) {
        final List<dynamic> items = data;

        podcasts.addAll(items.map<PodcastEntity>((item) => PodcastEntity(
              id: item['_id'],
              title: item['title'],
              description: item['description'],
              image: item['image'],
              audio: item['audioUrl'],
              author: item['author'],
              category: item['category'],
              duration: item['duration'],
            )));
        state = state.copyWith(
          isLoading: false,
          error: null,
          podcast: podcasts,
        );
      }
    }
  }

////////////////////////////////id/////////////////////////////////////////
  Future<void> getAllPodcastsById(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    var data = await _homeUseCase.getAllPodcastsById();
    data.fold((failure) {
      state = state.copyWith(
        isLoading: false,
        error: failure.error,
      );
      showSnackBar(message: failure.error, context: context, color: Colors.red);
    }, (success) {
      final List<PodcastEntity> podcasts = [];
      print('start id matra');
      print(success.data);
      print('end ok');

      if (success.data.containsKey('podcasts')) {
        final List<dynamic> items = success.data['podcasts'];

        print('items');
        print(items);
        print('end');

        podcasts.addAll(items.map<PodcastEntity>((item) => PodcastEntity(
              id: item['_id'],
              title: item['title'],
              description: item['description'],
              image: item['image'],
              audio: item['audioUrl'],
              author: item['author'],
              category: item['category'],
              duration: item['duration'],
            )));
      } else {
        print('no podcasts');
      }
      //print("all podcasts");
      //print(podcasts);
      state = state.copyWith(
        isLoading: false,
        error: null,
        podcast: podcasts,
      );
    });
    return;
  }

  Future<void> deletePodcast(
      BuildContext context, PodcastEntity podcast) async {
    state.copyWith(isLoading: true);
    var data = await _homeUseCase.deletePodcast(podcast.id!);

    data.fold(
      (l) {
        showSnackBar(message: l.error, context: context, color: Colors.red);

        state = state.copyWith(isLoading: false, error: l.error);
      },
      (r) {
        state.podcast?.remove(podcast);
        state = state.copyWith(isLoading: false, error: null);
        showSnackBar(
          message: 'Podcast delete successfully',
          context: context,
        );
      },
    );
  }

  Future<void> updatepodcast(
      BuildContext context, PodcastEntity podcast) async {
    state = state.copyWith(isLoading: true);

    if (podcast.id == null) {
      state = state.copyWith(
        isLoading: false,
        error: "Podcast ID not provided",
      );
      showSnackBar(
        message: "Podcast ID not provided",
        context: context,
        color: Colors.red,
      );
      return;
    }

    var data = await _homeUseCase.updatepodcast(podcast.id!, podcast);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        showSnackBar(
          message: failure.error,
          context: context,
          color: Colors.red,
        );
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        showSnackBar(message: "Podcast Updated", context: context);
      },
    );
  }

  Future<void> getFavorite(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    var data = await _homeUseCase.getFavorite();
    data.fold((failure) {
      state = state.copyWith(
        isLoading: false,
        error: failure.error,
      );
      showSnackBar(message: failure.error, context: context, color: Colors.red);
    }, (success) {
      final List<PodcastEntity> podcasts = [];
      print('start id matra');
      print(success.data);
      print('end ok');

      if (success.data is List<dynamic> && success.data.isNotEmpty) {
        final List<dynamic> items = success.data;

        print('items');
        print(items);
        print('end');

        podcasts.addAll(items.map<PodcastEntity>((item) => PodcastEntity(
              id: item['_id'],
              title: item['title'],
              description: item['description'],
              image: item['image'],
              audio: item['audioUrl'],
              author: item['author'],
              category: item['category'],
              duration: item['duration'],
            )));
      } else {
        print('no podcasts');
      }
      //print("all podcasts");
      //print(podcasts);
      state = state.copyWith(
        isLoading: false,
        error: null,
        podcast: podcasts,
      );
    });
    return;
  }

  Future<void> createFavorite(
      BuildContext context, PodcastEntity podcast) async {
    state = state.copyWith(isLoading: true);
    var data = await _homeUseCase.createFavorite(podcast.id!);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );

        showSnackBar(
            message: "already on favorite,${failure.error}",
            context: context,
            color: Colors.red);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        // Navigator.pop(context);
        showSnackBar(message: "add to favorite", context: context);
      },
    );
  }

  Future<void> delFavorite(BuildContext context, PodcastEntity podcast) async {
    state = state.copyWith(isLoading: true);
    var data = await _homeUseCase.deleteFavorite(podcast.id!);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );

        showSnackBar(
            message: "already remove${failure.error}",
            context: context,
            color: Colors.red);
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
        // Navigator.pop(context);
        showSnackBar(message: "remove from favorite", context: context);
      },
    );
  }

  // bool isFavorite(PodcastEntity podcast) =>
  //     state.podcast!.any((p) => p.id == podcast.id!);

/////toogle of favorite button

  ////////////////////////get by category///////////////////////////////////////
  Future<void> getcategory(BuildContext context, String category) async {
    state = state.copyWith(isLoading: true);

    var data = await _homeUseCase.getcategory(category);

    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
          podcast: [],
        );
        showSnackBar(
            message: failure.error, context: context, color: Colors.red);
      },
      (success) {
        try {
          final List<PodcastEntity> podcasts = [];

          if (success.data is Map<String, dynamic>) {
            final Map<String, dynamic> responseMap = success.data;

            // Extract and process data from the map
            final List<dynamic> items = responseMap['podcasts'] ?? [];

            podcasts.addAll(items.map<PodcastEntity>((item) => PodcastEntity(
                  id: item['_id'],
                  title: item['title'],
                  description: item['description'],
                  image: item['image'],
                  audio: item['audioUrl'],
                  author: item['author'],
                  category: item['category'],
                  duration: item['duration'],
                )));
          } else {
            print('Unexpected response format: ${success.data}');
          }

          state = state.copyWith(
            isLoading: false,
            error: null,
            podcast: podcasts,
          );
        } catch (e) {
          print('Error processing response: $e');
          state = state.copyWith(
            isLoading: false,
            error: 'Error processing response',
            podcast: [],
          );
        }
      },
    );
  }
}
