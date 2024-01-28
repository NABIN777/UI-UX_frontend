import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomBarPlayer extends ConsumerWidget {
  final AudioPlayer audioPlayer;

  const BottomBarPlayer({super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Implement the UI for the bottom bar player here
    // You can use the same logic for play, pause, and other controls

    return Container(
      // Customize the bottom bar player UI
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.pause_rounded),
            onPressed: () {
              // Pause logic
              audioPlayer.pause();
            },
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow_rounded),
            onPressed: () {
              // Play logic
              audioPlayer.play;
            },
          ),
          IconButton(
            icon: const Icon(Icons.stop_rounded),
            onPressed: () {
              // Stop logic
              audioPlayer.stop();
            },
          ),
        ],
      ),
    );
  }
}
