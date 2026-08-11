import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ParallaxWidget extends StatefulWidget {
  final Widget child;
  final double tiltFactor;

  const ParallaxWidget({
    Key? key,
    required this.child,
    this.tiltFactor = 0.05,
  }) : super(key: key);

  @override
  State<ParallaxWidget> createState() => _ParallaxWidgetState();
}

class _ParallaxWidgetState extends State<ParallaxWidget> {
  double x = 0;
  double y = 0;
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    try {
      _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
        if (mounted) {
          setState(() {
            x = (event.y * widget.tiltFactor).clamp(-0.2, 0.2);
            y = (-event.x * widget.tiltFactor).clamp(-0.2, 0.2);
          });
        }
      }, onError: (e) {
        // Ignore sensor errors (e.g. unsupported platform)
      });
    } catch (e) {
      // Ignore
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateX(y)
        ..rotateY(x),
      alignment: FractionalOffset.center,
      child: widget.child,
    );
  }
}
