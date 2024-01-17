class PodcastEntity {
  final String? id;
  final String title;
  final String description;
  final String image;
  final String audio;
  // final String date;
  final String author;
  final String duration;
  final String category;

  // static var product;

  PodcastEntity({
    this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.audio,
    // required this.date,
    required this.author,
    required this.duration,
    required this.category,
  });

  factory PodcastEntity.fromJson(Map<String, dynamic> json) => PodcastEntity(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        audio: json["audioUrl"],
        // date: json["date"],
        author: json["author"],
        duration: json["duration"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "audio": audio,
        // "date": date,
        "author": author,
        "duration": duration,
        "category": category,
      };

  List<Object?> get props => [
        id,
        title,
        description,
        image,
        audio,
        // date,
        author,
        duration,
        category,
      ];
}
