import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertddarchitecture/core/error/exceptions.dart';
import 'package:fluttertddarchitecture/features/number_trivia/number_trivia_constants.dart';
import 'package:fluttertddarchitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString =
        sharedPreferences.getString(NumberTriviaConstants.CACHED_NUMBER_TRIVIA);
    if (jsonString != null)
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    else
      throw CacheException();
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) {
    return sharedPreferences.setString(
        NumberTriviaConstants.CACHED_NUMBER_TRIVIA,
        json.encode(numberTriviaModel.toJson()));
  }
}
