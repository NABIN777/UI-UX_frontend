// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeApiModel _$HomeApiModelFromJson(Map<String, dynamic> json) => HomeApiModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      audio: json['audio'] as String,
      author: json['author'] as String,
      duration: json['duration'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$HomeApiModelToJson(HomeApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'audio': instance.audio,
      'author': instance.author,
      'duration': instance.duration,
      'category': instance.category,
    };
