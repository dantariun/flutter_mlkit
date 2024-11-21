import 'package:flutter/material.dart';
import 'package:mlkit_test/ui/get_id_camera_screen.dart';
import 'package:mlkit_test/ui/home_screen.dart';
import 'package:mlkit_test/ui/widget/menu_button.dart';

class PrepareIdScreen extends StatelessWidget {
  const PrepareIdScreen({super.key});

  void _getIdStart(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GetIdCameraScreen(),
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
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 73),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Image.asset('assets/images/seeu_logo.png'),
            ),
            const SizedBox(
              height: 144,
            ),
            const Text(
              "Personal\nVerification",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 44,
                  height: 1.1),
            ),
            const Text(
              "Process",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 44,
                  height: 1.1),
            ),
            const SizedBox(
              height: 29.43,
            ),
            const Text(
              "Press start to begin",
              style: TextStyle(
                  color: Color(0xFF2F2F2F),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.1),
            ),
            Expanded(child: Container()),
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
            MenuButonWidget(
              title: "Start",
              textColor: const Color(0xff000000),
              backgoundColor: const Color(0xffFFC92F),
              boxWidth: MediaQuery.of(context).size.width,
              boxHeight: 55,
              boxRadius: 6,
              onPressed: () => _getIdStart(context),
            )
          ],
        ),
      ),
    );
  }
}
