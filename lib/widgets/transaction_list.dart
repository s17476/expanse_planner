import 'package:flutter/material.dart';

import 'list_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  const TransactionList(
      {Key? key, required this.transactions, required this.deleteTransaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      'No transactions added yet!',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.4,
                    child: Image.asset(
                      'assets/img/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            })
          : ListView(
              children: transactions
                  .map(
                    (tx) => ListItem(
                      key: ValueKey(tx.id),
                      tx: tx,
                      delete: deleteTransaction,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
