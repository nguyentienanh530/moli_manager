import 'dart:ui';

import 'package:moli_manager/model/user/salon.dart';
import 'package:moli_manager/screens/ban/salon_ban_screen.dart';
import 'package:moli_manager/screens/login/email_login_screen.dart';
import 'package:moli_manager/screens/main/main_screen.dart';
import 'package:moli_manager/screens/registration/registration_screen.dart';
import 'package:moli_manager/screens/registration/sign_up_done_screen.dart';
import 'package:moli_manager/service/api_service.dart';
import 'package:moli_manager/utils/app_res.dart';
import 'package:moli_manager/utils/asset_res.dart';
import 'package:moli_manager/utils/color_res.dart';
import 'package:moli_manager/utils/const_res.dart';
import 'package:moli_manager/utils/custom/custom_widget.dart';
import 'package:moli_manager/utils/shared_pref.dart';
import 'package:moli_manager/utils/style_res.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class WelComeScreen extends StatefulWidget {
  const WelComeScreen({super.key});

  @override
  State<WelComeScreen> createState() => _WelComeScreenState();
}

class _WelComeScreenState extends State<WelComeScreen> {
  bool isLoading = false;
  var firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<bool> saveTokenUpdate() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    SharePref sharePref = await SharePref().init();
    AppRes.currency = sharePref.getSettings()?.data?.currency ?? '';
    await ApiService().fetchGlobalSettings();
    await FirebaseMessaging.instance.subscribeToTopic('salons');
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'cutfxsalon', // id
      'Notification', // title
      // 'This channel is used for bubbly notifications.', // description
      importance: Importance.max,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      }
      var initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = const DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      FlutterLocalNotificationsPlugin().initialize(initializationSettings);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? apple = message.notification?.apple;

      if (notification != null && apple != null) {
        flutterLocalNotificationsPlugin.show(
            1,
            notification.title,
            notification.body,
            const NotificationDetails(iOS: DarwinNotificationDetails()));
      }
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            1,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                // other properties...
              ),
            ));
      }
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Image(
            image: AssetImage(AssetRes.bg1),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                const Expanded(
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: AppLogo(
                        textSize: 34,
                      ),
                    ),
                  ),
                ),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorRes.black.withOpacity(0.4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SafeArea(
                        top: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .premiumBeautyServices,
                              style: kSemiBoldWhiteTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .registerYourShopWithUsAndHaveValuableLeads,
                              style: kLightWhiteTextStyle,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: TextButton(
                                style: kButtonWhiteStyle,
                                onPressed: () async {
                                  if (isLoading) {
                                    return;
                                  }
                                  isLoading = true;
                                  setState(() {});
                                  String? token = await FirebaseMessaging
                                      .instance
                                      .getToken();

                                  SharePref sharedPref =
                                      await SharePref().init();
                                  sharedPref.saveString(
                                      ConstRes.deviceToken, token);
                                  Salon? salon1 = sharedPref.getSalon();
                                  await saveTokenUpdate();
                                  ConstRes.salonId =
                                      salon1?.data?.id?.toInt() ?? -1;
                                  Salon? salon =
                                      await ApiService().fetchMySalonDetails();
                                  if (salon.data?.status == 2) {
                                    Get.off(() => const BanSalonInfoScreen());
                                  } else if (salon.data?.status?.toInt() == 0) {
                                    if (salon.data?.status == 1) {
                                      goToMainPage(salon);
                                    } else {
                                      Get.off(() => const SignUpDoneScreen());
                                    }
                                  } else if (salon.data?.bankAccount != null) {
                                    goToMainPage(salon);
                                  } else if (salon.status! &&
                                      salon.data?.bankAccount == null) {
                                    Get.off(() => const RegistrationScreen());
                                  } else {
                                    Get.off(() => const EmailLoginScreen());
                                  }
                                },
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: ColorRes.themeColor,
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!.continue_,
                                        style: kThemeButtonTextStyle,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    FlutterAppBadger.removeBadge();
    super.initState();
  }

  void goToMainPage(Salon salon) {
    ConstRes.salonId = salon.data?.id?.toInt() ?? -1;
    Get.off(() => const MainScreen());
  }
}
