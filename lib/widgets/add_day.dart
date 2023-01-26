import 'package:flutter/material.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:working_stats/models/salary.dart';
import 'package:working_stats/models/work.dart';

// ignore: must_be_immutable
class AddDay extends StatefulWidget {
  final Function onOk;
  bool edit = false;
  Work? work;

  AddDay({required this.onOk});

  AddDay.edit({required this.work, required this.onOk}) {
    edit = true;
  }

  @override
  _AddDayState createState() => edit ? _AddDayState.edit(work!) : _AddDayState();
}

class _AddDayState extends State<AddDay> {
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  bool _celebrationDay = false;

  _AddDayState();

  _AddDayState.edit(Work work) {
    _fromDate = work.from;
    _toDate = work.to;
    _celebrationDay = work.celebrationDay;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black87,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.edit ? 'Edit' : 'Add',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
            Container(
              height: 170.0,
              padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              color: Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: Column(
                          children: [
                            Text(
                              "${_fromDate.year}-${_fromDate.month.toString().padLeft(2, '0')}-${_fromDate.day.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "${_fromDate.hour.toString().padLeft(2, '0')}:${_fromDate.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          DateTime? date = await showPlatformDatePicker(
                            context: context,
                            firstDate: DateTime(2020, 1),
                            initialDate: _fromDate,
                            lastDate: DateTime.now(),
                            builder: (context, child) => Theme(
                              data: ThemeData(
                                colorScheme: ColorScheme.dark(
                                  primary: Colors.red,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          TimeOfDay? time = await showPlatformTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            use24hFormat: true,
                            builder: (context, child) => Theme(
                              data: ThemeData(
                                colorScheme: ColorScheme.dark(
                                  primary: Colors.red,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (date != null && time != null) {
                            date = DateTime(date.year, date.month, date.day,
                                time.hour, time.minute);
                            if (date != _fromDate) {
                              setState(() {
                                _fromDate = date!;
                                _toDate = date;
                              });
                            }
                          }
                        },
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.grey,
                        size: 40.0,
                      ),
                      ElevatedButton(
                        child: Column(
                          children: [
                            Text(
                              "${_toDate.year}-${_toDate.month.toString().padLeft(2, '0')}-${_toDate.day.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "${_toDate.hour.toString().padLeft(2, '0')}:${_toDate.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          DateTime? date = await showPlatformDatePicker(
                            context: context,
                            firstDate: _fromDate,
                            initialDate: _toDate,
                            lastDate: _fromDate.add(Duration(days: 1)),
                            builder: (context, child) => Theme(
                              data: ThemeData(
                                colorScheme: ColorScheme.dark(
                                  primary: Colors.red,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          TimeOfDay? time = await showPlatformTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_fromDate),
                            use24hFormat: true,
                            builder: (context, child) => Theme(
                              data: ThemeData(
                                colorScheme: ColorScheme.dark(
                                  primary: Colors.red,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (date != null && time != null) {
                            date = DateTime(date.year, date.month, date.day,
                                time.hour, time.minute);
                            if (date != _toDate && date.isAfter(_fromDate)) {
                              setState(() {
                                _toDate = date!;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  CheckboxListTile(
                    title: Text(
                      'Red-letter day',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    value: _celebrationDay,
                    activeColor: Colors.red,
                    checkColor: Colors.black87,
                    onChanged: (value) {
                      setState(() {
                        _celebrationDay = value!;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 150.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (widget.edit) {
                              widget.onOk(widget.work!, Work(
                                  from: _fromDate,
                                  to: _toDate,
                                  celebrationDay: _celebrationDay,
                                  salary: _calculateSalary()));
                            } else {
                              widget.onOk(Work(
                                  from: _fromDate,
                                  to: _toDate,
                                  celebrationDay: _celebrationDay,
                                  salary: _calculateSalary()));
                            }
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150.0,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Salary _calculateSalary() {
    int perHour = 1500; // TODO: add to settings

    // TODO: add them to settings
    int after18 = (perHour * 1.3).toInt();
    int after22 = (perHour * 1.4).toInt();

    int salary = 0;
    DateTime temp = _fromDate;
    while (temp.isBefore(_toDate)) {
      if (temp.hour >= 22 || temp.hour < 6) {
        salary += after22;
      } else if (temp.hour >= 18 && temp.hour < 22) {
        salary += after18;
      } else {
        salary += perHour;
      }
      temp = temp.add(Duration(hours: 1));
    }
    return Salary(_celebrationDay ? salary * 2 : salary);
  }
}
