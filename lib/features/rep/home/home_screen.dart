import 'package:flutter/material.dart';

class RepHomeScreen extends StatelessWidget {
  const RepHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RepHomeScreen')),
      body: const Center(
        child: Text('RepHomeScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
