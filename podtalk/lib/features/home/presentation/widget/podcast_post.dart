import 'package:flutter/material.dart';

import '../../domain/entity/podcast_entity.dart';

class PodcastHomeScreen extends StatelessWidget {
  const PodcastHomeScreen(
      {super.key,
      required this.podcastlist,
      required List<PodcastEntity> podcast});
  final List<PodcastEntity> podcastlist;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: podcastlist.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 2.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const CircleAvatar(),
                title: Text(podcastlist[index].author),
                subtitle: Text(DateTime.now().toString()),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(podcastlist[index].description),
              ),
              // if (imageUrl.isNotEmpty)
              // Image.asset(
              //   'assets/images/logo.png',
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              //   height: 200.0,
              // ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        // Handle favorite button press
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {
                        // Handle comment button press
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Handle share button press
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
