# Working statistics - Work wage tracker app
I made this Flutter app when I was working as a student (2021) to track my wage from month to month with logging my shifts.
I just started learning Flutter when I wrote this code. I learned much since then.

The app stores the data locally. The stored data is a JSON array with serialized instances of the `Work` (`lib/models/work.dart`) class as JSON objects in it.

It uses hardcoded numbers as hourly wages and VAT (15%).
The default hourly wage is 1500Ft that grows between 6pm and 10pm with 30% and between 10pm and 6am with 40%.
On red-letter days the whole wage for the shift being multiplied by 2.

It uses the following method to calculate wage for a shift with the specifications above:
```dart
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
```
`lib/widgets/add_day.dart | line 265`

The `Salary` (`lib/models/salary.dart`) class has a salary and a withoutVAT field. The withoutVAT is being multiplied by 0.85 (VAT is 15%) in the constructor.

# Screenshots
It has a minimal UI design aswell.
The data is shown for the selected month, but you can add shifts to any month with the add button or with editing a current shift's month.

<img src="https://user-images.githubusercontent.com/22691959/214815345-7610d3bd-7604-4fbb-9459-ae359084259b.jpg" height="500"></img>
<img src="https://user-images.githubusercontent.com/22691959/214815342-c70152fd-c6f7-400e-9c8a-ccd258fafc58.jpg" height="500"></img>
<img src="https://user-images.githubusercontent.com/22691959/214815339-407c53df-9b9c-4a3c-b3a6-29a6d1ec0bf7.jpg" height="500"></img>
<img src="https://user-images.githubusercontent.com/22691959/214815337-6b10724f-e2de-461e-b17f-d3f808ec9929.jpg" height="500"></img>
<img src="https://user-images.githubusercontent.com/22691959/214815333-dce69efa-65a6-4be0-b43a-d1eff2204b7f.jpg" height="500"></img>
<img src="https://user-images.githubusercontent.com/22691959/214815327-3bc7fef3-694f-42af-a393-72aa66f92127.jpg" height="500"></img>

# Libraries used in the app
- [modal_bottom_sheet](https://pub.dev/packages/modal_bottom_sheet) `^2.0.0`
- [platform_date_picker](https://pub.dev/packages/platform_date_picker) `^0.2.0-nullsafety.0+1`
- [intl](https://pub.dev/packages/intl) `^0.17.0`
- [shared_preferences](https://pub.dev/packages/shared_preferences) `^2.0.5`
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) `^2.2.17`
- [mat_month_picker_dialog](https://pub.dev/packages/mat_month_picker_dialog) `^1.1.1`
