import 'package:flutter/material.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top section with app name and circular image
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Column(
                children: [
                  Text(
                    'Podtalk',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                ],
              ),
            ),
            // Description section with rich text
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'Welcome to Podtalk, a fantastic app for podcast lovers. ',
                    ),
                    TextSpan(
                      text: 'Here are some great features of Podtalk:\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          '- Discover and listen to your favorite podcasts from around the world.\n',
                    ),
                    TextSpan(
                      text:
                          '- Create and manage your own playlists to organize your podcasts.\n',
                    ),
                    TextSpan(
                      text:
                          '- Mark your favorite episodes and save them for later.\n',
                    ),
                    TextSpan(
                      text:
                          '- Beautiful and intuitive user interface for a delightful experience.\n',
                    ),
                    TextSpan(
                      text: '- And much more!\n',
                    ),
                  ],
                ),
              ),
            ),
            // Back button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
