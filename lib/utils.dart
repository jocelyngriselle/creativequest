import "dart:math";
import 'package:flutter/material.dart';

dynamic listImagesFound = [
  "assets/images/compressor.png",
  //"assets/images/computer.png",
  //"assets/images/dj.png",
  //"assets/images/elektron.png",
  //"assets/images/keyboard.png",
  "assets/images/laptop.png",
  //"assets/images/microphone.png",
  //"assets/images/midi-controller.png",
  //"assets/images/mini-keyboard.png",
  "assets/images/mixer.png",
  //"assets/images/moog.png",
  //"assets/images/mpc.png",
  //"assets/images/sampler.png",
  //"assets/images/space-echo.png",
  "assets/images/speakers.png",
  "assets/images/tape-recorder.png",
];

Image randomImg() {
  return Image.asset(randomImgName());
}

String randomImgName() {
  int min = 0;
  int max = listImagesFound.length - 1;
  Random rnd = new Random();
  int r = min + rnd.nextInt(max - min);
  return listImagesFound[r].toString();
}
