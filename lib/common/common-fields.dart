import 'package:flutter/material.dart';

class CommonField {
  final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 50.0,
        child: Image.asset('assets/logo.jpg'),
      ),
    );
}