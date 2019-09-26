import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_scopedmodel_test/static/static_keys.dart';

abstract class BaseModel extends Model {
  bool _isDisposed = false;

  final GlobalKey<NavigatorState> navigatorKey = StaticKeys.navKey;

  // Currently unused
  static BaseModel of(BuildContext context) => ScopedModel.of<BaseModel>(context);

  // Need to be called when Widget page is loaded
  Future initialize() async {}

  // Need to be called when page is closed
  Future dispose() async {
    this._isDisposed = true;
  }

  // Usefull to navigate
  Future showPage(String route, {Object arguments}) async {
    this.navigatorKey.currentState.pushNamed(route, arguments: arguments);
  }

  // Usefull to close ViewModel only one time
  Future closePage() async {
    if (!this._isDisposed) {
      this.navigatorKey.currentState.pop();
    }
  }
}
