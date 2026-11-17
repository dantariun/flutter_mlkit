# flutter_mlkit

Flutter 기반 eKYC(전자 신원확인) 모바일 앱. 신분증 OCR 인식과 얼굴 활성화 감지(Active Liveness)를 통해 비대면 본인 인증 플로우를 구현한다.

## Stack

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B)
![Riverpod](https://img.shields.io/badge/State-Riverpod-blue)
![ML Kit](https://img.shields.io/badge/ML-Camera_ML_Kit-orange)

- **UI**: Flutter
- **상태 관리**: flutter_riverpod
- **카메라**: expo-camera (flutter camera 패키지)
- **API 통신**: http
- **미디어**: video_player, gallery_saver
- **권한**: permission_handler

## 화면 구성

```
홈 → 신분증 촬영 준비 → 신분증 촬영 → OCR 결과
   → 얼굴 인증 준비 → Active Liveness → 인증 결과
```

| 화면 | 파일 | 설명 |
|------|------|------|
| 홈 | home_screen.dart | 메뉴 선택 |
| 신분증 촬영 | get_id_camera_screen.dart | 신분증 프레임 가이드 + 촬영 |
| OCR 결과 | ocr_id_screen.dart | 텍스트 인식 결과 표시 |
| 얼굴 인증 준비 | prepare_liveness_screen.dart | 가이드 애니메이션 |
| Active Liveness | active_liveness_screen.dart | 고개 방향 지시 + 감지 |
| 검증 결과 | verification_result_screen.dart | 최종 인증 성공/실패 |

## 주요 기능

- **신분증 OCR**: 카메라로 신분증 촬영 → 텍스트 추출 → 위변조 판별
- **Active Liveness**: 상/하/좌/우 고개 방향 지시에 따른 얼굴 동작 감지로 실물 여부 확인
- **얼굴 인식(FRS)**: 신분증 사진과 셀피 얼굴 비교
- **단계별 검증 UI**: `StepIndicator` 위젯으로 현재 단계 시각화

## API 연동

```
lib/api/
├── api_ekyc.dart        # 신분증 OCR + 위변조 검증
├── api_service_id.dart  # 신분증 텍스트 추출
└── api_servide_frs.dart # 얼굴 인식(FRS) API
```

API 엔드포인트는 `lib/common/view_config.dart`에서 설정.

## 시작하기

```bash
flutter pub get
flutter run
```

**요구사항**: Flutter 3.x 이상, iOS/Android 카메라 권한 설정 필요

```
# iOS: Info.plist
NSCameraUsageDescription
NSPhotoLibraryUsageDescription

# Android: AndroidManifest.xml
<uses-permission android:name="android.permission.CAMERA" />
```

## 주의사항

- 실제 eKYC API 서버 연동이 필요하다. `view_config.dart`의 BASE_URL을 설정해야 동작한다.
- `assets/apngs/`의 얼굴 방향 가이드 이미지(anyEyeClose, leftRotate 등)는 liveness 단계별 안내에 사용된다.
