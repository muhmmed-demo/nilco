import 'package:flutter/material.dart';

class IncomingOrdersScreen extends StatelessWidget {
  const IncomingOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IncomingOrdersScreen')),
      body: const Center(
        child: Text('IncomingOrdersScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
