import 'dart:async';

import 'package:all_sensors2/all_sensors2.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/config/routers/app_route.dart';

import '../../domain/entity/podcast_entity.dart';
import '../viewmodel/home_view_model.dart';

class PodcastPlayView extends ConsumerStatefulWidget {
  final PodcastEntity podcast;

  late AudioPlayer audioPlayer;
  PodcastPlayView(
      {super.key, required this.podcast, required this.audioPlayer});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PodcastPlayViewState();
}

class _PodcastPlayViewState extends ConsumerState<PodcastPlayView> {
  // void _handleProximityValue(double proximityValue) {
  //   if (proximityValue < 4 && audioPlayerState == PlayerState.playing) {
  //     pauseMusic();
  //   } else if (proximityValue >= 4 && audioPlayerState == PlayerState.paused) {
  //     playMusic();
  //   }
  // }

  // double _proximityValue = 0;
  // final List<StreamSubscription<dynamic>> _streamSubscriptions =
  //     <StreamSubscription<dynamic>>[];
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final double shakeThreshold = 30; // Adjust as needed
  // bool isPlaying = false;
  bool isFavorite = false;

  ///////for audio playing
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;
  String getAudioUrl() {
    // Assuming widget.podcast.audio contains the audio file name or path
    return "http://10.0.2.2:3000/podcastAudios/${widget.podcast.audio}"; // emulator

    // return "http://192.168.18.140:3000/podcastAudios/${widget.podcast.audio}";

    ///real device
  }

  String url = "http://10.0.2.2:3000/podcastAudios/";

  ///emulator
  // String url = "http://192.168.18.140:3000/podcastAudios/";

  ///real device

  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;

  /// Optional
  Widget slider() {
    return SizedBox(
      width: 300.0,
      child: Slider.adaptive(
          value: timeProgress.toDouble(),
          max: audioDuration.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    super.initState();
    _accelerometerSubscription =
        accelerometerEvents?.listen((AccelerometerEvent event) {
      double acceleration = event.x + event.y + event.z;
      if (acceleration > shakeThreshold) {
        if (audioPlayerState == PlayerState.playing) {
          pauseMusic();
        } else {
          playMusic();
        }
      }
    });
/////
    /// Compulsory
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });

    /// Optional
    audioPlayer.setSourceUrl(url +
        widget.podcast
            .audio); // Triggers the onDurationChanged listener and sets the max duration string
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) async {
      setState(() {
        timeProgress = position.inSeconds;
      });
    });
  }

  /// Compulsory
  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  /// Compulsory
  playMusic() async {
    // Add the parameter "isLocal: true" if you want to access a local file
    await audioPlayer.setSource(UrlSource(url + widget.podcast.audio));
    return audioPlayer.play(UrlSource(url + widget.podcast.audio));
  }

  /// Compulsory
  pauseMusic() async {
    await audioPlayer.pause();
  }

  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer
        .seek(newPos); // Jumps to the given position within the audio file
  }

  /// Optional
  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString';
  }

  void goBackToHomeScreen() {
    Navigator.popUntil(
      context,
      ModalRoute.withName(AppRoute.homeRoute),
    );
  }

  void home() {
    Navigator.pop(context);
  }

  void addToPlaylist() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add to Playlist"),
        content: const TextField(
          // Customize the text field here as per your need
          decoration: InputDecoration(
            hintText: "Enter playlist name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Add to playlist logic here
              // You can access the text from the text field using its controller
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Add"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Color appBarColor = Colors.white; // Initial color

  void toggleColor() {
    setState(() {
      appBarColor = appBarColor == Colors.blue ? Colors.red : Colors.blue;
    });
  }

//// minimize player
  bool isMinimized = false;

  void toggleMinimized() {
    setState(() {
      isMinimized = !isMinimized;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isMinimized) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Podcast Player"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // goBackToHomeScreen();
              home();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.palette),
              color: Colors.white,
              onPressed: () {
                toggleColor();
              },
            ),
          ],
        ),
        body: Container(
          // Minimized view content
          child: IconButton(
            icon: const Icon(Icons.expand),
            onPressed: toggleMinimized,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Podcast Player"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // goBackToHomeScreen();
            home();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            color: Colors.white,
            onPressed: () {
              toggleColor();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          // height:10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              // Image(
              //   radius: 100,
              //   backgroundImage: NetworkImage(
              Image.network(
                "http://10.0.2.2:3000/albumPictures/${widget.podcast.image}",
              ),

              ///emulator
              // "http://192.168.18.140:3000/albumPictures/${widget.podcast.image}",

              const SizedBox(height: 20),

              Text(
                widget.podcast.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(
                widget.podcast.author,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.skip_previous,
                    ),
                    onPressed: () {
                      // Handle previous button press
                    },
                  ),
                  IconButton(
                      iconSize: 50,
                      onPressed: () {
                        audioPlayerState == PlayerState.playing
                            ? pauseMusic()
                            : playMusic();
                      },
                      icon: Icon(audioPlayerState == PlayerState.playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded)),
                  IconButton(
                    icon: const Icon(
                      Icons.skip_next,
                    ),
                    onPressed: () {
                      // Handle next button press
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Positioned.fill(
                    child: InkWell(
                      onTap: () async {
                        final homeViewModel = ref
                            .read(
                              homeViewModelProvider.notifier,
                            )
                            .createFavorite(context, widget.podcast);

                        toggleFavorite();
                      },
                      child: const Align(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        ),
                      ), // You can put other widgets here if needed
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.playlist_add,
                    ),
                    onPressed: () {
                      addToPlaylist(); // Show the add to playlist dialog
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getTimeString(timeProgress)),
                  const SizedBox(width: 20),
                  SizedBox(width: 200, child: slider()),
                  const SizedBox(width: 20),
                  Text(getTimeString(audioDuration))
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.podcast.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              )
              // Additional controls and metadata can be added here
            ],
          ),
        ),
      ),
      //   bottomNavigationBar: BottomAppBar(
      //     child: BottomBarPlayer(audioPlayer: widget.audioPlayer),
      //   ),
      //   floatingActionButton: FloatingActionButton(
      //     onPressed: toggleMinimized,
      //     child: const Icon(Icons.minimize),
      //   ),
      //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // );
    );
  }
}
