import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
StreamController<String?>.broadcast();

const MethodChannel platform =
MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

const AndroidInitializationSettings initializationSettingsAndroid =
AndroidInitializationSettings('app_icon');

final List<DarwinNotificationCategory> darwinNotificationCategories =
<DarwinNotificationCategory>[
  DarwinNotificationCategory(
    darwinNotificationCategoryText,
    actions: <DarwinNotificationAction>[
      DarwinNotificationAction.text(
        'text_1',
        'Action 1',
        buttonTitle: 'Send',
        placeholder: 'Placeholder',
      ),
    ],
  ),
  DarwinNotificationCategory(
    darwinNotificationCategoryPlain,
    actions: <DarwinNotificationAction>[
      DarwinNotificationAction.plain('id_1', 'Action 1'),
      DarwinNotificationAction.plain(
        'id_2',
        'Action 2 (destructive)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.destructive,
        },
      ),
      DarwinNotificationAction.plain(
        navigationActionId,
        'Action 3 (foreground)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        'id_4',
        'Action 4 (auth required)',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.authenticationRequired,
        },
      ),
    ],
    options: <DarwinNotificationCategoryOption>{
      DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
    },
  )
];

/// Note: permissions aren't requested here just to demonstrate that can be
/// done later
final DarwinInitializationSettings initializationSettingsDarwin =
DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
  onDidReceiveLocalNotification:
      (int id, String? title, String? body, String? payload) async {
    didReceiveLocalNotificationStream.add(
      ReceivedNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
      ),
    );
  },
  notificationCategories: darwinNotificationCategories,
);
final LinuxInitializationSettings initializationSettingsLinux =
LinuxInitializationSettings(
  defaultActionName: 'Open notification',
  defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
);

final InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsDarwin,
  macOS: initializationSettingsDarwin,
  linux: initializationSettingsLinux,
);

Future<void> scheduleNotification(int id, String title, String body,
    DateTime scheduledDate) async {
  const DarwinNotificationDetails darwinNotificationDetails =
  DarwinNotificationDetails();
  const NotificationDetails notificationDetails = NotificationDetails(
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
      android: AndroidNotificationDetails(
          "default-channel-id", "default-channel-name"));
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Asia/Calcutta"));
  var tzDate = tz.TZDateTime.from(
      scheduledDate, tz.getLocation("Asia/Calcutta"));

  await flutterLocalNotificationsPlugin.zonedSchedule(
      id, title, body, tzDate, notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
}