import '../../constants/IConstants.dart';
import '../../models/VxModels/VxStore.dart';
import '../../repository/fetchdata/home_repo.dart';
import '../../utils/prefUtils.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreenController  extends VxMutation<GroceStore>{
  // HomePageRepo _homePagerepo;
  var mode;
  var branch;
  var user;
  var rows;
  //var languageid;

HomeScreenController({this.mode = "getAll",this.branch,this.user,this.rows ="0",/*this.languageid*/});
  @override
  perform() async{
    // print("homepagerepo:${((await homePagerepo.getData(ParamBodyData(user: user,branch:branch ,languageId: IConstants.languageId,mode: mode,rows: "0"))).toJson())}");
    // TODO: implement perform
   store.homescreen = await homePagerepo.getData(ParamBodyData(user: user,branch:branch ,languageId: IConstants.languageId,mode: mode,rows: "0"));
   store.userData.area = store.homescreen.data.customerDetails.length>0?store.homescreen.data.customerDetails[0].area:PrefUtils.prefs.getString("restaurant_location");
   store.userData.latitude =  store.homescreen.data.customerDetails.length>0?store.homescreen.data.customerDetails[0].latitude:PrefUtils.prefs.getString("restaurant_lat");
   store.userData.longitude =  store.homescreen.data.customerDetails.length>0?store.homescreen.data.customerDetails[0].longitude:PrefUtils.prefs.getString("restaurant_long");
   store.userData.membership =  store.homescreen.data.customerDetails.length>0?store.homescreen.data.customerDetails[0].membership:"0";
  print("area:${store.userData.area}");
  }}