import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mlkit_test/api/api_ekyc.dart';
import 'package:mlkit_test/common/view_config.dart';
import 'package:mlkit_test/common/view_config_vm.dart';
import 'package:mlkit_test/constants/gaps.dart';
import 'package:mlkit_test/ui/prepare_id_screen.dart';
import 'package:mlkit_test/ui/prepare_liveness_screen.dart';
import 'package:mlkit_test/ui/widget/menu_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _personalIdentityVerification(BuildContext context, WidgetRef ref) {
    ref.read(viewConfigProvider.notifier).setViewMode(ViewMode.identity);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrepareIdScreen(),
      ),
    );
  }

  void _ocrIDVerification(BuildContext context, WidgetRef ref) {
    ref.read(viewConfigProvider.notifier).setViewMode(ViewMode.ocr);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrepareIdScreen(),
      ),
    );
  }

  void _faceRecognitionLiveness(BuildContext context, WidgetRef ref) {
    ref.read(viewConfigProvider.notifier).setViewMode(ViewMode.liveness);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrepareLivenessScreen(),
      ),
    );
  }

  void _livenessFaceMatching(BuildContext context, WidgetRef ref) {
    ref.read(viewConfigProvider.notifier).setViewMode(ViewMode.liveness);
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => const PrepareIdScreen(),
        builder: (context) => const PrepareLivenessScreen(),
      ),
    );
  }

  void _completeService(BuildContext context, WidgetRef ref) {
    ref.read(viewConfigProvider.notifier).setViewMode(ViewMode.full);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrepareIdScreen(),
      ),
    );
  }

  void _getToken(BuildContext context, WidgetRef ref) {
    ApiEkyc.ekycToken().then(
        (value) => ref.read(viewConfigProvider.notifier).setToken(value.token));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _getToken(context, ref);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 93),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.v64,
            const Text(
              "eKYC Service",
              style: TextStyle(
                fontSize: 37,
                color: Color(0xff0E0E0E),
                fontWeight: FontWeight.w500,
              ),
            ),
            Gaps.v60,
            MenuButonWidget(
              title: "Personal Identity Verification",
              textColor: const Color(0xff2f2f2f),
              backgoundColor: const Color(0xffeeeeee),
              boxWidth: MediaQuery.of(context).size.width - 90,
              boxHeight: 55,
              boxRadius: 6,
              // onPressed: () => _personalIdentityVerification(context, ref),
              onPressed: () {},
            ),
            Gaps.v32,
            MenuButonWidget(
              title: "OCR ID Verification",
              textColor: const Color(0xff2f2f2f),
              backgoundColor: const Color(0xffeeeeee),
              boxWidth: MediaQuery.of(context).size.width - 90,
              boxHeight: 55,
              boxRadius: 6,
              // onPressed: () => _ocrIDVerification(context, ref),
              onPressed: () {},
            ),
            Gaps.v32,
            MenuButonWidget(
              title: "Face Recognition: Liveness",
              textColor: const Color(0xff000000),
              backgoundColor: const Color(0xffeeeeee),
              boxWidth: MediaQuery.of(context).size.width - 90,
              boxHeight: 55,
              boxRadius: 6,
              // onPressed: () => _faceRecognitionLiveness(context, ref),
              onPressed: () {},
            ),
            Gaps.v32,
            MenuButonWidget(
              title: "Liveness",
              textColor: const Color(0xff2f2f2f),
              backgoundColor: const Color(0xffFFC92F),
              boxWidth: MediaQuery.of(context).size.width - 90,
              boxHeight: 55,
              boxRadius: 6,
              onPressed: () => _livenessFaceMatching(context, ref),
            ),
            Expanded(child: Container()),
            MenuButonWidget(
              title: "Complete Service",
              textColor: const Color(0xFF000000),
              backgoundColor: const Color(0xffeeeeee),
              boxWidth: MediaQuery.of(context).size.width,
              boxHeight: 55,
              boxRadius: 6,
              // onPressed: () => _completeService(context, ref),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: const Color(0xffeeeeee),
        ),
        child: const Center(
          child: Text(
            "Personal Identity Verification",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff2F2F2F),
            ),
          ),
        ),
      ),
    );
  }
}
