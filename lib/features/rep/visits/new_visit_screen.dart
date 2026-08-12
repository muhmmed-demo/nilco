import 'package:flutter/material.dart';

class NewVisitScreen extends StatelessWidget {
  const NewVisitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NewVisitScreen')),
      body: const Center(
        child: Text('NewVisitScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
