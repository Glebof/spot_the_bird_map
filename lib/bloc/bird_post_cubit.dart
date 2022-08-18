import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';
import '../models/bird_post_model.dart';

// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

import '../services/sqflite.dart';

part 'bird_post_state.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(BirdPostState(birdPosts: [], status: BirdPostStatus.initial));

  final dbHelper = DatabaseHelper.instance;

  Future<void> loadPosts() async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    // SharedPreferences prefs = await SharedPreferences.getInstance();

    List<BirdModel> birdPosts = [];

    final List<Map<String, dynamic>> rows = await dbHelper.queryAllRows();

    if (rows.length == 0) {
      print("Rows are empty");
    } else {
      print("Rows have data");

      // fetch data from db

      for (var row in rows) {
        birdPosts.add(BirdModel(
            id: row["id"],
            image: File(row["url"]),
            longitude: row["longitude"],
            latitude: row["latitude"],
            birdDescription: row["birdDescription"],
            birdName: row["birdName"]));
      }
    }

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));

    //
    // final List<String>? birdPostsJsonStringList =
    //     prefs.getStringList("birdPosts");
    // if (birdPostsJsonStringList != null) {
    //   for (var postJsonData in birdPostsJsonStringList) {
    //     final Map<String, dynamic> data =
    //         await json.decode(postJsonData) as Map<String, dynamic>;
    //
    //     final File imageFile = File(data["filePath"] as String);
    //     final String birdName = data["birdName"] as String;
    //     final String birdDescription = data["birdDescription"] as String;
    //     final double latitude = data["latitude"] as double;
    //     final double longitude = data["longitude"] as double;
    //
    //     birdPosts.add(BirdModel(
    //         image: imageFile,
    //         longitude: longitude,
    //         latitude: latitude,
    //         birdDescription: birdDescription,
    //         birdName: birdName));
    //   }
    // }
    // emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  Future<void> addBirdPost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;

    birdPosts.add(birdModel);

    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: birdModel.birdName,
      DatabaseHelper.columnDescription: birdModel.birdDescription,
      DatabaseHelper.latitude: birdModel.latitude,
      DatabaseHelper.longitude: birdModel.longitude,
      DatabaseHelper.columnUrl: birdModel.image.path,
    };

    final int? id = await dbHelper.insert(row);

    birdModel.id = id;
    // _saveToSharedPrefs(birdPosts);
    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  Future<void> removeBirdPost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;

    birdPosts.removeWhere((element) => element == birdModel);

    await dbHelper.delete(birdModel.id!);
    // _saveToSharedPrefs(birdPosts);

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

// Future<void> _saveToSharedPrefs(List<BirdModel> posts) async {
//   // SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   final List<String> jsonDataList = posts
//       .map((post) => json.encode({
//             "birdName": post.birdName,
//             "birdDescription": post.birdDescription,
//             "latitude": post.latitude,
//             "longitude": post.longitude,
//             "filePath": post.image.path,
//           }))
//       .toList();
//
//   prefs.setStringList("birdPosts", jsonDataList);
// }
}
