import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function newData;

  NewTransaction(this.newData);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _itemController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime _pickedDate;

  void getDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then(
      (value) {
        if (value == null) {
          return;
        }
        setState(() {
          _pickedDate = value;
        });
      },
    );
  }

  void _addNewData() {
    String titem = _itemController.text;
    int tprice = int.parse(_priceController.text);

    if (titem.isEmpty || tprice <= 0) {
      return;
    }

    widget.newData(titem, tprice, _pickedDate);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                  controller: _itemController,
                  decoration: InputDecoration(
                    label: Text(
                      'item',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontFamily: 'QuickSand'),
                    ),
                  ),
                  onSubmitted: (_) => _addNewData()),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  label: Text(
                    'price',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontFamily: 'QuickSand'),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                onSubmitted: (_) => _addNewData(),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        _pickedDate == null
                            ? DateFormat.yMd().format(DateTime.now())
                            : DateFormat.yMd().format(_pickedDate),
                        style: TextStyle(fontSize: 18)),
                  ),
                  TextButton(
                    child: Text('choose a Date'),
                    onPressed: getDatePicker,
                  )
                ],
              ),
              ElevatedButton(
                child: Text('Add Transaction'),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
                onPressed: _addNewData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
