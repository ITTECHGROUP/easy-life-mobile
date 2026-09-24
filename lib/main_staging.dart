import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


import 'providers/providers.dart';

import 'models/push_notification.dart';
import 'routes/routes.dart';
import 'theme/app_theme.dart';
import 'tools/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.staging.env');
  await PushNotificationService.initializeApp();
  await Firebase.initializeApp();
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectedServiceInfo()),
        ChangeNotifierProvider(create: (context) => ServicesProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CommentProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => MembershipProvider()),
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    
    PushNotificationService.messageStream.listen((data) async {
      PushNotification notification = PushNotification.fromMap(data);

      Future<void> navigateToNotification() async {
        ServicesProvider servicesProvider =
            Provider.of<ServicesProvider>(context, listen: false);
        servicesProvider.serviceType = 'services';
        servicesProvider.resetProducts();

        if (notification.productId != null) {
          await servicesProvider
              .getSingleProductDetailFromApi(notification.productId!);
        }
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          'products',
          (route) => route.isFirst,
          arguments: {'wait': true},
        );
        if (navigatorKey.currentState != null &&
            notification.productId != null) {
          navigatorKey.currentState!.pushNamed(
            'car_info',
            arguments: notification.toMap(),
          );
        }
        await servicesProvider.getProductsDetailFromApi(notification.serviceId); 
      }


      switch (notification.appState) {
        case AppStates.foreground:
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(notification.body),
                ],
              ),
              margin: EdgeInsets.fromLTRB(
                12,
                0,
                12,
                MediaQuery.of(context).size.height * 0.82,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Go',
                onPressed: navigateToNotification,
              ),
              duration: const Duration(seconds: 6),
              dismissDirection: DismissDirection.horizontal,
            ),
          );
          break;
        case AppStates.terminated:
        case AppStates.background:
          navigateToNotification();
          break;
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Life Club',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      theme: AppTheme.darkTheme,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
