import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertddarchitecture/core/error/failures.dart';
import 'package:fluttertddarchitecture/core/usecases/usecase.dart';
import 'package:fluttertddarchitecture/core/utils/input_converter.dart';
import 'package:fluttertddarchitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fluttertddarchitecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:fluttertddarchitecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - The number '
    'must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(NumberTriviaEmpty());

  NumberTriviaState get initialState => NumberTriviaEmpty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberAsString);

      yield* inputEither.fold((failure) async* {
        yield NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (numb) async* {
        yield NumberTriviaLoading();
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: numb));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield NumberTriviaLoading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
      (failure) => NumberTriviaError(message: _mapFailureIntoMessage(failure)),
      (trivia) => NumberTriviaLoaded(trivia: trivia),
    );
  }

  String _mapFailureIntoMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
