import 'dart:core';

import 'package:flutter_scopedmodel_test/base/base_model.dart';
import 'package:flutter_scopedmodel_test/models/movie_result.dart';
import 'package:flutter_scopedmodel_test/networking/api.dart';

class HomeModel extends BaseModel {
  bool isBusy;
  int pageIndex;
  String title;
  List<MovieResult> movies;

  HomeModel({
    this.isBusy = false,
    this.pageIndex = 1,
    this.title = "",
    this.movies,
  });

  @override
  Future initialize() async {
    this.movies = [];

    await this.loadMoreMovies();
  }

  Future loadMoreMovies() async {
    this.isBusy = true;
    this.title = "Loading";
    this.notifyListeners();

    var movies = await ApiClient().getHomePageMovies(this.pageIndex);
    if (movies != null) {
      this.pageIndex++;
      this.movies..addAll(movies);
    } else {
      print("HomeModel : loadMoreMovies() : Error movies == null");
    }

    this.isBusy = false;
    this.title = "Next page to load : ${this.pageIndex}";
    this.notifyListeners();
  }
}
