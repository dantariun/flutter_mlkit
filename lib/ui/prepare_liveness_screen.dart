import 'package:flutter/material.dart';
import 'package:mlkit_test/ui/active_liveness_screen.dart';
import 'package:mlkit_test/ui/home_screen.dart';
import 'package:mlkit_test/ui/widget/menu_button.dart';

class PrepareLivenessScreen extends StatelessWidget {
  const PrepareLivenessScreen({super.key});

  void _onNextPressed(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ActiveLivenessScreen(),
        ));
  }

  void _gotoMain(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 63),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 87,
            ),
            Image.asset('assets/images/prepare_liveness_face.png'),
            const SizedBox(
              height: 19.62,
            ),
            const Text(
              "Facial Recognition Process",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Color(0xFF414141),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Please follow the steps below,\nand press start to begin",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF414141),
              ),
            ),
            const SizedBox(
              height: 67.21,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Checklist!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF414141),
                    ),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  Row(
                    children: [
                      Image.asset("assets/images/circle_correct_gray.png"),
                      const SizedBox(
                        width: 13.32,
                      ),
                      const Text(
                        "Please follow the gestures displayed\nat the top of the screen",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF555555),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Image.asset("assets/images/circle_correct_gray.png"),
                      const SizedBox(
                        width: 13.32,
                      ),
                      const Text(
                        "Process will complete upon\n3 consecutive successful gestures.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF555555),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Image.asset("assets/images/circle_correct_gray.png"),
                      const SizedBox(
                        width: 13.32,
                      ),
                      const Text(
                        "3 failures to perform the gestures will\nautomatically end the process",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF555555),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
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
            const SizedBox(
              height: 10,
            ),
            MenuButonWidget(
              title: "Next",
              textColor: const Color(0xff000000),
              backgoundColor: const Color(0xffFFC92F),
              boxWidth: MediaQuery.of(context).size.width,
              boxHeight: 55,
              boxRadius: 6,
              onPressed: () => _onNextPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}
