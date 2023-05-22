import 'package:flutter/widgets.dart';

class AppSize {
  double heightApp(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double widthApp(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
