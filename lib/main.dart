import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/backend.dart';
import 'state/app_state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MiApp(backend: await _createBackend()));
}

/// Usa Firebase si está configurado (google-services.json); si no, modo demo.
Future<Backend> _createBackend() async {
  try {
    await Firebase.initializeApp();
    return FirebaseBackend();
  } catch (e) {
    debugPrint('Firebase no configurado, usando modo demo: $e');
    final local = LocalBackend();
    await local.init();
    return local;
  }
}

class MiApp extends StatelessWidget {
  final Backend backend;
  const MiApp({super.key, required this.backend});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(backend),
      child: MaterialApp(
        title: 'Canciones con Historia',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: Consumer<AppState>(
          builder: (_, state, _) =>
              state.user == null ? const LoginScreen() : const HomeScreen(),
        ),
      ),
    );
  }
}
