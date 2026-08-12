import 'package:flutter/material.dart';

class ManagerHomeScreen extends StatelessWidget {
  const ManagerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ManagerHomeScreen')),
      body: const Center(
        child: Text('ManagerHomeScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
