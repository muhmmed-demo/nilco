import 'package:flutter/material.dart';

class ClientStockScreen extends StatelessWidget {
  const ClientStockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClientStockScreen')),
      body: const Center(
        child: Text('ClientStockScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
