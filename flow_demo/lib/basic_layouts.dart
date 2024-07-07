import 'dart:math';

import 'package:flutter/material.dart';

class BasicLayouts extends StatelessWidget {
  const BasicLayouts({Key? key}) : super(key: key);

  List<Widget> generateContainers() {
    final colors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent
    ];
    final texts = ['1', '2', '3', '4'];

    return List<Widget>.generate(colors.length, (index) {
      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: colors[index]),
        width: 100,
        height: 100,
        alignment: Alignment.center,
        child: Text(texts[index]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: LayoutFlowDelegate(),
      children: generateContainers(),
    );
  }
}

class LayoutFlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {

    for (int childIndex = 0; childIndex < context.childCount; childIndex++) {
      double dx = 0;
      if (context.getChildSize(childIndex) != null) {
        dx = childIndex * context.getChildSize(childIndex)!.width;
      }
      context.paintChild(childIndex,
          transform: Matrix4.translationValues(dx, 0, 0));
    }

    //for stack
    // for (int childIndex = 0; childIndex < context.childCount; childIndex++) {
    //   double dx = childIndex * 20;
    //   double dy = childIndex * 20;
    //   context.paintChild(childIndex,
    //       transform: Matrix4.translationValues(dx, dy, 0));
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return false;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return const Size(double.infinity, 400);
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return i == 3
        ? const BoxConstraints.tightFor(width: 100, height: 50)
        : const BoxConstraints.tightFor(width: 100, height: 100);
  }
}
