import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static double w = 0;
  static double h = 0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    w = _mediaQueryData.size.width * 99 / 38880;
    h = _mediaQueryData.size.height * 99 / 77328;
    print(w);
    print(h);
  }
}
