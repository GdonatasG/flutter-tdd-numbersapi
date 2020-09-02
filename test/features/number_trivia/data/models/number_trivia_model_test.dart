import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertddarchitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:fluttertddarchitecture/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: 1);

  test('should be a subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('from JSON', () {
    test(
        'should return a valid model when the type of the JSON number is an integer',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });

    test(
        'should return a valid model when the type of the JSON number is a double',
        () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });
  });

  group('to JSON', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tNumberTriviaModel.toJson();

      final matcherMap = {
        'text': 'Test text',
        'number': 1,
      };
      expect(result, matcherMap);
    });
  });
}
