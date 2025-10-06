import 'validation_rules_model.dart';

class FormFieldModel {
  final int id;
  final String questionText;
  final String questionType;
  final String? questionDescription;
  final String? questionPlaceholder;
  final ValidationRulesModel validationRules;
  final List<dynamic>? options;

  FormFieldModel({
    required this.id,
    required this.questionText,
    required this.questionType,
    this.questionDescription,
    this.questionPlaceholder,
    required this.validationRules,
    this.options,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      id: json['id'] ?? 0,
      questionText: json['question_text'] ?? '',
      questionType: json['question_type'] ?? '',
      questionDescription: json['question_description'],
      questionPlaceholder: json['question_placeholder'],
      validationRules: ValidationRulesModel.fromJson(
        json['validation_rules'] ?? {},
      ),
      options: json['options'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'question_type': questionType,
      'question_description': questionDescription,
      'question_placeholder': questionPlaceholder,
      'validation_rules': validationRules.toJson(),
      'options': options,
    };
  }
}
