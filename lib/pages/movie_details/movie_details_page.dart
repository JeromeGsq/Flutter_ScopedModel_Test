import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scopedmodel_test/core/widgets/loader_page.dart';
import 'package:flutter_scopedmodel_test/models/movie_result.dart';
import 'package:scoped_model/scoped_model.dart';

import 'movie_details.dart';

class MovieDetailsPage extends StatefulWidget {
  final MovieResult movieResult;

  const MovieDetailsPage(
    this.movieResult, {
    Key key,
  }) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState(movieResult);
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  MovieResult movieResult;
  MovieDetailsModel _model;

  _MovieDetailsPageState(this.movieResult);

  @override
  void initState() {
    this._model = MovieDetailsModel(movieResult: this.movieResult);
    this._model.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MovieDetailsModel>(
      model: this._model,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            widget.movieResult?.title.toString(),
          ),
        ),
        body: ScopedModelDescendant<MovieDetailsModel>(
          builder: (context, child, model) {
            return this._model?.movie == null ? LoadingView() : buildPage(context);
          },
        ),
      ),
    );
  }

  Widget buildPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              imageUrl: this._model?.movie?.poster ?? "",
              placeholder: (context, url) => SizedBox(
                child: Icon(Icons.image),
              ),
              errorWidget: (context, url, error) => SizedBox(
                child: Icon(Icons.error),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      this._model.showFullDescription
                          ? this._model?.fullDescription.toString()
                          : this._model?.movie?.plot.toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    MaterialButton(
                      child: this._model.isBusy
                          ? CircularProgressIndicator()
                          : Icon(this._model.showFullDescription ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                      onPressed: () {
                        if (this._model?.fullDescription?.isEmpty ?? true) {
                          this._model.loadFullDescription();
                        } else {
                          this._model.switchFullDescriptionVisibiliy();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
