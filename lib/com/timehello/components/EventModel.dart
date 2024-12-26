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
  /**
      @enum       EKRecurrenceFrequency
      @abstract   The frequency of a recurrence
      @discussion EKRecurrenceFrequency designates the unit of time used to describe the recurrence.
      It has four possible values, which correspond to recurrence rules that are defined
      in terms of days, weeks, months, and years.
      case daily = 0

      case weekly = 1

      case monthly = 2

      case yearly = 3
   */
  final int? frequency;
  /**
      @property       interval
      @discussion     The interval of a EKRecurrenceRule is an integer value which specifies how often the recurrence rule repeats
      over the unit of time described by the EKRecurrenceFrequency. For example, if the EKRecurrenceFrequency is
      EKRecurrenceWeekly, then an interval of 1 means the pattern is repeated every week. A value of 2
      indicates it is repeated every other week, 3 means every third week, and so on. The value must be a
      positive integer; 0 is not a valid value, and nil will be returned if the client attempts to initialize a
      rule with a negative or zero interval.
   */
  final int? interval;
  final DateTime? endDate;
  final int? firstDayOfTheWeek;
  /**
      @property       daysOfTheWeek
      @discussion     This property is valid for rules whose EKRecurrenceFrequency is EKRecurrenceFrequencyWeekly, EKRecurrenceFrequencyMonthly, or
      EKRecurrenceFrequencyYearly. This property can be accessed as an array containing one or more EKRecurrenceDayOfWeek objects
      corresponding to the days of the week the event recurs. For all other EKRecurrenceRules, this property is nil.
      This property corresponds to BYDAY in the iCalendar specification.
   */
  final List<int>? daysOfTheWeek;
  final List<int>? weeksOfTheYear;
  final List<int>? daysOfTheMonth;
  final List<int>? monthsOfTheYear;
  final List<int>? setPositions;

  RecurrenceRule({
    this.frequency,
    this.interval,
    this.endDate,
    this.weeksOfTheYear,
    this.daysOfTheWeek,
    this.firstDayOfTheWeek,
    this.daysOfTheMonth,
    this.monthsOfTheYear,
    this.setPositions,
  });

  factory RecurrenceRule.fromJson(Map<String, dynamic> json) {
    return RecurrenceRule(
      firstDayOfTheWeek: json['firstDayOfTheWeek'],
      frequency: json['frequency'],
      interval: json['interval'],
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      weeksOfTheYear: (json['weeksOfTheYear'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
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
      'firstDayOfTheWeek': firstDayOfTheWeek,
      'frequency': frequency,
      'interval': interval,
      'weeksOfTheYear': weeksOfTheYear,
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