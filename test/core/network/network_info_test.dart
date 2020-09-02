import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertddarchitecture/core/network/network_info.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('is connected', () {
    test(
        'should forward the call to '
        'DataConnectionChecker.hasConnection', () async {
      final tHasConnectionAsFuture = Future.value(true);

      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionAsFuture);

      final result = networkInfoImpl.isConnected;
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, tHasConnectionAsFuture);
    });
  });
}
