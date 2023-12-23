import 'package:flutter/material.dart';
import 'package:swipe_pix/widgets/delete_button.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:swipe_pix/widgets/swipe_card.dart';
import 'package:swipe_pix/widgets/logo.dart';
import 'package:swipe_pix/widgets/button_group.dart';
import 'package:swipe_pix/provider/card_provider.dart';
import 'package:swipe_pix/utils/tour_target.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:swipe_pix/provider/swipe_pix_tour_storage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
          title: 'Swipe Pix',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                 elevation: 0,
                 shape: const CircleBorder(),
                 minimumSize: const Size.square(50),
              )
            )
          ),
          home: const MainPage(),
      ),
    );
  }
}

final cardKey = GlobalKey();

late TutorialCoachMark tutorialCoachMark;

void initAppTour() {
  tutorialCoachMark = TutorialCoachMark(
    targets: addAppTarget(
      cardKey: cardKey,
      removeButtonKey: removeButtonKey,
      keepButtonKey: keepButtonKey,
      undoButtonKey: undoButtonKey,
      deleteButtonKey: deleteButtonKey,
    ),
    colorShadow: Colors.black,
    paddingFocus: 0,
    hideSkip: false,
    opacityShadow: 0.8, 
    onFinish: () {
      SaveSwipePixTour().saveSwipePixTourStatue();
    }
  );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  // List<AssetEntity> assets = [];

  void showAppTour() {
  Future.delayed(const Duration(seconds: 1), () {
    SaveSwipePixTour().getSwipePixTourStatus().then((value) {
      if (!value) tutorialCoachMark.show(context: context);
    });
  }); 
}

  // Get User Photos When User Open The App
  @override
  void initState() {
    super.initState();

    void getPhotos() async {
      final provider = Provider.of<CardProvider>(context, listen: false);
      final PermissionState ps = await PhotoManager.requestPermissionExtend();

      provider.setPermissionState(ps);

      if (ps == PermissionState.denied) {
        return;
      }

      final int count = await PhotoManager.getAssetCount();
      final List<AssetEntity> entities = await PhotoManager.getAssetListRange(start: 0, end: provider.perGetPhotoNum);

      provider.setTotalPhotoGetCount(entities.length);
      // Filter asset type is not image
      entities.removeWhere((element) => element.type != AssetType.image);

      provider.setAssets(entities.reversed.toList());
      provider.setTotalPhotoCount(count);

      initAppTour();
      showAppTour();
    }

    getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white
          ]
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildLogo(context),
                const SizedBox(height: 16),
                Expanded(child: buildCards()),
                const SizedBox(height: 16),
                buildButtonGroup(context),
              ],
            )
          )
        ),
      ),
    );
  }

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final entities = provider.entities;
    final permissionState = provider.permissionState;

    if (permissionState == PermissionState.denied) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "It appears that you haven't granted access to the photo album.",
              // textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Swipe Pix requires your photo album permission to load your photos. Please press the button below to grant permission.",
              // textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Please press the button below to grant permission.",
              // textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                PhotoManager.openSetting();
              },
              style: ButtonStyle(
                foregroundColor: getColor(Colors.black, Colors.red, false, false),
                backgroundColor: getColor(Colors.black, Colors.white, false, false),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  )
                )
              ),
              child: const Text(
                'Go To Setting',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ]
        ),
      );
    } else {
      return entities.isNotEmpty ? Stack(
        key: cardKey,
        children: entities
          .map((entity) => SwipeCard(
            entity: entity,
            isFront: entities.last == entity
          ))
          .toList(),
      ) : Center(
        child: LoadingAnimationWidget.inkDrop(
          color: Colors.black,
          size: 40,
        ),
      );
    }
  }
}
