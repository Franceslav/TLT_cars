import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cars/bloc/app_bottom_form/app_bottom_form.dart';
import 'package:cars/bloc/auth/auth_cubit.dart';
import 'package:cars/bloc/live_search/live_search_bloc.dart';
import 'package:cars/firebase_options.dart';
import 'package:cars/pages/driver_home_page.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/pages/register_page.dart';
import 'package:cars/pages/search_page.dart';
import 'package:cars/pages/test_page.dart';
import 'package:cars/repository/repo.dart';
import 'package:cars/res/config.dart';
import 'package:cars/res/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'bloc/route_from_to/route_from_to.dart';

import 'package:flutter/material.dart';

import 'pages/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(oneSignalAppId);
  OneSignal.Notifications.requestPermission(true);
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelShowBadge: true,
        channelKey: "channel",
        defaultColor: Colors.blue,
        channelName: "Basic Notifications",
        importance: NotificationImportance.High,
        channelDescription: "Description",
      ),
    ],
  );

  OneSignal.Notifications.addForegroundWillDisplayListener(
      (OSNotificationWillDisplayEvent val) {
    print('Val=${val.notification.body}');
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'channel',
        title: 'title',
        body: 'body',
      ),
    );
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var repo = Repository();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(),
        ),
        BlocProvider<LiveSearchBloc>(
          create: (BuildContext context) => LiveSearchBloc(repo: repo),
        ),
        BlocProvider<RouteFromToCubit>(
          create: (BuildContext context) => RouteFromToCubit(),
        ),
        BlocProvider<AppBottomFormCubit>(
          create: (BuildContext context) => AppBottomFormCubit(),
        ),
      ],
      child: GetMaterialApp(
        home: MaterialApp(
          title: 'Cars App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: blue,
            ),
            useMaterial3: true,
          ),
          //home: Scaffold(body: SearchPage()),
          home: SignInPage(),
        ),
      ),
    );
  }
}
