import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/constants/theme_constant.dart';
import '../../../domain/entity/podcast_entity.dart';
import '../../viewmodel/home_view_model.dart';

class Favorite extends ConsumerStatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  ConsumerState<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends ConsumerState<Favorite> {
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
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    print('data leko xa ?');
    await homeViewModel.getFavorite(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await _fetchPodcasts();
          },
          child: SingleChildScrollView(
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
                        color: ThemeConstant.primaryColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text(
                      'Your Favorite podcasts will appear here',
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
                      return Text(
                        'Error: ${PodcastIdViewState.error}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                        ),
                      );
                    }

                    final List<PodcastEntity>? podcasts =
                        PodcastIdViewState.podcast;
                    print('podcasts aayo ? $podcasts');
                    if (podcasts == null || podcasts.isEmpty) {
                      return const Text(
                        'No podcasts found',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: podcasts.length,
                      itemBuilder: (context, index) {
                        PodcastEntity product = podcasts[index];
                        return buildPodcastTile(product);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPodcastTile(PodcastEntity product) {
    return ListTile(
      leading: Image.network(
        "http://10.0.2.2:3000/albumPictures/${product.image}",
        fit: BoxFit.cover,
      ),
      title: Text(
        product.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      subtitle: Text(
        'Author: ${product.author}',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14.0,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              // Handle play button click
            },
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title:
                      Text('Are you sure you want to remove ${product.title}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await ref
                            .read(homeViewModelProvider.notifier)
                            .delFavorite(context, product);
                        // Trigger a refresh after deletion
                        _fetchPodcasts();
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(
              Icons.delete,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
