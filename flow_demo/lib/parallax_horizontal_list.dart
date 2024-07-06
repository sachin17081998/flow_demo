import 'package:flow_demo/data.dart';
import 'package:flutter/material.dart';

class ExampleParallax extends StatelessWidget {
  final String title, subtitle;
  final double width, height;
  const ExampleParallax({
    required this.title,
    required this.subtitle,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
            child: Text(subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                )),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final car in carsData)
                  CarsListItem(
                    imageUrl: car.imageUrl,
                    name: car.name,
                    country: car.place,
                    description: car.description,
                    width: width,
                    height: height,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CarsListItem extends StatelessWidget {
  CarsListItem(
      {super.key,
      required this.width,
      required this.height,
      required this.imageUrl,
      required this.name,
      required this.country,
      required this.description});
  final double width, height;
  final String imageUrl;
  final String name;
  final String country;

  final String description;
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipPath(
        clipper: MyClipper(),
        child: Stack(
          children: [
            _buildParallaxBackground(context),
            _buildGradient(),
            _buildTitleAndSubtitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
      ),
      children: [
        Image.network(
          imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
          width: width,
          height: height,
        ),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.4, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 40,
      bottom: 20,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              country,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double clipFactor = 12;
    var path = Path()
      ..moveTo(clipFactor, clipFactor)
      ..quadraticBezierTo(clipFactor, 0, 2 * clipFactor, 0)
      ..lineTo(size.width - 2 * clipFactor, 0)
      ..quadraticBezierTo(
          size.width - clipFactor, 0, size.width - clipFactor, clipFactor)
      ..lineTo(size.width - clipFactor, size.height - clipFactor)
      ..quadraticBezierTo(size.width - clipFactor, size.height,
          size.width - 2 * clipFactor, size.height)
      ..lineTo(2 * clipFactor, size.height)
      ..quadraticBezierTo(
          clipFactor, size.height, clipFactor, size.height - clipFactor)
      ..lineTo(clipFactor, clipFactor)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    //step 1:  Calculate the position of this list item within the viewport.
    //get render box of scrollable area to calculate size of scrollable area
    // below statment will give size=(392,432), i.e:device width , given height(400) + 32 padding
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    //get renderBox of  item in from the list
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    // Convert the given point from the local coordinate system for this box to
    // the global coordinate system in logical pixels
    //in short we are taking center left coordinate of item and converting it
    //its parent coordinate.
    //so for first item dx=0
    // for 2nd item dx=246
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    context.paintChild(0,
        transform: Matrix4.translationValues(
            (0.5 + listItemOffset.dx * -0.1).clamp(-30, 30), 0, 0));
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext;
  }
}
