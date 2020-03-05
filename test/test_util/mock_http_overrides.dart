import 'dart:io';
import 'dart:typed_data';

import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class MockHttpOverrides extends HttpOverrides {
  final Uint8List _transparent = Uint8List.fromList(<int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
  ]);

  HttpClient createHttpClient(SecurityContext context) {
    return _createMockImageHttpClient(context);
  }

  MockHttpClient _createMockImageHttpClient(SecurityContext _) {
    final MockHttpClient client = MockHttpClient();
    final MockHttpClientRequest request = MockHttpClientRequest();
    final MockHttpClientResponse response = MockHttpClientResponse();
    final MockHttpHeaders headers = MockHttpHeaders();
    when(client.getUrl(any)).thenAnswer((_) => Future<HttpClientRequest>.value(request));
    when(request.headers).thenReturn(headers);
    when(request.close()).thenAnswer((_) => Future<HttpClientResponse>.value(response));
    when(response.contentLength).thenReturn(_transparent.length);
    when(response.statusCode).thenReturn(HttpStatus.ok);
    when(response.listen(any)).thenAnswer((Invocation invocation) {
      final void Function(List<int>) onData = invocation.positionalArguments[0];
      final void Function() onDone = invocation.namedArguments[#onDone];
      final void Function(Object, [StackTrace]) onError = invocation.namedArguments[#onError];
      final bool cancelOnError = invocation.namedArguments[#cancelOnError];
      return Stream<List<int>>.fromIterable(<List<int>>[_transparent])
          .listen(onData, onDone: onDone, onError: onError, cancelOnError: cancelOnError);
    });
    return client;
  }
}
