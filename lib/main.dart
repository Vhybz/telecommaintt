import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'routes/app_router.dart';
import 'features/notifications/data/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  try {
    await dotenv.load(fileName: "assets/tel_config.txt");
  } catch (e) {
    debugPrint("Warning: Could not load assets/tel_config.txt: $e");
  }
  
  // Initialize Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    publishableKey: AppConstants.supabaseServiceRoleKey,
  );

  final container = ProviderContainer();
  container.read(notificationServiceProvider).subscribeToAlarms();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const TelecomApp(),
    ),
  );
}

class TelecomApp extends ConsumerWidget {
  const TelecomApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final primaryColor = ref.watch(primaryColorProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.createTheme(brightness: Brightness.light, primaryColor: primaryColor),
      darkTheme: AppTheme.createTheme(brightness: Brightness.dark, primaryColor: primaryColor),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
