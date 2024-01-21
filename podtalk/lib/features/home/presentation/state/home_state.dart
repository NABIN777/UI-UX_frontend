import 'package:podtalk/features/favorite/domain/entity/favorite_entity.dart';

import '../../domain/entity/podcast_entity.dart';

class HomeState {
  final List<PodcastEntity>? podcast;
  final List<FavoriteEntity>? favorite;
  final bool isLoading;
  final String? error;
  final String? imageName;
  final String? audioName;

  HomeState({
    required this.isLoading,
    this.error,
    this.imageName,
    this.audioName,
    this.podcast,
    this.favorite,
  });

  factory HomeState.initial() {
    return HomeState(
        isLoading: false,
        error: null,
        imageName: null,
        audioName: null,
        podcast: []);
  }

  HomeState copyWith({
    bool? isLoading,
    String? error,
    String? imageName,
    String? audioName,
    List<PodcastEntity>? podcast,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      imageName: imageName ?? this.imageName,
      audioName: audioName ?? this.audioName,
      podcast: podcast,
    );
  }

  @override
  String toString() => 'HomeState(isLoading: $isLoading, error: $error)';
}
