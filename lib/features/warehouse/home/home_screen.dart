import 'package:flutter/material.dart';

class WarehouseHomeScreen extends StatelessWidget {
  const WarehouseHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WarehouseHomeScreen')),
      body: const Center(
        child: Text('WarehouseHomeScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
