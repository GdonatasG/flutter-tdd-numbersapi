import 'package:dartz/dartz.dart';
import 'package:fluttertddarchitecture/core/error/failures.dart';
import 'package:fluttertddarchitecture/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
