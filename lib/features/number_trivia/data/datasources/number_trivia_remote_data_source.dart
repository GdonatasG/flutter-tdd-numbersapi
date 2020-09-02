import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertddarchitecture/core/error/exceptions.dart';
import 'package:fluttertddarchitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:fluttertddarchitecture/features/number_trivia/number_trivia_constants.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client httpClient;

  NumberTriviaRemoteDataSourceImpl({@required this.httpClient});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async =>
      _getTriviaFromUrl(NumberTriviaConstants.BASE_URL + '/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl(NumberTriviaConstants.BASE_URL + '/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(url) async {
    final response = await httpClient
        .get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200)
      return NumberTriviaModel.fromJson(json.decode(response.body));
    else
      throw ServerException();
  }
}
