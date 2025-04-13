// import 'package:flutter/material.dart';
//
//
// class HistoryScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> heartRateDataToday = [
//     {"value": 119, "time": "12:60"},
//     {"value": 119, "time": "12:60"},
//   ];
//
//   final List<Map<String, dynamic>> heartRateDataYesterday = [
//     {"value": 119, "time": "12:60"},
//     {"value": 45, "time": "03:12"},
//     {"value": 230, "time": "09:30"},
//   ];
//
//   final List<Map<String, dynamic>> oxygenDataYesterday = [
//     {"value": 119, "time": "12:60"},
//     {"value": 45, "time": "03:12"},
//     {"value": 230, "time": "09:30"},
//   ];
//
//   Color getStatusColor(int value) {
//     if (value < 60 || value > 150) {
//       return Colors.red; // abnormal
//     } else {
//       return Colors.green; // normal
//     }
//   }
//
//   Widget buildSection(String title, IconData icon,Color iconColor, List<Map<String, dynamic>> today, List<Map<String, dynamic>> yesterday) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 20),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//           Row(
//           children: [
//           Icon(icon, color: iconColor),
//       SizedBox(width: 8),
//       Text(
//         title,
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//       ),
//       ],
//     ),
//             SizedBox(height: 12),
//             if (today.isNotEmpty) ...[
//               Text("TODAY", style: TextStyle(fontSize: 12, color: Colors.grey)),
//               SizedBox(height: 8),
//               ...today.map((data) => buildItem(data)),
//             ],
//             if (yesterday.isNotEmpty) ...[
//               SizedBox(height: 12),
//               Text("YESTERDAY", style: TextStyle(fontSize: 12, color: Colors.grey)),
//               SizedBox(height: 8),
//               ...yesterday.map((data) => buildItem(data)),
//             ],
//             SizedBox(height: 10),
//             Center(
//               child: Text("see more", style: TextStyle(fontSize: 12, color: Colors.grey)),
//             ),
//           ],
//       ),
//     );
//   }
//
//   Widget buildItem(Map<String, dynamic> data) {
//     return Container(
//         margin: EdgeInsets.only(bottom: 10),
//     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//     decoration: BoxDecoration(
//     color: Colors.grey.shade100,
//     borderRadius: BorderRadius.circular(12),
//     ),
//       child: Row(
//         children: [
//           Container(
//             width: 12,
//             height: 12,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: getStatusColor(data["value"]),
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               "${data["value"]} BPM",
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//             ),
//           ),
//           Text(
//             data["time"],
//             style: TextStyle(fontSize: 12, color: Colors.grey),
//           )
//         ],
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Text("History", style: TextStyle(color: Colors.black)),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             buildSection("Heart Rate", Icons.favorite_border,Colors.red, heartRateDataToday,
//                 heartRateDataYesterday),
//             buildSection(
//                 "Oxygen Level", Icons.water_drop_outlined,Colors.blue, [], oxygenDataYesterday),
//           ],
//         ),
//       ),
//
//     );
//   }
// }
import 'package:flutter/material.dart';
class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool showMoreHeart = false;
  bool showMoreOxygen = false;

  final List<Map<String, dynamic>> heartRateDataToday = [
    {"value": 119, "time": "12:00"},
    {"value": 110, "time": "12:30"},
    {"value": 85, "time": "01:00"},
    {"value": 76, "time": "01:30"},
    {"value": 95, "time": "02:00"},
  ];

  final List<Map<String, dynamic>> heartRateDataYesterday = [
    {"value": 119, "time": "12:00"},
    {"value": 45, "time": "03:12"},
    {"value": 230, "time": "09:30"},
    {"value": 80, "time": "10:00"},
    {"value": 100, "time": "11:45"},
  ];
  final List<Map<String, dynamic>> oxygenDataYesterday = [
    {"value": 98, "time": "12:00"},
    {"value": 187, "time": "03:12"},
    {"value": 97, "time": "09:30"},
    {"value": 92, "time": "11:10"},
    {"value": 180, "time": "01:30"},
  ];

  Color getStatusColor(int value) {
    if (value < 60 || value > 150) {
      return Colors.red; // abnormal
    } else {
      return Colors.green; // normal
    }
  }

  Widget buildSection(
      String title,
      IconData icon,
      Color iconColor,
      List<Map<String, dynamic>> today,
      List<Map<String, dynamic>> yesterday,
      bool showMore,
      VoidCallback onToggle,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
          children: [
          Icon(icon, color: iconColor),
      SizedBox(width: 8),
      Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      ],
    ),
    SizedBox(height: 12),
    if (today.isNotEmpty) ...[
    Text("TODAY", style: TextStyle(fontSize: 12, color: Colors.grey)),
    SizedBox(height: 8),
    ...(showMore ? today : today.take(2)).map(buildItem).toList(),
    ],
            if (yesterday.isNotEmpty) ...[
              SizedBox(height: 12),
              Text("YESTERDAY", style: TextStyle(fontSize: 12, color: Colors.grey)),
              SizedBox(height: 8),
              ...(showMore ? yesterday : yesterday.take(2)).map(buildItem).toList(),
            ],
            SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: onToggle,
                child: Text(
                  showMore ? "see less" : "see more",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
      ),
    );
  }

  Widget buildItem(Map<String, dynamic> data) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
    color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getStatusColor(data["value"]),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "${data["value"]} BPM",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            data["time"],
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("History", style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: ListView(
    children: [
    buildSection(
    "Heart Rate",
    Icons.favorite_border,
    Colors.red,
    heartRateDataToday,
    heartRateDataYesterday,
    showMoreHeart,
    () => setState(() => showMoreHeart = !showMoreHeart),
    ),
    buildSection(
    "Oxygen Level",
    Icons.water_drop_outlined,
    Colors.blue,
      [],
      oxygenDataYesterday,
      showMoreOxygen,
          () => setState(() => showMoreOxygen = !showMoreOxygen),
    ),
    ],
    ),
            ),
    );
    }
}