import "dart:math";
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

dynamic listImagesFound = [
  "assets/images/compressor.png",
  "assets/images/computer.png",
  "assets/images/dj.png",
  "assets/images/elektron.png",
  "assets/images/keyboard.png",
  "assets/images/laptop.png",
  "assets/images/microphone.png",
  "assets/images/midi-controller.png",
  "assets/images/mini-keyboard.png",
  "assets/images/mixer.png",
  "assets/images/moog.png",
  "assets/images/mpc.png",
  "assets/images/sampler.png",
  "assets/images/space-echo.png",
  "assets/images/speakers.png",
  "assets/images/tape-recorder.png",
];

Image randomImg() {
  int min = 0;
  int max = listImagesFound.length - 1;
  Random rnd = new Random();
  int r = min + rnd.nextInt(max - min);
  String imageName = listImagesFound[r].toString();
  return Image.asset(imageName);
}

Future<bool> addToFavorites(
    Future<SharedPreferences> _prefs, String text) async {
  final SharedPreferences prefs = await _prefs;
  final List<String> favorites =
      prefs.getStringList('creative_quest_favorites') ?? [];
  print(favorites);
  favorites.add(text);
  print(favorites);
  prefs
      .setStringList("creative_quest_favorites", favorites)
      .then((bool success) {
    print("succes");
    return true;
  }).catchError((e) {
    print("error");
    return false;
  });
}
