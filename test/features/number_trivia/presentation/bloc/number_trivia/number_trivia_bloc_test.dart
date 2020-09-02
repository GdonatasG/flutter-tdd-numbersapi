import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertddarchitecture/core/error/failures.dart';
import 'package:fluttertddarchitecture/core/usecases/usecase.dart';
import 'package:fluttertddarchitecture/core/utils/input_converter.dart';
import 'package:fluttertddarchitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fluttertddarchitecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:fluttertddarchitecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:fluttertddarchitecture/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('should check that initialState is NumberTriviaEmpty', () {
    expect(bloc.initialState, equals(NumberTriviaEmpty()));
  });

  group('getTriviaForConcreteNumber', () {
    final tNumberAsString = '1'; // before converting
    final tNumberParsed = 1; // after converting
    final tNumberTrivia =
        NumberTrivia(text: 'test text', number: tNumberParsed);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test('should emit [NumberTriviaError] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      final expected = [
        NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberAsString));
    });

    test('should get trivia from the concrete use case', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      bloc.add(GetTriviaForConcreteNumber(tNumberAsString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaLoaded]'
        'when data is fetched successfully', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      final expected = [
        NumberTriviaLoading(),
        NumberTriviaLoaded(trivia: tNumberTrivia)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberAsString));
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaError]'
        'when data is NOT successfully and got an error', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      final expected = [
        NumberTriviaLoading(),
        NumberTriviaError(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberAsString));
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaError]'
        'with a proper message for the error when getting data fails',
        () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        NumberTriviaLoading(),
        NumberTriviaError(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberAsString));
    });
  });

  group('getTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test text', number: 1);

    test('should get trivia from the random use case', () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaLoaded]'
        'when data is fetched successfully', () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      final expected = [
        NumberTriviaLoading(),
        NumberTriviaLoaded(trivia: tNumberTrivia)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaError]'
        'when data is NOT successfully and got an error', () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      final expected = [
        NumberTriviaLoading(),
        NumberTriviaError(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [NumberTriviaLoading, NumberTriviaError]'
        'with a proper message for the error when getting data fails',
        () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        NumberTriviaLoading(),
        NumberTriviaError(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
