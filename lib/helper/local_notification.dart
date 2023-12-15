import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wallet/helper/logger.dart';

class LocalNotification {
  static final int FCM_PUSH = 0;
  static final int SYNC_WALLET = 1;
  static final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final StreamController<int?> selectNotificationStream = StreamController<int?>.broadcast();
  static bool _initialized  = false;

  static bool isPlatformSupported(){
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS || Platform.isLinux ) {
      return true;
    }
    logger.i("${Platform.operatingSystem} is not supported platform for LocalNotification");
    return false;
  }

  static final androidNotificationDetail = AndroidNotificationDetails(
      '0', // channel Id
      'general' // channel Name
  );
  static final iosNotificatonDetail = DarwinNotificationDetails();
  static final notificationDetails = NotificationDetails(
    iOS: iosNotificatonDetail,
    android: androidNotificationDetail,
  );

  static Future<void> init() async {
    if (!isPlatformSupported()) {
      return;
    }
    if (!_initialized ) {
      _initialized  = true;
      const androidInitializationSetting = AndroidInitializationSettings(
          '@mipmap/ic_launcher');
      const iosInitializationSetting = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const navigationActionId = "Ok";
      const initSettings = InitializationSettings(
          android: androidInitializationSetting, iOS: iosInitializationSetting);
      await _flutterLocalNotificationsPlugin.initialize(
          initSettings,
          onDidReceiveNotificationResponse: (
              NotificationResponse notificationResponse) {
            switch (notificationResponse.notificationResponseType) {
              case NotificationResponseType.selectedNotification:
                selectNotificationStream.add(notificationResponse.id);
                break;
              case NotificationResponseType.selectedNotificationAction:
                if (notificationResponse.actionId == navigationActionId) {
                  selectNotificationStream.add(notificationResponse.id);
                }
                break;
            }
          }
      );
      _listenNotificationClickEvent();
    }
  }

  static void show(int id, String title, String body) {
    if (!isPlatformSupported()) {
      return;
    }
    _flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);
  }

  static void _listenNotificationClickEvent() {
    selectNotificationStream.stream.listen((int? id) async {
        logger.i('user clicked notification with ID = ${id}');
    });
  }
}