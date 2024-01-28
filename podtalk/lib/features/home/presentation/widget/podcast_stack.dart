import 'package:flutter/material.dart';

class PodcastStack extends StatelessWidget {
  const PodcastStack({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual list of podcast episodes or streamed items
    List<String> podcastItems = [
      'Episode 1',
      'Episode 2',
      'Episode 3',
    ];

    return Stack(
      children: podcastItems.map((item) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          color: Colors.grey,
          child: Text(item),
        );
      }).toList(),
    );
  }
}
