import 'package:expense_app_real/widgets/chart.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';

import './include/transaction_format.dart';
import './widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
          textTheme: ThemeData.light().textTheme.copyWith(
                subtitle1: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
            elevation: 2,
            toolbarTextStyle: ThemeData.light()
                .textTheme
                .copyWith(
                  headline6: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                )
                .bodyText2,
          ),
        ),
        home: MyAppHome());
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<MyAppHome> createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  List<TransactionFormat> _transactionList = [];

  bool showChart = false;

  void _inputData(String xitem, int xprice, DateTime dated) {
    var tmp = TransactionFormat(
        id: _transactionList.length + 1,
        date: dated == null ? DateTime.now() : dated,
        item: xitem,
        price: xprice);

    setState(() {
      _transactionList.add(tmp);
    });
  }

  void _addNewData(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_inputData);
      },
    );
  }

  List<TransactionFormat> get _recentTransaction {
    return _transactionList.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _deleteData(int index) {
    setState(() {
      _transactionList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkOrientation =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var appBar = AppBar(
      title: Text('Expense App'),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _addNewData(context),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (checkOrientation)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch.adaptive(
                      value: showChart,
                      onChanged: (val) {
                        setState(() {
                          showChart = val;
                        });
                      }),
                ],
              ),
            if (!checkOrientation)
              Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) * 
                      0.3,
                  child: Chart(_recentTransaction)),
            if (!checkOrientation)
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TransactionList(_transactionList, _deleteData),
              ),
            if (checkOrientation) 
              showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(_recentTransaction))
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TransactionList(_transactionList, _deleteData),
                    )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (() => _addNewData(context)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
