// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:podtalk/core/shared_prefs/user_shared_prefs.dart';
// import 'package:podtalk/features/home/presentation/widget/daily_vewing_section.dart';
// import 'package:podtalk/features/home/presentation/widget/favorite_view.dart';

// import '../../viewmodel/home_view_model.dart';

// class NewHome extends ConsumerStatefulWidget {
//   const NewHome({Key? key}) : super(key: key);

//   @override
//   _NewHomeState createState() => _NewHomeState();
// }

// class _NewHomeState extends ConsumerState<NewHome> {
//   late String image;
//   String? usernamess;
//   AudioPlayer audioPlayer = AudioPlayer();
//   Map<int, PlayerState> audioPlayerStates = {};

//   @override
//   void initState() {
//     super.initState();

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

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchPodcasts();
//     });

//     audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
//       setState(() {
//         // This is a global player state, but each podcast has its own state
//       });
//     });

//     image = "http://10.0.2.2:3000/albumPictures/";
//   }

//   @override
//   void dispose() {
//     audioPlayer.release();
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchPodcasts() async {
//     final homeViewModel = ref.read(homeViewModelProvider.notifier);
//     await homeViewModel.getFavorite(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   height: 100,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color.fromARGB(255, 0, 40, 72), Colors.black],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(10),
//                       bottomRight: Radius.circular(10),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 5,
//                   left: 10,
//                   child: Text(
//                     'Welcome back, ${usernamess ?? 'user'}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                   bottom: 35,
//                   left: 20,
//                   child: Text(
//                     "Find Today's best podcasts",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             const SectionTitle(title: "Your Favorite List"),
//             const FavoriteSection(),
//             const SectionTitle(title: "Playlists For You"),
//             const DailyViewingSection(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SectionTitle extends StatelessWidget {
//   final String title;

//   const SectionTitle({Key? key, required this.title}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               print('See All button pressed');
//               // Navigate to the respective section
//             },
//             child: const Text(
//               "See All",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // class FavoriteSection extends ConsumerWidget {
// //   const FavoriteSection({Key? key}) : super(key: key);

// //   Future<void> _fetchPodcasts(BuildContext context, WidgetRef ref) async {
// //     final homeViewModel = ref.read(homeViewModelProvider.notifier);
// //     await homeViewModel.getFavorite(context);
// //   }

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     // Fetch podcasts when the widget is built
// //     _fetchPodcasts(context, ref);

// //     return Container(
// //       width: double.infinity,
// //       height: 195,
// //       decoration: const BoxDecoration(
// //         color: Colors.white,
// //       ),
// //       child: Consumer(
// //         builder: (context, watch, child) {
// //           final PodcastIdViewState = ref.watch(homeViewModelProvider);

// //           if (PodcastIdViewState.isLoading) {
// //             return const CircularProgressIndicator();
// //           }

// //           if (PodcastIdViewState.error != null) {
// //             // Handle error state
// //             return Text(
// //               'Error: ${PodcastIdViewState.error}',
// //               style: const TextStyle(
// //                 color: Colors.red,
// //                 fontSize: 16.0,
// //               ),
// //             );
// //           }

// //           final List<PodcastEntity>? podcasts = PodcastIdViewState.podcast;

// //           if (podcasts == null || podcasts.isEmpty) {
// //             return const Text(
// //               'No podcasts found, podcast to add in this list',
// //               style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
// //             );
// //           }

// //           return ListView.builder(
// //             itemCount: podcasts.length,
// //             itemBuilder: (context, index) {
// //               final podcast = podcasts[index];

// //               return buildPodcastTile(podcast, context, ref);
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget buildPodcastTile(
// //       PodcastEntity product, BuildContext context, WidgetRef ref) {
// //     return ListTile(
// //       leading: Image.network(
// //         "http://10.0.2.2:3000/albumPictures/${product.image}",
// //         fit: BoxFit.cover,
// //       ),
// //       title: Text(
// //         product.title,
// //         style: const TextStyle(
// //           fontWeight: FontWeight.bold,
// //           fontSize: 16.0,
// //         ),
// //       ),
// //       subtitle: Text(
// //         'Author: ${product.author}',
// //         style: TextStyle(
// //           color: Colors.grey[600],
// //           fontSize: 14.0,
// //         ),
// //       ),
// //       trailing: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           IconButton(
// //             onPressed: () {
// //               // Handle play button click
// //               // You can add audio playback logic here
// //             },
// //             icon: const Icon(
// //               Icons.play_arrow_rounded,
// //               color: Colors.black,
// //             ),
// //           ),
// //           GestureDetector(
// //             onTap: () {
// //               // Handle the click on the delete button
// //               // Show a confirmation dialog and delete the podcast if confirmed
// //               showDialog(
// //                 context: context,
// //                 builder: (context) => AlertDialog(
// //                   title:
// //                       Text('Are you sure you want to remove ${product.title}?'),
// //                   actions: [
// //                     TextButton(
// //                       onPressed: () {
// //                         Navigator.pop(context);
// //                       },
// //                       child: const Text('No'),
// //                     ),
// //                     TextButton(
// //                       onPressed: () {
// //                         Navigator.pop(context, product);
// //                         ref
// //                             .read(
// //                               homeViewModelProvider.notifier,
// //                             )
// //                             .delFavorite(context, product);
// //                       },
// //                       child: const Text('Yes'),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //             child: const Icon(
// //               Icons.delete,
// //               color: Colors.black,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
