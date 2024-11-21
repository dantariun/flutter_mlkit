// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mlkit_test/common/view_config.dart';
import 'package:mlkit_test/common/view_config_vm.dart';
import 'package:mlkit_test/ui/home_screen.dart';
import 'package:mlkit_test/ui/id_total_verification_screen.dart';
import 'package:mlkit_test/ui/ocr_id_screen.dart';
import 'package:mlkit_test/ui/personal_id_verification_screen.dart';
import 'package:mlkit_test/ui/prepare_liveness_screen.dart';
import 'package:mlkit_test/ui/widget/menu_button.dart';
import 'package:mlkit_test/util/cropper_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class GetIdCameraScreen extends ConsumerStatefulWidget {
  const GetIdCameraScreen({super.key});

  @override
  ConsumerState<GetIdCameraScreen> createState() => _GetIdCameraScreenState();
}

class _GetIdCameraScreenState extends ConsumerState<GetIdCameraScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _hasPermission = false;
  final bool _isSelfieMode = false;
  // late FlashMode _flashMode;
  // late double _minZoom;
  // late final bool _noCamera = kDebugMode && Platform.isIOS;

  final FaceDetector _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    // enableLandmarks: true,
    // enableTracking: true,
  ));

  Future<void> initPermission() async {
    final camearaPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();
    final cameraDenied =
        camearaPermission.isDenied || camearaPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      initCamera();
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }
    for (var camera in cameras) {
      print("camera lensDirection :  ${camera.lensDirection}");
      print("camera sensorOrientation : ${camera.sensorOrientation}");
      print("camera name : ${camera.name}");
    }

    _cameraController = CameraController(
        cameras[_isSelfieMode ? 1 : 0], ResolutionPreset.ultraHigh);

    await _cameraController?.initialize();
    await _cameraController?.prepareForVideoRecording(); // on
    if (_cameraController != null) {
      // _flashMode = _cameraController!.value.flashMode;
      // _minZoom = await _cameraController!.getMinZoomLevel();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // if (!_noCamera) {
    //   initPermission();
    // } else {
    //   _hasPermission = true;
    // }
    initCamera();
  }

  @override
  void dispose() {
    _faceDetector.close();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasPermission) return;
    if (_cameraController != null) {
      if (!_cameraController!.value.isInitialized) return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future<void> _onCapturePressed(BuildContext context, WidgetRef ref) async {
    final image = await _cameraController!.takePicture();

    final mode = ViewMode.getByCode(ref.watch(viewConfigProvider).viewMode);
    if (mode == ViewMode.full || mode == ViewMode.matching) {
      final InputImage inputImage = InputImage.fromFilePath(image.path);
      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isNotEmpty) {
        final largeFace = faces.reduce((value, element) =>
            value.boundingBox.width > element.boundingBox.width
                ? value
                : element);

        Rect rect = largeFace.boundingBox;
        final file = await CropperService.cropImageFile(
          image.path,
          [
            rect.left.toInt(),
            rect.top.toInt(),
            rect.right.toInt(),
            rect.bottom.toInt()
          ],
        );

        ref.read(viewConfigProvider.notifier).setIdPath(file.path);
      }
    } else if (mode == ViewMode.identity) {
      ref.read(viewConfigProvider.notifier).setIdPath(image.path);
    }

    switch (mode) {
      case ViewMode.full:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const IdTotalVerificationScreen(),
        ));
      case ViewMode.ocr:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const OcrIdScreen(),
        ));
      case ViewMode.liveness:
      case ViewMode.identity:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PersonalIdVerificationScreen(
            imagePath: image.path,
          ),
        ));
      case ViewMode.matching:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const PrepareLivenessScreen(),
        ));
      case ViewMode.etc:
    }
  }

  void _gotoMain(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    late final double cameraRatio;
    final size = MediaQuery.of(context).size;
    final deviceRatio = (size.width - 42) / 319;
    bool init = false;
    if (_cameraController != null) {
      init = _cameraController!.value.isInitialized;
      cameraRatio = deviceRatio * (_cameraController!.value.aspectRatio);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 13),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Image.asset('assets/images/seeu_logo.png'),
            ),
            const SizedBox(
              height: 42,
            ),
            const Text(
              "Capture ID Card",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff444444),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "For authentication purposes, capture your ID",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF828282),
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 27,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              clipBehavior: Clip.hardEdge,
              height: 319,
              decoration: const BoxDecoration(color: Color(0xffeeeeee)),
              child: init
                  ? Transform.scale(
                      scaleY: cameraRatio,
                      child: CameraPreview(_cameraController!),
                    )
                  : null,
            ),
            const SizedBox(
              height: 11,
            ),
            MenuButonWidget(
              title: "Capture",
              textColor: Colors.black,
              backgoundColor: const Color(0xffFFC92F),
              boxWidth: MediaQuery.of(context).size.width,
              boxHeight: 55,
              boxRadius: 6,
              onPressed: () => _onCapturePressed(context, ref),
            ),
            Expanded(child: Container()),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Checklist!",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF414141),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 18.65,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/circle_correct_gray.png'),
                const SizedBox(
                  width: 18.22,
                ),
                const Text(
                  "Please ensure the entire ID card is clearly visible",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(
                      0xFF555555,
                    ),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 11.29,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/circle_correct_gray.png'),
                const SizedBox(
                  width: 18.22,
                ),
                const Text(
                  "Please present the front face of the ID card ",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(
                      0xFF555555,
                    ),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 11.29,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/circle_correct_gray.png'),
                const SizedBox(
                  width: 18.22,
                ),
                const Text(
                  "Position the ID card on a well-lit surface. Dark\nbackgrounds may enhance recognition accuracy.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(
                      0xFF555555,
                    ),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 17,
            ),
            TextButton(
              onPressed: () => _gotoMain(context),
              child: const Text(
                "Return to Main Menu",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  color: Color(0xFF777777),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
