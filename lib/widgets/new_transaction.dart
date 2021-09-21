import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  const NewTransaction(this.addTransaction, {Key? key}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    double enteredAmount = 0;

    if (enteredTitle.isEmpty ||
        _amountController.text.isEmpty ||
        _selectDate == null) return;

    enteredAmount = double.parse(_amountController.text);

    widget.addTransaction(
      enteredTitle,
      enteredAmount,
      _selectDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDayPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              onSubmitted: (_) => _submitData(),
              autofocus: true,
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onSubmitted: (_) => _submitData(),
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectDate == null
                          ? 'No date choosen!'
                          : 'Picked date: ' +
                              DateFormat('dd / MMM / yyyy')
                                  .format(_selectDate!),
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDayPicker,
                    child: Text(
                      'Choose date',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
              child: Text(
                'Add transaction',
                style: TextStyle(
                  color: Theme.of(context).textTheme.button!.color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
