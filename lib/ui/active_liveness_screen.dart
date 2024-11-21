import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mlkit_test/common/view_config_vm.dart';
import 'package:mlkit_test/constants/action_model.dart';
import 'package:mlkit_test/ui/verification_result_screen.dart';
import 'package:mlkit_test/util/face_inspection.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:vibration/vibration.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:path_provider/path_provider.dart';

class ActiveLivenessScreen extends ConsumerStatefulWidget {
  const ActiveLivenessScreen({super.key});

  @override
  ConsumerState<ActiveLivenessScreen> createState() =>
      _ActiveLivenessScreenState();
}

class _ActiveLivenessScreenState extends ConsumerState<ActiveLivenessScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  ActionModel actionModel = ActionModel();
  CameraController? _cameraController;
  bool _hasPermission = false;
  final bool _isSelfieMode = true;
  var selectedCamera;
  // late final bool _noCamera = kDebugMode && Platform.isIOS;
  final _noCamera = false;
  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };
  final FaceDetector _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    // enableLandmarks: true,
    // enableTracking: true,
  ));

  late ActionModels actionModels;
  bool actionBool = false;
  bool isWaiting = false;
  String orderString = "";
  String faceAsset = 'assets/apngs/faceScan.png';
  int failCount = 0;
  final failTotal = 3;
  int succesCount = 0;
  final successTotal = 3;
  bool isFirst = true;

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 5,
    ),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    // final camera = _cameras[_cameraIndex];
    final sensorOrientation = selectedCamera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_cameraController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (selectedCamera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation!);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  // final

  Future<void> _doDetect(CameraImage cameraImage) async {
    onDetect = false;
    var inputImage = _inputImageFromCameraImage(cameraImage);

    print("_doDetect");
    if (inputImage != null) {
      final faces = await _faceDetector.processImage(inputImage);
      if (faces.length > 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            showCloseIcon: true,
            content: Text(
              "Multiple Face detection!",
            ),
          ),
        );
        failCount == 3;
        _failCountUp();
      }
      if (faces.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            showCloseIcon: true,
            content: Text(
              "Face has disappeared!",
            ),
          ),
        );
        failCount == 3;
        _failCountUp();
      }
      for (var face in faces) {
        var result = FaceInspection.isFacialExpression(face, actionModels.list);
        if (result) {
          _successCountUp();
          setNextAction();

          final xFile = await _cameraController!.takePicture();
          ref.read(viewConfigProvider.notifier).setRealPath(xFile.path);
          break;
        } else {
          onDetect = true;
        }
        inputImage = null;
      }
    } else {
      print("inputImage is null");
    }
  }

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

  bool onDetect = true;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    selectedCamera = cameras[_isSelfieMode ? 1 : 0];

    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888, // for iOS
    );

    await _cameraController?.initialize();
    await _cameraController?.prepareForVideoRecording(); // only ios
    _cameraController!.startImageStream((image) {
      if (onDetect) {
        _doDetect(image);
      }
    });
    if (_cameraController != null) {
      // _flashMode = _cameraController!.value.flashMode;
      // _minZoom = await _cameraController!.getMinZoomLevel();
      setState(() {});
    }
  }

  void _failCountUp() {
    failCount++;
    faceAsset = "assets/images/fail.png";
    if (failCount >= 3) {
      ref.read(viewConfigProvider.notifier).setLivenessResult(false);
      _gotoResultScreen();
    } else {
      setState(() {});
      setNextAction();
    }
  }

  void _successCountUp() {
    Vibration.vibrate(duration: 300);
    succesCount++;
    faceAsset = "assets/images/success.png";
    if (succesCount >= successTotal) {
      ref.read(viewConfigProvider.notifier).setLivenessResult(true);
      _gotoResultScreen();
    } else {
      setState(() {});
    }
  }

  void _gotoResultScreen() {
    // _cameraController?.dispose();
    _cameraController?.stopImageStream();
    onDetect = false;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const VerificationResultScreen(),
    ));
  }

  Future<void> setNextAction() async {
    _progressAnimationController.value = 1.0;
    _progressAnimationController.reverse();
    if (isFirst) {
      actionModels = ActionModels.frontal;
      orderString = "Please look at the camera";
    } else {
      actionModels = actionModel.randomAction();
      orderString = actionModel.orderString();
    }
    print("actionModels.name ${actionModels.name}");
    // 'assets/apngs/faceScan.png'
    setState(() {});
    Future.delayed(const Duration(seconds: 1));

    if (isFirst) {
      isFirst = false;
      faceAsset = "assets/apngs/faceScan.png"; // 'assets/apngs/faceScan.png'
    } else {
      faceAsset =
          "assets/apngs/${actionModels.name}.png"; // 'assets/apngs/faceScan.png'
    }

    onDetect = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    onDetect = true;
    setNextAction();

    // if (!_noCamera) {
    //   initPermission();
    // } else {
    //   _hasPermission = true;
    // }
    initCamera();

    WidgetsBinding.instance.addObserver(this);
    _progressAnimationController.addListener(() {
      if (_progressAnimationController.value <= 0.0) {
        orderString = "Time Out!!";
        onDetect = false;
        _failCountUp();
        setNextAction();
      }
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });
  }

  @override
  void dispose() {
    onDetect = false;
    _faceDetector.close();
    _progressAnimationController.dispose();
    if (!_noCamera) _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_noCamera) return;
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

  void _startProgess() {
    _progressAnimationController.forward();
  }

  void _onLogoPressed(BuildContext context) {
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => const VerificationResultScreen(),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    final circleWidth = MediaQuery.of(context).size.width - 70;
    final screenHeight = MediaQuery.of(context).size.height;
    var scale = 0.0;
    bool init = false;
    if (_cameraController != null &&
        _cameraController!.value.previewSize != null) {
      scale = 1 /
          (_cameraController!.value.aspectRatio *
              MediaQuery.of(context).size.aspectRatio);
      init = !_noCamera && _cameraController!.value.isInitialized;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (init)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Transform.scale(
                scaleX: scale,
                child: _cameraController != null
                    ? CameraPreview(
                        _cameraController!,
                      )
                    : Container(),
              ),
            ),
          WidgetMask(
            childSaveLayer: true,
            blendMode: BlendMode.dstOut,
            mask: Center(
              child: Container(
                width: circleWidth,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green),
              ),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          Center(
            child: CircularPercentIndicator(
              radius: circleWidth / 2 + (2.5),
              lineWidth: 5.0,
              percent: _progressAnimationController.value,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: const Color(0xff5FBA5D),
              backgroundColor: Colors.transparent,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 85, left: 90, right: 90),
            alignment: Alignment.bottomCenter,
            child: StepProgressIndicator(
              totalSteps: 3,
              size: 7.18,
              padding: 8.7,
              currentStep: succesCount,
              selectedColor: const Color(0xFF5FBA5D),
              unselectedColor: const Color(0xff626262),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                top: (screenHeight / 2) - (circleWidth / 2) - 135),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  faceAsset,
                  width: 78,
                  height: 78,
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Image.asset(
                      "assets/images/polygon.png",
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 29, vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        orderString,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF414141),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
