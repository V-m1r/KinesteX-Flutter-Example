class ExerciseOverviewData {
  final String type;
  final List<ExerciseData> data;

  ExerciseOverviewData({required this.type, required this.data});

  factory ExerciseOverviewData.fromJson(Map<String, dynamic> json) {
    return ExerciseOverviewData(
      type: json['type'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ExerciseData.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  static ExerciseOverviewData emptyData() {
    return ExerciseOverviewData(type: '', data: []);
  }
}

class ExerciseData {
  final int timeSpent;
  final int repeats;
  final double calories;
  final String exercise;
  final List<Mistake> mistakes;

  ExerciseData({
    required this.timeSpent,
    required this.repeats,
    required this.calories,
    required this.exercise,
    required this.mistakes,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      timeSpent: json['time_spent'] ?? 0,
      repeats: json['repeats'] ?? 0,
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      exercise: json['exercise'] ?? '',
      mistakes: (json['mistakes'] as List<dynamic>?)
          ?.map((e) => Mistake.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class Mistake {
  final String name;
  final int count;

  Mistake({required this.name, required this.count});

  factory Mistake.fromJson(Map<String, dynamic> json) {
    final entry = json.entries.first;
    return Mistake(
      name: entry.key,
      count: (entry.value as num?)?.toInt() ?? 0,
    );
  }
}
