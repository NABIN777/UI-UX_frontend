import 'dart:async';

import 'package:all_sensors2/all_sensors2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/routers/app_route.dart';
// import '../../viewmodel/home_view_model.dart';
import '../../../../../core/common/provider/is_dark_theme.dart';
import '../../../../../core/shared_prefs/user_shared_prefs.dart';
import '../../viewmodel/home_viewmodel.dart';

// ignore: must_be_immutable
class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  late bool isDark;
  String? usernamess;
  late StreamSubscription<ProximityEvent> _proximitySubscription;
  bool isSensorEnabled = true;
  bool isObjectNear = false; // Track if the object is near the proximity sensor

  @override
  void initState() {
    isDark = ref.read(isDarkThemeProvider);
    _proximitySubscription = proximityEvents!.listen(_handleProximityEvent);

    /////okay username
    ///
    ///
    final userSharedPrefsProvider = Provider<UserSharedPrefs>((ref) {
      return UserSharedPrefs();
    });
    // Fetch user name and user image using the providers
    final userSharedPrefs = ref.read(userSharedPrefsProvider);
    userSharedPrefs.getUsername().then((either) {
      either.fold(
        (failure) {
          // Handle the failure, e.g., display an error message
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
  }

  @override
  void dispose() {
    _proximitySubscription.cancel();
    super.dispose();
  }

  void _handleProximityEvent(ProximityEvent event) {
    if (isSensorEnabled) {
      if (event.proximity < 4 && !isObjectNear) {
        isObjectNear = true;
        ref
            .read(isDarkThemeProvider.notifier)
            .updateTheme(true); // Turn on dark mode
      } else if (event.proximity >= 4 && isObjectNear) {
        isObjectNear = false;
        ref
            .read(isDarkThemeProvider.notifier)
            .updateTheme(false); // Turn off dark mode
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('$usernamess');
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),
                radius: 25.0,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(usernamess ?? 'John Doe'),
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Upload Podcast'),
              onTap: () {
                Navigator.pushNamed(context, AppRoute.uploadRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('My Favorites'),
              onTap: () {
                Navigator.pushNamed(context, AppRoute.newhome);
              },
            ),
            ListTile(
              leading: const Icon(Icons.podcasts_rounded),
              title: const Text('My podcasts'),
              onTap: () {
                Navigator.pushNamed(context, AppRoute.idpodcastsRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App info'),
              onTap: () {
                Navigator.pushNamed(context, AppRoute.appinfoRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                ref.read(homeViewModelProvider.notifier).logout(context);
              },
            ),
            ListTile(
                title: const Text('Dark Theme'),
                trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      ref.read(isDarkThemeProvider.notifier).updateTheme(value);
                    })),
            // Switch(
            //     value: isDark,
            //     onChanged: (value) {
            //       setState(() {
            //         isDark = value;
            //         ref.read(isDarkThemeProvider.notifier).updateTheme(value);
            //       });
            //     }),
            ListTile(
              title: const Text('Toggle Sensor'),
              trailing: Switch(
                value: isSensorEnabled,
                onChanged: (value) {
                  setState(() {
                    isSensorEnabled = value;
                    if (!isSensorEnabled) {
                      // If sensor is disabled, turn off dark mode and reset isObjectNear
                      isObjectNear = false;
                      ref.read(isDarkThemeProvider.notifier).updateTheme(false);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
