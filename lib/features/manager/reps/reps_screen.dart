import 'package:flutter/material.dart';

class RepsListScreen extends StatelessWidget {
  const RepsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RepsListScreen')),
      body: const Center(
        child: Text('RepsListScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
