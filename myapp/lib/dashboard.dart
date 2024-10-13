// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/authservice.dart';
import 'package:myapp/report.dart';
import 'package:myapp/stats.dart';

import 'package:myapp/workoutscreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}
final AuthService _authService = AuthService();
class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  String _username = '';
  String _age = '';
  String _weight = '';
  double _waterProgress = 0.0;
  double _stepProgress = 0.0;
  int _waterConsumed = 0;
     double waterIntake = 0;
   double stepTarget = 0;
   int _stepsWalked =0;

  List<Map<String, dynamic>> _workoutProgressData = [];

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _fetchWaterIntakeData(); // Fetch water intake data on initialization
    _fetchStepstakeData();
    _fetchWorkoutProgressData();
  }
  //  @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _fetchUserProfile();
  //   _fetchWaterIntakeData(); // Fetch water intake data on initialization
  //   _fetchStepstakeData();
  //   _fetchWorkoutProgressData();
  // }

  int _parseTarget(String target) {
    // Convert target string like '10 reps' or '3000 m' into an integer value
    return int.tryParse(target.split(' ')[0]) ?? 0;
  }
    Map<String, String> keyMapping = {
    "legpress": "Leg Press Progress (kg)",
    "squats": "Squats Progress (reps)",
    "weightlift": "Weight Lift Progress (kg)",
    "deadlift": "Dead Lift Progress (kg)",
    "pushups": "Push Ups Progress (reps)",
    "pullups": "Pull Ups Progress (reps)",
    "jumpingjacks": "Jumping Jacks Progress (reps)",
    "walking": "Walking Progress (metres)",
    "swimming": "Swimming Progress (metres)",
    "cycling": "Cycling Progress (metres)",
    "running": "Running Progress (metres)",
    "lunges": "Lunges Progress (reps)",
    "benchpress": "Bench Press Progress (reps)"
  };
  Color _getColorForWorkout(String workoutName) {
    // Assign colors to each workout type for better visualization
    switch (workoutName) {
      case 'Pull Ups Progress (reps)':
        return Colors.blue;
      case 'Push Ups Progress (reps)':
        return Colors.red;
      case 'Squats Progress (reps)':
        return Colors.green;
      case 'Cycling Progress (metres)':
        return Colors.orange;
      case 'Running Progress (metres)':
        return const Color.fromARGB(255, 147, 81, 159);
      case 'Bench Press Progress (reps)':
        return const Color.fromARGB(255, 140, 99, 187);
      case 'Lunges Progress (reps)':
        return const Color.fromARGB(255, 116, 213, 156);
      case 'Swimming Progress (metres)':
        return const Color.fromARGB(255, 189, 226, 129);
      case 'Walking Progress (metres)':
        return  const Color.fromARGB(255, 108, 227, 162);
      case 'Jumping Jacks Progress (reps)':
        return  const Color.fromARGB(217, 103, 220, 218);
      case 'Dead Lift Progress (kg)':
        return const Color.fromARGB(255, 217, 239, 75);
      case 'Weight Lift Progress (kg)':
        return  const Color.fromARGB(255, 155, 119, 65);
      case 'Leg Press Progress (kg)':
        return const Color.fromARGB(255, 10, 86, 227);
      default:
        return Colors.grey;
    }
  }
  Future<void> _fetchWorkoutProgressData() async {
      final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');
      String authHeader = 'Bearer $token'; 
    try {

            final response = await http.post(
        Uri.parse('http://localhost:8080/userdailydatatarget/$username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authHeader,
      },
      body: jsonEncode(<String, String>{
        "dummy" : "2", // Send the entered value in the body
      }),
    );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List workoutData = data['Workout'];
        setState(() {
          _workoutProgressData = workoutData.map<Map<String, dynamic>>((workout) {
            String newKey = keyMapping[workout['Name']] ?? workout['Name'];
            final String name = newKey;
            final int done = workout['Done'];
            final target = _parseTarget(workout['Target']);
            // final progress = workout[]
            // final double progress = target > 0 ? (done / target) * 100 : 0;

            return {
              'name': name,
              'progress': done,
              'target' : target,
              'color': _getColorForWorkout(name),
            };
          }).toList();
        });
      } else {
        print('Failed to load workout data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching workout progress data: $error');
    }
  }
  Future<void> _fetchStepstakeData() async {
        final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');
      String authHeader = 'Bearer $token'; 

    if (token == null || username == null) {
      print('Token or username is missing.');
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/userdailydata/$username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authHeader,
      },
      body: jsonEncode(<String, String>{
        "dummy" : "2", // Send the entered value in the body
      }),
    );
    final prefs = await SharedPreferences.getInstance();
    String? bmiString = prefs.getString('bmi');
    if (bmiString != null) {
      double bmi = double.tryParse(bmiString) ?? 0;
      print(bmi);
      // Calculate water intake based on BMI
      if (bmi < 18) {
        stepTarget = 10000;
      } else if (bmi >= 18 && bmi <= 25) {
        stepTarget = 12000;
      } else {
        stepTarget = 8000;
      }
    }
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          _stepsWalked = data['steps'];
          _stepProgress = (_stepsWalked / stepTarget).clamp(0.0, 1.0); // Ensure the value is between 0 and 1
          print("steps walked progress ");
          print(_stepProgress);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }


  Future<void> _fetchWaterIntakeData() async {
        final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');
      String authHeader = 'Bearer $token'; 

    if (token == null || username == null) {
      print('Token or username is missing.');
      return;
    }
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/userdailydata/$username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authHeader,
      },
      body: jsonEncode(<String, String>{
        "dummy" : "2", // Send the entered value in the body
      }),
    );
    final prefs = await SharedPreferences.getInstance();
    String? bmiString = prefs.getString('bmi');
    if (bmiString != null) {
      double bmi = double.tryParse(bmiString) ?? 0;
      print(bmi);
      // Calculate water intake based on BMI
      if (bmi < 18) {
        waterIntake = 3.0;
      } else if (bmi >= 18 && bmi <= 25) {
        waterIntake = 3.5;
      } else {
        waterIntake = 4.0;
      }
    }
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          _waterConsumed = data['water'];
          _waterProgress = (_waterConsumed / waterIntake).clamp(0.0, 1.0); // Ensure the value is between 0 and 1
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');

    if (token != null && username != null) {
      String authHeader = 'Bearer $token';
      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/getuser/$username'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': authHeader,
            'Accept': '*/*',
          },
          body: jsonEncode(<String, String>{
            'someKey': 'someValue', // If you need to send any data in the body
          }),
        );

        if (response.statusCode == 200) {
          String rawData = response.body;
          if (rawData.startsWith('w')) {
            rawData = rawData.substring(1); // Remove leading character
          }
          var userData = jsonDecode(rawData);
          await prefs.setString('weight', userData['weight'].toString());
          await prefs.setString('bmi', userData['bmi'].toString());
          setState(() {
            _username = userData['firstname'] ?? '';
            _age = (userData['age'] != null && userData['age'] >= 0)
                ? userData['age'].toString()
                : 'N/A';
            _weight = (userData['weight'] != null && userData['weight'] >= 0)
                ? userData['weight'].toString()
                : 'N/A';
          });
        } else {
          print('Error fetching user profile: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
       if (_selectedIndex == 0) {
         _fetchUserProfile();
    _fetchWaterIntakeData(); // Fetch water intake data on initialization
    _fetchStepstakeData();
    _fetchWorkoutProgressData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fitness Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.logout(); // Call the logout method
              Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login page
            },
          ),
        ],
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _selectedIndex == 0 
          ? DashboardScreen(username: _username, age: _age, weight: _weight, waterProgress: _waterProgress, waterConsumed: _waterConsumed, stepProgress: _stepProgress,stepConsumed: _stepsWalked,workoutProgressData: _workoutProgressData,) 
         : _selectedIndex == 1 
            ? WorkoutsScreen() 
            : _selectedIndex == 2
            ? StatsScreen()
            // : _ReportPageState(username: _username, age: _age, weight: _weight, waterProgress: _waterProgress, waterConsumed: _waterConsumed, stepConsumed: _stepsWalked, stepProgress: _stepProgress, workoutProgressData: _workoutProgressData),
            // : ReportPage(username: _username, age: _age, weight: _weight, waterProgress: _waterProgress, waterConsumed: _waterConsumed, stepProgress: _stepProgress,stepConsumed: _stepsWalked,workoutProgressData1: _workoutProgressData,),
            : ReportPage(),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize_sharp),
            label: 'Reports',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Color.fromARGB(255, 206, 224, 228),
        onTap: _onItemTapped,
      ),
    );
  }
}

