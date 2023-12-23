import 'package:flutter/material.dart';
import 'package:swipe_pix/provider/card_provider.dart';
import 'package:provider/provider.dart';

Widget buildStamps(context) {
  final provider = Provider.of<CardProvider>(context);
  final status = provider.getStatus();
  final opacity = provider.getStatusOpacity();

  Widget buildStamp({
    double angle = 0,
    required IconData icon,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: 0,
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(
              color: Colors.white, 
              width: 6,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }

  switch (status) {
    case CardStatus.keep:
      final child = buildStamp(
        icon: Icons.favorite,
        opacity: opacity,
      );
      return Center(child: child);

    case CardStatus.remove:
      final child = buildStamp(
        icon: Icons.clear,
        opacity: opacity,
      );
      return Center(child: child);

    default:
      return Container();
  }

}