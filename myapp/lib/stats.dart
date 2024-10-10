import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final TextEditingController _waterIntakeController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _strengthController = TextEditingController();
  final TextEditingController _cardioController = TextEditingController();
  
  // Map to hold cardio metrics
  Map<String, String> cardioMetrics = {};
  Map<String, String> strengthMetrics = {};
    final Map<String, String> workoutLabels = {
      "legpress": "Leg Press",
      "squats": "Squats",
      "weightlift": "Weight Lift",
      "deadlift": "Dead Lift",
      "pushups": "Push Ups",
      "pullups": "Pull Ups",
      "jacks": "Jumping Jacks",
      "walking": "Walking",
      "swimming": "Swimming",
      "cycling": "Cycling",
      "running": "Running",
      "lunges": "Lunges",
      "benchpress": "Bench Press"
    };
  @override
  void initState() {
    super.initState();
    _fetchCardioMetrics(); // Fetch metrics on init
    _fetchStrengthMetrics();
  }

  @override
  void dispose() {
    _waterIntakeController.dispose();
    _stepsController.dispose();
    _strengthController;
    _cardioController;
    super.dispose();
  }

  // Method to fetch cardio metrics from the API
  void _fetchCardioMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');

    if (token == null || username == null) {
      print('Token or username is missing.');
      return;
    }

    String authHeader = 'Bearer $token'; 
      // String authHeader = 'Bearer $token';
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
      // Map of original keys to desired formatted keys
  Map<String, String> keyMapping = {
    "legpress": "Leg Press (reps)",
    "squats": "Squats (reps)",
    "weightlift": "Weight Lift (kg)",
    "deadlift": "Dead Lift (kg)",
    "pushups": "Push Ups (reps)",
    "pullups": "Pull Ups (reps)",
    "jumpingjacks": "Jumping Jacks (reps)",
    "walking": "Walking (metres)",
    "swimming": "Swimming (metres)",
    "cycling": "Cycling (metres)",
    "running": "Running (metres)",
    "lunges": "Lunges (reps)",
    "benchpress": "Bench Press (reps)"
  };


    if (response.statusCode == 200) {
        // Decode the JSON response into a Dart map
  Map<String, String> originalData = Map<String, String>.from(jsonDecode(response.body));

  // Create a new map with the transformed keys
  Map<String, String> transformedData = {};

  // Loop through the original data and map the keys to their new values
  originalData.forEach((key, value) {
    // If the key exists in the keyMapping map, use the mapped value; otherwise, use the original key
    String newKey = keyMapping[key] ?? key;
    transformedData[newKey] = value;
  });
      setState(() {
        cardioMetrics =transformedData;
      });
    } else {
      print('Failed to fetch cardio metrics: ${response.reasonPhrase}');
    }
  }

  // Method to fetch cardio metrics from the API
  void _fetchStrengthMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');

    if (token == null || username == null) {
      print('Token or username is missing.');
      return;
    }

    String authHeader = 'Bearer $token'; 
      // String authHeader = 'Bearer $token';
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
      // Map of original keys to desired formatted keys
  Map<String, String> keyMapping = {
    "legpress": "Leg Press (reps)",
    "squats": "Squats (reps)",
    "weightlift": "Weight Lift (kg)",
    "deadlift": "Dead Lift (kg)",
    "pushups": "Push Ups (reps)",
    "pullups": "Pull Ups (reps)",
    "jumpingjacks": "Jumping Jacks (reps)",
    "walking": "Walking (metres)",
    "swimming": "Swimming (metres)",
    "cycling": "Cycling (metres)",
    "running": "Running (metres)",
    "lunges": "Lunges (reps)",
    "benchpress": "Bench Press (reps)"
  };


    if (response.statusCode == 200) {
        // Decode the JSON response into a Dart map
  Map<String, String> originalData = Map<String, String>.from(jsonDecode(response.body));

  // Create a new map with the transformed keys
  Map<String, String> transformedData = {};

  // Loop through the original data and map the keys to their new values
  originalData.forEach((key, value) {
    // If the key exists in the keyMapping map, use the mapped value; otherwise, use the original key
    String newKey = keyMapping[key] ?? key;
    transformedData[newKey] = value;
  });
      setState(() {
        strengthMetrics =transformedData;
      });
    } else {
      print('Failed to fetch strenght metrics: ${response.reasonPhrase}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildMetricsRow(),
            SizedBox(height: 20),
            _buildAnotherMetricsRow(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: _buildWaterIntake()),
        SizedBox(width: 20),
        Expanded(child: _buildStepsCounter()),
      ],
    );
  }

  Widget _buildWaterIntake() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Water Intake',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            _buildUserInputField(_waterIntakeController, 'Water Consumed'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveWaterIntake,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsCounter() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Step Counter',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            _buildUserInputField(_stepsController, 'Steps Walked'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSteps,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnotherMetricsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: _buildCardioMetric()),
        SizedBox(width: 20),
        Expanded(child: _buildStrengthMetric()),
      ],
    );
  }

  Widget _buildCardioMetric() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Cardio Workouts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            ...cardioMetrics.entries.map((entry) {
              return _buildCardioInputField(entry.key, entry.value);
            }).toList(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCardioInputField(String label, String currentValue) {
    TextEditingController controller = TextEditingController(); // Set initial value

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label, // Display the label above the input box
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter $label done',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _submitCardioValue(label, controller.text),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          child: Text('Save'),
        ),
      ],
    );
  }

   Widget _buildStrengthMetric() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Strength Workouts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            ...strengthMetrics.entries.map((entry) {
              return _buildStrengthInputField(entry.key, entry.value);
            }).toList(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthInputField(String label, String currentValue) {
    TextEditingController controller = TextEditingController(); // Set initial value

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label, // Display the label above the input box
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter $label done',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _submitStrengthValue(label, controller.text),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          child: Text('Save'),
        ),
      ],
    );
  }

  Widget _buildUserInputField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      ),
      keyboardType: TextInputType.number,
    );
  }

  void _submitCardioValue(String label, String value) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');

    if (token == null || username == null) {
      print('Token or username is missing.');
      return;
    }
      Map<String, String> keyMapping1 = {
     "Leg Press (reps)": "legpressdone",
     "Squats (reps)": "squatsdone",
     "Weight Lift (kg)": "weightliftdone",
     "Dead Lift (kg)": "deadliftdone",
     "Push Ups (reps)": "pushupsdone",
     "Pull Ups (reps)":"pullupsdone",
     "Jumping Jacks (reps)":"jumpingjacksdone",
   "Walking (metres)": "walkingdone",
    "Swimming (metres)":"swimmingdone" ,
    "Cycling (metres)":"cyclingdone" ,
   "Running (metres)": "runningdone" ,
   "Lunges (reps)":"lungesdone" ,
    "Bench Press (reps)": "benchpressdone"
  };
 String newKey1 = keyMapping1[label] ?? label;
 var myInt = int.parse(value);
