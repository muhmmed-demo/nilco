import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ReportsScreen')),
      body: const Center(
        child: Text('ReportsScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
