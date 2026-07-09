import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flowpay/l10n/app_localizations.dart';
import 'package:flowpay/app/routes/app_router.dart';
import 'package:flowpay/app/theme/app_theme.dart';
import 'package:flowpay/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Setup Dependency Injection
  setupDependencies();

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
