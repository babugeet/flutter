// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/profilescreen.dart';
import 'package:myapp/workoutscreen.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  String _username = '';
  String _age = '';
  String _weight = '';

  // List of widgets for each section
  final List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    WorkoutsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    // Retrieve the token and username from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');
print("token not found");
print(token);
print(username);
    if (token != null && username != null) {
      print("token found");
      // Prepare the authorization header
      String authHeader = 'Bearer ${token}';
      print(authHeader);
      print(username);
      try {
        // Make the GET request
        // Response response = await Dio().get(
        //   'http://localhost:8080/getuser/$username',
        //   options: Options(headers: {'Authorization': authHeader}),
        // );
      // final response = await http.post(
      //   Uri.parse('http://localhost:8080/getuser/$username'),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //     // 'Accept': 'application/json',
      //     'Origin':'http://localhost:8081',
      //    'Authorization': authHeader,
      //    'Accept': '*/*',
      //   },
      // );
      Response response = await Dio().post(
  'http://localhost:8080/getuser/$username',
  options: Options(
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Origin': 'http://localhost:8080',
    },
  ),  data: { 
    // Include any data you want to send in the body, if needed
    'someKey': 'someValue' 
  },
);
        // Check the response status
        if (response.statusCode == 200) {
          // Parse the response and update the state
          // var userData = response.body;
          // print(userData);
          // setState(() {
          //   _username = userData['username'] ?? '';
          //   _age = userData['age']?.toString() ?? 'N/A';
          //   _weight = userData['weight']?.toString() ?? 'N/A';
          // });
        } else {
          // Handle the error response
          print('Error fetching user profile: ${response.statusCode}');
        }
      } catch (e) {
        // Handle any errors
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fitness Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _widgetOptions.elementAt(_selectedIndex), // Display selected page
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
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Diet',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Main Dashboard Screen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUserProfile(context), // Pass context to fetch user profile
          SizedBox(height: 20),
          _buildWorkoutsCompleted(),
          SizedBox(height: 20),
          _buildProgressChart(),
          SizedBox(height: 20),
          _buildWaterIntakeProgress(),
          SizedBox(height: 20),
          _buildStepsCounter(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    final _DashboardPageState dashboardState = context.findAncestorStateOfType<_DashboardPageState>()!;

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
              backgroundImage: AssetImage('assets/user_profile.jpg'),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dashboardState._username.isNotEmpty ? dashboardState._username : 'Loading...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Age: ${dashboardState._age.isNotEmpty ? dashboardState._age : 'Loading...'}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  'Weight: ${dashboardState._weight.isNotEmpty ? dashboardState._weight : 'Loading...'} kg',
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

  Widget _buildProgressChart() {
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
                Icon(Icons.show_chart, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  'Workout Progress',
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
              height: 200,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 30,
                          color: Colors.blueAccent,
                          width: 20,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 50,
                            color: Colors.blue.shade100,
                          ),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 45,
                          color: Colors.greenAccent,
                          width: 20,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 50,
                            color: Colors.green.shade100,
                          ),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: 25,
                          color: Colors.redAccent,
                          width: 20,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 50,
                            color: Colors.red.shade100,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                Icon(Icons.local_drink, color: Colors.lightBlueAccent),
                SizedBox(width: 10),
                Text(
                  'Daily Water Intake',
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
              value: 0.75, // 75% of water intake goal
              backgroundColor: Colors.grey.shade300,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 10),
            Text('Goal: 3 L', style: TextStyle(color: Colors.grey.shade600)),
            Text('Intake: 2.25 L', style: TextStyle(color: Colors.grey.shade600)),
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
                Icon(Icons.directions_walk, color: Colors.purpleAccent),
                SizedBox(width: 10),
                Text(
                  'Steps Counter',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Steps Today: 7,500', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
