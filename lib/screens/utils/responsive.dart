// Class responsiva de UI

import 'package:flutter/material.dart';

class Responsive {
  late double _diagonal,_height, _width;
  late bool _isTablet;

  double get diagonal => _diagonal;
  double get height => _height;
  double get width => _width;
  
  bool get isTablet => _isTablet;

  static Responsive of(BuildContext context) => Responsive(context);

  Responsive(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;

    _isTablet = size.shortestSide >= 600;
  }
  double wp(double percent) => _width * percent / 100;
  double hp(double percent) => _height * percent / 100;
  double dp(double percent) => _diagonal * percent / 100;
}