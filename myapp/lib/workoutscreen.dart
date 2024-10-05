// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildWorkoutCategory(
            title: 'Cardio Workouts',
            icon: Icons.directions_run,
            color: Colors.redAccent,
            workouts: [
              WorkoutDetail(
                name: 'Running',
                duration: '30 mins',
                caloriesBurned: 300,
              ),
              WorkoutDetail(
                name: 'Cycling',
                duration: '45 mins',
                caloriesBurned: 400,
              ),
              WorkoutDetail(
                name: 'Swimming',
                duration: '25 mins',
                caloriesBurned: 250,
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildWorkoutCategory(
            title: 'Strength Training',
            icon: Icons.fitness_center,

            color: Colors.black12,
            workouts: [
              WorkoutDetail(
                name: 'Weight Lifting',
                duration: '60 mins',
                caloriesBurned: 500,
              ),
              WorkoutDetail(
                name: 'Squats',
                duration: '40 mins',
                caloriesBurned: 300,
              ),
              WorkoutDetail(
                name: 'Deadlifts',
                duration: '45 mins',
                caloriesBurned: 350,
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildWorkoutCategory(
            title: 'Yoga & Flexibility',
            icon: Icons.self_improvement,
            color: Colors.greenAccent,
            workouts: [
              WorkoutDetail(
                name: 'Vinyasa Yoga',
                duration: '60 mins',
                caloriesBurned: 250,
              ),
              WorkoutDetail(
                name: 'Hatha Yoga',
                duration: '45 mins',
                caloriesBurned: 200,
              ),
              WorkoutDetail(
                name: 'Stretching',
                duration: '30 mins',
                caloriesBurned: 150,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Workout Category Card
  Widget _buildWorkoutCategory({
    required String title,
    required IconData icon,
    required Color color,
    required List<WorkoutDetail> workouts,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: color, size: 30),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ...workouts.map((workout) => _buildWorkoutDetail(workout)),
          ],
        ),
      ),
    );
  }

  // Individual Workout Detail Widget
  Widget _buildWorkoutDetail(WorkoutDetail workout) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.timer, color: Colors.grey.shade600),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  workout.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${workout.duration} | ${workout.caloriesBurned} kcal burned',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Workout Detail Class
class WorkoutDetail {
  final String name;
  final String duration;
  final int caloriesBurned;

  WorkoutDetail({
    required this.name,
    required this.duration,
    required this.caloriesBurned,
  });
}
