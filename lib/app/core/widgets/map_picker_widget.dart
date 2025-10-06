import 'package:flutter/material.dart';
import '../../data/models/form_field_model.dart';

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
    // TODO: Implement Google Maps picker
    // For now, show a dialog to input coordinates manually
    final latController = TextEditingController(
      text: coordinates?['latitude']?.toString() ?? '',
    );
    final lngController = TextEditingController(
      text: coordinates?['longitude']?.toString() ?? '',
    );

    final result = await showDialog<Map<String, double>?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Koordinat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: latController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                hintText: '-6.9175',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lngController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                hintText: '107.6191',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'TODO: Integrate Google Maps untuk memilih lokasi dari map',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.orange[700],
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final lat = double.tryParse(latController.text);
              final lng = double.tryParse(lngController.text);

              if (lat != null && lng != null) {
                Navigator.pop(context, {
                  'latitude': lat,
                  'longitude': lng,
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Koordinat tidak valid'),
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
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
        ? '${coordinates!['latitude']}, ${coordinates!['longitude']}'
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
