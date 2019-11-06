import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:popular_movies/resources/images.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class TestHttpOverrides extends HttpOverrides {
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
    when(response.contentLength).thenReturn(Images.transparent.length);
    when(response.statusCode).thenReturn(HttpStatus.ok);
    when(response.listen(any)).thenAnswer((Invocation invocation) {
      final void Function(List<int>) onData = invocation.positionalArguments[0];
      final void Function() onDone = invocation.namedArguments[#onDone];
      final void Function(Object, [StackTrace]) onError = invocation.namedArguments[#onError];
      final bool cancelOnError = invocation.namedArguments[#cancelOnError];
      return Stream<List<int>>.fromIterable(<List<int>>[Images.transparent])
          .listen(onData, onDone: onDone, onError: onError, cancelOnError: cancelOnError);
    });
    return client;
  }
}
