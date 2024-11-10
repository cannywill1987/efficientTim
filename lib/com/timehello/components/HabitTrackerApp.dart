import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HabitTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HabitTrackerPage(),
    );
  }
}

class HabitTrackerPage extends StatelessWidget {
  final List<Habit> habits = [
    Habit(name: '冥想', color: Colors.blue, icon: Icons.spa),
    Habit(name: '吃晚饭', color: Colors.lightBlue, icon: Icons.restaurant),
    Habit(name: '阅读', color: Colors.cyan, icon: Icons.book),
    Habit(name: '锻炼身体', color: Colors.purple, icon: Icons.fitness_center),
    Habit(name: '早起', color: Colors.yellow, icon: Icons.wb_sunny),
    Habit(name: '吃早餐', color: Colors.pink, icon: Icons.breakfast_dining),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                // Add logic to go to previous month
              },
            ),
            SizedBox(width: 8),
            Text('10月'),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                // Add logic to go to next month
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: habits.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemBuilder: (context, index) {
            return HabitCard(habit: habits[index]);
          },
        ),
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  final Habit habit;

  HabitCard({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              habit.icon,
              size: 40,
              color: habit.color.withOpacity(0.8),
            ),
            Text(
              habit.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: HabitGrid(color: habit.color),
            ),
          ],
        ),
      ),
    );
  }
}

class HabitGrid extends StatelessWidget {
  final Color color;

  HabitGrid({required this.color});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: 31, // Assuming each month has 31 days for simplicity
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: index % 2 == 0 ? color.withOpacity(0.6) : color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      },
    );
  }
}

class Habit {
  final String name;
  final Color color;
  final IconData icon;

  Habit({required this.name, required this.color, required this.icon});
}

