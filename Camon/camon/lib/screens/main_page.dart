// import 'dart:math';

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
// import 'package:external_path/external_path.dart';
import 'package:media_scanner/media_scanner.dart';

class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainPage({super.key, required this.cameras});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CameraController cameraController;
  late Future<void> cameraValue;
  bool isFlashEnabled = false; // check if flash is enabled
  bool isRearCamera = true; // check if rear camera is enabled
  List<File> imagesList = []; // Storing image files as arrays

  // Saving file in downloads folder
  Future<File> saveImage(XFile image) async {
    final downloadpath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD); // Getting downloads directory path
    final filename =
        '${DateTime.now().millisecondsSinceEpoch}.png'; // Saving date, time and millisecond of file to avoid duplicates. Also saving file as png
    final file = File('$downloadpath/$filename');

    try {
      await file.writeAsBytes(await image.readAsBytes());
    } catch (e) {}
    return file;
  }

  // Method to capture images
  void takePicture() async {
    XFile? image;
    if (cameraController.value.isTakingPicture ||
        !cameraController.value.isInitialized) {
      return;
    }
    if (isFlashEnabled == false) {
      await cameraController.setFlashMode(FlashMode.off);
    } else {
      await cameraController
          .setFlashMode(FlashMode.torch); // using torch light as flash
    }
    image = await cameraController.takePicture();
    if (cameraController.value.flashMode == FlashMode.torch) {
      setState(() {
        cameraController.setFlashMode(
            FlashMode.off); // if flash light or torch is on, turn off
      });
    }

    final file = await saveImage(image);

    setState(() {
      imagesList.add(file);
    });

    MediaScanner.loadMedia(path: file.path); // loading image from path
  }

  void startCamera(int camera) {
    cameraController = CameraController(
        widget.cameras[camera], ResolutionPreset.high,
        enableAudio: false); // no audio flash
    cameraValue = cameraController.initialize();
  }

  @override
  void initState() {
    startCamera(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // Camera button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        shape: CircleBorder(),
        onPressed: takePicture, // action to capture image
        child: Icon(
          Icons.camera_alt,
          size: 40,
          color: Colors.black87,
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: CameraPreview(cameraController),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),

          //Camera Flash and Rear-Front Camera Switch Button
          SafeArea(
            child: Align(
              alignment:
                  Alignment.topRight, // buttons at top right corners of screen
              child: Padding(
                padding: EdgeInsets.only(right: 5, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gesture detection
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isRearCamera = !isRearCamera;
                        });
                        isRearCamera
                            ? startCamera(0)
                            : startCamera(
                                1); // If isRearCamera is false, the expression after the colon is executed, calling the startCamera function with an argument of 1
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(50, 0, 0, 0),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            isRearCamera
                                ? Icons.camera_rear // rear camera icon
                                : Icons.camera_front, // front camera icon
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFlashEnabled = !isFlashEnabled;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(50, 0, 0, 0),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            isFlashEnabled ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // List to show captured images
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.only(left: 7, bottom: 75),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: imagesList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                height: 100,
                                width: 100,
                                image: FileImage(
                                  imagesList[index],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
