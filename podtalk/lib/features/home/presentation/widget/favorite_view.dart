// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:podtalk/core/shared_prefs/user_shared_prefs.dart';
// import 'package:podtalk/features/home/domain/entity/podcast_entity.dart';
// import 'package:podtalk/features/home/presentation/view/podcast_play_view.dart';
// import 'package:podtalk/features/home/presentation/viewmodel/home_view_model.dart';

// class FavoriteSection extends ConsumerStatefulWidget {
//   const FavoriteSection({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _FavoriteSectionState();
// }

// class _FavoriteSectionState extends ConsumerState<FavoriteSection> {
//   String image = "http://10.0.2.2:3000/albumPictures/";
//   String? usernamess;
//   AudioPlayer audioPlayer = AudioPlayer();
//   Map<int, PlayerState> audioPlayerStates = {};

//   @override
//   void initState() {
//     final userSharedPrefsProvider = Provider<UserSharedPrefs>((ref) {
//       return UserSharedPrefs();
//     });

//     final userSharedPrefs = ref.read(userSharedPrefsProvider);
//     userSharedPrefs.getUsername().then((either) {
//       either.fold(
//         (failure) {
//           print('Failed to get username: ${failure.error}');
//         },
//         (username) {
//           setState(() {
//             usernamess = username;
//           });
//         },
//       );
//     });

//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchPodcasts();
//       // _content();
//     });

//     audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
//       setState(() {
//         // This is a global player state, but each podcast has its own state
//       });
//     });
//   }

//   @override
//   void dispose() {
//     audioPlayer.release();
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   pauseMusic() async {
//     await audioPlayer.pause();
//   }

//   Future<void> _fetchPodcasts() async {
//     final homeViewModel = ref.read(homeViewModelProvider.notifier);
//     await homeViewModel.getFavorite(context);
//   }

//   // Future<void> _content() async {
//   //   final homeViewModel = ref.read(homeViewModelProvider.notifier);
//   //   await homeViewModel.getFavorite(context);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 195,
//       decoration: const BoxDecoration(
//           // gradient: LinearGradient(
//           //   colors: [Color.fromARGB(255, 0, 40, 72), Colors.black],
//           //   begin: Alignment.topLeft,
//           //   end: Alignment.bottomRight,
//           // ),
//           // color: Colors.white,
//           ),
//       child: Positioned(
//         top: 5,
//         left: 0,
//         child: Consumer(
//           builder: (context, watch, child) {
//             final homeState = ref.watch(homeViewModelProvider);
//             if (homeState.isLoading) {
//               return const CircularProgressIndicator();
//             }

//             if (homeState.error != null) {
//               return Text(
//                 'Error: ${homeState.error}',
//                 style: const TextStyle(
//                   color: Colors.red,
//                   fontSize: 16.0,
//                 ),
//               );
//             }

//             final List<PodcastEntity>? podcasts = homeState.podcast;
//             print('podcasts aayo ? $podcasts');
//             if (podcasts == null || podcasts.isEmpty) {
//               return const Text(
//                 'No podcasts found',
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               );
//             }

//             return ListView.builder(
//               // physics: const NeverScrollableScrollPhysics(),
//               itemCount: podcasts.length,
//               itemBuilder: (context, index) {
//                 final podcast = podcasts[index];

//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 0),
//                   child: ListTile(
//                     leading: Image.network(
//                       "http://10.0.2.2:3000/albumPictures/${podcast.image}",
//                       height: 150,
//                       width: 100,
//                       fit: BoxFit.contain,
//                     ),
//                     title: Text(
//                       podcast.title,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     trailing: IconButton(
//                       style: const ButtonStyle(),
//                       icon: Icon(
//                         audioPlayerStates[index] == PlayerState.playing
//                             ? Icons.pause_rounded
//                             : Icons.play_circle_outline,
//                       ),
//                       onPressed: () async {
//                         if (audioPlayerStates[index] == PlayerState.playing) {
//                           await pauseMusic();
//                         } else {
//                           print('podcast baja');
//                           await audioPlayer.play(
//                             UrlSource(
//                               'http://10.0.2.2:3000/podcastAudios/${podcast.audio}',
//                             ),
//                           );
//                         }
//                         setState(() {
//                           audioPlayerStates[index] =
//                               audioPlayerStates[index] == PlayerState.playing
//                                   ? PlayerState.paused
//                                   : PlayerState.playing;
//                         });
//                       },
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PodcastPlayView(
//                             podcast: podcast,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
