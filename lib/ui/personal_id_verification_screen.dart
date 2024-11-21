import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mlkit_test/api/api_ekyc.dart';
import 'package:mlkit_test/api/models/ekyc/ekyc_real.dart';
import 'package:mlkit_test/common/view_config.dart';
import 'package:mlkit_test/common/view_config_vm.dart';
import 'package:mlkit_test/ui/home_screen.dart';
import 'package:mlkit_test/ui/widget/menu_button.dart';
import 'package:mlkit_test/util/cropper_service.dart';

class PersonalIdVerificationScreen extends ConsumerStatefulWidget {
  final String imagePath;
  const PersonalIdVerificationScreen({
    super.key,
    required this.imagePath,
  });

  @override
  ConsumerState<PersonalIdVerificationScreen> createState() =>
      _PersonalIdVerificationScreenState();
}

class _PersonalIdVerificationScreenState
    extends ConsumerState<PersonalIdVerificationScreen> {
  late Future<EKYCReal> ekycRealModel;

  String cropPath = "";

  void onTryAgainPressed(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void gotoMain(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }

  @override
  void initState() {
    super.initState();

    final path = ref.read(viewConfigProvider).idPath;
    final token = ref.read(viewConfigProvider).token;
    ekycRealModel = ApiEkyc.getEKYCReal(path, token);
  }

  Future<void> _cropImage(String path, List<dynamic> rect) async {
    final file = await CropperService.cropImageFile(path, rect);
    setState(() {
      cropPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 93),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Image.asset('assets/images/seeu_logo.png'),
            ),
            const SizedBox(
              height: 42,
            ),
            const Text(
              "ID Authenticity Verification Result",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff444444),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 31,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 207,
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
              ),
              child: FutureBuilder(
                  future: ekycRealModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (cropPath == "") {
                        _cropImage(
                          ref.read(viewConfigProvider).idPath,
                          snapshot.data!.detectModel.bbox,
                        );
                      }
                      return cropPath == ""
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : Image.file(File(cropPath));
                    }
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }),
            ),
            const SizedBox(
              height: 33,
            ),
            Container(
              padding: const EdgeInsets.all(30),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: const Color(0xFFFFC92F)),
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF7F7F7),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "ID Type",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF646464),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            FutureBuilder(
                              future: ekycRealModel,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    IdType
                                        .values[snapshot.data!.detectModel.cls]
                                        .code,
                                    style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF161616),
                                    ),
                                  );
                                }
                                return const Text(
                                  "--",
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF161616),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "ID Verification Value",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF646464),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            FutureBuilder(
                                future: ekycRealModel,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      (snapshot.data!.detectModel.conf)
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF161616),
                                      ),
                                    );
                                  }
                                  return const Text(
                                    "0.00",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF161616),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 29,
                  ),
                  FutureBuilder(
                    future: ekycRealModel,
                    builder: (context, snapshot) {
                      var real = false;
                      var score = "0.00";
                      if (snapshot.hasData) {
                        real = snapshot.data!.score > snapshot.data!.threshold;
                        score = ((snapshot.data!.score * 100).floor() / 100.0)
                            .toStringAsFixed(2);
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "ID Authenticity",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF646464),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  real
                                      ? Authenticity.original.code
                                      : Authenticity.replica.code,
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF161616),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "ID Authenticity Value",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF646464),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  score,
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF161616),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: MenuButonWidget(
                    title: "Try Again",
                    textColor: const Color(0xFFFFFFFF),
                    backgoundColor: const Color(0xFFD2D2D2),
                    boxWidth: MediaQuery.of(context).size.width,
                    boxHeight: 55,
                    boxRadius: 6,
                    onPressed: () => onTryAgainPressed(context),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: MenuButonWidget(
                    title: "Main Menu",
                    textColor: const Color(0xFF121212),
                    backgoundColor: const Color(0xffFFC92F),
                    boxWidth: MediaQuery.of(context).size.width,
                    boxHeight: 55,
                    boxRadius: 6,
                    onPressed: () => gotoMain(context),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
