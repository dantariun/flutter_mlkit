import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mlkit_test/api/api_ekyc.dart';
import 'package:mlkit_test/common/view_config_vm.dart';
import 'package:mlkit_test/ui/home_screen.dart';
import 'package:mlkit_test/ui/widget/menu_button.dart';

class OcrIdScreen extends ConsumerStatefulWidget {
  const OcrIdScreen({super.key});

  @override
  ConsumerState<OcrIdScreen> createState() => _OcrIdScreenState();
}

class _OcrIdScreenState extends ConsumerState<OcrIdScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerNumber = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();

  bool updated = false;

  @override
  void initState() {
    super.initState();

    final path = ref.read(viewConfigProvider).idPath;
    final token = ref.read(viewConfigProvider).token;
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

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerNumber.dispose();
    _controllerDate.dispose();
    super.dispose();
  }

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
            const SizedBox(
              height: 20,
            ),
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
            const SizedBox(
              height: 22,
            ),
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
            const SizedBox(
              height: 22,
            ),
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
