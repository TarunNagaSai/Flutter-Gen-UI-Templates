import 'package:education_gen_ui/firebase_options.dart';
import 'package:education_gen_ui/src/routes/routes.dart';
import 'package:education_gen_ui/src/services/local_storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:education_gen_ui/src/const/theme.dart';
import 'package:genui/genui.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorageService().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  configureGenUiLogging(level: Level.ALL);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final appRouter = AppRouter();

    return MaterialApp.router(
      title: 'Edutech Gen UI',
      routerConfig: appRouter.config(),
      theme: MaterialTheme(textTheme).light(),
      darkTheme: MaterialTheme(textTheme).dark(),
      themeMode: ThemeMode.system,
    );
  }
}
