import 'package:flutter/material.dart';

import '../../widget/podcast_stack.dart';
import '../../widget/recent_artist_grid.dart';

class StreamView extends StatefulWidget {
  const StreamView({super.key});

  @override
  State<StreamView> createState() => _StreamViewState();
}

class _StreamViewState extends State<StreamView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Recently Played Artists',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            RecentArtistsGrid(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Podcast Episodes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            PodcastStack(),
          ],
        ),
      ),
    );
  }
}
