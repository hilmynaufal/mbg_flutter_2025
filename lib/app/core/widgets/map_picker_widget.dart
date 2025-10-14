import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/form_field_model.dart';
import '../theme/app_colors.dart';

class MapPickerWidget extends StatelessWidget {
  final FormFieldModel field;
  final Map<String, double>? coordinates;
  final void Function(Map<String, double>?) onCoordinatesSelected;
  final String? Function(String?)? validator;

  const MapPickerWidget({
    super.key,
    required this.field,
    required this.coordinates,
    required this.onCoordinatesSelected,
    this.validator,
  });

  Future<void> _pickLocation(BuildContext context) async {
    final result = await Navigator.push<Map<String, double>?>(
      context,
      MaterialPageRoute(
        builder: (context) => _MapPickerScreen(
          initialCoordinates: coordinates,
          fieldName: field.questionText,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result != null) {
      onCoordinatesSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCoordinates = coordinates != null &&
        coordinates!.containsKey('latitude') &&
        coordinates!.containsKey('longitude');

    final displayText = hasCoordinates
        ? '${coordinates!['latitude']?.toStringAsFixed(6)}, ${coordinates!['longitude']?.toStringAsFixed(6)}'
        : field.questionPlaceholder ?? 'Pilih ${field.questionText}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator
        RichText(
          text: TextSpan(
            text: field.questionText,
            style: Theme.of(context).textTheme.labelLarge,
            children: [
              if (field.validationRules.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
            ],
          ),
        ),
        if (field.questionDescription != null &&
            field.questionDescription!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            field.questionDescription!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickLocation(context),
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: field.questionPlaceholder ?? 'Pilih ${field.questionText}',
              suffixIcon: const Icon(Icons.location_on),
            ),
            child: Text(
              displayText,
              style: hasCoordinates
                  ? Theme.of(context).textTheme.bodyMedium
                  : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
            ),
          ),
        ),
        // Hidden FormField for validation
        FormField<Map<String, double>>(
          initialValue: coordinates,
          validator: (value) {
            if (validator != null) {
              final coordString = value != null
                  ? '${value['latitude']}, ${value['longitude']}'
                  : null;
              return validator!(coordString);
            }
            return null;
          },
          builder: (state) {
            if (state.hasError) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  state.errorText!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _MapPickerScreen extends StatefulWidget {
  final Map<String, double>? initialCoordinates;
  final String fieldName;

  const _MapPickerScreen({
    this.initialCoordinates,
    required this.fieldName,
  });

  @override
  State<_MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<_MapPickerScreen> {
  late MapController _mapController;
  late LatLng _selectedPosition;
  bool _isLoadingLocation = false;

  // Default center: Bandung, Indonesia
  static const LatLng _defaultCenter = LatLng(-6.9175, 107.6191);
  static const double _defaultZoom = 13.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Initialize with existing coordinates or default to Bandung
    if (widget.initialCoordinates != null &&
        widget.initialCoordinates!.containsKey('latitude') &&
        widget.initialCoordinates!.containsKey('longitude')) {
      _selectedPosition = LatLng(
        widget.initialCoordinates!['latitude']!,
        widget.initialCoordinates!['longitude']!,
      );
    } else {
      _selectedPosition = _defaultCenter;
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Layanan lokasi tidak aktif. Silakan aktifkan GPS.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Izin akses lokasi ditolak'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Izin akses lokasi ditolak permanen. Ubah di pengaturan.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
      });

      // Animate to current position
      _mapController.move(_selectedPosition, _defaultZoom);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lokasi saat ini berhasil didapatkan'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mendapatkan lokasi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
  }

  void _saveLocation() {
    Navigator.pop(context, {
      'latitude': _selectedPosition.latitude,
      'longitude': _selectedPosition.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih ${widget.fieldName}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveLocation,
            child: const Text(
              'Simpan',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedPosition,
              initialZoom: _defaultZoom,
              onTap: _onMapTap,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              // Tile layer - OpenStreetMap
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.mbg.flutter_2025',
                maxZoom: 19,
              ),
              // Marker layer
              MarkerLayer(
                markers: [
                  Marker(
                    width: 50,
                    height: 50,
                    point: _selectedPosition,
                    child: const Icon(
                      Icons.location_pin,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Coordinates display card
          Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColors.primary, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Koordinat Terpilih:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Latitude: ${_selectedPosition.latitude.toStringAsFixed(6)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'Longitude: ${_selectedPosition.longitude.toStringAsFixed(6)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Zoom controls
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoom_in',
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      currentZoom + 1,
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoom_out',
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      currentZoom - 1,
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: AppColors.primary),
                ),
              ],
            ),
          ),

          // Current location button
          Positioned(
            right: 16,
            bottom: 160,
            child: FloatingActionButton(
              heroTag: 'current_location',
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              backgroundColor: AppColors.primary,
              child: _isLoadingLocation
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.my_location, color: Colors.white),
            ),
          ),

          // Instruction overlay
          Positioned(
            top: 16,
            left: 16,
            right: 80,
            child: Card(
              color: Colors.white.withValues(alpha: 0.9),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tap pada peta untuk memilih lokasi',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
