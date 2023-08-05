import 'package:maa/services/connectivity_checker_service.dart';

class ConnectivityCheckerViewModel {
  final ConnectivityCheckerService _connectivityCheckerService;
  ConnectivityCheckerViewModel(this._connectivityCheckerService);

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> mCheckConnectivity() async {
    _isConnected = await _connectivityCheckerService.mIsConnected();
  }
}
