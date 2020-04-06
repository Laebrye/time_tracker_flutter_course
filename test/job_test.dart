import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      final job = Job.fromMap(null, 'job_abc');
      expect(job, null);
    });

    test('job with all properties', () {
      final job = Job.fromMap({
        'name': 'Blogging',
        'ratePerHour': 10,
      }, 'job_abc');
      expect(
        job,
        Job(
          name: 'Blogging',
          ratePerHour: 10,
          id: 'job_abc',
        ),
      );
    });

    test('job with all properties', () {
      final job = Job.fromMap({
        'ratePerHour': 10,
      }, 'job_abc');
      expect(
        job,
        null,
      );
    });
  });

  group('toMap', () {
    test('valid name and ratePerHour', () {
      final job = Job(name: 'Blogging', ratePerHour: 10, id: 'job_abc');

      expect(job.toMap(), {
        'name': 'Blogging',
        'ratePerHour': 10,
      });
    });

    test('valid name, invalid ratePerHour', () {
      final job = Job(id: 'job_abc', name: 'Blogging', ratePerHour: null);
      expect(job.toMap(), {
        'name': 'Blogging',
      });
    });
  });
}
