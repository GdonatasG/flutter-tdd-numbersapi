import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertddarchitecture/core/error/exceptions.dart';
import 'package:fluttertddarchitecture/features/number_trivia/number_trivia_constants.dart';
import 'package:fluttertddarchitecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:fluttertddarchitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from SharedPref'
        'when there is a trivia in the cache', () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      final result =
          await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();
      verify(mockSharedPreferences
          .getString(NumberTriviaConstants.CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw CacheException'
        'when there is NO trivia in the cache', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia;
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPref to cache the number trivia', () async {
      numberTriviaLocalDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          NumberTriviaConstants.CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
