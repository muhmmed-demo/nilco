import 'package:flutter/material.dart';

class OrdersManagerScreen extends StatelessWidget {
  const OrdersManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OrdersManagerScreen')),
      body: const Center(
        child: Text('OrdersManagerScreen - Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
