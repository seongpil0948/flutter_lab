import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// TODO: https://codelabs.developers.google.com/codelabs/flutter-codelab-first?hl=ko#4

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  // ↓ Add this.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HorizonAnimation(),
            FirstMatrix(),
            Text('A random AWESOME idea:'),
            BigCard(pair: pair),
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase),
      ),
    );
  }
}

class FirstMatrix extends StatefulWidget {
  const FirstMatrix({super.key});

  @override
  State<FirstMatrix> createState() => _FirstMatrixState();
}

class _FirstMatrixState extends State<FirstMatrix> {
  double x = 0;
  double y = 0;
  double z = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height / 3,
      child: Center(
        child: Transform(
          // 1,0,0,0,
          // 0,1,0,0,
          // 0,0,1,0,
          // 0,0,0,1,
          transform: Matrix4(
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
          )
            ..rotateX(x)
            ..rotateY(y)
            ..rotateZ(z),
          alignment: FractionalOffset.center,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                y = y - details.delta.dx / 100;
                x = x + details.delta.dy / 100;
              });
            },
            child: Container(
              color: Colors.red,
              height: 200.0,
              width: 200.0,
            ),
          ),
        ),
      ),
    );
  }
}

class HorizonAnimation extends StatefulWidget {
  const HorizonAnimation({super.key});

  @override
  State<HorizonAnimation> createState() => _HorizonAnimationState();
}

class _HorizonAnimationState extends State<HorizonAnimation> {
  bool _isBack = true;
  double _angle = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height / 3,
      child: Center(
        child: GestureDetector(
          onTap: () => setState(() {
            _angle = (_angle + pi) % (2 * pi);
          }),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: _angle),
            duration: Duration(milliseconds: 1000),
            builder: (BuildContext con, double val, _) {
              _isBack = (val >= (pi / 2)) ? false : true;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(val),
                child: Container(
                  width: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: _isBack
                            ? AssetImage("assets/images/logo_b_1.png")
                            : AssetImage("assets/images/logo_b_2.png")),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
