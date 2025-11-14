import 'package:flutter/material.dart';

AppBar appBarWidget(BuildContext context) {
  return AppBar(
    title: Image(image: AssetImage('assets/images/logo.png'), height: 40),
    centerTitle: true,
    backgroundColor: Colors.white,
  );
}
