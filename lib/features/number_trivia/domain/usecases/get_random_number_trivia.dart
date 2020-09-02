import 'package:dartz/dartz.dart';
import 'package:fluttertddarchitecture/core/error/failures.dart';
import 'package:fluttertddarchitecture/core/usecases/usecase.dart';
import 'package:fluttertddarchitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fluttertddarchitecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository numberTriviaRepository;

  GetRandomNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}
