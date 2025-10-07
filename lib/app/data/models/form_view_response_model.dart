class QuestionAnswer {
  final String question;
  final String answer;

  QuestionAnswer({
    required this.question,
    required this.answer,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      question: json['question'] as String,
      answer: json['answer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }

  /// Check if answer is an image URL
  bool get isImageUrl {
    final lowerAnswer = answer.toLowerCase();
    return (lowerAnswer.startsWith('http') &&
        (lowerAnswer.endsWith('.jpg') ||
            lowerAnswer.endsWith('.jpeg') ||
            lowerAnswer.endsWith('.png') ||
            lowerAnswer.endsWith('.gif') ||
            lowerAnswer.contains('.jpg?') ||
            lowerAnswer.contains('.jpeg?') ||
            lowerAnswer.contains('.png?')));
  }
}

class FormViewResponseModel {
  final int id;
  final String submittedAt;
  final String submittedBy;
  final String? skpdNama;
  final List<QuestionAnswer> answers;

  FormViewResponseModel({
    required this.id,
    required this.submittedAt,
    required this.submittedBy,
    this.skpdNama,
    required this.answers,
  });

  factory FormViewResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return FormViewResponseModel(
      id: data['id'] as int,
      submittedAt: data['submitted_at'] as String,
      submittedBy: data['submitted_by'] as String,
      skpdNama: data['skpd_nama'] as String?,
      answers: (data['answers'] as List<dynamic>)
          .map((item) => QuestionAnswer.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'id': id,
        'submitted_at': submittedAt,
        'submitted_by': submittedBy,
        'skpd_nama': skpdNama,
        'answers': answers.map((item) => item.toJson()).toList(),
      }
    };
  }
}
