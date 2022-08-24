import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    return GetMaterialApp(
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      // theme: makeAppTheme(),
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      getPages: [
        // GetPage(name: '/', page: makeSplashPage, transition: Transition.fade),
        // GetPage(name: '/register', page: makeLoginPage, transition: Transition.fadeIn),
        // GetPage(name: '/signup', page: makeSignUpPage),
        // GetPage(name: '/surveys', page: makeSurveysPage, transition: Transition.fadeIn),
        // GetPage(name: '/survey_result/:survey_id', page: makeSurveyResultPage),
      ],
    );
  }
}
