import 'package:flutter/cupertino.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Timer with ChangeNotifier {
  static final Timer _singleton = Timer._internal();

  factory Timer() {
    return _singleton;
  }

  Timer._internal();

  bool working = false;

  void startWorking() {
    working = true;
    notifyListeners();
  }

  void stopWorking() {
    working = false;
    notifyListeners();
  }
}
