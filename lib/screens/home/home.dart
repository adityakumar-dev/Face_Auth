import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<void> initCameraSetup;
  late CameraController cameraController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      final ct = ModalRoute.of(context)!.settings.arguments as Map;
      print("value of ct is : $ct");
      cameraController = ct['cameraController'] as CameraController;
      initCameraSetup = cameraController.initialize();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: initCameraWidget(
              initCameraSetup: initCameraSetup,
              cameraController: cameraController,
            ),
          ),
        ],
      ),
    );
  }
}

class initCameraWidget extends StatelessWidget {
  const initCameraWidget({
    super.key,
    required this.initCameraSetup,
    required this.cameraController,
  });

  final Future<void> initCameraSetup;
  final CameraController cameraController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initCameraSetup,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(cameraController);
        } else if (snapshot.hasError) {
          return Text("Snapshot error: ${snapshot.error}");
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
