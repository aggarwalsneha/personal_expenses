import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/chart_bar.dart';
import 'package:personal_expenses/transaction.dart';

class ChartBox extends StatelessWidget {
  final List <Transaction> recentTransactions;

  List <Map<String,Object>> get groupedTransactions
  {
    return List.generate(7, (index) {
      final weekDay=DateTime.now().subtract(Duration(days: index));
      double totalSum=0.0;
      for(var i=0;i<recentTransactions.length;i++)
        {
          if(recentTransactions[i].date.day == weekDay.day &&
              recentTransactions[i].date.month == weekDay.month &&
          recentTransactions[i].date.year == weekDay.year)
            {
                totalSum=totalSum+recentTransactions[i].amount;
            }
        }
  return {'day':DateFormat.E().format(weekDay).substring(0,1),
    'amount':totalSum};
  }).reversed.toList();
  }

  double get totalSpending{
    return groupedTransactions.fold(0.0, (sum,item) {
      return sum + (item['amount'] as double);
    });
  }
  ChartBox({Key? key, required this.recentTransactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(elevation: 6,
    margin: EdgeInsets.all(20),
    child: Padding(padding: EdgeInsets.all(10),
        child:Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: groupedTransactions.map((data){
      return Flexible(fit: FlexFit.tight,
          child:ChartBar(
          label:data['day'].toString(),
          spendingAmount:(data['amount'] as double),
          spendingPer: totalSpending==0? 0.0 : (data['amount'] as double)/totalSpending));
    }).toList(),
    )),);
  }
}
