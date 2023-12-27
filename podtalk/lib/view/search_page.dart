import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podtalk/features/home/presentation/viewmodel/home_view_model.dart';

import '../features/home/domain/entity/podcast_entity.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<PodcastEntity> _foundedPodcasts = [];

  void onSearch(String search) {
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    // Instead of using Future<void>, use List<PodcastEntity>
    final List<PodcastEntity> allPodcasts =
        homeViewModel.getAllPodcasts(context) as List<PodcastEntity>;

    setState(() {
      _foundedPodcasts = allPodcasts
          .where((podcast) =>
              podcast.author.toLowerCase().contains(search.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Podcasts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => onSearch(value),
              decoration: const InputDecoration(
                hintText: 'Search by author',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _foundedPodcasts.length,
              itemBuilder: (context, index) {
                PodcastEntity podcast = _foundedPodcasts[index];
                return buildPodcastTile(podcast);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPodcastTile(PodcastEntity podcast) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(podcast.image),
      ),
      title: Text(podcast.author),
      subtitle: Text(podcast.title),
      // Add your playback logic here using AudioPlayer
    );
  }
}
