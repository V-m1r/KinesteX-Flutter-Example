# [KinesteX AI](https://kinestex.com)
## INTEGRATE AI FITNESS & PHYSIO TRAINER IN YOUR APP IN MINUTES

## Available Integration Options

### Integration Options

| **Integration Option**         | **Description**                                                                                                 | **Features**                                                                                                                                     | **Details**                                                                                                             |
|--------------------------------|-----------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| **Complete User Experience**   | Leave it to us to recommend the best workout routines for your customers, handle motion tracking, and overall user interface. High level of customization based on your brand book for a seamless experience. | - Long-term lifestyle workout plans <br> - Specific body parts and full-body workouts <br> - Individual exercise challenges (e.g., 20 squat challenge) | [View Integration Options](https://www.figma.com/proto/XYEoV023iSFdhpw3w65zR1/Complete?page-id=0%3A1&node-id=0-1&viewport=793%2C330%2C0.1&t=d7VfZzKpLBsJAcP9-1&scaling=contain) |
| **Custom User Experience**     | Integrate the camera component with motion tracking. Real-time feedback on all customer movements. Control the position, size, and placement of the camera component. | - Real-time feedback on customer movements <br> - Communication of every repeat and mistake <br> - Customizable camera component position, size, and placement | [View Details](https://www.figma.com/proto/JyPHuRKKbiQkwgiDTkGJgT/Camera-Component?page-id=0%3A1&node-id=1-4&viewport=925%2C409%2C0.22&t=3UccMcp1o3lKc0cP-1&scaling=contain) |

---
## Configuration

### Permissions

#### AndroidManifest.xml

Add the following permissions for camera and microphone usage:

```xml
<!-- Add this line inside the <manifest> tag -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.VIDEO_CAPTURE" />
```

#### Info.plist

Add the following keys for camera and microphone usage:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for video streaming.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for video streaming.</string>
```

### Install libraries

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
   kinestex_sdk_flutter: ^@latest
```

## Usage

### Initial Setup

1. **Prerequisites**: Ensure you’ve added the necessary permissions in `AndroidManifest.xml` and `Info.plist`.

2. **Launching the View**: Initialize essential widgets, check, and request for camera permission before launching KinesteX.

```dart
void _checkCameraPermission() async {
   if (await Permission.camera.request() != PermissionStatus.granted) {
      _showCameraAccessDeniedAlert();
   }
}

void _showCameraAccessDeniedAlert() {
   showDialog(
      context: context,
      builder: (BuildContext context) {
         return AlertDialog(
            title: const Text("Camera Permission Denied"),
            content: const Text("Camera access is required for this app to function properly."),
            actions: <Widget>[
               TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                     Navigator.of(context).pop();
                  },
               ),
            ],
         );
      },
   );
}
```
## 1. Selecting workouts, challenges, and plans
We have a collection of workouts, challenges, and plans from which you can select to display to your users. Please view available routines here: https://kinestex-plans.vercel.app/

## 2. Displaying workouts, challenges, and plans

a. To display individual workout, please use our `KinesteXAIFramework.createWorkoutView` function. 

Here is the usage of this function:
```dart
Widget createWorkoutView() {
    return Center(
      child: KinesteXAIFramework.createWorkoutView(
          apiKey: apiKey,
          isShowKinesTex: showKinesteX,
          companyName: company,
          userId: userId,
          workoutName: selectedWorkoutName!, // the name of the workout which you can find by following the link above https://kinestex-plans.vercel.app
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

```
b. To display individual challenge, please use our  `KinesteXAIFramework.createChallengeView`

Here is the usage of this function:
```dart
Widget createChallengeView() {
    return Center(
      child: KinesteXAIFramework.createChallengeView(
          apiKey: apiKey,
          companyName: company,
          isShowKinesTex: showKinesteX,
          userId: userId,
          exercise: selectedChallenge!, // exercise name to be presented as a challenge
          countdown: 100, // countdown for the challenge
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

```

c. To display individual workout plan, please use our `KinesteXAIFramework.createPlanView`

And the usage of this function is as following: 
```dart
Widget createPlanView() {
    return Center(
      child: KinesteXAIFramework.createPlanView(
          apiKey: apiKey,
          companyName: company,
          userId: userId,
          isShowKinesTex: showKinesteX,
          planName: selectedPlanName!, // plan name to be presented 
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

```

## 3. Processing the data:

We send the data to you as a value of a WebViewMessage class where we have different values depending on the current use case in our platform. 
The list of available data points is below, they will be passed as following instances: 

```dart
factory WebViewMessage.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;

    switch (type) {
      case 'kinestex_launched':
        return KinestexLaunched(json); 
      case 'finished_workout':
        return FinishedWorkout(json);
      case 'error_occurred':
        return ErrorOccurred(json);
      case 'exercise_completed':
        return ExerciseCompleted(json);
      case 'exit_kinestex':
        return ExitKinestex(json);
      case 'workout_opened':
        return WorkoutOpened(json);
      case 'workout_started':
        return WorkoutStarted(json);
      case 'plan_unlocked':
        return PlanUnlocked(json);
      case 'mistake':
        return Mistake(json);
      case 'successful_repeat':
        return Reps(json);
      case 'left_camera_frame':
        return LeftCameraFrame(json);
      case 'returned_camera_frame':
        return ReturnedCameraFrame(json);
      case 'workout_overview':
        return WorkoutOverview(json);
      case 'exercise_overview':
        return ExerciseOverview(json);
      case 'workout_completed':
        return WorkoutCompleted(json);
      default:
        return CustomType(json);
    }
}

class KinestexLaunched extends WebViewMessage {
  const KinestexLaunched(Map<String, dynamic> data) : super(data);
}

// ...

```

To handle the statistics data, you can use ExerciseOverview (complete log, exercise by exercise of how many reps have been done, how many calories burnt, seconds spent, and mistakes made) and WorkoutOverview (overall total reps, percentage completed, calories burnt, mistakes made, time spent) classes. 

1.  Process the post message for exercise_overview and workout_overview by creating model classes to store and process the values: 
```dart
// exercise_overview class
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

// workout_overview class:
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

```

2. Create value notifiers for real-time updated from ExerciseOverview and WorkoutOverview post messages: 
```dart
final ValueNotifier<ExerciseOverviewData> currentExerciseOverviewNotifier =
      ValueNotifier<ExerciseOverviewData>(ExerciseOverviewData.emptyData());
  final ValueNotifier<WorkoutOverviewData> currentWorkoutOverviewNotifier =
      ValueNotifier<WorkoutOverviewData>(WorkoutOverviewData.emptyData());


```
3. Handle the incoming post message:
```dart
void handleWebViewMessage(WebViewMessage message) {
    if (message is ExitKinestex) {
      setState(() {
        showKinesteX.value = false;
      });
    } else if (message is ExerciseOverview) {
      ExerciseOverviewData exerciseOverview =
          ExerciseOverviewData.fromJson(message.data);

      List<ExerciseData> filteredData = exerciseOverview.data
          .where((exercise) => exercise.timeSpent > 0)
          .toList();

      ExerciseOverviewData filteredExerciseOverview =
          ExerciseOverviewData(type: exerciseOverview.type, data: filteredData);

      currentExerciseOverviewNotifier.value = filteredExerciseOverview;
    } else if (message is WorkoutOverview) {
      WorkoutOverviewData workoutOverview =
          WorkoutOverviewData.fromJson(message.data);
      currentWorkoutOverviewNotifier.value = workoutOverview;
    } else {
      print("Other message received: ${message.data}");
    }
  }

```

## 4. You can choose to display the processed data however you want easily. Please refer to the example [here](https://github.com/V-m1r/KinesteX-Flutter-Example/blob/main/lib/views/expandable_stats_card.dart)



## Data Points

The KinesteX SDK provides various data points that are returned through the message callback. Here are the available data types:

| Type                       | Data                                                                                   | Description                                                                                               |
|----------------------------|----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| `kinestex_launched`        | `dd mm yyyy hours:minutes:seconds`                                                      | When a user has launched KinesteX                                                                          |
| `exit_kinestex`            | `date: dd mm yyyy hours:minutes:seconds`, `time_spent: number`                          | Logs when a user clicks the exit button and the total time spent                                           |
| `plan_unlocked`            | `title: String, date: date and time`                                                    | Logs when a workout plan is unlocked by a user                                                            |
| `workout_opened`           | `title: String, date: date and time`                                                    | Logs when a workout is opened by a user                                                                   |
| `workout_started`          | `title: String, date: date and time`                                                    | Logs when a workout is started by a user                                                                  |
| `exercise_completed`       | `time_spent: number`, `repeats: number`, `calories: number`, `exercise: string`, `mistakes: [string: number]` | Logs each time a user finishes an exercise                                                                 |
| `total_active_seconds`     | `number`                                                                                | Logs every 5 seconds, counting the active seconds a user has spent working out                            |
| `left_camera_frame`        | `number`                                                                                | Indicates that a user has left the camera frame                                                           |
| `returned_camera_frame`    | `number`                                                                                | Indicates that a user has returned to the camera frame                                                    |
| `workout_overview`         | `workout: string`, `total_time_spent: number`, `total_repeats: number`, `total_calories: number`, `percentage_completed: number`, `total_mistakes: number` | Logs a complete summary of the workout                                                                    |
| `exercise_overview`        | `[exercise_completed]`                                                                 | Returns a log of all exercises and their data                                                             |
| `workout_completed`        | `workout: string`, `date: dd mm yyyy hours:minutes:seconds`                             | Logs when a user finishes the workout and exits the workout overview                                      |
| `active_days` (Coming soon)| `number`                                                                                | Represents the number of days a user has been opening KinesteX                                             |
| `total_workouts` (Coming soon)| `number`                                                                            | Represents the number of workouts a user has done since starting to use KinesteX                          |
| `workout_efficiency` (Coming soon)| `number`                                                                        | Represents the level of intensity with which a person has completed the workout                           |
## Contact

If you have any questions, contact: [support@kinestex.com](mailto:support@kinestex.com)

