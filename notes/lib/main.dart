import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'screens/note_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('app_locale') ?? 'id';

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp(initialLocale: Locale(savedLocale)));
}

class MainApp extends StatefulWidget {
  final Locale initialLocale;

  const MainApp({super.key, required this.initialLocale});

  // Static instance supaya bisa dipanggil dari widget mana saja
  static _MainAppState? _instance;

  // Method untuk mengganti bahasa, dipanggil dari widget lain
  static void setLocale(Locale locale) {
    _instance?._setLocale(locale);
  }

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    MainApp._instance = this; // daftarkan instance
  }

  // Ganti bahasa + simpan ke SharedPreferences
  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('app_locale', locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),

      // ↓ Tiga baris ini yang mengaktifkan localization
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      home: const NoteListScreen(),
    );
  }
}