import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {

  final Function addTx;
  const NewTransaction({Key? key, required this.addTx}) : super(key: key);

  @override
  _NewTransactionState createState() => _NewTransactionState();

}

class _NewTransactionState extends State<NewTransaction>{

  final _titleCont = TextEditingController();
  final _amountCont = TextEditingController();
  DateTime? _selectedDate;
  void _submitData()
  {
    final titleValue=_titleCont.text;
    final amountValue=double.parse(_amountCont.text);

    if(titleValue.isEmpty || _amountCont.text.isEmpty || amountValue<=0 || _selectedDate==null) {
      return;
    }
    widget.addTx(titleValue,amountValue,_selectedDate);

    Navigator.of(context).pop();
  }
  void _presentDatePicker(){
    showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022), lastDate:DateTime.now()).then(
        (pickedDate){
          if(pickedDate==null){
            return;
          }
          setState(() {
            _selectedDate=pickedDate;
          });
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left:10,
            right:10,
            bottom:MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(controller: _titleCont,
                onSubmitted: (_)=>_submitData,
                decoration: const InputDecoration(
                    labelText: 'Title',labelStyle: TextStyle(fontSize: 20)
                ),),
              TextField(controller: _amountCont,
                onSubmitted: (_)=>_submitData,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Amount',labelStyle: TextStyle(fontSize: 20)),),
              Container(height: 80,
                  child:Row(children: [
                    Expanded(child:
                    Text(_selectedDate==null ? 'No date chosen!' :
                     'Picked Date:${DateFormat.yMd().format(_selectedDate!)}' ,
                      style: TextStyle(fontSize: 18),),),
                TextButton(onPressed:_presentDatePicker,
                  child: Text('Choose Date',style: TextStyle(fontWeight: FontWeight.w700,fontSize:18),),),]
              )),
              ElevatedButton(style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white54)),
                  onPressed:_submitData,
                  child:const Text('Add Transaction',style:
                  TextStyle(color: Colors.deepPurple,fontSize:20 ),))
            ],),)
    ));
  }


}
