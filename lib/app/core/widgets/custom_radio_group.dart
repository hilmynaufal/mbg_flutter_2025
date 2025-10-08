import 'package:flutter/material.dart';
import '../../data/models/form_field_model.dart';

class CustomRadioGroup extends StatelessWidget {
  final FormFieldModel field;
  final String? value;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomRadioGroup({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Parse options from field.options
    final apiOptions = field.options ?? [];
    final options = apiOptions.map((option) {
      if (option is Map) {
        return {
          'value': option['value']?.toString() ?? '',
          'text': option['text']?.toString() ?? option['value']?.toString() ?? '',
        };
      } else {
        return {
          'value': option.toString(),
          'text': option.toString(),
        };
      }
    }).toList();

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

        // Radio buttons
        FormField<String>(
          initialValue: value,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: state.hasError
                          ? Theme.of(context).colorScheme.error
                          : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: options.map((option) {
                      final optionValue = option['value'] ?? '';
                      final optionText = option['text'] ?? '';

                      return RadioListTile<String>(
                        title: Text(optionText),
                        value: optionValue,
                        groupValue: value,
                        onChanged: (String? newValue) {
                          onChanged(newValue);
                          state.didChange(newValue);
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (state.hasError) ...[
                  const SizedBox(height: 8),
                  Text(
                    state.errorText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
