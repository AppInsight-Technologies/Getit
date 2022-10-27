import 'package:flutter/cupertino.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/user.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';
enum AuthPlatform{
google,facebook,phone
}
/// this portal is to handle login And sign in Acsess [AuthPlatform]
/// is to sevar he platmorm where you want to login [data] only required if you are login true Phone
/// sent # otp and # phonenumber in map [data]
///
/// you will get error messege if error occerd from login[onerror]
/// in [onSucsess] the data parameter will pass it contain all login daata with the #new or old User Tag
/// you can check if the user is new or the old for sending the user to register page or the home page by checking it
///
class UserAppAuth {
  AuthPlatform platform;
  Auth _auth = Auth();
  /// [onsucsess] onsucsess(SocialAuthUser values)
  ///, [platform] eg: AuthPlatform.facebook
  login(AuthPlatform platform, {onSucsess,onerror,data}){
    switch(platform){

      case AuthPlatform.google:
        _auth.googleLogin((value){
          if(value.status){
            if(!value.data.newuser);
            onSucsess(value.data,null);
          }else{
            onerror(value.messege);
          }
        });
        // TODO: Handle this case.
        break;
      case AuthPlatform.facebook:
        _auth.facebookLogin((value){
          if(value.status){
            if(!value.data.newuser)
            onSucsess(value.data,null);
          }else{
            onerror(value.messege);
          }
        });
        // TODO: Handle this case.
        break;
      case AuthPlatform.phone:
        LoginData otpk;
        debugPrint("otp hi...");
        _auth.phoneNumberAuth(data["mobile"],(otp,value){
          debugPrint("otp hihi...");
          otpk = otp;
          debugPrint("otp phoneweb..."+otpk.otp.toString()+"  "+value.status.toString()+"  "+value.data.newuser.toString());
          if(value.status){
            if(value.data.newuser)
              PrefUtils.prefs.setBool('type',value.data.newuser);
            if(!value.data.newuser)
              PrefUtils.prefs.setString("apikey", value.data.id);
            // print("your api key: "+PrefUtils.prefs.getString("apikey"));
            onSucsess(value.data,otpk);
          }else{
            debugPrint("error ....");
            onerror(value.messege);
          }
        });
        // TODO: Handle this case.
        break;
    }
  }
  register({onSucsess,onerror,RegisterAuthBodyParm data}){
    _auth.userRegister(data,onSucsess: (UserData response)
    {
      onSucsess(response);
      SetUser(response);}, onError: (messege)=>onerror(messege));
  }

}
final userappauth = UserAppAuth();
class SetUserData extends VxMutation<GroceStore> {
  UserModle data;

  SetUserData(this.data);
  @override
  perform() async{
    store.userData = data.data[0];
    store.prepaid = data.prepaid[0];
    // TODO: implement perform
    print('sp.......');
    // if (PrefUtils.prefs.containsKey("apikey")) {
    //   store.userData =await auth.getuserProfile(PrefUtils.prefs.getString("apikey"),onsucsess: (value){
    //     store.userData=value;
    //   });
    // }else{
    //   store.userData =await auth.getuserProfile("1",onsucsess: (value){
    //     store.userData=value;
    //   });
    // }
  }
}
class SetUser extends VxMutation<GroceStore>{
  UserData authUser;
  SetUser(this.authUser);
  @override
  perform() async{
    store.userData =authUser;
  }
}