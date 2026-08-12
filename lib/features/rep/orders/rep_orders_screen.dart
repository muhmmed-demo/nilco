import 'package:flutter/material.dart';

class RepOrdersScreen extends StatelessWidget {
  const RepOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RepOrdersScreen')),
      body: const Center(
        child: Text('RepOrdersScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
