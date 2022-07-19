import 'package:flutter/material.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Archived Tasks",
        style: TextStyle(
          fontSize: 50.0,
        ),
      ),
    );
  }
}
