import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image/image.dart' as img;
import 'package:matrix_gesture_detector_pro/matrix_gesture_detector_pro.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/constants.dart';
import '../components/draggable_image.dart';

class CameraScreen extends StatefulWidget {
  final String? imagePath;
  final File? imageData;

  const CameraScreen({super.key, this.imagePath, this.imageData});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  CameraController? cameraController;
  Offset containerPosition = const Offset(0, 0);
  double _opacityValue = 0.5;
  bool isColored = false;
  bool isFlash = false;
  bool isLocked = false;
  bool isFlipped = false;
  dynamic _lineArtImage;
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    startCamera();
  }

  double height(double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double width(double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  void startCamera() async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    await cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) async {
      var status = await Permission.camera.status;
      Permission.camera.onDeniedCallback(() => Navigator.pop(context));
      Permission.camera.onPermanentlyDeniedCallback(() => Navigator.pop(context));
      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Allow the camera permission")));
        Permission.camera.request();
      } else if(status.isPermanentlyDenied){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Allow the camera permission")));
       await Future.delayed(Duration(seconds: 2));
        openAppSettings();
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e)));
      }
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container(
        color: Colors.white,
        child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xff189EE9),
        )),
      );
    }
    return SafeArea(
      top: true,
      bottom: true,
      child: MatrixGestureDetector(
        shouldScale: isLocked ? false : true,
        shouldRotate: isLocked ? false : true,
        shouldTranslate: isLocked ? false : true,
        onMatrixUpdate: (m, tm, rm, sm) {
          notifier.value = m;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    RepaintBoundary(
                      key: key,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: double.infinity,
                            width: double.maxFinite,
                            child: CameraPreview(cameraController!),
                          ),
                          Opacity(
                              opacity: _opacityValue,
                              child: AnimatedBuilder(
                                animation: notifier,
                                builder: (ctx, child) {
                                  return Transform(
                                    transform: notifier.value,
                                    child: DraggableImage(
                                      widget: widget,
                                      isColored: isColored,
                                      isFlipped: isFlipped,
                                      lineArtImage: _lineArtImage,
                                    ),
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff189EE9),
                          shape: BoxShape.circle
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.imageData?.delete();
                          },
                          icon: const Icon(Icons.arrow_back_ios_sharp,color: Colors.white,)
                        ),
                      ),
                    ),
                    Positioned(
                        top: 20,//height(0.3),
                        right: 20,//width(0.04),
                        child: Container(
                       //   width: 250,//width(0.6),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: const Color(0xff189EE9).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            children: [
                              buildFilledButton(
                                  isFlash == false
                                      ? Icons.flash_off
                                      : Icons.flash_on,
                                  toggleTorch),
                              const SizedBox(
                                height: 10,
                              ),
                              buildFilledButton(Icons.flip_outlined, () {
                                setState(() {
                                  isFlipped = !isFlipped;
                                });
                              }),
                              const SizedBox(
                                height: 10,
                              ),
                              buildFilledButton(
                                isLocked == true
                                    ? Icons.lock
                                    : Icons.lock_open_sharp,
                                toggleLock,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                child: TextButton(
                                  onPressed: (){
                                    _convertToLineArt(context);
                                  },
                                  child: Image.asset(
                                    'assets/bg_remover_2.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              )
                              // buildFilledButton(Icons.flip_to_back_outlined, () {
                              //   _convertToLineArt(context);
                              // }),
                            ],
                          ),
                        )),
                    Positioned(
                      right: width(0.1),
                      left: width(0.1),
                      bottom: width(0.05),
                      child: opacitySlider(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Function Definition

  /// toggle torch
  void toggleTorch() async {
    if (isFlash) {
      await cameraController?.setFlashMode(FlashMode.off);
    } else {
      await cameraController?.setFlashMode(FlashMode.torch);
    }
    setState(() {
      isFlash = !isFlash;
    });
  }

  /// toggle lock
  void toggleLock() {
    setState(() {
      isLocked = !isLocked;
    });
  }

  ///  opacity slider
  SizedBox opacitySlider(BuildContext context) {
    return SizedBox(
      width: width(0.4),
      child: Container(
        height: height(0.07),
        decoration: BoxDecoration(
          color: Colors.white24,
          border: Border.all(
            color: const Color(0xff189EE9),
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Slider(
          min: 0.0,
          max: 1.0,
          value: _opacityValue,
          onChanged: (double value) {
            setState(() {
              _opacityValue = value;
            });
          },
        ),
      ),
    );
  }

  /// Filled button
  Padding buildFilledButton(IconData icon, Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size:25,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _convertToLineArt(BuildContext context) async {
    if (widget.imagePath != null) {
      setState(() {
        isColored = !isColored;
        isColored == true ? _opacityValue = 1 : _opacityValue = 0.5;
      });
    } else if (widget.imageData == null) {
      return;
    } else if (_lineArtImage != null) {
      setState(() {
        _lineArtImage = null;
        _opacityValue = 1;
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 50),
                Text('Convert Bitmap'),
              ],
            ),
          );
        },
      );

      await Future.delayed(const Duration(milliseconds: 200));
      final bytes = await widget.imageData!.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      final grayscaleImage = img.grayscale(originalImage!);
      final lineArtImage = img.sobel(grayscaleImage);
      final invertedImage = img.invert(lineArtImage);
      final newFile = File('${widget.imageData!.path}_lineArt.png');
      newFile.writeAsBytesSync(img.encodePng(invertedImage));


      _lineArtImage = newFile;
      _opacityValue = 0.4;

      if (context.mounted) {
        Navigator.of(context).pop();
      }
      setState(() {});
    }
  }
}
