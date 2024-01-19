import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/config/constants/theme_constant.dart';
import 'package:podtalk/features/home/presentation/view/update_podcast.dart';

import '../../domain/entity/podcast_entity.dart';
import '../viewmodel/home_view_model.dart';

class PodcastIdView extends ConsumerStatefulWidget {
  const PodcastIdView({super.key});

  @override
  ConsumerState<PodcastIdView> createState() => _PodcastIdViewState();
}

class _PodcastIdViewState extends ConsumerState<PodcastIdView> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPodcasts();
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  Future<void> _fetchPodcasts() async {
    final PodcastIdViewviewmodel = ref.read(homeViewModelProvider.notifier);
    print('data leko xa ?');
    await PodcastIdViewviewmodel.getAllPodcastsById(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Podcasts List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: ThemeConstant.primaryColor, //yesma edit garya xu
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'Manage your Podcasts here !',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Consumer(
              builder: (context, watch, child) {
                final PodcastIdViewState = ref.watch(homeViewModelProvider);
                if (PodcastIdViewState.isLoading) {
                  return const CircularProgressIndicator();
                }

                if (PodcastIdViewState.error != null) {
                  // Handle error state
                  return Text(
                    'Error: ${PodcastIdViewState.error}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  );
                }
                //              children: List.generate(podcasts?.length ?? 0, (index) { // Add the '?' after podcasts to check for null
                // PodcastEntity product = podcasts![index];

                final List<PodcastEntity>? podcasts =
                    PodcastIdViewState.podcast;
                print('podcasts aayo ? $podcasts');

                return Wrap(
                  children: List.generate(podcasts?.length ?? 0, (index) {
                    PodcastEntity product = podcasts![index];
                    print('aako xa ?? ${product.id}');
                    print('aako xa ?? ${product.title}');

                    return SizedBox(
                      width: MediaQuery.of(context).size.width /
                          2, // Adjust the width based on your requirements
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.4,
                                child: Image.network(
                                  "http://10.0.2.2:3000/albumPictures/${product.image}", //emulator
                                  // "http://192.168.18.140:3000/albumPictures/${product.image}",

                                  ///real device
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 7.0, top: 7, bottom: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        // Handle action selection
                                        if (value == 'edit') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdatePodcast(
                                                  product: product,
                                                ),
                                              ));
                                          // Handle edit action
                                        } else if (value == 'delete') {
                                          // Handle delete action
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                  'Are you sure you want to delete ${product.title}?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, podcasts);
                                                    },
                                                    child: const Text('No')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      ref
                                                          .read(
                                                              homeViewModelProvider
                                                                  .notifier)
                                                          .deletePodcast(
                                                              context, product);
                                                    },
                                                    child: const Text('Yes')),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          const PopupMenuItem<String>(
                                            value: 'edit',
                                            child: Text('Edit'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Text('Delete'),
                                          ),
                                        ];
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 0),
                                child: Text(
                                  'author: ${product.author}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 0),
                                child: IconButton(
                                  iconSize: 50,
                                  onPressed: () async {
                                    if (audioPlayerState ==
                                        PlayerState.playing) {
                                      await pauseMusic();
                                    } else {
                                      print('podcast baja');
                                      await audioPlayer.play(UrlSource(
                                          'http://10.0.2.2:3000/podcastAudios/${product.audio}' //emulator
                                          // "http://192.168.18.140:3000/podcastAudios/${product.audio}", //real device
                                          ));
                                    }
                                  },
                                  icon: Icon(
                                    color: Colors.black,
                                    audioPlayerState == PlayerState.playing
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(left: 8.0, bottom: 0),
                              //   child: IconButton(
                              //     iconSize: 50,
                              //     onPressed: () async {
                              //       if (audioPlayerState ==
                              //           PlayerState.playing) {
                              //         await pauseMusic();
                              //       } else {
                              //         print('podcast baja');
                              //         await audioPlayer.play(UrlSource(
                              //             'http://10.0.2.2:3000/podcastAudios/${product.audio}'));
                              //       }
                              //     },
                              //     icon: Icon(
                              //       color: Colors.black,
                              //       audioPlayerState == PlayerState.playing
                              //           ? Icons.pause_rounded
                              //           : Icons.play_arrow_rounded,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



















// body: Card(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.network(
//               'https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/images/511789main_he210_print4_full.jpg',
//               height: 200,
//               width: 200,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Roaming around the Cosmos',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Nirajan Khanal',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: const Icon(
//                     Icons.skip_previous,
//                     color: Colors.black,
//                   ),
//                   onPressed: () {
//                     // Handle previous button press
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.play_circle_outline,
//                     color: Colors.black,
//                   ),
//                   onPressed: () {
//                     // Handle play button press
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.skip_next,
//                     color: Colors.black,
//                   ),
//                   onPressed: () {
//                     // Handle next button press
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             // Additional controls and metadata can be added here
//           ],
//         ),
//       ),