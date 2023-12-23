import 'package:flutter/material.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:swipe_pix/provider/card_provider.dart';
import 'package:swipe_pix/widgets/stamp.dart';
import 'dart:math';

class SwipeCard extends StatefulWidget {
  final bool isFront;
  final AssetEntity entity;

  const SwipeCard({
    Key? key,
    required this.isFront,
    required this.entity
  }) : super(key: key);

  @override
  SwipeCardState createState() => SwipeCardState();
}

class SwipeCardState extends State<SwipeCard> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: widget.isFront ? buildFrontCard() : buildCard(),
    );
  }

  Widget buildFrontCard() {
    return GestureDetector(
     child: LayoutBuilder(
       builder: (context, constraints) {
        final provider = Provider.of<CardProvider>(context);
        final position = provider.position;
        final milliseconds = provider.isDragging ? 0 : 400;
        final angle = provider.angle * pi / 180;
        final center = constraints.smallest.center(Offset.zero);
        final rotatedMatrix = Matrix4.identity()
          ..translate(center.dx, center.dy)
          ..rotateZ(angle)
          ..translate(-center.dx, -center.dy);

         return AnimatedContainer(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: milliseconds),
          transform: rotatedMatrix..translate(position.dx, position.dy),
          child: Stack(
            fit: StackFit.expand,
            children: [
              buildCard(),
              buildStamps(context),
            ]
          )
        );
       }
     ),
     onPanStart: (details) {
      final provider = Provider.of<CardProvider>(context, listen: false);

      provider.startPosition(details);
     },
     onPanUpdate: (details) {
      final provider = Provider.of<CardProvider>(context, listen: false);

      provider.updatePosition(details);
     },
     onPanEnd: (details) {
      final provider = Provider.of<CardProvider>(context, listen: false);

      provider.endPosition(details);
     }
    );
  }

  Widget buildCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: AssetEntityImage(widget.entity, fit: BoxFit.contain),
      ),
    );
  }
}

