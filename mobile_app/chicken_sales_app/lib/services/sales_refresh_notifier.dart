import 'package:flutter/foundation.dart';

class SalesRefreshNotifier {
  static final ValueNotifier<int> refreshKey = ValueNotifier<int>(0);

  static void notifyRefresh() {
    refreshKey.value++;
  }
}
