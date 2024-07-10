import 'dart:convert';

import 'package:KinesteX_B2B/models/workout_overview_data.dart';

void convertJsonToModel() {
  // Your JSON string
  String jsonString = '{"type": "workout_overview", "data": {"workout": "Fitness Lite", "total_time_spent": 21, "total_repeats": 150, "total_calories": 48, "percentage_completed": 2.666666666666667, "total_mistakes": 2}}';

  // Parse the JSON string
  Map<String, dynamic> jsonMap = json.decode(jsonString);

  WorkoutOverviewData workoutOverview = WorkoutOverviewData.fromJson(jsonMap); // Create the WorkoutOverview object


  // Now you can access the data like this:
  print(workoutOverview.type); // "workout_overview"
  print(workoutOverview.data.workout); // "Fitness Lite"
  print(workoutOverview.data.totalTimeSpent); // 21
  print(workoutOverview.data.percentageCompleted); // 2.666666666666667
}