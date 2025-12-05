import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:wmp/data/services/auth_service.dart';
import 'package:wmp/data/services/firestore_service.dart';

class LocationService {
  LocationService._();
  static final instance = LocationService._();

  Future<bool> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Tidak memblokir, pengguna bisa menyalakan sendiri
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<Position?> getCurrentPosition({LocationAccuracy accuracy = LocationAccuracy.high}) async {
    try {
      return await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
    } catch (_) {
      return null;
    }
  }

  /// Ambil lokasi perangkat dan simpan ke profil user saat ini.
  Future<bool> updateMyLocationToProfile() async {
    final ok = await ensurePermission();
    if (!ok) return false;
    final pos = await getCurrentPosition(accuracy: LocationAccuracy.high);
    final uid = AuthService.instance.currentUser?.uid;
    if (pos == null || uid == null) return false;
    String? humanReadable;
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final locality = [p.subLocality, p.locality].where((e) => (e ?? '').isNotEmpty).join(', ');
        final admin = [p.administrativeArea, p.country].where((e) => (e ?? '').isNotEmpty).join(', ');
        final composed = [locality, admin].where((e) => (e).isNotEmpty).join(' • ');
        humanReadable = composed.isNotEmpty ? composed : null;
      }
    } catch (_) {
      // abaikan kegagalan geocoding, gunakan fallback
    }
    await FirestoreService.instance.updateUserProfile(uid, {
      'lat': pos.latitude,
      'lng': pos.longitude,
      if (humanReadable != null) 'location': humanReadable,
      if (humanReadable == null)
        'location': '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}',
      'locationUpdatedAt': DateTime.now().toUtc().toIso8601String(),
    });
    return true;
  }
}
