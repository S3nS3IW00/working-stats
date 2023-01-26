import 'package:working_stats/models/salary.dart';

class Work {

  final DateTime from;
  final DateTime to;
  final bool celebrationDay;
  final Salary salary;

  Work({required this.from, required this.to, required this.celebrationDay, required this.salary});
}