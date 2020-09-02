import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertddarchitecture/core/error/exceptions.dart';
import 'package:fluttertddarchitecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:fluttertddarchitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:fluttertddarchitecture/features/number_trivia/number_trivia_constants.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl numberTriviaRemoteDataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    numberTriviaRemoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should perform a GET request on a url'
        'with number being the endpoint and with application/json header',
        () async {
      setUpMockHttpClientSuccess200();
      numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
      verify(mockHttpClient.get(NumberTriviaConstants.BASE_URL + '/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the status code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200();
      final result = await numberTriviaRemoteDataSourceImpl
          .getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the status code is NOT 200 (not success)',
        () async {
      setUpMockHttpClientFailure404();
      final call = numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia;
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should perform a GET request on a url'
        'with number being the endpoint and with application/json header',
        () async {
      setUpMockHttpClientSuccess200();
      numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
      verify(mockHttpClient.get(NumberTriviaConstants.BASE_URL + '/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the status code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200();
      final result =
          await numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the status code is NOT 200 (not success)',
        () async {
      setUpMockHttpClientFailure404();
      final call = numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia;
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
