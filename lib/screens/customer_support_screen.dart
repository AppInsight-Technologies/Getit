import 'package:crisp/crisp_view.dart';
import 'package:crisp/models/main.dart';
import 'package:crisp/models/user.dart';
import 'package:flutter/material.dart';

import '../assets/ColorCodes.dart';
import '../constants/IConstants.dart';


class CustomerSupportScreen extends StatefulWidget {
  static const routeName = '/cutomer-support-screen';
  @override
  _CustomerSupportScreenState createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {

    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    final name = routeArgs['name'];
    final email = routeArgs['email'];
    final photourl = routeArgs['photourl'];
    final phone = routeArgs['phone'];

    crisp.initialize(
      websiteId: IConstants.websiteId,//'7ada1ff4-e065-4e54-bb26-193defda73e2',
      //locale: 'pt-br',
    );

    crisp.register(
      CrispUser(
        email: email,
        avatar: photourl,
        nickname: name,
        phone: phone,
      ),
    );
    crisp.setMessage("Hi");

    return /*Scaffold(
      body : Material(
          child: Stack(
            children: <Widget>[
              SafeArea(
                child: CrispView(
                  loadingWidget: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
*//*              SafeArea(
                child: Positioned(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios,),
                  ),
                ),
              ),*//*

            ],
          ),
      ),
    );*/
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:  (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.blackColor),
            onPressed: () => Navigator.of(context).pop()),

      ),
      body: CrispView(

        loadingWidget: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
