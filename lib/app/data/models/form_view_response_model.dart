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

  /// Check if answer is a coordinate (latitude, longitude format)
  /// Supports formats: "-6.9175, 107.6191" or "-6.9175,107.6191"
  bool get isCoordinate {
    if (answer.trim().isEmpty) return false;

    // Regex pattern for coordinate format: number, number
    // Supports: -6.9175, 107.6191 or -6.9175,107.6191
    final coordRegex = RegExp(r'^-?\d+\.?\d*\s*,\s*-?\d+\.?\d*$');
    return coordRegex.hasMatch(answer.trim());
  }

  /// Parse coordinate string to Map with latitude and longitude
  /// Returns null if answer is not a valid coordinate
  Map<String, double>? get coordinateValues {
    if (!isCoordinate) return null;

    try {
      final parts = answer.split(',').map((e) => e.trim()).toList();
      if (parts.length != 2) return null;

      final lat = double.tryParse(parts[0]);
      final lng = double.tryParse(parts[1]);

      if (lat == null || lng == null) return null;

      // Validate coordinate ranges
      // Latitude: -90 to 90, Longitude: -180 to 180
      if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
        return null;
      }

      return {
        'latitude': lat,
        'longitude': lng,
      };
    } catch (e) {
      return null;
    }
  }
}

class FormViewResponseModel {
  final int id;
  final String? slug;
  final String submittedAt;
  final String submittedBy;
  final String? skpdNama;
  final List<QuestionAnswer> answers;

  FormViewResponseModel({
    required this.id,
    this.slug,
    required this.submittedAt,
    required this.submittedBy,
    this.skpdNama,
    required this.answers,
  });

  factory FormViewResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return FormViewResponseModel(
      id: data['id'] as int,
      slug: data['slug'] as String?,
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
        'slug': slug,
        'submitted_at': submittedAt,
        'submitted_by': submittedBy,
        'skpd_nama': skpdNama,
        'answers': answers.map((item) => item.toJson()).toList(),
      }
    };
  }
}
