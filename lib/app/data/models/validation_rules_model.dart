class ValidationRulesModel {
  final int required;
  final String? minValue;
  final String? maxValue;
  final int? minLength;
  final int? maxLength;
  final String? regexPattern;

  ValidationRulesModel({
    required this.required,
    this.minValue,
    this.maxValue,
    this.minLength,
    this.maxLength,
    this.regexPattern,
  });

  factory ValidationRulesModel.fromJson(Map<String, dynamic> json) {
    return ValidationRulesModel(
      required: json['required'] ?? 0,
      minValue: json['min_value']?.toString(),
      maxValue: json['max_value']?.toString(),
      minLength: json['min_length'],
      maxLength: json['max_length'],
      regexPattern: json['regex_pattern'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'min_value': minValue,
      'max_value': maxValue,
      'min_length': minLength,
      'max_length': maxLength,
      'regex_pattern': regexPattern,
    };
  }

  bool get isRequired => required == 1;
}
