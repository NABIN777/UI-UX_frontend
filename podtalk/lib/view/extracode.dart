import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/config/routers/app_route.dart';
import 'package:podtalk/core/shared_prefs/user_shared_prefs.dart';
import 'package:podtalk/features/home/domain/entity/podcast_entity.dart';
import 'package:podtalk/features/home/presentation/view/podcast_play_view.dart';
import 'package:podtalk/features/home/presentation/viewmodel/home_view_model.dart';

class NewHome extends ConsumerStatefulWidget {
  const NewHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewHomeState();
}

class _NewHomeState extends ConsumerState<NewHome> {
  late PageController _pageController;
  int _currentPage = 0;
  String image = "http://10.0.2.2:3000/albumPictures/";
  String? usernamess;
  AudioPlayer audioPlayer = AudioPlayer();
  Map<int, PlayerState> audioPlayerStates = {};

  @override
  void initState() {
    final userSharedPrefsProvider = Provider<UserSharedPrefs>((ref) {
      return UserSharedPrefs();
    });

    final userSharedPrefs = ref.read(userSharedPrefsProvider);
    userSharedPrefs.getUsername().then((either) {
      either.fold(
        (failure) {
          print('Failed to get username: ${failure.error}');
        },
        (username) {
          setState(() {
            usernamess = username;
          });
        },
      );
    });

    super.initState();
    _pageController = PageController(initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _fetchPodcasts();
      _content();
      // _fetchfavorite();
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        // This is a global player state, but each podcast has its own state
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

  // Future<void> _fetchPodcasts() async {
  //   final homeViewModel = ref.read(homeViewModelProvider.notifier);
  //   await homeViewModel.getFavorite(context);
  // }

  Future<void> _content() async {
    // final homeViewModel =
    await ref.read(homeViewModelProvider.notifier).getAllPodcasts(context);
    // await homeViewModel.getAllPodcasts(context);
  }

  // Future<void> _fetchfavorite() async {
  //   final GridViewModel = ref.read(gridViewModelProvider.notifier);
  //   await GridViewModel.getFavorite(context);
  // }
  final List<String> imagePaths = [
    'assets/images/cover.png',
    'assets/images/cover1.png',
    'assets/images/cover2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _content,
      child: Scaffold(
        body: Container(
          color: const Color.fromARGB(179, 239, 234, 234),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 0, 40, 72),
                            Colors.black
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 10,
                      child: Text(
                        "Welcome back, $usernamess" ?? 'Users',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 35,
                      left: 20,
                      child: Text(
                        "Find Today's best podcasts",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //////
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('See All button pressed');
                        Navigator.pushNamed(context, AppRoute.favorite);
                      },
                      child: Container(
                        height: 200, // Set your desired height
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust the radius as needed
                          border: Border.all(width: 2),
                        ),
                        child: SizedBox(
                          height: 200, // Set your desired height
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: imagePaths.length,
                            itemBuilder: (context, index) {
                              return Image.asset(
                                imagePaths[index],
                                fit: BoxFit.cover,
                              );
                            },
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 110,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: 319,
                        height: 77,
                        decoration: ShapeDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Recommended,For You Today",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //  daily viewing
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        // gradient: LinearGradient(
                        //   colors: [
                        //     Color.fromARGB(255, 0, 0, 0),
                        //     Color.fromARGB(255, 0, 0, 0)
                        //   ],
                        //   begin: Alignment.topLeft,
                        //   end: Alignment.bottomRight,
                        // ),
                        // color: Colors.white,
                        border: Border(
                          top: BorderSide(width: 2),
                          left: BorderSide(width: 2),
                          right: BorderSide(width: 2),
                        ),
                      ),
                      child: const Positioned(
                        right: 25,
                        top: 25,
                        child: Text(
                          "PLaylists For You",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            // color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 5,
                      child: GestureDetector(
                        onTap: () {
                          print('See All button pressed');
                          Navigator.pushNamed(context, AppRoute.homeRoute);
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2),
                          left: BorderSide(width: 2),
                          right: BorderSide(width: 2),
                        ),
                        // color: Colors.white,
                      ),
                      child: Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Consumer(
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

                            final List<PodcastEntity>? podcasts =
                                homeState.podcast;
                            print('podcasts aayo ? $podcasts');
                            if (podcasts == null || podcasts.isEmpty) {
                              return const Text(
                                'No podcasts found',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            // _content();
                            shuffle(podcasts);
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(podcasts.length ?? 0,
                                    (index) {
                                  PodcastEntity product = podcasts[index];

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
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Container(
                                        margin: const EdgeInsets.all(10.0),
                                        child: Card(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              AspectRatio(
                                                aspectRatio: 1.4,
                                                child: Image.network(
                                                  image + product.image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  '${product.title}-${product.author}',
                                                  // overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
