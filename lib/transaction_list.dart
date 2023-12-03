import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/transaction.dart';

class TransactionList extends StatelessWidget {
  final List <Transaction> transactions;
  final Function deleteTx;

  const TransactionList({Key? key, required this.transactions, required this.deleteTx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty ? LayoutBuilder(builder: (ctx,constraints){
      return Center(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text('Nothing to display',
                style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20.0)),
              SizedBox(height: 20,),
              Container(height: constraints.maxHeight * 0.5,
                  child: Image.asset('assets/waiting.png',fit: BoxFit.contain))
            ],
          ));
    }):ListView.builder(
      itemCount: transactions.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(elevation: 5,
              margin: EdgeInsets.all(5),
              child:ListTile(leading: CircleAvatar(radius: 30,
            child: Padding(padding: EdgeInsets.all(8),
                child:FittedBox(child:
                Text(transactions[index].amount.toString(),style: const TextStyle(fontSize: 20),
            ))
            ),),
          title: Text(
              transactions[index].title,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)
          ),
          subtitle:Text(DateFormat.yMMMd().format(transactions[index].date),style: const TextStyle(fontSize: 20),),
          trailing: MediaQuery.of(context).size.width> 400?
              TextButton.icon(
                style: TextButton.styleFrom(primary: Theme.of(context).errorColor),
                  onPressed: () => deleteTx(transactions[index].id),
                icon: Icon(Icons.delete),
                label: Text('DELETE'),
                ):
          IconButton(icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () => deleteTx(transactions[index].id)),
              ));

        },
    );
  }
}
