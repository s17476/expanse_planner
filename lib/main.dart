import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_planner/widgets/chart.dart';
import 'package:expense_planner/widgets/new_transaction.dart';
import 'package:expense_planner/widgets/transaction_list.dart';
import 'models/transaction.dart';

void main() {
  // Disable landscape mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const ExpansePlanner());
}

class ExpansePlanner extends StatelessWidget {
  const ExpansePlanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expanse Planner',
      home: const HomePage(),
      theme: ThemeData(
        errorColor: Colors.red,
        primarySwatch: Colors.purple,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              secondary: Colors.deepOrange,
            ),
        fontFamily: 'Quicksand',
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: const TextStyle(color: Colors.white),
            ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _transactions = [];

  bool _schowChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  void _addTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: date);
    setState(() {
      _transactions.add(newTx);
    });
  }

  void _showAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builderContext) {
        return NewTransaction(_addTransaction);
      },
    );
  }

  void deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, SizedBox txListView) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Schow Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: _schowChart,
            onChanged: (val) {
              setState(() {
                _schowChart = val;
              });
            },
          ),
        ],
      ),
      _schowChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(recentTransactions: _recentTransactions))
          : txListView,
    ];
  }

  List<Widget> _buildPortraitWidget(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, SizedBox txListView) {
    return [
      SizedBox(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(recentTransactions: _recentTransactions)),
      txListView,
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Expanse Planner'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _showAddNewTransaction(context),
                ),
              ],
            ),
          ) as PreferredSizeWidget
        : AppBar(
            title: const Text('Expanse Planner'),
            backgroundColor: Theme.of(context).primaryColor,
            actions: <Widget>[
              IconButton(
                onPressed: () => _showAddNewTransaction(context),
                icon: const Icon(
                  Icons.add_circle_outline_sharp,
                  color: Colors.white,
                  size: 30,
                ),
                padding: const EdgeInsets.only(right: 15),
              )
            ],
          );
  }

  SizedBox _buildListView(
    MediaQueryData mediaQuery,
    PreferredSizeWidget appBar,
  ) {
    return SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
        transactions: _transactions,
        deleteTransaction: deleteTransaction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscapeMode = mediaQuery.orientation == Orientation.landscape;
    final appBar = _buildAppBar();
    final txListView = _buildListView(mediaQuery, appBar);

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscapeMode)
              ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                txListView,
              ),
            if (!isLandscapeMode)
              ..._buildPortraitWidget(
                mediaQuery,
                appBar,
                txListView,
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            // Showing floating button in Android OS
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                    onPressed: () => _showAddNewTransaction(context),
                    elevation: 5,
                  ));
  }
}
