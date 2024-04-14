import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  Widget child;
  bool isColse;
  FlipCard({super.key, required this.child, this.isColse = true});

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
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
    if (widget.isColse && _controller.value == 0) {
      _controller.reverse(from: 1);
    } else if (widget.isColse == false && _controller.value == 0) {
      _controller.forward(from: 0);
    }
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.horizontal,
      axisAlignment: 0,
      child: widget.child,
    );
  }
}
