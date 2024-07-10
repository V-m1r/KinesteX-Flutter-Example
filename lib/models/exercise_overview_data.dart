class ExerciseOverviewData {
  final String type;
  final List<ExerciseData> data;

  ExerciseOverviewData({required this.type, required this.data});

  factory ExerciseOverviewData.fromJson(Map<String, dynamic> json) {
    return ExerciseOverviewData(
      type: json['type'],
      data: (json['data'] as List).map((e) => ExerciseData.fromJson(e)).toList(),
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
      timeSpent: json['time_spent'],
      repeats: json['repeats'],
      calories: json['calories'].toDouble(),
      exercise: json['exercise'],
      mistakes: (json['mistakes'] as List).map((e) => Mistake.fromJson(e)).toList(),
    );
  }
}



class Mistake {
  final String description;
  final int count;

  Mistake({required this.description, required this.count});

  factory Mistake.fromJson(Map<String, dynamic> json) {
    final entry = json.entries.first;
    return Mistake(
      description: entry.key,
      count: entry.value,
    );
  }
}