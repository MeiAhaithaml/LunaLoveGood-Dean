import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/user_preferences/user_preferences.dart';
import 'package:lunalovegood/welcome/welcome_page.dart';

import 'saudangnhap/bottom_bar.dart';


void main() {
  runApp(GetMaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF8B8B)),
      useMaterial3: true,
    ),
    home: FutureBuilder(
      future: RememberUserPrefs.readUserInfo(),
      builder: (context, dataSnapShot) {
        if (dataSnapShot.data == null) {
          return const OnboardPage();
        } else {
          return const NavigationMenu();
        }
      },
    ),
  ));
}