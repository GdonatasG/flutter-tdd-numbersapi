import 'package:flutter/material.dart';
import 'package:fluttertddarchitecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:fluttertddarchitecture/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // dependency injection
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
          primaryColor: Colors.green.shade800,
          accentColor: Colors.green.shade600),
      home: NumberTriviaPage(),
    );
  }
}
