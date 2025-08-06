import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Interactive Rotating Cube')),
        body: const Center(child: CubeControlPanel()),
      ),
    );
  }
}

class CubeControlPanel extends StatefulWidget {
  const CubeControlPanel({super.key});

  @override
  State<CubeControlPanel> createState() => _CubeControlPanelState();
}

class _CubeControlPanelState extends State<CubeControlPanel> {
  double cubeSize = 50.0;
  double rotateX = 0.0;
  double rotateY = 0.0;

  void increaseSize() {
    setState(() {
      cubeSize = (cubeSize + 10.0).clamp(20.0, 200.0);
    });
  }

  void decreaseSize() {
    setState(() {
      cubeSize = (cubeSize - 10.0).clamp(20.0, 200.0);
    });
  }

  void resetSize() {
    setState(() {
      cubeSize = 50.0;
      rotateX = 0.0;
      rotateY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300.0,
          height: 300.0,
          child: ClipRect(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  rotateY += details.delta.dx * 0.01;
                  rotateX -= details.delta.dy * 0.01;
                });
              },
              child: RepaintBoundary(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Colors.black12,
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.004) // Increased perspective
                          ..rotateX(rotateX)
                          ..rotateY(rotateY),
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            CubeFace(
                              transform: Matrix4.identity(),
                              color: Colors.blue.withOpacity(0.2), // Front
                              size: cubeSize,
                            ),
                            CubeFace(
                              transform: Matrix4.identity()..translate(0.0, 0.0, cubeSize),
                              color: Colors.red.withOpacity(0.2), // Back
                              size: cubeSize,
                            ),
                            CubeFace(
                              transform: Matrix4.identity()
                                ..translate(-cubeSize / 2, 0.0, cubeSize / 2)
                                ..rotateY(-pi / 2),
                              color: Colors.green.withOpacity(0.2), // Left
                              size: cubeSize,
                            ),
                            CubeFace(
                              transform: Matrix4.identity()
                                ..translate(cubeSize / 2, 0.0, cubeSize / 2)
                                ..rotateY(pi / 2),
                              color: Colors.yellow.withOpacity(0.2), // Right
                              size: cubeSize,
                            ),
                            CubeFace(
                              transform: Matrix4.identity()
                                ..translate(0.0, -cubeSize / 2, cubeSize / 2)
                                ..rotateX(pi / 2),
                              color: Colors.purple.withOpacity(0.2), // Top
                              size: cubeSize,
                            ),
                            CubeFace(
                              transform: Matrix4.identity()
                                ..translate(0.0, cubeSize / 2, cubeSize / 2)
                                ..rotateX(-pi / 2),
                              color: Colors.orange.withOpacity(0.2), // Bottom
                              size: cubeSize,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 3.0,
                      height: 3.0,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: increaseSize, child: const Text('+')),
            const SizedBox(width: 10),
            ElevatedButton(onPressed: decreaseSize, child: const Text('-')),
            const SizedBox(width: 10),
            ElevatedButton(onPressed: resetSize, child: const Text('=')),
          ],
        ),
      ],
    );
  }
}

class CubeFace extends StatelessWidget {
  final Matrix4 transform;
  final Color color;
  final double size;

  const CubeFace({
    super.key,
    required this.transform,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 1.0),
        ),
      ),
    );
  }
}
