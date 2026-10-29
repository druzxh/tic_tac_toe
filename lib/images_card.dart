import 'dart:math';

import 'package:flutter/material.dart';

class Game {
  static const String hiddenCardPath = 'assets/images/hidden.png';

  final List<Object> cards = <Object>[
    'assets/images/circle.png',
    'assets/images/heart.png',
    'assets/images/star.png',
    'assets/images/triangle.png',
    Icons.pets,
    Icons.cake,
    Icons.flight,
    Icons.music_note,
  ];

  late List<Object> gameImg;

  void initGame() {
    gameImg = <Object>[...cards, ...cards]..shuffle(Random());
  }
}
