import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
class DashboardData {
  final double temperature;
  final double humidity;
  final int batteryPercentage;
  final String status;

  DashboardData({
    required this.temperature,
    required this.humidity,
    required this.batteryPercentage,
    required this.status,
  });
}

Stream<DashboardData> getCombinedDashboardStream() {
  final humAndTempStream = FirebaseDatabase.instance
      .ref()
      .child("(BOX)Hum&Temp")
      .onValue
      .map((event) => event.snapshot.value as Map);

  final batteryStream = FirebaseDatabase.instance
      .ref()
      .child("battery")
      .onValue
      .map((event) => event.snapshot.value as Map);

  final statusStream = FirebaseDatabase.instance
      .ref()
      .child("devices")
      .onValue
      .map((event) => event.snapshot.value as Map);

  return Rx.combineLatest3<Map, Map, Map, DashboardData>(
    humAndTempStream,
    batteryStream,
    statusStream,
        (humAndTemp, battery, deviceStatus) {
      return DashboardData(
        temperature: (humAndTemp['temperature'] ?? 0).toDouble(),
        humidity: (humAndTemp['humidity'] ?? 0).toDouble(),
        batteryPercentage: (battery['percentage'] ?? 0).toInt(),
        status: deviceStatus['status'] ?? 'offline',
      );
    },
  );
}
