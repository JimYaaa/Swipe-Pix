import 'package:shared_preferences/shared_preferences.dart';

class SaveSwipePixTour {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

   void saveSwipePixTourStatue() async {
     final prefs = await _prefs;

     prefs.setBool("swipePixTour", true);
   }

   Future<bool> getSwipePixTourStatus() async {
    final prefs = await _prefs;

    if (prefs.containsKey("swipePixTour")) {
      bool? getData = prefs.getBool("swipePixTour");

      return getData!;
    } else {
      return false;
    }
   }
}