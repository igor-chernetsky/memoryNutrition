import 'package:flutter/material.dart';
import 'dart:math';

import 'package:memory_nutration/widgets/flip_card.dart';

class AnimatedBlock extends StatelessWidget {
  bool isActive;
  Widget child;
  double min;
  int duration;
  bool isRotating;
  bool? isFlip;
  AnimatedBlock(
      {super.key,
      required this.isActive,
      required this.child,
      this.isFlip,
      this.isRotating = false,
      this.min = 0.8,
      this.duration = 1200});

  @override
  Widget build(BuildContext context) {
    Widget result = child;
    if (isActive && isFlip != null) {
      return FlipCard(
        isColse: isFlip!,
        child: child,
      );
    }
    if (isActive) {
      result = ShakeCard(
        duration: duration,
        min: min,
        child: child,
      );
    }
    if (isRotating && isActive) {
      result = RotateCard(child: result);
    }
    return result;
  }
}

class ShakeCard extends StatefulWidget {
  Widget child;
  double min;
  int duration;
  ShakeCard(
      {super.key,
      required this.child,
      required this.min,
      required this.duration});

  @override
  State<ShakeCard> createState() => _ShakeCardState();
}

class _ShakeCardState extends State<ShakeCard> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    lowerBound: widget.min,
    upperBound: 1,
    duration: Duration(milliseconds: widget.duration),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.stop();
    _controller.reset();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

class RotateCard extends StatefulWidget {
  Widget child;
  RotateCard({super.key, required this.child});

  @override
  State<RotateCard> createState() => _RotateCardState();
}

class _RotateCardState extends State<RotateCard> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    lowerBound: 0.9,
    upperBound: 1,
    value: 0.1,
    duration: const Duration(milliseconds: 500),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.stop();
    _controller.reset();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Transform.rotate(angle: 0.05, child: widget.child),
    );
  }
}
