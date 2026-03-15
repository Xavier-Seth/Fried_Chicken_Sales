import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'controllers/locale_controller.dart';
import 'l10n/app_localizations.dart';
import 'pages/main_navigation_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final localeController = await LocaleController.create();

  runApp(SalesApp(localeController: localeController));
}

class SalesApp extends StatelessWidget {
  final LocaleController localeController;

  const SalesApp({super.key, required this.localeController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: localeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFF59E0B),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF6F7FB),
          ),
          home: MainNavigationPage(localeController: localeController),
        );
      },
    );
  }
}
