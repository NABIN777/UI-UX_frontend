import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:podtalk/features/home/domain/entity/podcast_entity.dart';

part 'home_api_model.g.dart';

final homeApiModelProvider = Provider<HomeApiModel>((ref) {
  return HomeApiModel(
    id: '',
    title: '',
    description: '',
    image: '',
    audio: '',
    // date: '',
    author: '',
    duration: '',
    category: '',
  );
});

@JsonSerializable()
class HomeApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String description;
  final String image;
  final String audio;
  // final String date;
  final String author;
  final String duration;
  final String category;

  HomeApiModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.audio,
    // required this.date,
    required this.author,
    required this.duration,
    required this.category,
  });

  factory HomeApiModel.fromJson(Map<String, dynamic> json) =>
      _$HomeApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeApiModelToJson(this);

  // convert AuthApiModel to AuthEntity
  PodcastEntity toEntity() => PodcastEntity(
        id: id,
        title: title,
        description: description,
        image: image,
        audio: audio,
        // date: date,
        author: author,
        duration: duration,
        category: category,
      );

  // Convert AuthApiModel list to AuthEntity list
  List<PodcastEntity> listFromJson(List<HomeApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  String toString() {
    return 'HomeApiModel(id:$id,tittle:$title, description:$description,image:$image,audio:$audio,author:$author,duration:$duration,category:$category)';
  }
}
