import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  _WorkoutsScreenState createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  Future<List<WorkoutDetail>>? cardioWorkoutsFuture;
  Future<List<WorkoutDetail>>? strengthWorkoutsFuture;

  @override
  void initState() {
    super.initState();
    cardioWorkoutsFuture = fetchCardioWorkouts();
    strengthWorkoutsFuture = fetchStrengthWorkouts();
  }

  Future<List<WorkoutDetail>> fetchCardioWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token1');
      String? username = prefs.getString('userna1me');

      if (token == null || username == null) {
        print('Token or username is missing.');
        return [];
      }

      String authHeader = 'Bearer $token';
      final response = await http.post(
        Uri.parse('http://localhost:8080/getuser/$username/cardioplan'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
            'Origin': 'http://localhost:8081',
          'Authorization': authHeader,
            'Accept': '*/*',
        },
        body: jsonEncode(<String, String>{
          'someKey': 'someValue', // If you need to send any data in the body
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return parseWorkoutData(data);
      } else {
        print('Failed to load cardio workouts. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching cardio workouts: $e');
      return [];
    }
  }

  Future<List<WorkoutDetail>> fetchStrengthWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token1');
      String? username = prefs.getString('userna1me');
      String? weight = prefs.getString('weight');

      if (token == null || username == null) {
        print('Token or username is missing.');
        return [];
      }

      String authHeader = 'Bearer $token';
      final response = await http.post(
        Uri.parse('http://localhost:8080/getuser/$username/workoutplan'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
            'Origin': 'http://localhost:8081',
          'Authorization': authHeader,
            'Accept': '*/*',
        },
        body: jsonEncode(<String, String>{
          'someKey': 'someValue', // If you need to send any data in the body
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return parseWorkoutData(data);
      } else {
        print('Failed to load strength workouts. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching strength workouts: $e');
      return [];
    }
  }

  List<WorkoutDetail> parseWorkoutData(Map<String, dynamic> data) {
    final Map<String, String> workoutLabels = {
      "legpress": "Leg Press",
      "squats": "Squats",
      "weightlift": "Weight Lift",
      "deadlift": "Dead Lift",
      "pushups": "Push Ups",
      "pullups": "Pull Ups",
      "jumpingjacks": "Jumping Jacks",
      "walking": "Walking",
      "swimming": "Swimming",
      "cycling": "Cycling",
      "running": "Running",
      "lunges": "Lunges",
      "benchpress": "Bench Press"
    };

    return data.entries.map((entry) {
      String readableName = workoutLabels[entry.key] ?? entry.key; // Use a fallback if the key isn't in the map

      // Assuming the entry value is the weight; adjust if your API structure is different
      // int weight = int.tryParse(entry.value.toString()) ?? 0; // Get the weight from the entry value

      return WorkoutDetail(
        name: readableName,
        duration: entry.value, // You can adjust this as needed
        weight: entry.value.toString(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder<List<WorkoutDetail>>(
            future: cardioWorkoutsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No cardio workouts found.');
              } else {
                return _buildWorkoutCategory(
                  title: 'Cardio Workouts',
                  icon: Icons.directions_run,
                  color: Colors.redAccent,
                  workouts: snapshot.data!,
                );
              }
            },
          ),
          SizedBox(height: 20),
          FutureBuilder<List<WorkoutDetail>>(
            future: strengthWorkoutsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No strength workouts found.');
              } else {
                return _buildWorkoutCategory(
                  title: 'Strength Training',
                  icon: Icons.fitness_center,
                  color: Colors.black12,
                  workouts: snapshot.data!,
                );
              }
            },
          ),
          SizedBox(height: 20),
          _buildWorkoutCategory(
            title: 'Diet Plan',
            icon: Icons.self_improvement,
            color: Colors.greenAccent,
            workouts: [
              WorkoutDetail(
                name: 'Egg white',
                duration: '60 mins',
                weight: "0", // Not applicable for diet
              ),
              WorkoutDetail(
                name: 'Chicken 150g',
                duration: '45 mins',
                weight: "0", // Not applicable for diet
              ),
              WorkoutDetail(
                name: 'Rice 50g',
                duration: '30 mins',
                weight: "0", // Not applicable for diet
              ),
            ],
          ),
        ],
      ),
    );
  }

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

class WorkoutDetail {
  final String name;
  final String duration;
  // final int weight; // Weight property to hold the weight value
  final int caloriesBurned;
  final String weight;

  WorkoutDetail({
    required this.name,
    required this.duration,
    required this.weight,
  }) : caloriesBurned = calculateCalories(name, duration, weight);

  static int calculateCalories(String exerciseName, String duration, String weight) {
    int minutes = int.tryParse(duration.split(' ')[0]) ?? 0;
    int userWeight = int.tryParse(weight.split(' ')[0]) ?? 0;
    // A simple calorie calculation logic based on exercise type and weight
    switch (exerciseName.toLowerCase()) {
      case 'leg press':
        return ((minutes) * userWeight * 5).toInt(); // Example calculation
      case 'squats':
        return (minutes * userWeight * 5).toInt(); // Example calculation
      case 'weight lift':
        return (minutes * userWeight * 6).toInt(); // Example calculation
      case 'deadlift':
        return (minutes * userWeight * 6).toInt(); // Example calculation
      case 'push ups':
        return (minutes * userWeight *8).toInt(); // Example calculation
      case 'pull ups':
        return (minutes * userWeight *8).toInt(); // Example calculation
      case 'jumping jacks':
        return (minutes * userWeight *8).toInt(); // Example calculation
      case 'walking':
        return (minutes * userWeight *3.8).toInt(); // Example calculation
      case 'swimming':
        return (minutes * userWeight *7).toInt(); // Example calculation
      case 'cycling':
        return (minutes * userWeight *8).toInt(); // Example calculation
      case 'running':
        return (minutes * userWeight *9.8).toInt(); // Example calculation
      case 'lunges':
        return (minutes * userWeight *5).toInt(); // Example calculation
      case 'bench press':
        return (minutes * userWeight *5.5).toInt(); // Example calculation
      // Add more cases as needed
      default:
        return 0; // Default to 0 calories if no match
    }
  }
}
