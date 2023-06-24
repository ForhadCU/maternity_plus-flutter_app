import 'package:flutter/foundation.dart';
import 'package:maa/services/connectivity_checker_service.dart';

class ShaptahikPoribortonViewModel {
  // c: other viewmodel logic goes here...

  // c: create connectivity service instance
/*   final ConnectivityCheckerService _connectivityCheckerService;
  // final Map<String, dynamic> _mapData;

  ShaptahikPoribortonViewModel(this._connectivityCheckerService);
  // ShaptahikPoribortonViewModel.initialTabIndex(this._mapData);

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> checkConnectivity() async {
    _isConnected = await _connectivityCheckerService.mIsConnected();

       // e: test
    _isConnected = false; 
  } */

  int getInitialTabIndex(
      {required List<Map<String, dynamic>> tabData, required int presentWeek}) {
    int index = 0;
    int initialFirstWeek = 3;
    int initialSecondWeek = 4;
    int initialFinalWeek = 41;

    presentWeek == initialFirstWeek
        ? {index}
        : presentWeek == initialSecondWeek
            ? {index++}
            : presentWeek == initialFinalWeek
                ? {index += 3}
                : {index += 2};

    // kDebugMode ? logger.d("index: $index") : null;
    return index;
  }
}
