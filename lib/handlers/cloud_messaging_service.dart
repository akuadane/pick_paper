import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class MessagingService with ChangeNotifier {
  static final Client client = Client();

  static const String serverKey = 'AAAA3PdWq0E:APA91bGXvBdZoeyixeSRDWX_SNu9Azl28ZlFL4JOD9RnMtfo9p6AuBTBdtKwU8kcf0gIxx6g-fqHk53BzW1diPCSnv5MWeiLQcc6DvlM13RYJLmtnZaDXxAwrY1faorddk0X0A-WjNSQ';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) => sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic({@required String title,
    @required String body,
    @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}