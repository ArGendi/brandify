import 'package:flutter/material.dart';
import 'package:tabe3/constants.dart';


class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: mainColor,
    );
  }
}