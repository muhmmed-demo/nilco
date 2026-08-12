import 'package:flutter/material.dart';

class RoutesManagerScreen extends StatelessWidget {
  const RoutesManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RoutesManagerScreen')),
      body: const Center(
        child: Text('RoutesManagerScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
