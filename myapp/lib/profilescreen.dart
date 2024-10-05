// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildPersonalDetails(),
            SizedBox(height: 20),
            _buildBodyMetrics(),
            SizedBox(height: 20),
            _buildAchievements(),
          ],
        ),
      ),
    );
  }

  // User profile header section
  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/user_profile.jpg'), // Replace with user's image
          ),
          SizedBox(height: 16),
          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            'Age: 30 | Male',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Personal Details section
  Widget _buildPersonalDetails() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Personal Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            _buildDetailRow('Email:', 'johndoe@example.com'),
            _buildDetailRow('Phone:', '+1 234 567 890'),
            _buildDetailRow('Location:', 'New York, USA'),
          ],
        ),
      ),
    );
  }

  // Row for details like email, phone, etc.
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            '$label ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Body Metrics section (e.g., height, weight, BMI)
  Widget _buildBodyMetrics() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Body Metrics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            _buildMetricRow('Height:', '180 cm'),
            _buildMetricRow('Weight:', '75 kg'),
            _buildMetricRow('BMI:', '23.1 (Normal)'),
          ],
        ),
      ),
    );
  }

  // Row for metrics like height, weight, etc.
  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            '$label ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Achievements section
  Widget _buildAchievements() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Achievements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '🏅 5K Marathon - Completed in 25 mins',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            Text(
              '🏅 50 Workouts Completed in a Month',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
