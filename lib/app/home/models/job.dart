import 'dart:ui';

import 'package:flutter/foundation.dart';

class Job {
  Job({
    @required this.id,
    @required this.name,
    @required this.ratePerHour,
  });

  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) {
      return null;
    }
    final int ratePerHour = data['ratePerHour'];
    return Job(
      id: documentId,
      name: name,
      ratePerHour: ratePerHour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      if (ratePerHour != null) 'ratePerHour': ratePerHour,
    };
  }

  @override
  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }
    if (runtimeType != other.runtimeType) {
      return false;
    }
    final Job otherJob = other;
    return this.name == otherJob.name &&
        this.ratePerHour == otherJob.ratePerHour &&
        this.id == otherJob.id;
  }

  @override
  int get hashCode => hashValues(id, name, ratePerHour);

  @override
  String toString() => 'id: $id, name: $name, ratePerHour: $ratePerHour';
}
