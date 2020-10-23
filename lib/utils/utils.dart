import 'package:geolocator/geolocator.dart';

class Utils {
  static double getDistance(
      {double startLat, double startLong, double endLat, double endLong}) {
    double t = Geolocator.distanceBetween(startLat, startLong, endLat, endLong);
    final sd = (t / 1000).toStringAsFixed(2);
    return double.parse(sd);
  }
}
