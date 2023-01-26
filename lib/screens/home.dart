import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:working_stats/models/salary.dart';
import 'package:working_stats/models/work.dart';
import 'package:working_stats/widgets/add_day.dart';
import 'package:working_stats/widgets/stat_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NumberFormat numberFormat = NumberFormat("#,###", "EN");
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  int _allSalary = 0;
  int _allHours = 0;
  List<Work> _selectedWorks = [];
  DateTime _selectedDate = DateTime.now();

  final List<Work> works = [];

  _HomePageState() {
    _init();
  }

  _init() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    if (storage.containsKey("works")) {
      (jsonDecode(storage.get("works") as String) as List<dynamic>)
          .forEach((element) {
        works.add(Work(
            from: dateFormat
                .parse((element as Map<String, dynamic>)["from"] as String),
            to: dateFormat.parse(element["to"] as String),
            celebrationDay: element["celebration"] ?? false,
            salary: Salary(element["salary"] ?? 0)));
      });
      _updateWorks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Work statistic',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.black87,
              ),
              child: Text(
                  "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}"),
              onPressed: () => showMonthPicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now(),
              ).then((date) {
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                    _updateWorks();
                  });
                }
              }),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.black54,
        child: _selectedWorks.length == 0
            ? Center(
                child: Text(
                  "No data!",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25.0,
                  ),
                ),
              )
            : ListView(
                children: [
                  ..._selectedWorks.map((e) => StatisticCard(
                        work: e,
                        onDelete: _onDelete,
                        onTap: () => showCupertinoModalBottomSheet(
                          context: context,
                          builder: (builder) => AddDay.edit(
                            work: e,
                            onOk: _editWork,
                          ),
                        ),
                      )),
                ],
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.black87),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => showCupertinoModalBottomSheet(
          context: context,
          builder: (builder) => AddDay(
            onOk: _addWork,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.red,
          ),
          height: 60.0,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${numberFormat.format(_allSalary)}Ft",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              Text(
                " ($_allHours hours)",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _saveWorks() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    List<Map<String, Object>> jsonList = [];
    works.forEach((element) => jsonList.add({
          "from": dateFormat.format(element.from),
          "to": dateFormat.format(element.to),
          "celebration": element.celebrationDay,
          "salary": element.salary.salary
        }));
    storage.setString("works", jsonEncode(jsonList));
  }

  _addWork(Work work) {
    works.add(work);
    _saveWorks();
    _updateWorks();
  }

  _editWork(Work from, Work to) {
    works.remove(from);
    _addWork(to);
  }

  _updateWorks() {
    setState(() {
      _selectedWorks = works
          .where((element) =>
              element.from.year == _selectedDate.year &&
              element.from.month == _selectedDate.month)
          .toList();
      _selectedWorks.sort((a, b) => a.from.compareTo(b.from));
      _allSalary = 0;
      _allHours = 0;
      _selectedWorks.forEach((element) {
        _allSalary += element.salary.withoutVAT;
        _allHours += element.to.difference(element.from).inHours;
      });
    });
  }

  _onDelete(Work work) {
    works.remove(work);
    _saveWorks();
    _updateWorks();
  }
}
