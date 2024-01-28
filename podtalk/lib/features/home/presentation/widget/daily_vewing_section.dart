// import 'package:audioplayers/audioplayers.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:podtalk/core/shared_prefs/user_shared_prefs.dart';
// import 'package:podtalk/features/home/domain/entity/podcast_entity.dart';
// import 'package:podtalk/features/home/presentation/view/podcast_play_view.dart';
// import 'package:podtalk/features/home/presentation/viewmodel/home_view_model.dart';

// class DailyViewingSection extends ConsumerStatefulWidget {
//   const DailyViewingSection({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _DailyViewingSectionState();
// }

// class _DailyViewingSectionState extends ConsumerState<DailyViewingSection> {
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
//             usernamess = username ?? 'user';
//           });
//         },
//       );
//     });

//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // _fetchPodcasts();
//       _content();
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

//   // Future<void> _fetchPodcasts() async {
//   //   final homeViewModel = ref.read(homeViewModelProvider.notifier);
//   //   await homeViewModel.getFavorite(context);
//   // }

//   Future<void> _content() async {
//     final homeViewModel = ref.read(homeViewModelProvider.notifier);
//     await homeViewModel.getAllPodcasts(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 250,
//       decoration: const BoxDecoration(
//           // color: Colors.white,
//           ),
//       child: Positioned(
//         top: 10,
//         left: 0,
//         right: 0,
//         bottom: 0,
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
//             // _content();
//             shuffle(podcasts);
//             return SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: List.generate(podcasts.length ?? 0, (index) {
//                   PodcastEntity product = podcasts[index];

//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PodcastPlayView(
//                             podcast: product,
//                           ),
//                         ),
//                       );
//                     },
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width / 2,
//                       child: Container(
//                         margin: const EdgeInsets.all(10.0),
//                         child: Card(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               AspectRatio(
//                                 aspectRatio: 1.4,
//                                 child: Image.network(
//                                   image + product.image,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(12.0),
//                                 child: Text(
//                                   '${product.title}-${product.author}',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12.0,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
