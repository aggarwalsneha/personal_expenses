import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expenses/chart.dart';
import 'package:personal_expenses/new_transaction.dart';
import 'package:personal_expenses/transaction.dart';
import 'package:personal_expenses/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(
          subtitle1:TextStyle(fontSize: 20.0,fontWeight: FontWeight.w900),
        )),
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        errorColor: Colors.red
      ),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();

}
class _MyHomePageState extends State<MyHomePage>{

  final List<Transaction> _userTransactions=[];
  bool _showChart=false;
  List <Transaction> get _recentTransactions
  {
    return _userTransactions.where((tx){
      return tx.date.isAfter(DateTime.now().subtract(Duration(days:7))
      );
    }
    ).toList();
  }

  void _addTransaction(String title,double amount,DateTime chosenDate)
  {
    final newTx=Transaction(
        title: title,
        amount: amount,
        date: chosenDate,
        id: DateTime.now().toString()
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startNewTransaction(BuildContext ctx)
  {
    showModalBottomSheet(context: ctx, builder: (_){
      return GestureDetector(
        onTap: (){},
          child:NewTransaction(addTx:_addTransaction),
        behavior: HitTestBehavior.opaque,
      );
    });
  }

  void _deleteTransaction(String id)
  {
      setState(() {
        _userTransactions.removeWhere((tx) => tx.id==id);
      });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context);
    final _isLandscape =mediaQuery.orientation==Orientation.landscape;
    final appBar=AppBar(
      backgroundColor: Colors.deepPurple,
      title: Text('Your Expenses'),
      actions: [
        IconButton(icon:Icon(Icons.add),onPressed: ()=>
            _startNewTransaction(context)
        )
      ],
    );
    final _txListWidget= Container(height: (
        mediaQuery.size.height- appBar.preferredSize.height-
            mediaQuery.padding.top
    )*0.7,
        child: TransactionList(transactions: _userTransactions,deleteTx: _deleteTransaction));
    return Scaffold(
        resizeToAvoidBottomInset: true,
        extendBody: true,
        appBar: appBar,
        body: SingleChildScrollView(child:
            Column(children: [
             if (_isLandscape)
               Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('Show Chart'),
                Switch.adaptive(activeColor: Theme.of(context).accentColor,
                    value:_showChart, onChanged: (val){
                  setState(() {
                    _showChart=val;
                  });
                })
              ],),
             if(!_isLandscape)
               Container(height: (
                   mediaQuery.size.height- appBar.preferredSize.height -
                       mediaQuery.padding.top
               )*0.3,
                 child: ChartBox(recentTransactions: _recentTransactions),
               ),
             if(! _isLandscape)
               _txListWidget,
             if(_isLandscape)
             _showChart? Container(height: (
                  mediaQuery.size.height- appBar.preferredSize.height -
                      mediaQuery.padding.top
              )*0.7,
                child: ChartBox(recentTransactions: _recentTransactions),
              ):
              _txListWidget
            ],)
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS? Container():
      FloatingActionButton(child: Icon(Icons.add),
          onPressed: ()=>
              _startNewTransaction(context)
      ),
    );
  }

}

