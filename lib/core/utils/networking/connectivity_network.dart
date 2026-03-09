import 'package:connectivity_plus/connectivity_plus.dart';
// ignore: file_names


class ConnectivityNetwork {
  final Connectivity _connectivity = Connectivity();

  Future<bool> checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    // ignore: unrelated_type_equality_checks
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> isConnectedViaWifi() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    // ignore: unrelated_type_equality_checks
    return connectivityResult == ConnectivityResult.wifi;
  }

  Future<bool> isConnectedViaMobile() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    // ignore: unrelated_type_equality_checks
    return connectivityResult == ConnectivityResult.mobile;
  }
}
