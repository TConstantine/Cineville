import 'package:cineville/data/network/network.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class WirelessNetwork implements Network {
  final DataConnectionChecker _dataConnectionChecker;

  WirelessNetwork(this._dataConnectionChecker);

  @override
  Future<bool> isConnected() {
    return _dataConnectionChecker.hasConnection;
  }
}
