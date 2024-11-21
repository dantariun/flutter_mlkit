import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mlkit_test/api/api_ekyc.dart';
import 'package:mlkit_test/api/models/ekyc/ekyc_verification.dart';
import 'package:mlkit_test/common/view_config.dart';
import 'package:mlkit_test/common/view_config_vm.dart';
import 'package:mlkit_test/ui/home_screen.dart';
import 'package:mlkit_test/ui/widget/menu_button.dart';

class VerificationResultScreen extends ConsumerStatefulWidget {
  const VerificationResultScreen({super.key});

  @override
  ConsumerState<VerificationResultScreen> createState() =>
      _VerificationResultScreenState();
}

class _VerificationResultScreenState
    extends ConsumerState<VerificationResultScreen> {
  late Future<EKYCVerification> verificationModel;
  late final String idPath;
  late final String realPath;

  @override
  void initState() {
    super.initState();

    if (ref.read(viewConfigProvider).viewMode == ViewMode.liveness.code) {
      // idPath = ref.read(viewConfigProvider).idPath;
      realPath = ref.read(viewConfigProvider).realPath;
      // final token = ref.read(viewConfigProvider).token;

      // verificationModel = ApiEkyc.ekycVerification(idPath, realPath, token);
    }
  }

  void _onMainMenuPressed(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final viewmode = ViewMode.getByCode(ref.watch(viewConfigProvider).viewMode);
    final isAvailable = viewmode == ViewMode.liveness;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 113),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 145,
            ),
            const SizedBox(
              height: 31.68,
            ),
            const Text(
              "Liveness Result",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w300,
                color: Color(0xFF000000),
              ),
            ),
            ref.read(viewConfigProvider).viewMode == ViewMode.liveness.code
                ? Text(
                    ref.read(viewConfigProvider).resultBool
                        ? "Success"
                        : "Fail",
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ))
                : FutureBuilder(
                    future: verificationModel,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final result =
                            snapshot.data!.score > snapshot.data!.threshold;
                        return Text(
                          result ? "Success" : "Fail",
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF000000),
                          ),
                        );
                      }
                      return const Text(
                        "--",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                        ),
                      );
                    },
                  ),
            const SizedBox(
              height: 14,
            ),
            if (isAvailable)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 134,
                        height: 143,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD9D9D9),
                        ),
                        child: Image.file(
                          File(realPath),
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text(
                  //       "Score",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w400,
                  //         color: Color(0xFF5F5F5F),
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 32,
                  //     ),
                  //     FutureBuilder(
                  //       future: verificationModel,
                  //       builder: (context, snapshot) {
                  //         if (snapshot.hasData) {
                  //           return Text(
                  //             ((snapshot.data!.score * 100).floor() / 100.0)
                  //                 .toStringAsFixed(2),
                  //             style: const TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w600,
                  //               color: Color(0xFF5F5F5F),
                  //             ),
                  //           );
                  //         }
                  //         return const Text(
                  //           "0.0",
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w600,
                  //             color: Color(0xFF5F5F5F),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            Expanded(child: Container()),
            MenuButonWidget(
              title: "Main Menu",
              textColor: const Color(0xFF000000),
              backgoundColor: const Color(0xFFDDDDDD),
              boxWidth: MediaQuery.of(context).size.width,
              boxHeight: 55,
              boxRadius: 6,
              onPressed: () => _onMainMenuPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}
