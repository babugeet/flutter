// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/profilescreen.dart';
import 'package:myapp/workoutscreen.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');
    
    if (token != null && username != null) {
      String authHeader = 'Bearer $token';
      try {
        final response = await http.post(
        //   Uri.parse('http://localhost:8080/getuser/$username'),
        //   headers: <String, String>{
        //     'Content-Type': 'application/json; charset=UTF-8',
        //     'Authorization': authHeader,
        //   },
        // );
                // final response = await http.post(
          Uri.parse('http://localhost:8080/getuser/$username'),
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
          String rawData = response.body;
          if (rawData.startsWith('w')) {
            rawData = rawData.substring(1); // Remove leading character
          }
          var userData = jsonDecode(rawData);

          setState(() {
            _username = userData['username'] ?? '';
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
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _selectedIndex == 0 
          ? DashboardScreen(username: _username, age: _age, weight: _weight) 
          : _selectedIndex == 1 
            ? WorkoutsScreen() 
            : ProfileScreen(), // Assuming WorkoutsScreen and ProfileScreen are stateless too
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
  final String username;
  final String age;
  final String weight;

  const DashboardScreen({
    Key? key,
    required this.username,
    required this.age,
    required this.weight,
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
              backgroundImage: AssetImage('user_profile.jpg'),
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
              value: 0.5,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 10),
            Text(
              'You have consumed 1.5 liters today.',
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
                Icon(Icons.directions_walk, color: Colors.orange),
                SizedBox(width: 10),
                Text(
                  'Steps Counted',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('You have walked 5,000 steps today.', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
