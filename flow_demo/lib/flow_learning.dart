import 'package:flow_demo/data.dart';
import 'package:flutter/material.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class FlowExample extends StatefulWidget {
  const FlowExample({Key? key}) : super(key: key);

  @override
  State<FlowExample> createState() => _FlowExampleState();
}

class _FlowExampleState extends State<FlowExample>
    with SingleTickerProviderStateMixin {
  late AnimationController dragAnimation;

  @override
  void initState() {
    super.initState();
    dragAnimation = AnimationController(
      lowerBound: 0,
      value: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          padding: const EdgeInsets.only(top: 100),
          child: Flow(
            clipBehavior: Clip.antiAlias,
            delegate: ListFlowDelegate(dragAnimation: dragAnimation),
            children: [
              for (int i = 1; i < 4; i++)
                GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails drag) {
                    if (drag.primaryVelocity == null) return;
                    if (drag.primaryVelocity! < 0) {
                      //left to right
                      dragAnimation.reverse();
                      //animation value 0 <- 1
                    } else {
                      //right to left
                      dragAnimation.forward();
                      //animation value 0 -> 1
                    }
                  },
                  child: TextCard(
                    title: carsData[i].name,
                    subTitle: carsData[i].place,
                    color: carsData[i].color,
                  ),
                )
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

class ListFlowDelegate extends FlowDelegate {
  ListFlowDelegate({required this.dragAnimation})
      : super(repaint: dragAnimation);
  final Animation<double> dragAnimation;
  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++) {
      double dx = i * 10 +
          (context.getChildSize(i)!.width.toDouble() * i * dragAnimation.value);
      context.paintChild(i, transform: Matrix4.translationValues(dx, 0, 0));

      //can add scaling transformation also
      // double scale = 0.4 + 0.02 * i;
      //   context.paintChild(i,
      // transform: Matrix4.translationValues(dx, 0, 0)..scale(scale));
    }
  }

  @override
  bool shouldRepaint(ListFlowDelegate oldDelegate) {
    return dragAnimation != oldDelegate.dragAnimation;
  }
}

class CarsCard extends StatelessWidget {
  const CarsCard({
    super.key,
    required this.selectedCard,
  });

  final int? selectedCard;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.network(
                  carsData[selectedCard!].imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.4, 0.95],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 20,
                child: Text(
                  carsData[selectedCard!].name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  final String title, subTitle;
  final Color color;

  const TextCard(
      {required this.title,
      required this.subTitle,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 100,
      alignment: Alignment.center,
      height: 100,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xffFFFFFF),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subTitle,
              style: const TextStyle(
                color: Color(0xffFFFFFF),
                fontSize: 14,
              ),
            ),
          ]),
    );
  }
}

