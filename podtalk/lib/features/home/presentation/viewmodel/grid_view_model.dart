import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/core/common/snackbar/my_snackbar.dart';
import 'package:podtalk/features/home/domain/entity/podcast_entity.dart';
import 'package:podtalk/features/home/domain/use_case/home_usecase.dart';
import 'package:podtalk/features/home/presentation/state/home_state.dart';

final gridViewModelProvider =
    StateNotifierProvider<GridViewModel, HomeState>((ref) => GridViewModel(
          ref.read(homeUseCaseProvider),
        ));

class GridViewModel extends StateNotifier<HomeState> {
  final HomeUseCase _homeUseCase;

  GridViewModel(this._homeUseCase)
      : super(HomeState(isLoading: false, podcast: []));

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
}
