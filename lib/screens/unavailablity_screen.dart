import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import 'package:provider/provider.dart';
import '../models/unavailabilityfield.dart';
import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';


class unavailability extends StatefulWidget {
  static const routeName = 'unavailability-screen';
  @override
  _unavailabilityState createState() => _unavailabilityState();
}

class _unavailabilityState extends State<unavailability> {
  var productdetails;

  @override
  void initState() {


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productdetails = Provider.of<unavailabilities>(context,listen: false);

    return Scaffold(
       appBar: AppBar(title: Text(S.of(context).my_basket,
       style: TextStyle(color: ColorCodes.menuColor),),
         automaticallyImplyLeading: false,
         leading: IconButton(
             icon: Icon(Icons.arrow_back, color: ColorCodes.menuColor),
             onPressed: () => Navigator.of(context).pop()),
         elevation: (IConstants.isEnterprise)?0:1,
       ),

      body: SingleChildScrollView(
        child: Column(
          children: [
          SizedBox(height: 10,),

            Container(padding: EdgeInsets.all(10),
            child: Text(productdetails.items.length.toString() + S.of(context).product_unavailable),)
        ],
        ),
      )
       ,
    );
  }
}
