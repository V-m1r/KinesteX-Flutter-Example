import 'package:flutter/material.dart';
import '../models/exercise_overview_data.dart';
import '../models/workout_overview_data.dart';

class ExpandableStatsCard extends StatefulWidget {
  final ExerciseOverviewData? exerciseOverview;
  final WorkoutOverviewData? workoutOverview;

  const ExpandableStatsCard({
    Key? key,
    this.exerciseOverview,
    this.workoutOverview,
  }) : super(key: key);

  @override
  _ExpandableStatsCardState createState() => _ExpandableStatsCardState();
}

class _ExpandableStatsCardState extends State<ExpandableStatsCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Statistics'),
              subtitle: Text(
                  widget.workoutOverview?.data.workout ?? 'No workout data'),
              trailing:
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Completed percentage'),
                  Text(
                      '${widget.workoutOverview?.data.percentageCompleted.toStringAsFixed(2) ?? 0}%'),
                ],
              ),
            ),
            if (_isExpanded) ...[
              // Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      // Ensure text is aligned to the start
                      child: Text(
                        'Exercises',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.exerciseOverview?.data.isEmpty ?? true)
                      Text(
                        'No exercise data',
                        textAlign: TextAlign.start,
                      ),
                    if (!(widget.exerciseOverview?.data.isEmpty ?? true))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.exerciseOverview!.data.map((exercise) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildExerciseItem(
                                exercise.exercise,
                                '${exercise.timeSpent} secs',
                                '${exercise.repeats} reps',
                                '${exercise.calories.toStringAsFixed(2)} calories',
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(
      String name, String duration, String repeats, String calories) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      // Adjust the padding as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(duration),
              const SizedBox(width: 8), // Add some space between the texts
              Text(repeats),
              const SizedBox(width: 8), // Add some space between the texts
              Text(calories),
            ],
          ),
        ],
      ),
    );
  }
}
