import 'package:flutter/material.dart';
import 'package:swipe_pix/provider/card_provider.dart';
import 'package:provider/provider.dart';

final removeButtonKey = GlobalKey();
final keepButtonKey = GlobalKey();
final undoButtonKey = GlobalKey();

MaterialStateProperty<Color> getColor(Color color, Color colorPressed, bool force, bool isDisable) {
  getColor(Set<MaterialState> states) {
    if (force || states.contains(MaterialState.pressed)) {
      return isDisable ? colorPressed.withOpacity(0.5) : colorPressed;
    }
      
    return isDisable ? color.withOpacity(0.5) : color;
  }

  return MaterialStateProperty.resolveWith((getColor));
}

MaterialStateProperty<BorderSide> getBorder(Color color, bool force) {
  getBorder(Set<MaterialState> states) {
    if (force || states.contains(MaterialState.pressed)) {
      return const BorderSide(color: Colors.transparent);
    }
      
    return BorderSide(color: color, width: 2);
  }

  return MaterialStateProperty.resolveWith((getBorder));
}

Widget buildButtonGroup(context) {
  final provider = Provider.of<CardProvider>(context, listen: false);
  final status = provider.getStatus();
  final isRemove = status == CardStatus.remove;
  final isKeep = status == CardStatus.keep;
  final timelineLength = provider.timeline.length;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      ElevatedButton(
        key: removeButtonKey,
        onPressed: () {
          provider.remove();
        },
        style: ButtonStyle(
          foregroundColor: getColor(Colors.black, Colors.red, isRemove, false),
        ),
        child: const Icon(
          Icons.clear, 
          size: 40,
        )
      ),

      ElevatedButton(
        key: undoButtonKey,
        onPressed: () {
          if (timelineLength <= 0) return;

          provider.undo();
        },
        style: ButtonStyle(
          foregroundColor: getColor(Colors.black, Colors.blue, false, timelineLength <= 0),
        ),
        child: const Icon(
          Icons.undo_rounded, 
          size: 40,
        )
      ),

      ElevatedButton(
        key: keepButtonKey,
        onPressed: () {
          provider.keep();
        },
        style: ButtonStyle(
          foregroundColor: getColor(Colors.black, Colors.teal, isKeep, false),
        ),
        child: const Icon(
          Icons.favorite, 
          size: 40,
        )
      ),
    ],
  );
}