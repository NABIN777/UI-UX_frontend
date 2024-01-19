import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:podtalk/features/home/domain/entity/podcast_entity.dart';

import '../viewmodel/home_view_model.dart';

class UploadPodcast extends ConsumerStatefulWidget {
  const UploadPodcast({super.key});

  @override
  ConsumerState<UploadPodcast> createState() => _UploadPodcastState();
}

// ignore: unused_element
class _UploadPodcastState extends ConsumerState<UploadPodcast> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  TextEditingController audioUrlController = TextEditingController();
  bool isFileSelected = false;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _titlecontroller = TextEditingController();
  final _durationcontroller = TextEditingController();
  // final _audioUrlcontroller = TextEditingController();

  final _authorcontroller = TextEditingController();

  final _categorycontroller = TextEditingController();
  String? selectedAudioPath;
  File? _audioUrl;
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

  // Future _pickAudio() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['mp3', 'wav', 'aac', 'm4a', 'ogg', 'opus'],
  //     );
  //     if (result != null) {
  //       setState(() {
  //         _audioUrl = File(result.files.single.path!);
  //         selectedAudioPath = result.files.single.path!;
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
  Future _browseFile(WidgetRef ref) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _audioUrl = File(result.files.single.path!);
          ref.read(homeViewModelProvider.notifier).uploadAudio(_audioUrl!);
          isFileSelected = true;
          audioUrlController.text = result.files.single.name;
        });

        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('File selected successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Podcast'),
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
                    controller: _titlecontroller,
                    decoration: const InputDecoration(labelText: 'Title'),
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
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
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
                    decoration: const InputDecoration(labelText: 'Audio URL'),
                    controller: audioUrlController,
                    readOnly: true,
                    onTap: () {
                      _browseFile(ref);
                    },
                  ),
                  if (isFileSelected)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'File selected: ${audioUrlController.text}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _durationcontroller,
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
                    controller: _authorcontroller,
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
                    controller: _categorycontroller,
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        var podcast = PodcastEntity(
                          title: _titlecontroller.text,
                          description: _descriptionController.text,
                          audio:
                              ref.read(homeViewModelProvider).audioName ?? '',
                          image:
                              ref.read(homeViewModelProvider).imageName ?? '',
                          duration: _durationcontroller.text,
                          author: _authorcontroller.text,
                          category: _categorycontroller.text,
                        );

                        print(podcast);
                        ref
                            .read(homeViewModelProvider.notifier)
                            .postAudio(context, podcast);
                      }
                    },
                    child: const Text('Upload'),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
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
      ),
    );
    // );
  }
}
