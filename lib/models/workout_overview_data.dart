class WorkoutOverviewData {
  final String type;
  final WorkoutData data;

  WorkoutOverviewData({required this.type, required this.data});

  factory WorkoutOverviewData.fromJson(Map<String, dynamic> json) {
    return WorkoutOverviewData(
      type: json['type'] ?? '',
      data: WorkoutData.fromJson(json['data'] ?? {}),
    );
  }

  static WorkoutOverviewData emptyData() {
    return WorkoutOverviewData(
      type: '',
      data: WorkoutData.emptyData(),
    );
  }
}

class WorkoutData {
  final String workout;
  final int totalTimeSpent;
  final int totalRepeats;
  final double totalCalories;
  final double percentageCompleted;
  final int totalMistakes;

  WorkoutData({
    required this.workout,
    required this.totalTimeSpent,
    required this.totalRepeats,
    required this.totalCalories,
    required this.percentageCompleted,
    required this.totalMistakes,
  });

  factory WorkoutData.fromJson(Map<String, dynamic> json) {
    return WorkoutData(
      workout: json['workout'] ?? 'No Workout',
      totalTimeSpent: json['total_time_spent'] ?? 0,
      totalRepeats: json['total_repeats'] ?? 0,
      totalCalories: (json['total_calories'] as num?)?.toDouble() ?? 0.0,
      percentageCompleted: (json['percentage_completed'] as num?)?.toDouble() ?? 0.0,
      totalMistakes: json['total_mistakes'] ?? 0,
    );
  }

  static WorkoutData emptyData() {
    return WorkoutData(
      workout: 'No Workout',
      totalTimeSpent: 0,
      totalRepeats: 0,
      totalCalories: 0.0,
      percentageCompleted: 0.0,
      totalMistakes: 0,
    );
  }
}
