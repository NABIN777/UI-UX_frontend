import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/features/home/presentation/view/podcast_play_view.dart';

import '../../domain/entity/podcast_entity.dart';
import '../viewmodel/home_view_model.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  String baseUrl = "http://192.168.18.140:3000/";
  String image = "http://10.0.2.2:3000/albumPictures/";

  String audio = "http://192.168.18.140:3000/podcastAudios/";
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;
  String selectedCategory = "All"; // Default category
  List<String> categories = [
    "All",
    "Science & Technology",
    "Sprituality",
    "Lifestyle",
    "Motivation"
  ];

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
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    await homeViewModel.getcategory(context, selectedCategory);
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchPodcasts,
      child: Scaffold(
        appBar: selectedIndex == 0
            ? AppBar(
                automaticallyImplyLeading: true,
                // title: const Row(
                //   children: [
                //     CircleAvatar(
                //       backgroundImage: AssetImage('assets/images/logo.png'),
                //       radius: 16,
                //     ),
                //     SizedBox(width: 8),
                //     Text('Podcasts Section'),
                //   ],
                // ),
                centerTitle: true,
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(categories.length, (index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                          _fetchPodcasts();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: category == selectedCategory
                                ? const Color.fromARGB(255, 1, 44, 79)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: category == selectedCategory
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Consumer(
                builder: (context, watch, child) {
                  final homeState = ref.watch(homeViewModelProvider);
                  if (homeState.isLoading) {
                    return const CircularProgressIndicator();
                  }

                  if (homeState.error != null) {
                    return Text(
                      'Error: ${homeState.error}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                      ),
                    );
                  }

                  final List<PodcastEntity>? podcasts = homeState.podcast;
                  print('Podcasts: $podcasts');
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: podcasts?.length ?? 0,
                    itemBuilder: (context, index) {
                      final sortedPodcasts = podcasts!
                        ..sort((a, b) => b.duration.compareTo(a.duration));

                      PodcastEntity product = sortedPodcasts[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PodcastPlayView(
                                podcast: product,
                                audioPlayer: audioPlayer,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1,
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.4,
                                    child: Image.network(
                                      image + product.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      '${product.title}-${product.author}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      product.description,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('${product.duration} minutes'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