// Main Dashboard Screen
class DashboardScreen extends StatelessWidget {
  final String username;
  final String age;
  final String weight;
  final double waterProgress;
  final int waterConsumed;
    final double stepProgress;
  final int stepConsumed;
  // final List<PieChartSectionData> workoutProgressData;
final List<Map<String, dynamic>> workoutProgressData;
  const DashboardScreen({
    Key? key,
    required this.username,
    required this.age,
    required this.weight,
    required this.waterProgress,
    required this.waterConsumed,
    required this.stepConsumed,
    required this.stepProgress,
     required this.workoutProgressData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUserProfile(),
          SizedBox(height: 20),
          // _buildWorkoutsCompleted(),
          SizedBox(height: 20),
          _buildWorkoutProgressCharts(context),
          SizedBox(height: 20),
          _buildWaterIntakeProgress(),
          SizedBox(height: 20),
          _buildStepsCounter(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWorkoutProgressCharts(BuildContext context) {
double value1;
double value2;


    
  return Wrap(
    spacing: 16.0, // Horizontal spacing between charts
    runSpacing: 16.0, // Vertical spacing between rows of charts
    children: workoutProgressData.map((workout) {
      if (workout['progress'] >= workout['target']) {
  value1 = workout['progress'].toDouble(); // Completed progress
  value2 = 0; // No remaining progress
} else {
  value1 = workout['progress'].toDouble(); // Completed progress
  value2 = (workout['target'] - workout['progress']).toDouble(); // Remaining progress
}
      return SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 24, // Width to fit two charts in a row
        child: Card(
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
                  children: [
                    Icon(Icons.pie_chart, color: workout['color']),
                    SizedBox(width: 10),
                    Text(
                      '${workout['name']} ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        // done 121, taget: 30
                        PieChartSectionData(
                          
                          value: value1,
                          // title: '${workout['progress'].toStringAsFixed(1)}%',
                          color: workout['color'],
                          radius: 35,
                          titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        PieChartSectionData(
                          value: value2,
                          color: Colors.grey.shade300,
                          radius: 35,
                        ),
                      ],
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  );
}


  Widget _buildUserProfile() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('user_profile.jpg'), // Change the path as necessary
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  username.isNotEmpty ? username : 'Loading...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Age: ${age.isNotEmpty ? age : 'Loading...'}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  'Weight: ${weight.isNotEmpty ? weight : 'Loading...'} kg',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildWorkoutsCompleted() {
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
              children: [
                Icon(Icons.fitness_center, color: Colors.blueAccent),
                SizedBox(width: 10),
                Text(
                  'Workouts Completed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('1. Running - 30 mins', style: TextStyle(color: Colors.grey.shade600)),
            Text('2. Cycling - 45 mins', style: TextStyle(color: Colors.grey.shade600)),
            Text('3. Swimming - 25 mins', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }









  // Widget _buildProgressChart() {
  //   return Card(
  //     elevation: 6,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Row(
  //             children: [
  //               Icon(Icons.show_chart, color: Colors.green),
  //               SizedBox(width: 10),
  //               Text(
  //                 'Workout Progress',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 10),
  //           SizedBox(
  //             height: 200,
  //             child: BarChart(
  //               BarChartData(
  //                 barTouchData: BarTouchData(enabled: false),
  //                 titlesData: FlTitlesData(show: true),
  //                 borderData: FlBorderData(show: false),
  //                 barGroups: [
  //                   BarChartGroupData(
  //                     x: 0,
  //                     barRods: [BarChartRodData(toY: 5, color: Colors.blue)],
  //                   ),
  //                   BarChartGroupData(
  //                     x: 1,
  //                     barRods: [BarChartRodData(toY: 3, color: Colors.red)],
  //                   ),
  //                   BarChartGroupData(
  //                     x: 2,
  //                     barRods: [BarChartRodData(toY: 6, color: Colors.green)],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildWaterIntakeProgress() {
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
              children: [
                Icon(Icons.local_drink, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Water Intake',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: waterProgress, // Use the dynamic value calculated from API response
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 10),
            Text(
              'You have consumed ${waterConsumed} liters today.', // Display water consumed in liters
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsCounter() {
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
              children: [
                Icon(Icons.directions_walk, color: const Color.fromARGB(255, 20, 160, 39)),
                SizedBox(width: 10),
                Text(
                  'Step Counter',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: stepProgress, // Use the dynamic value calculated from API response
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 10),
            Text(
              'You have walked  ${stepConsumed} steps today.', // Display water consumed in liters
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
