import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/form_field_model.dart';
import 'custom_text_field.dart';
import 'custom_number_field.dart';
import 'custom_textarea.dart';
import 'custom_dropdown.dart';
import 'custom_date_picker.dart';
import 'map_picker_widget.dart';
import 'custom_image_picker.dart';
import 'custom_radio_group.dart';

class DynamicFormBuilder extends StatefulWidget {
  final List<FormFieldModel> fields;
  final GlobalKey<FormState> formKey;
  final Map<int, dynamic> formValues;

  const DynamicFormBuilder({
    super.key,
    required this.fields,
    required this.formKey,
    required this.formValues,
  });

  @override
  State<DynamicFormBuilder> createState() => _DynamicFormBuilderState();
}

class _DynamicFormBuilderState extends State<DynamicFormBuilder> {
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for text-based fields
    for (var field in widget.fields) {
      if (['text', 'number', 'textarea'].contains(field.questionType)) {
        _controllers[field.id] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _validateField(FormFieldModel field, dynamic value) {
    final rules = field.validationRules;

    // Check required
    if (rules.isRequired) {
      if (value == null || value.toString().trim().isEmpty) {
        return '${field.questionText} wajib diisi';
      }
    }

    // If not required and empty, skip other validations
    if (value == null || value.toString().trim().isEmpty) {
      return null;
    }

    final stringValue = value.toString();

    // Check min length
    if (rules.minLength != null && stringValue.length < rules.minLength!) {
      return '${field.questionText} minimal ${rules.minLength} karakter';
    }

    // Check max length
    if (rules.maxLength != null && stringValue.length > rules.maxLength!) {
      return '${field.questionText} maksimal ${rules.maxLength} karakter';
    }

    // Check min value (for numbers)
    if (field.questionType == 'number') {
      final numValue = int.tryParse(stringValue);
      if (numValue != null && rules.minValue != null) {
        final minValue = int.tryParse(rules.minValue!);
        if (minValue != null && numValue < minValue) {
          return '${field.questionText} minimal $minValue';
        }
      }

      // Check max value
      if (numValue != null && rules.maxValue != null) {
        final maxValue = int.tryParse(rules.maxValue!);
        if (maxValue != null && numValue > maxValue) {
          return '${field.questionText} maksimal $maxValue';
        }
      }
    }

    // Check regex pattern
    if (rules.regexPattern != null && rules.regexPattern!.isNotEmpty) {
      final regex = RegExp(rules.regexPattern!);
      if (!regex.hasMatch(stringValue)) {
        return '${field.questionText} format tidak valid';
      }
    }

    return null;
  }

  Widget _buildField(FormFieldModel field) {
    switch (field.questionType) {
      case 'text':
        return CustomTextField(
          field: field,
          controller: _controllers[field.id]!,
          validator: (value) => _validateField(field, value),
          onChanged: (value) {
            widget.formValues[field.id] = value;
          },
        );

      case 'number':
        return CustomNumberField(
          field: field,
          controller: _controllers[field.id]!,
          validator: (value) => _validateField(field, value),
          onChanged: (value) {
            widget.formValues[field.id] = value;
          },
        );

      case 'textarea':
        return CustomTextArea(
          field: field,
          controller: _controllers[field.id]!,
          validator: (value) => _validateField(field, value),
          onChanged: (value) {
            widget.formValues[field.id] = value;
          },
        );

      case 'dropdown':
        return CustomDropdown(
          field: field,
          value: widget.formValues[field.id] as String?,
          formValues: widget.formValues, // Pass formValues for dependent dropdowns
          onChanged: (value) {
            setState(() {
              widget.formValues[field.id] = value;

              // If this is a kecamatan field, clear desa selection
              final text = field.questionText.toLowerCase();
              if (text.contains('kecamatan')) {
                // Find and clear desa field value
                for (var f in widget.fields) {
                  final fText = f.questionText.toLowerCase();
                  if (fText.contains('desa') || fText.contains('kelurahan')) {
                    widget.formValues[f.id] = null;
                  }
                }
              }
            });
          },
          validator: (value) => _validateField(field, value),
        );

      case 'radio':
        return CustomRadioGroup(
          field: field,
          value: widget.formValues[field.id] as String?,
          onChanged: (value) {
            setState(() {
              widget.formValues[field.id] = value;
            });
          },
          validator: (value) => _validateField(field, value),
        );

      case 'date':
        return CustomDatePicker(
          field: field,
          selectedDate: widget.formValues[field.id] as DateTime?,
          onDateSelected: (date) {
            setState(() {
              widget.formValues[field.id] = date;
            });
          },
          validator: (value) => _validateField(field, value),
        );

      case 'map':
        return MapPickerWidget(
          field: field,
          coordinates: widget.formValues[field.id] as Map<String, double>?,
          onCoordinatesSelected: (coords) {
            setState(() {
              widget.formValues[field.id] = coords;
            });
          },
          validator: (value) => _validateField(field, value),
        );

      case 'image':
        return CustomImagePicker(
          field: field,
          selectedImage: widget.formValues[field.id] as File?,
          onImageSelected: (image) {
            setState(() {
              widget.formValues[field.id] = image;
            });
          },
          validator: (value) => _validateField(field, value),
        );

      default:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange),
          ),
          child: Text(
            'Unsupported field type: ${field.questionType}',
            style: TextStyle(color: Colors.orange[900]),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: widget.fields.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final field = widget.fields[index];
          return _buildField(field);
        },
      ),
    );
  }

  // Method to get form values
  Map<String, dynamic> getFormValues() {
    final Map<String, dynamic> values = {};

    for (var field in widget.fields) {
      if (['text', 'number', 'textarea'].contains(field.questionType)) {
        values[field.id.toString()] = _controllers[field.id]?.text ?? '';
      } else {
        values[field.id.toString()] = widget.formValues[field.id];
      }
    }

    return values;
  }
}
