import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mlkit_test/common/view_config.dart';
import 'package:mlkit_test/common/view_config_vm.dart';
import 'package:mlkit_test/ui/home_screen.dart';
import 'package:mlkit_test/ui/id_total_verification_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final repository = ViewConfigRepository(preferences);
  runApp(ProviderScope(
    overrides: [
      viewConfigProvider.overrideWith(
        () => ViewConfigViewModel(repository),
      )
    ],
    child: const ActiveLiveness(),
  ));
}

class ActiveLiveness extends ConsumerWidget {
  const ActiveLiveness({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
