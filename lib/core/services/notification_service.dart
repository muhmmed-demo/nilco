import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'supabase_client.dart';

class NotificationService {
  static final _local = FlutterLocalNotificationsPlugin();
  
  static Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission();
    
    // Local notifications
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _local.initialize(const InitializationSettings(android: android));
    
    // Token
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      if (supabase.auth.currentUser != null) {
        await supabase.from('users').update({'fcm_token': token})
            .eq('id', supabase.auth.currentUser!.id);
      }
    }
    
    // Listen foreground
    FirebaseMessaging.onMessage.listen((msg) {
      _showNotification(msg);
    });
  }
  
  static Future<void> _showNotification(RemoteMessage msg) async {
    const androidDetails = AndroidNotificationDetails(
      'nilco_channel', 'Nilco Notifications',
      importance: Importance.high,
    );
    await _local.show(
      0, msg.notification?.title, msg.notification?.body,
      const NotificationDetails(android: androidDetails),
    );
  }
}
