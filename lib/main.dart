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
  double cubeSize = 50.0; // Start with smaller cube
  double rotateX = 0.0;
  double rotateY = 0.0;

  void increaseSize() {
    setState(() {
      cubeSize = (cubeSize + 10.0).clamp(20.0, 200.0); // Limit max size
    });
  }

  void decreaseSize() {
    setState(() {
      cubeSize = (cubeSize - 10.0).clamp(20.0, 200.0); // Limit min size
    });
  }

  void resetSize() {
    setState(() {
      cubeSize = 50.0; // Reset to initial size
      rotateX = 0.0;  // Reset rotation X
      rotateY = 0.0;  // Reset rotation Y
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300.0, // Fixed large square size
          height: 300.0, // Fixed large square size
          child: ClipRect(
            child: GestureDetector(
              onPanUpdate: (details) {
                if (details.localPosition.dx >= 0 &&
                    details.localPosition.dx <= 300 &&
                    details.localPosition.dy >= 0 &&
                    details.localPosition.dy <= 300) {
                  setState(() {
                    rotateY += details.delta.dx * 0.01;
                    rotateX -= details.delta.dy * 0.01; // Invert Y for natural feel
                  });
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.black12,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002) // Perspective
                        ..rotateX(rotateX)
                        ..rotateY(rotateY),
                      alignment: Alignment(0.0, 0.0), // Centered on dot (adjust if needed)
                      // Alternative alignment based on your request: Alignment(2 / cubeSize, 2 / cubeSize) if offset intended
                      child: Stack(
                        children: [
                          // Front face (centered on dot)
                          Transform(
                            transform: Matrix4.identity(),
                            alignment: Alignment.center,
                            child: Container(
                              width: cubeSize,
                              height: cubeSize,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.black, width: 1.0),
                              ),
                            ),
                          ),
                          // Back face
                          Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0, cubeSize),
                            alignment: Alignment.center,
                            child: Container(
                              width: cubeSize,
                              height: cubeSize,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.black, width: 1.0),
                              ),
                            ),
                          ),
                          // Left face
                          Transform(
                            transform: Matrix4.identity()
                              ..translate(-cubeSize / 2, 0.0, cubeSize / 2)
                              ..rotateY(-pi / 2),
                            alignment: Alignment.center,
                            child: Container(
                              width: cubeSize,
                              height: cubeSize,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.black, width: 1.0),
                              ),
                            ),
                          ),
                          // Right face
                          Transform(
                            transform: Matrix4.identity()
                              ..translate(cubeSize / 2, 0.0, cubeSize / 2)
                              ..rotateY(pi / 2),
                            alignment: Alignment.center,
                            child: Container(
                              width: cubeSize,
                              height: cubeSize,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.black, width: 1.0),
                              ),
                            ),
                          ),
                          // Top face
                          Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, -cubeSize / 2, cubeSize / 2)
                              ..rotateX(pi / 2),
                            alignment: Alignment.center,
                            child: Container(
                              width: cubeSize,
                              height: cubeSize,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.black, width: 1.0),
                              ),
                            ),
                          ),
                          // Bottom face
                          Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, cubeSize / 2, cubeSize / 2)
                              ..rotateX(-pi / 2),
                            alignment: Alignment.center,
                            child: Container(
                              width: cubeSize,
                              height: cubeSize,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.black, width: 1.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Dot in the middle
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
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: increaseSize,
              child: const Text('+'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: decreaseSize,
              child: const Text('-'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: resetSize,
              child: const Text('='),
            ),
          ],
        ),
      ],
    );
  }
}