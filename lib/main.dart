import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flowpay/l10n/app_localizations.dart';
import 'package:flowpay/app/routes/app_router.dart';
import 'package:flowpay/app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const FlowPayApp());
}

class FlowPayApp extends StatelessWidget {
  const FlowPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FlowPay',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      
      // i18n setup
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
      ],
      // Default to PT-BR
      locale: const Locale('pt'),
      
      debugShowCheckedModeBanner: false,
    );
  }
}
