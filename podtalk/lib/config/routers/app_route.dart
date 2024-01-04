import 'package:podtalk/features/auth/domain/entity/user_entity.dart';
import 'package:podtalk/features/auth/presentation/view/login_view.dart';
import 'package:podtalk/features/auth/presentation/view/setting_view.dart';
import 'package:podtalk/features/auth/presentation/view/signup.dart';
import 'package:podtalk/features/home/presentation/view/bottom_view/dashboard.dart';
import 'package:podtalk/features/home/presentation/view/bottom_view/favorites.dart';
import 'package:podtalk/features/home/presentation/view/home.dart';
import 'package:podtalk/features/home/presentation/view/podcast_detail_screen.dart';
import 'package:podtalk/features/home/presentation/view/podcast_id_view.dart';
import 'package:podtalk/features/home/presentation/view/upload_podcast.dart';
import 'package:podtalk/features/splash/presentation/view/splash_view.dart';
import 'package:podtalk/view/app_info_page.dart';
import 'package:podtalk/view/extracode.dart';
import 'package:podtalk/view/otp.dart';
import 'package:podtalk/view/search_page.dart';

UserEntity? userEntity;

class AppRoute {
  AppRoute._();

  static const String splashRoute = '/splash';
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String otpRoute = '/otp';
  static const String dashRoute = '/dash';
  static const String uploadRoute = '/upload';
  static const String updateRoute = '/update';
  //  '/update_podcast': (context) => UpdatePodcast(),
  static const String passingRoute = '/update_podcast';
  static const String idpodcastsRoute = '/podcastbyid';
  static const String detailRoute = '/podcastdetailview';
  static const String appinfoRoute = '/appinfoview';
  static const String searchRoute = '/search';
  static const String settingRoute = '/setting';
  static const String newhome = '/newhome';
  static const String favorite = '/favorite';

  /// Define all possible route names here,

  /// Get the application routes

  static getApplicationRoute() {
    return {
      splashRoute: (context) => const SplashView(),
      loginRoute: (context) => const LoginView(),
      homeRoute: (context) => const Home(),
      registerRoute: (context) => const RegisterView(),
      otpRoute: (context) => const OTP(),
      dashRoute: (context) => const DashboardView(),
      uploadRoute: (context) => const UploadPodcast(),
      // updateRoute: (context) =>
      //     UpdatePodcast(product: ,),
      idpodcastsRoute: (context) => const PodcastIdView(),
      detailRoute: (context) => const PodcastDetailScreen(),
      appinfoRoute: (context) => const AppInfoPage(),
      searchRoute: (context) => const SearchPage(),
      settingRoute: (context) => const Setting(),
      newhome: (context) => const NewHome(),
      favorite: (context) => const Favorite(),
    };
  }
}
