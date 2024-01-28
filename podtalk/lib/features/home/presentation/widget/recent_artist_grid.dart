import 'package:flutter/material.dart';

class RecentArtistsGrid extends StatelessWidget {
  const RecentArtistsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual list of recently played artists
    List<String> recentlyPlayedArtists = [
      'Artist 1',
      'Artist 2',
      'Artist 3',
      'Artist 4',
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: recentlyPlayedArtists.map((artist) {
        return Card(
          child: Center(
            child: Text(artist),
          ),
        );
      }).toList(),
    );
  }
}
