import 'package:flutter/material.dart';

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NewOrderScreen')),
      body: const Center(
        child: Text('NewOrderScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
