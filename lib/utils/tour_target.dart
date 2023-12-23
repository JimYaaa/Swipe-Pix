import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

List<TargetFocus> addAppTarget({
  required GlobalKey cardKey,
  required GlobalKey removeButtonKey,
  required GlobalKey keepButtonKey,
  required GlobalKey undoButtonKey,
  required GlobalKey deleteButtonKey,
}) {
  List<TargetFocus> targets = [];

  targets.add(TargetFocus(
    keyTarget: cardKey,
    alignSkip: Alignment.topRight,
    radius: 10,
    shape: ShapeLightFocus.RRect,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        padding: EdgeInsets.zero,
        builder: (context, controller) {
          return Center(
            child: Container(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You can swip photo to keep or remove it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ],
              ),
            ),
          );
        },
      )
    ]
  ));

  targets.add(TargetFocus(
    keyTarget: removeButtonKey,
    alignSkip: Alignment.topRight,
    radius: 10,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        // padding: EdgeInsets.zero,
        builder: (context, controller) {
          return Center(
            child: Container(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You can click this button to remove photo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ],
              ),
            ),
          );
        },
      )
    ]
  ));

  targets.add(TargetFocus(
    keyTarget: keepButtonKey,
    alignSkip: Alignment.topRight,
    radius: 10,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        // padding: EdgeInsets.zero,
        builder: (context, controller) {
          return Center(
            child: Container(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You can click this button to keep photo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ],
              ),
            ),
          );
        },
      )
    ]
  ));

  targets.add(TargetFocus(
    keyTarget: undoButtonKey,
    alignSkip: Alignment.topRight,
    radius: 10,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        // padding: EdgeInsets.zero,
        builder: (context, controller) {
          return Center(
            child: Container(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You can click this button to recover photo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ],
              ),
            ),
          );
        },
      )
    ]
  ));

  targets.add(TargetFocus(
    keyTarget: deleteButtonKey,
    alignSkip: Alignment.bottomRight,
    radius: 10,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        // padding: EdgeInsets.zero,
        builder: (context, controller) {
          return Center(
            child: Container(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Before you leave App make sure you have click this trash can icon to delete photos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ],
              ),
            ),
          );
        },
      )
    ]
  ));

  return targets;
}