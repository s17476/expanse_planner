import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_planner/models/transaction.dart';

class ListItem extends StatefulWidget {
  final Transaction tx;
  final Function delete;

  const ListItem({Key? key, required this.tx, required this.delete})
      : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.purple,
      Colors.black,
      Colors.blue,
    ];

    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text('\$${widget.tx.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          widget.tx.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat('yyyy MMM dd').format(widget.tx.date),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? TextButton.icon(
                onPressed: () => widget.delete(widget.tx.id),
                label: Text(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              )
            : IconButton(
                onPressed: () => widget.delete(widget.tx.id),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              ),
      ),
    );
  }
}
