import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertddarchitecture/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final inputController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // TextField
          TextFormField(
            validator: (value) {
              if (value.isEmpty) return 'Enter a number!';
              return null;
            },
            controller: inputController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a number',
            ),
            onChanged: (value) {
              inputStr = value;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    _addConcreteTriviaEvent();
                  },
                  child: Text('Search'),
                  textTheme: ButtonTextTheme.primary,
                  color: Theme.of(context).accentColor,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    _addRandomTriviaEvent();
                  },
                  child: Text('Get random trivia'),
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _addConcreteTriviaEvent() {
    if (formKey.currentState.validate()) {
      inputController.clear();
      BlocProvider.of<NumberTriviaBloc>(context)
          .add(GetTriviaForConcreteNumber(inputStr));
    }
  }

  void _addRandomTriviaEvent() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
