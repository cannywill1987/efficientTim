class GeoLocation {
  final double? latitude;
  final double? longitude;

  GeoLocation({this.latitude, this.longitude});

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class StructuredLocation {
  final String? title;
  final GeoLocation? geoLocation;
  final double? radius;

  StructuredLocation({this.title, this.geoLocation, this.radius});

  factory StructuredLocation.fromJson(Map<String, dynamic> json) {
    return StructuredLocation(
      title: json['title'],
      geoLocation: json['geoLocation'] != null
          ? GeoLocation.fromJson(json['geoLocation'])
          : null,
      radius: json['radius'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'geoLocation': geoLocation?.toJson(),
      'radius': radius,
    };
  }
}

class RecurrenceRule {
  final int? frequency;
  final int? interval;
  final DateTime? endDate;
  final List<int>? daysOfTheWeek;
  final List<int>? daysOfTheMonth;
  final List<int>? monthsOfTheYear;
  final List<int>? setPositions;

  RecurrenceRule({
    this.frequency,
    this.interval,
    this.endDate,
    this.daysOfTheWeek,
    this.daysOfTheMonth,
    this.monthsOfTheYear,
    this.setPositions,
  });

  factory RecurrenceRule.fromJson(Map<String, dynamic> json) {
    return RecurrenceRule(
      frequency: json['frequency'],
      interval: json['interval'],
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      daysOfTheWeek: (json['daysOfTheWeek'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      daysOfTheMonth: (json['daysOfTheMonth'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      monthsOfTheYear: (json['monthsOfTheYear'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      setPositions: (json['setPositions'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency,
      'interval': interval,
      'endDate': endDate?.toIso8601String(),
      'daysOfTheWeek': daysOfTheWeek,
      'daysOfTheMonth': daysOfTheMonth,
      'monthsOfTheYear': monthsOfTheYear,
      'setPositions': setPositions,
    };
  }
}

class EventModel {
  final String? id;
  final String? title;
  final String? note;
  final String? location;
  final String? calendar;
  final StructuredLocation? structuredLocation;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? allDay;
  final bool? floating;
  final RecurrenceRule? recurrence;
  final String? travelTime;
  final String? startLocation;

  EventModel({
    this.id,
    this.title,
    this.note,
    this.calendar,
    this.location,
    this.structuredLocation,
    this.startDate,
    this.endDate,
    this.allDay,
    this.floating,
    this.recurrence,
    this.travelTime,
    this.startLocation,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      calendar: json['calendar'],
      location: json['location'],
      structuredLocation: json['structuredLocation'] != null
          ? StructuredLocation.fromJson(json['structuredLocation'])
          : null,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      allDay: json['allDay'],
      floating: json['floating'],
      recurrence: json['recurrence'] != null
          ? RecurrenceRule.fromJson(json['recurrence'])
          : null,
      travelTime: json['travelTime'],
      startLocation: json['startLocation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'structuredLocation': structuredLocation?.toJson(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'allDay': allDay,
      'floating': floating,
      'recurrence': recurrence?.toJson(),
      'travelTime': travelTime,
      'startLocation': startLocation,
    };
  }
}