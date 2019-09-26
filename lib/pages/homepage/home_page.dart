import 'package:flutter/material.dart';
import 'package:flutter_scopedmodel_test/core/widgets/loader_page.dart';
import 'package:flutter_scopedmodel_test/pages/movie_cell/movie_cell.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:scoped_model/scoped_model.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeModel _model = HomeModel();

  @override
  void initState() {
    this._model.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<HomeModel>(
      model: this._model,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Center(
            child: ScopedModelDescendant<HomeModel>(
              builder: (context, child, model) {
                return Text(model.title);
              },
            ),
          ),
        ),
        body: ScopedModelDescendant<HomeModel>(
          builder: (context, child, model) {
            if (model?.movies != null && model?.movies?.isEmpty == false) {
              return buildPage(model, context);
            } else {
              return LoadingView();
            }
          },
        ),
      ),
    );
  }

  Widget buildPage(HomeModel model, BuildContext context) {
    return IncrementallyLoadingListView(
      padding: const EdgeInsets.all(8),
      hasMore: () => true,
      itemCount: () => model.movies.length,
      loadMore: () async {
        if (!model.isBusy) {
          await model.loadMoreMovies();
        }
      },
      itemBuilder: (BuildContext context, int index) {
        // Is this the last item ? Replace it with CircularProgressIndicator
        if (model.movies?.length != null && index == model.movies.length - 1) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 50,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: HomepageMovieCell(model.movies[index]),
          );
        }
      },
    );
  }
}
