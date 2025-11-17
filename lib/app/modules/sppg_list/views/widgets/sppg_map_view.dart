import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/sppg_item_model.dart';
import '../../../../routes/app_routes.dart';

class SppgMapView extends StatefulWidget {
  final List<SppgItemModel> sppgList;

  const SppgMapView({
    super.key,
    required this.sppgList,
  });

  @override
  State<SppgMapView> createState() => _SppgMapViewState();
}

class _SppgMapViewState extends State<SppgMapView> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  /// Get user's current location
  Future<void> _getUserLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        Get.snackbar(
          'GPS Tidak Aktif',
          'Silakan aktifkan GPS untuk melihat lokasi Anda',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoadingLocation = false);
        Get.snackbar(
          'Izin Lokasi Ditolak',
          'Silakan aktifkan izin lokasi di pengaturan aplikasi',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      // Center map on user location with nearby SPPG
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_userLocation != null) {
          _mapController.move(_userLocation!, 12);
        }
      });
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      Get.snackbar(
        'Gagal Mendapatkan Lokasi',
        'Tidak dapat mengakses lokasi Anda',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create markers from SPPG list
    final sppgMarkers = _createSppgMarkers();
    final userMarker = _createUserMarker();

    // Combine all markers
    final allMarkers = [...sppgMarkers, if (userMarker != null) userMarker];

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _userLocation ?? const LatLng(-6.9175, 107.6191),
            initialZoom: _userLocation != null ? 12 : 11,
            minZoom: 8,
            maxZoom: 18,
          ),
          children: [
            // OpenStreetMap Tile Layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.bandungkab.mbg',
            ),

            // Marker Cluster Layer
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 80,
                size: const Size(40, 40),
                markers: allMarkers,
                builder: (context, markers) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        markers.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // Loading indicator
        if (_isLoadingLocation)
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Mencari lokasi Anda...',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Recenter button (if user location available)
        if (_userLocation != null)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                if (_userLocation != null) {
                  _mapController.move(_userLocation!, 12);
                }
              },
              child: Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),
      ],
    );
  }

  /// Create markers from SPPG list
  List<Marker> _createSppgMarkers() {
    final markers = <Marker>[];

    for (var sppg in widget.sppgList) {
      final coords = sppg.detail.coordinateValues;
      if (coords != null && coords.length == 2) {
        markers.add(
          Marker(
            point: LatLng(coords[0], coords[1]),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _showSppgBottomSheet(sppg),
              child: Container(
                decoration: BoxDecoration(
                  color: sppg.detail.isActive ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      }
    }

    return markers;
  }

  /// Create user location marker
  Marker? _createUserMarker() {
    if (_userLocation == null) return null;

    return Marker(
      point: _userLocation!,
      width: 50,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  /// Calculate bounds to fit all markers
  LatLngBounds? _calculateBounds() {
    final points = <LatLng>[];

    for (var sppg in widget.sppgList) {
      final coords = sppg.detail.coordinateValues;
      if (coords != null && coords.length == 2) {
        points.add(LatLng(coords[0], coords[1]));
      }
    }

    if (points.isEmpty) return null;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );
  }

  /// Show bottom sheet with SPPG info
  void _showSppgBottomSheet(SppgItemModel sppg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nama SPPG
              Text(
                sppg.detail.namaSppg,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${sppg.detail.desa}, ${sppg.detail.kecamatan}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: sppg.detail.isActive
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: sppg.detail.isActive
                            ? Colors.green.withValues(alpha: 0.3)
                            : Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      sppg.detail.statusSppg,
                      style: TextStyle(
                        fontSize: 12,
                        color: sppg.detail.isActive
                            ? Colors.green[700]
                            : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Produksi: ${sppg.detail.totalProduksi} porsi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Get.toNamed(Routes.SPPG_DETAIL, arguments: sppg);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Lihat Detail'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
