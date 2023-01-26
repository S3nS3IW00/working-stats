import 'package:flutter/material.dart';

class BottomSheetSelector extends StatelessWidget {
  final String title;
  final Function onSelect;
  final Map<Object, String> items;

  const BottomSheetSelector({required this.title, required this.onSelect, required this.items});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text(title)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ...items.keys.map((e) => ListTile(
                title: Text(items[e]!),
                onTap: () {
                  Navigator.of(context).pop();
                  onSelect(e);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
