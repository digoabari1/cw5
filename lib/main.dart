import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(AquariumApp());
}

class AquariumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Aquarium',
      home: AquariumScreen(),
    );
  }
}

class Fish {
  Color color;
  double speed;
  Offset position;
  Fish({required this.color, required this.speed, required this.position});
}

class AquariumScreen extends StatefulWidget {
  @override
  _AquariumScreenState createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen>
    with SingleTickerProviderStateMixin {
  List<Fish> fishList = [];
  Color selectedColor = Colors.blue;
  double selectedSpeed = 2.0;
  late AnimationController _controller;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    )..addListener(_updateFishPositions);
    _controller.repeat();
  }

  void _updateFishPositions() {
    setState(() {
      for (var fish in fishList) {
        fish.position = Offset(
          (fish.position.dx + (random.nextDouble() - 0.5) * fish.speed)
              .clamp(0, 300),
          (fish.position.dy + (random.nextDouble() - 0.5) * fish.speed)
              .clamp(0, 300),
        );
      }
    });
  }

  void _addFish() {
    if (fishList.length < 10) {
      setState(() {
        fishList.add(Fish(
          color: selectedColor,
          speed: selectedSpeed,
          position: Offset(random.nextDouble() * 300, random.nextDouble() * 300),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Virtual Aquarium')),
      body: Column(
        children: [
          Container(
            width: 400,
            height: 800,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Stack(
              children: fishList
                  .map((fish) => Positioned(
                left: fish.position.dx,
                top: fish.position.dy,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: fish.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
          ElevatedButton(onPressed: _addFish, child: Text('Add Fish')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
