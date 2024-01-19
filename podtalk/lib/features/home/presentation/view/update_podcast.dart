import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entity/podcast_entity.dart';
import '../viewmodel/home_view_model.dart';

class UpdatePodcast extends ConsumerStatefulWidget {
  PodcastEntity product;
  UpdatePodcast({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdatePodcastState();
}

// ignore: unused_element
class _UpdatePodcastState extends ConsumerState<UpdatePodcast> {
  late final PodcastEntity podcast;
  checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  final _formKey = GlobalKey<FormState>();

  String? selectedAudioPath;

  File? _img;

  Future _browseImage(WidgetRef ref, ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _img = File(image.path);
          ref.read(homeViewModelProvider.notifier).uploadImage(_img!);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _fetchPodcasts() async {
    final homeviewmodel = ref.read(homeViewModelProvider.notifier);
    print('data leko xa ?');
    await homeviewmodel.getAllPodcasts(context);
  }

  @override
  Widget build(BuildContext context) {
    final descriptionController =
        TextEditingController(text: widget.product.description);
    final titlecontroller = TextEditingController(text: widget.product.title);
    final durationcontroller =
        TextEditingController(text: widget.product.duration);
    final authorcontroller = TextEditingController(text: widget.product.author);
    final categorycontroller =
        TextEditingController(text: widget.product.category);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Podcast'),
      ),
      body: SafeArea(
        // child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: titlecontroller,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  // onSaved: (value) {
                  //   _title = value;
                  // },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      // labelText: 'Description',

                      ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  // onSaved: (value) {
                  //   _description = value;
                  // },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: durationcontroller,
                  decoration: const InputDecoration(labelText: 'Duration'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a duration';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: authorcontroller,
                  decoration: const InputDecoration(labelText: 'Author'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter an author';
                    }
                    return null;
                  },
                  // onSaved: (value) {
                  //   _author = value;
                  // },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.grey[300],
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                checkCameraPermission();
                                _browseImage(ref, ImageSource.camera);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.camera),
                              label: const Text('Camera'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _browseImage(ref, ImageSource.gallery);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.image),
                              label: const Text('Gallery'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: _img != null
                          ? Image.file(
                              _img!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/add.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: categorycontroller,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                  // onSaved: (value) {
                  //   _category = value;
                  // },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    // final id =
                    //     ModalRoute.of(context)?.settings.arguments as String?;
                    // if (id != null) {
                    var podcast = PodcastEntity(
                      title: titlecontroller.text,
                      description: descriptionController.text,
                      audio: ref.read(homeViewModelProvider).audioName ?? '',
                      image: ref.read(homeViewModelProvider).imageName ?? '',
                      duration: durationcontroller.text,
                      author: authorcontroller.text,
                      category: categorycontroller.text,
                      id: '${widget.product.id}',
                    );

                    print('update vayena');
                    print('id k xa ${podcast.id}');

                    ref
                        .read(homeViewModelProvider.notifier)
                        .updatepodcast(context, podcast);
                    // } else {
                    //   // Handle the case when id is null
                    //   // For example, show an error message or navigate back
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Error: Podcast ID not provided'),
                    //     ),
                    //   );
                    //   Navigator.pop(context, AppRoute.homeRoute);
                    // }
                  },
                  child: const Text('update'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // );
  }
}
