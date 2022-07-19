import 'package:flutter/material.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Done Tasks",
        style: TextStyle(
          fontSize: 50.0,
        ),
      ),
    );
  }
}
