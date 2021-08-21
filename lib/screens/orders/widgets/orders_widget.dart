import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/models/payments.dart';
import 'package:untitled/widgets/custom_text.dart';

class OrdersWidget extends StatefulWidget {
  final PaymentsModel paymentsModel;

  const OrdersWidget({Key key, this.paymentsModel}) : super(key: key);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {

  selectAnAction(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Change Status to:"),
            children: [
              SimpleDialogOption(
                  child: Text("Approved"),
                  onPressed:(){
                    paymentsController.updateOrderStatus(widget.paymentsModel.id.toString(), "Approved", );
                  }
              ),
              SimpleDialogOption(
                  child: Text("Delivered"),
                  onPressed: (){
                    // handleChooseFromGallery(context);
                  }
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 15
            )
          ]
      ),
      child: Wrap(
        children: [
          Row(
            children: [
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(text: "ITEMS:", color: Colors.grey,),
              ),
              CustomText(text: widget.paymentsModel.cart.length.toString(), color: Colors.black, weight: FontWeight.bold,),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(text: "₦${widget.paymentsModel.amount}", color: Colors.black, weight: FontWeight.bold,size: 18,),
              ),
              SizedBox(width: 5,)
            ],
          ),
          Divider(),
          Column(
              children: widget.paymentsModel.cart.map((item) => ListTile(
                title: CustomText(text: item['name'],),
                trailing: CustomText(text: "₦${item['cost']}",),
              )).toList()
          ),


          Divider(),
          ListTile(
            title: CustomText(text: _returnDate(), color: Colors.grey,),
            trailing: ElevatedButton(onPressed: (){
              selectAnAction(context);
            }, child: CustomText(text: widget.paymentsModel.status, color: Colors.white,)),
          ),

          ListTile(
            title: CustomText(text: "Phone", color: Colors.grey,),
            trailing: CustomText(text: widget.paymentsModel.phone, color: Colors.black, weight: FontWeight.bold,size: 18,),
          ),

          ListTile(
            title: CustomText(text: "Address", color: Colors.grey,),
            trailing: CustomText(text: widget.paymentsModel.userAddress, color: Colors.black, weight: FontWeight.bold,size: 10,),
          ),
        ],
      ),
    );
  }

  String _returnDate(){
    // DateTime date = new DateTime.fromMillisecondsSinceEpoch(paymentsModel.createdAt);
    return timeago.format(widget.paymentsModel.createdAt);
  }
}
