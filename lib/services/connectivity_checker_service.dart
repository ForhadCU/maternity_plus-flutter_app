import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCheckerService {
  final Connectivity _connectivity = Connectivity();

  // m: check connectivity
  Future<bool> mIsConnected() async {
    final res = await _connectivity.checkConnectivity();

    return res != ConnectivityResult.none;
  }
}
