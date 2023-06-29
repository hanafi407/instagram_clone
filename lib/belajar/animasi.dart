import 'package:flutter/material.dart';

class Person {
  final String name = 'hanafi';
}

class Animasi extends StatefulWidget {
  const Animasi({super.key});

  @override
  State<Animasi> createState() => _AnimasiState();
}

class _AnimasiState extends State<Animasi> with SingleTickerProviderStateMixin {
  _AnimasiState();
  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 2),
  );
  late Animation<double> _scale = Tween<double>(begin: 0, end: 1).animate(_controller);

// _controller=AnimationController(vsync: vsync)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
          onPressed: () {
            _controller.repeat(reverse: true);
          },
          child: Text(
            'Klik',
            style: TextStyle(color: Colors.white),
          ),
        )
      ]),
      body: Center(
          child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 100,
          height: 100,
          color: Colors.amber,
        ),
      )),
    );
  }
}
