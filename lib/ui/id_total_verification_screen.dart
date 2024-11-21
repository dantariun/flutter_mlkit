import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mlkit_test/api/api_ekyc.dart';
import 'package:mlkit_test/api/models/ekyc/ekyc_real.dart';
import 'package:mlkit_test/common/view_config.dart';
import 'package:mlkit_test/common/view_config_vm.dart';
import 'package:mlkit_test/ui/home_screen.dart';
import 'package:mlkit_test/ui/temporarily_screen.dart';
import 'package:mlkit_test/ui/widget/menu_button.dart';

class IdTotalVerificationScreen extends ConsumerStatefulWidget {
  const IdTotalVerificationScreen({super.key});

  @override
  ConsumerState<IdTotalVerificationScreen> createState() =>
      _IdTotalVerificationScreenState();
}

class _IdTotalVerificationScreenState
    extends ConsumerState<IdTotalVerificationScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerNumber = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  late Future<EKYCReal> ekycRealModel;

  @override
  void initState() {
    super.initState();

    final path = ref.read(viewConfigProvider).idPath;
    final token = ref.read(viewConfigProvider).token;
    ekycRealModel = ApiEkyc.getEKYCReal(path, token);
    ApiEkyc.ekycOCRText(path, token).then((value) {
      for (var item in value.textModel) {
        if (item.type == "name") {
          _controllerName.value = TextEditingValue(text: item.text);
        }
        if (item.type == "resident_number") {
          _controllerNumber.value = TextEditingValue(text: item.text);
        }
        if (item.type == "issued_at") {
          _controllerDate.value = TextEditingValue(text: item.text);
        }
      }
    });
  }

  void _gotoMain(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }

  void _onTryAgainPressed(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void _onNextPressed(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const TemporarilyScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              "ID Card Verification",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff444444),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            const Text(
              "Please verify the information below.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF828282),
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              "Edit if needed.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF828282),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Name",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF646464),
                ),
              ),
            ),
            const SizedBox(
              height: 9,
            ),
            SizedBox(
              height: 50,
              child: TextField(
                controller: _controllerName,
                style: const TextStyle(color: Color(0xFF161616)),
                decoration: InputDecoration(
                    hintText: "First / Last Name",
                    hintStyle: const TextStyle(color: Color(0xFFADADAD)),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20)),
              ),
            ),
            const Spacer(),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "ID Number",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF646464),
                ),
              ),
            ),
            const SizedBox(
              height: 9,
            ),
            SizedBox(
              height: 50,
              child: TextField(
                controller: _controllerNumber,
                style: const TextStyle(
                    color: Color(0xFF161616), letterSpacing: 5.52),
                decoration: InputDecoration(
                    hintText: "1234567 - 0000000",
                    hintStyle: const TextStyle(color: Color(0xFFADADAD)),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20)),
              ),
            ),
            const Spacer(),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Date of Issuance",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF646464),
                ),
              ),
            ),
            const SizedBox(
              height: 9,
            ),
            SizedBox(
              height: 50,
              child: TextField(
                controller: _controllerDate,
                style: const TextStyle(
                    color: Color(0xFF161616), letterSpacing: 5.52),
                decoration: InputDecoration(
                    hintText: "2020 - 12 - 20",
                    hintStyle: const TextStyle(color: Color(0xFFADADAD)),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20)),
              ),
            ),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                border: Border.all(width: 1, color: const Color(0xFFFFC92F)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 17, horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "ID Type",
                            style: TextStyle(
                              color: Color(0xFF646464),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          FutureBuilder(
                            future: ekycRealModel,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  IdType.values[snapshot.data!.detectModel.cls]
                                      .code,
                                  style: const TextStyle(
                                    color: Color(0xFF161616),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
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
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "ID Authenticity",
                            style: TextStyle(
                              color: Color(0xFF646464),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          FutureBuilder(
                              future: ekycRealModel,
                              builder: (context, snapshot) {
                                var real = false;
                                if (snapshot.hasData) {
                                  real = snapshot.data!.score >
                                      snapshot.data!.threshold;
                                }
                                return Text(
                                  real
                                      ? Authenticity.original.code
                                      : Authenticity.replica.code,
                                  style: const TextStyle(
                                    color: Color(0xFF161616),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                );
                              }),
                        ],
                      )
                    ]),
              ),
            ),
            const Spacer(),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
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
              ),
            ),
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
                    onPressed: () => _onTryAgainPressed(context),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: MenuButonWidget(
                    title: "Next",
                    textColor: const Color(0xFF121212),
                    backgoundColor: const Color(0xffFFC92F),
                    boxWidth: MediaQuery.of(context).size.width,
                    boxHeight: 55,
                    boxRadius: 6,
                    onPressed: () => _onNextPressed(context),
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
