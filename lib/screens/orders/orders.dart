import 'package:flutter/material.dart';
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/screens/orders/widgets/orders_widget.dart';

class OrdersScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.grey.withOpacity(.1),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Manage Orders",
          style: TextStyle(color: Colors.black),
        ),

      ),
      body: ListView(
        children: [
          Column(
            children: paymentsController.payments.map((payment) => OrdersWidget(paymentsModel: payment,)).toList()
            ,
          )
        ],
      ),
    );
  }


}
