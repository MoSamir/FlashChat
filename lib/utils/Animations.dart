import 'dart:ui';

import 'package:flutter/animation.dart';

class AnimationUtils{
  static Animation getTwinAnim(Color startColor, Color endColor,AnimationController _parentController){
    return ColorTween(begin: startColor,end: endColor).animate(_parentController);
  }
}