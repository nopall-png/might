import 'dart:math';

/// Menghitung jarak (kilometer) antara dua koordinat menggunakan Haversine.
double distanceKm({
  required double lat1,
  required double lon1,
  required double lat2,
  required double lon2,
}) {
  const R = 6371.0; // radius bumi dalam kilometer
  double _deg2rad(double d) => d * pi / 180.0;
  final dLat = _deg2rad(lat2 - lat1);
  final dLon = _deg2rad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
          sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}
