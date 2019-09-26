import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scopedmodel_test/static/static_keys.dart';

class BaseState<T extends StatefulWidget> extends State<T> with RouteAware {
  // Return at least a Container to fix crashes but you have to override this widget in your class
  @override
  Widget build(BuildContext context) => Container();

  // View change on navigation
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    StaticKeys.rootObserverKey.subscribe(this, ModalRoute.of(context));
  }

  Future setStatusBarColor(bool needBlackText) async {
    // Need delay to fix race condition
    await Future.delayed(Duration(milliseconds: 100));
    needBlackText = true;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarIconBrightness: needBlackText ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: needBlackText ? Brightness.dark : Brightness.light,
      statusBarBrightness: needBlackText ? Brightness.light : Brightness.dark,
    ));
  }
}
