import 'dart:math';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceInspection {
  static var actionMin = [-10.0, -10.0, -10.0, 0.2, 0.5, 0.9];
  static var actionMax = [10.0, 10.0, 10.0, 0.6, 1.0, 1.1];
  static var successCount = 0;
  static const successLimit = 5;

  static bool isFacialExpression(Face face, List<int> orderAction) {
    var watchAction = [-1, -1, -1, -1, -1, -1];
    watchAction = _xyz(orderAction, watchAction, face);
    watchAction = _eye(orderAction, watchAction, face);
    watchAction = _mouse(orderAction, watchAction, face);

    for (var i = 0; i < watchAction.length; i++) {
      if (watchAction[i] != orderAction[i]) {
        successCount = 0;
        return false;
      }
    }
    successCount++;
    if (successCount > successLimit) {
      return true;
    }
    return false;
  }

  static List<int> _xyz(
    List<int> orderAction,
    List<int> watchAction,
    Face face,
  ) {
    var action = watchAction;
    final rotX = face.headEulerAngleX ?? 0.0;
    final rotY = face.headEulerAngleY ?? 0.0;
    final rotZ = face.headEulerAngleZ ?? 0.0;
    if (orderAction[0] == -1) {
      action[0] = -1;
    } else if (rotX > actionMax[0]) {
      action[0] = 2;
    } else if (rotX < actionMin[0]) {
      action[0] = 1;
    } else {
      action[0] = 0;
    }

    if (orderAction[1] == -1) {
      action[1] = -1;
    } else if (rotY > actionMax[1]) {
      action[1] = 1;
    } else if (rotY < actionMin[1]) {
      action[1] = 2;
    } else {
      action[1] = 0;
    }

    if (orderAction[2] == -1) {
      action[2] = -1;
    } else if (rotZ > actionMax[2]) {
      action[2] = 2;
    } else if (rotZ < actionMin[2]) {
      action[2] = 1;
    } else {
      action[2] = 0;
    }

    return action;
  }

  static List<int> _eye(
    List<int> orderAction,
    List<int> watchAction,
    Face face,
  ) {
    var action = watchAction;
    if (orderAction[3] == -1) {
      action[3] = -1;
      return action;
    }
    var left = -1;
    final leftEyeOpen = face.leftEyeOpenProbability ?? 0.0;
    if (leftEyeOpen > actionMax[3]) {
      left = 0;
    } else {
      left = 1;
    }

    var right = -1;
    final rightEyeOpen = face.rightEyeOpenProbability ?? 0.0;
    if (rightEyeOpen > actionMax[3]) {
      right = 0;
    } else {
      right = 1;
    }

    if (left == 1 || right == 1) {
      action[3] = 1;
    } else {
      action[3] = 0;
    }

    return action;
  }

  static List<int> _mouse(
    List<int> orderAction,
    List<int> watchAction,
    Face face,
  ) {
    var action = watchAction;
    if (orderAction[4] == -1) {
      action[4] = -1;
      return action;
    }

    List<Point<int>>? upperLipTop;
    List<Point<int>>? upperLipBottom;
    List<Point<int>>? lowerLipTop;
    for (var contour in face.contours.entries) {
      if (contour.key == FaceContourType.upperLipTop) {
        upperLipTop = contour.value?.points;
      }
      if (contour.key == FaceContourType.upperLipBottom) {
        upperLipBottom = contour.value?.points;
      }
      if (contour.key == FaceContourType.lowerLipTop) {
        lowerLipTop = contour.value?.points;
      }
    }

    if (upperLipTop != null && upperLipBottom != null) {
      final mouseOpenHeight = distanceSQRT(upperLipBottom[4], lowerLipTop![4]);
      final upperLipThickness = distanceSQRT(upperLipTop[4], upperLipBottom[4]);
      final openRadio = mouseOpenHeight / upperLipThickness;
      final smileRadio =
          distanceP3(upperLipTop[0], upperLipTop[8], upperLipTop[5]) /
              upperLipThickness;
      if (smileRadio < actionMin[4]) {
        action[4] = 2;
      }
      if (openRadio > actionMax[4]) {
        action[4] = 1;
      }
      return action;
    } else {
      action[4] = -1;
      return action;
    }
  }

  static double distanceSQRT(Point p0, Point p1) {
    return sqrt(
        ((p0.x - p1.x) * (p0.x - p1.x) + (p0.y - p1.y) * (p0.y - p1.y)));
  }

  static double distanceP3(Point p0, Point p1, Point p) {
    final a = (p1.y - p0.y) / (p1.x - p0.x); //    1. a 직선의 기울기를 먼저 구하자.
    final r = p0.y - a * p0.x; //    2. r 을 구하자.
    return ((a * p.x - p.y + r) / sqrt(a * a + 1)).abs();
  }
}
