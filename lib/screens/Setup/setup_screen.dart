import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  bool isLoading = false;

  Future<void> cameraInit() async {
    try {
      setState(() {
        isLoading = true;
      });

      final cameras = await availableCameras();
      final cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
      );
      await cameraController.initialize();

      setState(() {
        isLoading = false;
      });

      // Pass cameraController to the next screen
      Navigator.pushNamed(context, '/home', arguments: {
        'cameraController': cameraController,
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error initializing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset(
              'assets/cam-svg.svg',
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: cameraInit, // Trigger camera initialization
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera),
                  SizedBox(width: 10),
                  Text("Initialize your camera"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (isLoading) const LinearProgressIndicator(), // Show loading
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
