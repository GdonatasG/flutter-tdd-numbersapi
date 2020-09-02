import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertddarchitecture/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:fluttertddarchitecture/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:fluttertddarchitecture/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: Center(child: _buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> _buildBody(BuildContext context) =>
      BlocProvider(
        create: (context) => sl<NumberTriviaBloc>(),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is NumberTriviaEmpty) {
                        return MessageDisplay(
                          message: 'Start searching!',
                        );
                      } else if (state is NumberTriviaError) {
                        return MessageDisplay(message: state.message);
                      } else if (state is NumberTriviaLoading) {
                        return LoadingWidget();
                      } else if (state is NumberTriviaLoaded) {
                        return TriviaDisplay(numberTrivia: state.trivia);
                      }
                      return Container();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // bottom
                  TriviaControls()
                ],
              ),
            ),
          ),
        ),
      );
}
