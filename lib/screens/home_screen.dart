import 'package:flutter/material.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
        child: CupertinoNavigationBar(
          middle: Text(
            'PayPaint',
            style: TextStyle(
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: <Color>[
                    const Color.fromARGB(255, 0, 0, 255),
                    const Color.fromARGB(255, 202, 167, 240),
                  ],
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            // textAlign: TextAlign.center,
          ),
          automaticallyImplyLeading: false,
        ),
      ),

      body: Center(),
    );
  }
}
