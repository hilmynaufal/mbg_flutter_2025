import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/form_field_model.dart';

class CustomDatePicker extends StatelessWidget {
  final FormFieldModel field;
  final DateTime? selectedDate;
  final void Function(DateTime?) onDateSelected;
  final String? Function(String?)? validator;

  const CustomDatePicker({
    super.key,
    required this.field,
    required this.selectedDate,
    required this.onDateSelected,
    this.validator,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final displayText = selectedDate != null
        ? dateFormat.format(selectedDate!)
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
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: field.questionPlaceholder ?? 'Pilih ${field.questionText}',
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            child: Text(
              displayText,
              style: selectedDate != null
                  ? Theme.of(context).textTheme.bodyMedium
                  : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
            ),
          ),
        ),
        // Hidden FormField for validation
        FormField<DateTime>(
          initialValue: selectedDate,
          validator: (value) {
            if (validator != null) {
              final dateString = value != null ? dateFormat.format(value) : null;
              return validator!(dateString);
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
