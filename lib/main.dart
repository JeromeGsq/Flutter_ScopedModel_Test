import 'package:flutter/material.dart';
import 'package:flutter_scopedmodel_test/pages/homepage/home_page.dart';
import 'package:flutter_scopedmodel_test/pages/movie_details/movie_details_page.dart';

void main() {
  runApp(
    FlutterScopedModelApp(title: "Flutter ScopedModel App"),
  );
}

class FlutterScopedModelApp extends StatefulWidget {
  final String title;

  FlutterScopedModelApp({Key key, this.title}) : super(key: key);

  @override
  _FlutterScopedModelAppState createState() => _FlutterScopedModelAppState();
}

class _FlutterScopedModelAppState extends State<FlutterScopedModelApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      title: widget.title,
      onGenerateRoute: _getRoute,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }

  /// Navigation
  Route _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/movie_details':
        return _buildRoute(settings, MovieDetailsPage(settings.arguments));
      default:
        return _buildRoute(settings, HomePage());
    }
  }

  // Build route
  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => builder,
    );
  }
}
