import 'package:flutter/material.dart';

class ClockInWidget extends StatefulWidget {
  @override
  _ClockInWidgetState createState() => _ClockInWidgetState();
}

class _ClockInWidgetState extends State<ClockInWidget> {
  final List<String> daysOfWeek = ["日", "一", "二", "三", "四", "五", "六"];

  final List<Task> tasks = [
    Task(icon: Icons.emoji_events, title: "每天进步一点点", status: [false, false, false, true, false, false, false], color: Colors.blue),
    Task(icon: Icons.nightlight_round, title: "早睡", status: [false, false, false, false, false, false, false], color: Colors.purple),
    Task(icon: Icons.science, title: "测试", status: [false, false, false, false, false, false, false], color: Colors.red),
    Task(icon: Icons.emoji_events, title: "每天进步一点点", status: [false, false, false, false, false, false, false], color: Colors.green),
  ];

  void toggleStatus(int taskIndex, int dayIndex) {
    setState(() {
      tasks[taskIndex].status[dayIndex] = !tasks[taskIndex].status[dayIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Icon(
          Icons.emoji_events,
          color: Colors.orange,
        ),
        actions: daysOfWeek.map((day) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  color: day == "四" ? Colors.blue : Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Divider(color: Colors.grey),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  Task task = tasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          task.icon,
                          color: task.color,
                        ),
                        SizedBox(width: 8),
                        Text(
                          task.title,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Spacer(),
                        Row(
                          children: List.generate(7, (dayIndex) {
                            double opacity = task.status[dayIndex] ? task.completionRate() : 0.3;
                            return GestureDetector(
                              onTap: () => toggleStatus(index, dayIndex),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: task.color.withOpacity(opacity),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final IconData icon;
  final String title;
  final List<bool> status;
  final Color color;

  Task({
    required this.icon,
    required this.title,
    required this.status,
    required this.color,
  });

  double completionRate() {
    int completedDays = status.where((day) => day).length;
    return completedDays / status.length;
  }
}