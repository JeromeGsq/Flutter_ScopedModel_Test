import 'dart:core';

import 'package:flutter_scopedmodel_test/base/base_model.dart';
import 'package:flutter_scopedmodel_test/models/movie.dart';
import 'package:flutter_scopedmodel_test/models/movie_result.dart';
import 'package:flutter_scopedmodel_test/networking/api.dart';

class MovieDetailsModel extends BaseModel {
  bool isBusy;
  bool showFullDescription;
  MovieResult movieResult;
  Movie movie;
  String fullDescription;

  MovieDetailsModel({
    this.isBusy = false,
    this.showFullDescription = false,
    this.movieResult,
    this.movie,
    this.fullDescription = "",
  });

  @override
  Future initialize() async {
    await this.loadMovie();
    return super.initialize();
  }

  Future loadMovie() async {
    this.isBusy = true;
    this.notifyListeners();

    var movie = await ApiClient().getMovie(movieResult.imdbID);
    await Future.delayed(Duration(seconds: 1));
    this.movie = movie;

    this.isBusy = false;
    this.notifyListeners();
  }

  Future loadFullDescription() async {
    this.isBusy = true;
    this.notifyListeners();

    var movie = await ApiClient().getMovie(movieResult.imdbID, fullDescription: true);
    await Future.delayed(Duration(seconds: 1));
    this.fullDescription = movie.plot;

    this.isBusy = false;
    this.showFullDescription = true;
    this.notifyListeners();
  }

  void switchFullDescriptionVisibiliy() {
    this.showFullDescription = !this.showFullDescription;
    this.notifyListeners();
  }
}
