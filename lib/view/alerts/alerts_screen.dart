// import 'package:flutter/material.dart';
//
// class AlertsScreen extends StatelessWidget {
//   final List<AlertItem> alerts = [
//     AlertItem(
//       title: '2 missed doses',
//       message: 'Take your medication at 11:00am and 7:00pm',
//       time: '15:00 PM',
//     ),
//     AlertItem(
//       title: 'Box recharge',
//       message: 'Battery is low, please charge the device',
//       time: '15:00 PM',
//     ),
//     AlertItem(
//       title: 'Box Refill Alert',
//       message: 'Please refill container 3 soon.',
//       time: '15:00 PM',
//     ),
//     AlertItem(
//       title: 'Vital sign',
//       message: 'Best heart rate measure from 3 days',
//       time: '15:00 PM',
//     ),
//     AlertItem(
//       title: 'Room Temperature',
//       message: 'Room temperature is low please change box place',
//       time: '15:00 PM',
//     ),
//     AlertItem(
//       title: 'Room humidity',
//       message: 'Room temperature is low please change box place',
//       time: '15:00 PM',
//     ),
//     AlertItem(
//       title: 'Room humidity',
//       message: 'Room temperature is low please change box place',
//       time: '15:00 PM',
//     ),
//     AlertItem(
//       title: 'Room humidity',
//       message: 'Room temperature is low please change box place',
//       time: '15:00 PM',
//     ),
//     AlertItem(
//       title: 'Room humidity',
//       message: 'Room temperature is low please change box place',
//       time: '15:00 PM',
//     ),
//     AlertItem(
//       title: 'Room humidity',
//       message: 'Room temperature is low please change box place',
//       time: '15:00 PM',
//     ),
//   ];
//
//   IconData getAlertIcon(String title, String message) {
//     if (title.toLowerCase().contains('missed dose')) {
//       return Icons.medication_outlined ;
//     } else if (title.toLowerCase().contains('recharge')) {
//       return Icons.battery_0_bar_outlined;
//     } else if (title.toLowerCase().contains('refill')) {
//       return Icons.replay;
//     } else if (title.toLowerCase().contains('vital measures')) {
//       return Icons.favorite_border;
//     } else if (title.toLowerCase().contains('temperature')) {
//       return Icons.thermostat;
//     }  else if (title.toLowerCase().contains('humidity')) {
//       return Icons.water_drop_outlined;
//     } else {
//       return Icons.notifications_none_rounded;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Alerts', style: TextStyle(color: Colors.black)),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(top: 15),
//           child: Column(
//             children: [
//               ListView.separated(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: alerts.length,
//                 separatorBuilder: (context, index) => Divider(
//                   height: 10,
//                   thickness: 0.5,
//                   color: Colors.grey[400],
//                 ),
//                 itemBuilder: (context, index) {
//                   final alert = alerts[index];
//                   return ListTile(
//
//                     leading: Icon(
//                       getAlertIcon(alert.title, alert.message),
//                       color: Colors.blue,
//                       size: 26,
//                     ),
//                     title: Text(
//                       alert.title,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(
//                       alert.message,
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     trailing: Text(
//                       alert.time,
//                       style: TextStyle(fontSize: 12, color: Colors.grey[800]),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class AlertItem {
//   final String title;
//   final String message;
//   final String time;
//
//   AlertItem({
//     required this.title,
//     required this.message,
//     required this.time,
//   });
// }
import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  final List<AlertItem> alerts = [
    AlertItem(
      title: '2 missed doses',
      message: 'Take your medication at 11:00am and 7:00pm',
      time: '15:00 PM',
    ),
    AlertItem(
      title: 'Box recharge',
      message: 'Battery is low, please charge the device',
      time: '15:00 PM',
    ),
    AlertItem(
      title: 'Box Refill Alert',
      message: 'Please refill container 3 soon.',
      time: '15:00 PM',
    ),
    AlertItem(
      title: 'Vital sign',
      message: 'Best heart rate measure from 3 days',
      time: '15:00 PM',
    ),
    AlertItem(
      title: 'Room Temperature',
      message: 'Room temperature is low please change box place',
      time: '15:00 PM',
    ),
    AlertItem(
      title: 'Room humidity',
      message: 'Room temperature is low please change box place',
      time: '15:00 PM',
    ),
    AlertItem(
      title: 'Box recharge',
      message: 'Battery is low, please charge the device',
      time: '15:00 PM',
    ),
    AlertItem(
      title: 'Box Refill Alert',
      message: 'Please refill container 3 soon.',
      time: '15:00 PM',
    ),
    AlertItem(
      title: 'Vital sign',
      message: 'Best heart rate measure from 3 days',
      time: '15:00 PM',
    ),
    AlertItem(
      title: 'Room Temperature',
      message: 'Room temperature is low please change box place',
      time: '15:00 PM',
    ),
  ];

  IconData getAlertIcon(String title, String message) {
    if (title.toLowerCase().contains('missed dose')) {
      return Icons.medication_outlined ;
    } else if (title.toLowerCase().contains('recharge')) {
      return Icons.battery_0_bar_outlined;
    } else if (title.toLowerCase().contains('refill')) {
      return Icons.replay;
    } else if (title.toLowerCase().contains('vital measures')) {
      return Icons.favorite_border;
    } else if (title.toLowerCase().contains('temperature')) {
      return Icons.thermostat;
    }  else if (title.toLowerCase().contains('humidity')) {
      return Icons.water_drop_outlined;
    } else {
      return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alerts', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: alerts.length,
                separatorBuilder: (context, index) => Divider(
                  height: 10,
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return ListTile(
                    leading:Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          getAlertIcon(alert.title, alert.message),
                          color: Colors.blue,
                          size: 22,
                        ),
                      ),
                    ),

                    title: Text(
                      alert.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      alert.message,
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      alert.time,
                      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertItem {
  final String title;
  final String message;
  final String time;

  AlertItem({
    required this.title,
    required this.message,
    required this.time,
  });
}