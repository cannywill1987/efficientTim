class ReminderModel {
  final String? id;
  final String? title;
  final String? notes;
  final String? calendar;
  final DateTime? startDate;
  final DateTime? dueDate;
  final bool? isCompleted;
  final DateTime? completionDate;
  final int? priority; //Priorities run from 1 (highest) to 9 (lowest).  A priority of 0 means no priority. Saving a reminder with any other priority will fail. Per RFC 5545, priorities of 1-4 are considered "high," a priority of 5 is "medium," and priorities of 6-9 are "low."

  ReminderModel({
    this.id,
    this.title,
    this.notes,
    this.calendar,
    this.startDate,
    this.dueDate,
    this.isCompleted,
    this.completionDate,
    this.priority,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      title: json['title'],
      notes: json['notes'],
      calendar: json['calendar'],
      startDate: json['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['startDate'])
          : null,
      dueDate: json['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['dueDate'])
          : null,
      isCompleted: json['isCompleted'],
      completionDate: json['completionDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
          (json['completionDate'] * 1000).toInt())
          : null,
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'calendar': calendar,
      'startDate': startDate?.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'completionDate': completionDate?.millisecondsSinceEpoch,
      'priority': priority,
    };
  }
}