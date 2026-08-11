import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For Phase 1 we use CircularProgressIndicator, 
    // it can be replaced with Lottie once the assets are provided.
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
