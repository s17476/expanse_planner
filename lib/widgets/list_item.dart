import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_planner/models/transaction.dart';

class ListItem extends StatelessWidget {
  final Transaction tx;
  final Function delete;

  const ListItem({Key? key, required this.tx, required this.delete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text('\$${tx.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          tx.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat('yyyy MMM dd').format(tx.date),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: IconButton(
          onPressed: () => delete(tx.id),
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).errorColor,
          ),
        ),
      ),
    );
  }
}
