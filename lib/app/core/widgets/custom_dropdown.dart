import 'package:flutter/material.dart';
import '../../data/models/form_field_model.dart';
import '../../data/models/desa_model.dart';
import '../../data/regional_data.dart';

class CustomDropdown extends StatelessWidget {
  final FormFieldModel field;
  final String? value;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  final Map<int, dynamic>?
      formValues; // For dependent dropdowns (Desa depends on Kecamatan)

  const CustomDropdown({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
    this.validator,
    this.formValues,
  });

  /// Check if this is a Kecamatan field
  bool get isKecamatanField {
    final text = field.questionText.toLowerCase();
    return text.contains('kecamatan');
  }

  /// Check if this is a Desa/Kelurahan field
  bool get isDesaField {
    final text = field.questionText.toLowerCase();
    return text.contains('desa') || text.contains('kelurahan');
  }

  /// Get selected kecamatan name from form values
  String? _getSelectedKecamatanName() {
    if (formValues == null) return null;

    // Try to find kecamatan field in form values by checking all fields
    for (var f in RegionalData.kecamatanList) {
      for (var entry in formValues!.entries) {
        final val = entry.value;
        if (val is String && val.toUpperCase() == f.nmKec.toUpperCase()) {
          return f.nmKec;
        }
      }
    }
    return null;
  }

  /// Get desa list filtered by kecamatan name
  List<DesaModel> _getDesaByKecamatanName(String kecamatanName) {
    // Find kecamatan by name
    final kec = RegionalData.kecamatanList.firstWhere(
      (k) => k.nmKec.toUpperCase() == kecamatanName.toUpperCase(),
      orElse: () => RegionalData.kecamatanList.first,
    );

    // Get desa by kecamatan ID
    return RegionalData.getDesaByKecamatan(kec.idKec);
  }

  @override
  Widget build(BuildContext context) {
    // Determine options source: hardcoded regional data or API options
    List<Map<String, String>> options;

    if (isKecamatanField) {
      // Use hardcoded kecamatan data
      // Store nama (uppercase) as value, not ID
      options = RegionalData.kecamatanList
          .map((kec) => {'value': kec.nmKec.toUpperCase(), 'label': kec.nmKec})
          .toList();
    } else if (isDesaField) {
      // Use hardcoded desa data, filtered by kecamatan if available
      final selectedKecName = _getSelectedKecamatanName();
      final desaData = selectedKecName != null
          ? _getDesaByKecamatanName(selectedKecName)
          : RegionalData.desaList;

      // Store nama (uppercase) as value, not ID
      options = desaData
          .map((desa) =>
              {'value': desa.nmDesa.toUpperCase(), 'label': desa.nmDesa})
          .toList();
    } else {
      // Use options from API
      final apiOptions = field.options ?? [];
      options = apiOptions.map((option) {
        if (option is Map) {
          return {
            'value': option['value']?.toString() ?? '',
            'label': option['label']?.toString() ??
                option['value']?.toString() ??
                '',
          };
        } else {
          return {
            'value': option.toString(),
            'label': option.toString(),
          };
        }
      }).toList();
    }

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
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText:
                field.questionPlaceholder ?? 'Pilih ${field.questionText}',
          ),
          items: options.isEmpty
              ? null
              : options.map((option) {
                  final displayValue = option['label'] ?? '';
                  final optionValue = option['value'] ?? '';

                  return DropdownMenuItem<String>(
                    value: optionValue,
                    child: Text(displayValue),
                  );
                }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}
