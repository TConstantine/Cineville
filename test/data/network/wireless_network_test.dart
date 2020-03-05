import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/network/wireless_network.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  DataConnectionChecker mockDataConnectionChecker;
  Network network;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    network = WirelessNetwork(mockDataConnectionChecker);
  });

  test('should check if the device is connected to the internet', () async {
    final testIsConnected = Future.value(true);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => testIsConnected);

    final Future<bool> isConnected = network.isConnected();

    verify(mockDataConnectionChecker.hasConnection);
    expect(isConnected, testIsConnected);
  });
}
