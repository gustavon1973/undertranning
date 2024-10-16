import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Conditional import
import 'web_config.dart' if (dart.library.io) 'mobile_config.dart';

void main() {
  configureApp();
  runApp(const MyApp());
}

class Exercise {
  final String aluno;
  final String treinos;
  final String exercicio;
  final String serie;
  final String carga;
  final String pausa;
  bool isCompleted;

  Exercise({
    required this.aluno,
    required this.treinos,
    required this.exercicio,
    required this.serie,
    required this.carga,
    required this.pausa,
    this.isCompleted = false,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      aluno: json['aluno'],
      treinos: json['treinos'],
      exercicio: json['exercico'],
      serie: json['serie'],
      carga: json['carga'],
      pausa: json['pausa'],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Treinos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF3F51B5),
      ),
      home: const ExerciseScreen(),
    );
  }
}

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => ExerciseScreenState();
}

class ExerciseScreenState extends State<ExerciseScreen> {
  List<Exercise> exercises = [];
  int currentValue = 60;
  Timer? timer;
  bool isPlaying = false;
  bool isStopped = false;
  bool isZeroReached = false;
  bool isTimerVisible = true; // Control visibility of timer components
  int _selectedIndex = 0; // Track the selected index for bottom navigation

  // URLs for the exercises
  final String urlA = 'http://ut.sportsontheweb.net/bia/treino/query.php?valueToSearch=lesley&search';
  final String urlB = 'http://ut.sportsontheweb.net/bia/treino/queryb.php?valueToSearch=lesley&search';
  final String urlC = 'http://ut.sportsontheweb.net/bia/treino/queryc.php?valueToSearch=lesley&search';

  Future<void> fetchExercises(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      setState(() {
        exercises = jsonList.map((json) => Exercise.fromJson(json)).toList();
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void loadExercisesA() {
    fetchExercises(urlA);
  }

  void loadExercisesB() {
    fetchExercises(urlB);
  }

  void loadExercisesC() {
    fetchExercises(urlC);
  }

  @override
  void initState() {
    super.initState();
    loadExercisesA(); // Load initial data for button A
  }

  void startTimer() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (currentValue > 0) {
        setState(() {
          currentValue--;
        });
      } else {
        stopTimer();
      }
    });

    setState(() {
      isPlaying = true;
      isStopped = false;
      isZeroReached = false;
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    setState(() {
      isPlaying = false;
      isStopped = true;
      isZeroReached = currentValue == 0;
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      currentValue = 60;
      isStopped = false;
      isZeroReached = false;
    });
  }

  void toggleTimerVisibility() {
    setState(() {
      isTimerVisible = !isTimerVisible; // Toggle the visibility
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Load different data based on selected index if needed
      if (index == 0) loadExercisesA(); // Home
      if (index == 1) loadExercisesB(); // Personal
      if (index == 2) loadExercisesC(); // Timer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Treinos'),
        backgroundColor: Color(0xFF3F51B5),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(isTimerVisible ? Icons.timer_off : Icons.timer, color: Colors.white),
                  onPressed: toggleTimerVisibility,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: Text('A'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      onPressed: loadExercisesA,
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      child: Text('B'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: loadExercisesB,
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      child: Text('C'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: loadExercisesC,
                    ),
                  ],
                ),
                Icon(Icons.timer_off, color: Colors.white), // Static icon for design
              ],
            ),
          ),
          if (isTimerVisible) // Only show these components if visible
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    child: Text('-15'),
                    onPressed: () {
                      setState(() {
                        currentValue = (currentValue - 15).clamp(0, 100);
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    child: Text('+15'),
                    onPressed: () {
                      setState(() {
                        currentValue = (currentValue + 15).clamp(0, 100);
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$currentValue',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    children: [
                      if (isPlaying)
                        IconButton(
                          icon: Icon(Icons.stop, color: Colors.white),
                          onPressed: stopTimer,
                        ),
                      if (isStopped)
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.replay, color: Colors.white),
                              onPressed: resetTimer,
                            ),
                            if (!isZeroReached)
                              IconButton(
                                icon: Icon(Icons.play_arrow, color: Colors.white),
                                onPressed: startTimer,
                              ),
                          ],
                        ),
                      if (!isPlaying && !isStopped && !isZeroReached)
                        IconButton(
                          icon: Icon(Icons.play_arrow, color: Colors.white),
                          onPressed: startTimer,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: exercises.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      return ExerciseItem(
                        exercise: exercises[index],
                        onChanged: (bool? value) {
                          setState(() {
                            exercises[index].isCompleted = value ?? false;
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class ExerciseItem extends StatelessWidget {
  final Exercise exercise;
  final ValueChanged<bool?> onChanged;

  const ExerciseItem({required this.exercise, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        exercise.exercicio,
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${exercise.serie} séries - ${exercise.carga}',
        style: TextStyle(color: Colors.white),
      ),
      trailing: Checkbox(
        value: exercise.isCompleted,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }
}