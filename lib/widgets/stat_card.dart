import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:working_stats/models/work.dart';

class StatisticCard extends StatelessWidget {
  final NumberFormat numberFormat = NumberFormat("#,###", "EN");

  final Work work;
  final Function onDelete;
  final Function onTap;

  StatisticCard(
      {required this.work, required this.onDelete, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      onLongPress: () {
        showCupertinoModalBottomSheet(
          context: context,
          expand: false,
          builder: (builder) => Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                  onTap: () {
                    Navigator.of(context).pop();
                    onDelete(work);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: ListTile(
        title: Container(
          height: 75.0,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 3.0,
                offset: Offset(0.0, 1.0),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: work.celebrationDay ? Colors.red : Colors.grey,
                      size: 60.0,
                    ),
                    Positioned.fill(
                      top: 12.5,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          work.from.day.toString(),
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color:
                                work.celebrationDay ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  thickness: 2.0,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${work.from.hour.toString().padLeft(2, "0")}-${work.to.hour.toString().padLeft(2, "0")} (${work.to.difference(work.from).inHours} hour)',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
                      Divider(
                        thickness: 2.0,
                        color: Colors.grey,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: 'Wage: ',
                            ),
                            TextSpan(
                                text: '${numberFormat.format(work.salary.withoutVAT)}Ft',
                                style: TextStyle(
                                  color: Colors.green[500],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
