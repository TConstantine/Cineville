import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/network/wireless_network.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  DataConnectionChecker _mockDataConnectionChecker;
  Network _network;

  setUp(() {
    _mockDataConnectionChecker = MockDataConnectionChecker();
    _network = WirelessNetwork(_mockDataConnectionChecker);
  });

  group('isConnected', () {
    final testIsConnected = Future.value(true);

    test('should check if the device is connected to the internet', () async {
      when(_mockDataConnectionChecker.hasConnection).thenAnswer((_) => testIsConnected);

      final Future<bool> isConnected = _network.isConnected();

      verify(_mockDataConnectionChecker.hasConnection);
      expect(isConnected, testIsConnected);
    });
  });
}
