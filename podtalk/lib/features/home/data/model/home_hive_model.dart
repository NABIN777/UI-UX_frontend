import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:podtalk/config/constants/hive_table_constant.dart';

import '../../domain/entity/podcast_entity.dart';

part 'home_hive_model.g.dart';

final homeHiveModelProvider = Provider(
  (ref) => HomeHiveModel.empty(),
);

@HiveType(typeId: HiveTableConstant.postTableId)
class HomeHiveModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String duration;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String images;

  @HiveField(6)
  final String audio;

  // Constructor
  HomeHiveModel(
      {required this.title,
      required this.description,
      required this.author,
      required this.duration,
      required this.category,
      required this.images,
      required this.audio});

  // empty constructor
  HomeHiveModel.empty()
      : this(
            title: '',
            description: '',
            author: '',
            duration: '',
            category: '',
            images: '',
            audio: '');

  // Convert Hive Object to Entity
  PodcastEntity toEntity() => PodcastEntity(
        title: title,
        description: description,
        author: author,
        audio: audio,
        duration: duration,
        category: category,
        image: images,
      );

  // Convert Entity to Hive Object
  HomeHiveModel fromEntity(PodcastEntity entity) => HomeHiveModel(
      title: entity.title,
      description: entity.description,
      author: entity.author,
      duration: entity.duration,
      category: entity.category,
      images: entity.image,
      audio: entity.audio);

  @override
  String toString() {
    return 'title: $title, description: $description, author: $author, duration: $duration, category: $category, images: $images';
  }

  toHiveModel(PodcastEntity podcast) {}
}
