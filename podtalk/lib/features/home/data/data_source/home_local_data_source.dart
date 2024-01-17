import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/network/local/hive_service.dart';

class HomeLocalDataSource {
  final HiveService hiveService;

  HomeLocalDataSource({
    required this.hiveService,
  });

  Future<dynamic> retrieveDataFromHive() async {
    try {
      final box = await Hive.openBox("hivePodcasts");
      final hivePodcastsData = box.get('2');
      await box.close();
      return hivePodcastsData;
    } catch (e) {
      print('Error while retrieving data from Hive: $e');
    }
  }

  Future<Either<Failure, bool>> storePodcastsDataInHive(
      List<dynamic> podcasts) async {
    try {
      final box = await Hive.openBox("hivePodcasts");
      box.clear();

      await box.put('2', podcasts);
      print('Saved Podcasts Data To Hive Database');

      await box.close(); // Move this line outside the loop

      return const Right(true);
    } catch (e) {
      print('error is coming $e');
      return Left(Failure(error: e.toString()));
    }
  }
}