assert(myInt is int);
    String authHeader = 'Bearer $token'; 
    final response = await http.post(
      Uri.parse('http://localhost:8080/userinput/$username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authHeader,
      },
      body: jsonEncode(<String, int>{
        newKey1 : myInt, // Send the entered value in the body
      }),
    );

    if (response.statusCode == 200) {
      print('Cardio value submitted: $value for $newKey1');
      // Handle the successful response here (e.g., show a message)
    } else {
      print('Failed to submit cardio value: ${response.reasonPhrase}');
      // Handle the error here (e.g., show an error message)
    }
  }


  void _submitStrengthValue(String label, String value) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');

    if (token == null || username == null) {
      print('Token or username is missing.');
      return;
    }
          Map<String, String> keyMapping1 = {
     "Leg Press (reps)": "legpressdone",
     "Squats (reps)": "squatsdone",
     "Weight Lift (kg)": "weightliftdone",
     "Dead Lift (kg)": "deadliftdone",
     "Push Ups (reps)": "pushupsdone",
     "Pull Ups (reps)":"pullupsdone",
     "Jumping Jacks (reps)":"jumpingjacksdone",
   "Walking (metres)": "walkingdone",
    "Swimming (metres)":"swimmingdone" ,
    "Cycling (metres)":"cyclingdone" ,
   "Running (metres)": "runningdone" ,
   "Lunges (reps)":"lungesdone" ,
    "Bench Press (reps)": "benchpressdone"
  };
 String newKey1 = keyMapping1[label] ?? label;
 var myInt = int.parse(value);
assert(myInt is int);
    String authHeader = 'Bearer $token'; 
    final response = await http.post(
      Uri.parse('http://localhost:8080/userinput/$username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authHeader,
      },
      body: jsonEncode(<String, int>{
        newKey1: myInt, // Send the entered value in the body
      }),
    );

    if (response.statusCode == 200) {
      print('Strength value submitted: $value for $label');
      // Handle the successful response here (e.g., show a message)
    } else {
      print('Failed to submit strength value: ${response.reasonPhrase}');
      // Handle the error here (e.g., show an error message)
    }
  }

  void _saveWaterIntake()async{
        final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');

    if (token == null || username == null) {
      print('Token or username is missing.');
      return;
    }
    String waterIntake = _waterIntakeController.text;
     var myInt = int.parse(waterIntake);
assert(myInt is int);
    String authHeader = 'Bearer $token'; 
    final response = await http.post(
      Uri.parse('http://localhost:8080/userinput/$username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authHeader,
      },
      body: jsonEncode(<String, int>{
        "water": myInt, // Send the entered value in the body
      }),
    );

    if (response.statusCode == 200) {
      print('Water Consumed: $waterIntake liters');
      // Handle the successful response here (e.g., show a message)
    } else {
      print('Failed to submit water intake value: ${response.reasonPhrase}');
      // Handle the error here (e.g., show an error message)
    }
    
  }

  void _saveSteps() async {
       final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token1');
    String? username = prefs.getString('userna1me');

    if (token == null || username == null) {
      print('Token or username is missing.');
      return;
    }
    String stepsWalked = _stepsController.text;
     var myInt = int.parse(stepsWalked);
assert(myInt is int);
    String authHeader = 'Bearer $token'; 
    final response = await http.post(
      Uri.parse('http://localhost:8080/userinput/$username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authHeader,
      },
      body: jsonEncode(<String, int>{
        "steps": myInt, // Send the entered value in the body
      }),
    );

    if (response.statusCode == 200) {
      print('Water Consumed: $stepsWalked liters');
      // Handle the successful response here (e.g., show a message)
    } else {
      print('Failed to submit water intake value: ${response.reasonPhrase}');
      // Handle the error here (e.g., show an error message)
    }
    
    print('Steps Walked: $stepsWalked steps');
  }

  void _saveStrengthMetric() {
    String strengthValue = _strengthController.text;
    print('Strength Value: $strengthValue');
  }
}
