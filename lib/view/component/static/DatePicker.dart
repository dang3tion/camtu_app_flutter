import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DatePickerButton extends StatefulWidget {
  final String label;
  final DateTime date;
  final DateTime maxdate;
  final DateTime mindate;

  final bool timea;

  DatePickerButton(
      this.label, this.date, this.maxdate, this.mindate, this.timea);

  _DatePickerButtonState input;

  @override
  _DatePickerButtonState createState() {
    input = new _DatePickerButtonState(
        this.label, this.date, this.maxdate, this.mindate, this.timea);
    return input;
  }

  String getDate() {
    return input.getDate();
  }


  String getDateTime() {
    return input.getDateTime();
  }
}

class _DatePickerButtonState extends State<DatePickerButton> {
  final String label;
  final DateTime date;
  final DateTime maxdate;
  final DateTime mindate;
  final bool timea;
  String _date = "Chưa chọn";

  _DatePickerButtonState(
      this.label, this.date, this.maxdate, this.mindate, this.timea) {}

  String getDate() {
    if (_date == "Chưa chọn") {
      _date =
          '${date.year} - ${date.month} - ${date.day} / ${date.hour}:${date.minute} ';
    }
    ;
    return _date;
  }

  String getDateTime() {
    if (_date == 'Chưa chọn') {
      return this.date.toString();
    }
    return _date;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        height: 60,
        width: MediaQuery.of(context).size.width * 0.85,
        child: RaisedButton(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            if (timea) {
              DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  minTime: mindate,
                  maxTime: maxdate, onConfirm: (date) {
                print('confirm $date');
                _date = date.toString();

                setState(() {});
              }, currentTime: date, locale: LocaleType.en);
            } else {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: mindate,
                  maxTime: maxdate, onConfirm: (date) {
                print('confirm $date');

                _date = '${date.year} - ${date.month} - ${date.day}';

                setState(() {});
              }, currentTime: date, locale: LocaleType.en);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Transform.translate(
                offset: Offset(-10, 0),
                child: Row(
                  children: [
                    Icon(Icons.date_range, size: 40, color: Colors.grey[600]),
                    Text(
                      _date,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    )
                  ],
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
