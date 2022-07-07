import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

typedef SizeChangedCallback = void Function(Size size);

class SizeListenableContainer extends SingleChildRenderObjectWidget {
  const SizeListenableContainer({
    Key? key,
    Widget? child,
    required this.onSizeChanged,
  }) : super(key: key, child: child);

  final SizeChangedCallback onSizeChanged;

  @override
  SizeListenableRenderObject createRenderObject(BuildContext context) {
    return SizeListenableRenderObject(onSizeChanged: onSizeChanged);
  }
}

/////////////////////////////////////

class SizeListenableRenderObject extends RenderProxyBox {
  SizeListenableRenderObject({
    RenderBox? child,
    required this.onSizeChanged,
  }) : super(child);

  final SizeChangedCallback onSizeChanged;

  Size _oldSize = const Size(0, 0);

  @override
  void performLayout() {
    super.performLayout();

    final Size size = this.size;

    if (size != _oldSize) {
      _oldSize = size;
      _callback(size);
    }
  }

  void _callback(Size size) {
    SchedulerBinding.instance.addPostFrameCallback((Duration _) {
      onSizeChanged(size);
    });
  }
}
