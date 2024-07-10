// ignore_for_file: sort_child_properties_last

import 'dart:developer';
import 'package:KinesteX_B2B/Option.dart';
import 'package:KinesteX_B2B/views/expandable_stats_card.dart';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/exercise_overview_data.dart';
import 'models/workout_overview_data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String apiKey = YOURAPIKEY;
  String company = YOUR COMPANY NAME;
  String userId = "user1";

  ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);
  String? selectedPlanName;
  String? selectedWorkoutName;
  String? selectedChallenge;

  final ValueNotifier<ExerciseOverviewData> currentExerciseOverviewNotifier =
      ValueNotifier<ExerciseOverviewData>(ExerciseOverviewData.emptyData());
  final ValueNotifier<WorkoutOverviewData> currentWorkoutOverviewNotifier =
      ValueNotifier<WorkoutOverviewData>(WorkoutOverviewData.emptyData());

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

  void _checkCameraPermission() async {
    if (await Permission.camera.request() != PermissionStatus.granted) {
      _showCameraAccessDeniedAlert(context);
    }
  }

  void _showCameraAccessDeniedAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Camera Permission Denied"),
          content: const Text(
              "Camera access is required for this app to function properly."),
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

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showKinesteX,
      builder: (context, isShowKinesteX, child) {
        if (isShowKinesteX) {
          if (selectedPlanName != null) {
            return SafeArea(child: createPlanView());
          } else if (selectedWorkoutName != null) {
            return SafeArea(child: createWorkoutView());
          } else if (selectedChallenge != null) {
            return SafeArea(child: createChallengeView());
          }
        }
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  ValueListenableBuilder<ExerciseOverviewData?>(
                    valueListenable: currentExerciseOverviewNotifier,
                    builder: (context, exerciseOverview, _) {
                      if (exerciseOverview == null) {
                        // Return a widget or null if exerciseOverview is null
                        return const SizedBox(); // or return null;
                      } else {
                        return ValueListenableBuilder<WorkoutOverviewData?>(
                          valueListenable: currentWorkoutOverviewNotifier,
                          builder: (context, workoutOverview, _) {
                            if (workoutOverview == null) {
                              // Return a widget or null if workoutOverview is null
                              return const SizedBox(); // or return null;
                            } else {
                              return ExpandableStatsCard(
                                exerciseOverview: exerciseOverview,
                                workoutOverview: workoutOverview,
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                  Expanded(
                    child:
                        initialComponent(), // Assuming this is your fallback widget
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget initialComponent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildHorizontalSection(
            title: 'Challenges',
            items: ['Squats', 'Jumping Jack', 'Lunges'],
            onTap: (item) {
              setState(() {
                selectedChallenge = item;
                selectedPlanName = null;
                selectedWorkoutName = null;
                showKinesteX.value = true;
              });
            },
          ),
          buildHorizontalSection(
            title: 'Workouts',
            items: ['Fitness Lite', 'Cardio Core', 'Circuit Training'],
            onTap: (item) {
              setState(() {
                selectedWorkoutName = item;
                selectedPlanName = null;
                selectedChallenge = null;
                showKinesteX.value = true;
              });
            },
          ),
          buildHorizontalSection(
            title: 'Workout Plans',
            items: ['Circuit Training', 'Fitness Cardio'],
            onTap: (item) {
              setState(() {
                selectedPlanName = item;
                selectedWorkoutName = null;
                selectedChallenge = null;
                showKinesteX.value = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildHorizontalSection({
    required String title,
    required List<String> items,
    required Function(String) onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items.map((item) {
              return Container(
                width: 200, // Adjust the width as necessary
                margin: const EdgeInsets.only(right: 10),
                child: Card(
                  color: const Color.fromARGB(255, 48, 48, 48),
                  child: InkWell(
                    onTap: () => onTap(item),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          item,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget createPlanView() {
    return Center(
      child: KinesteXAIFramework.createPlanView(
          apiKey: apiKey,
          companyName: company,
          userId: userId,
          isShowKinesTex: showKinesteX,
          planName: selectedPlanName!,
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

  Widget createWorkoutView() {
    return Center(
      child: KinesteXAIFramework.createWorkoutView(
          apiKey: apiKey,
          isShowKinesTex: showKinesteX,
          companyName: company,
          userId: userId,
          workoutName: selectedWorkoutName!,
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

  Widget createChallengeView() {
    return Center(
      child: KinesteXAIFramework.createChallengeView(
          apiKey: apiKey,
          companyName: company,
          isShowKinesTex: showKinesteX,
          userId: userId,
          exercise: selectedChallenge!,
          countdown: 100,
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }
}
