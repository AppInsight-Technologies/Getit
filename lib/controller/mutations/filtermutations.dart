import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/filterModle.dart';
import '../../repository/filterdata/filter_repo.dart';
import 'package:velocity_x/velocity_x.dart';

enum Filters{
  COLOR,SIZE,FIT,ALL
}
class filterMutation extends VxMutation<GroceStore>{
  Filters filters;
  var data;
  filterMutation({this.filters,this.data});

  @override
  perform() {
    // TODO: implement perform
    switch (filters){

      case Filters.COLOR:
        // TODO: Handle this case.
     store.filterData.colorItems.where((element) => element.id==data["id"]).first.selected=data["boolean"];
        break;
      case Filters.SIZE:
        // TODO: Handle this case.
        store.filterData.sizeItems.where((element) => element.id==data["id"]).first.selected=data["boolean"];
        break;
      case Filters.FIT:
        // TODO: Handle this case.
        store.filterData.fitItems.where((element) => element.id==data["id"]).first.selected=data["boolean"];
        break;
      case Filters.ALL:
        // TODO: Handle this case.
      store.filterData = data;
        break;
    }
  }

}
class Futurecontroller{
   setAll() async {
    filterMutation(filters: Filters.ALL,data: FilterData(colorItems: await FilterRepo().getFilterColor(),fitItems:await FilterRepo().getFilterFit(),sizeItems:await FilterRepo().getFilterSize() ));
  }
  setColor(String id,bool setvalue)async{
     filterMutation(filters: Filters.COLOR,data:{"id":id,"boolean":setvalue});
  }
  setSize(String id,bool setvalue)async{
    filterMutation(filters: Filters.SIZE,data: {"id":id,"boolean":setvalue});
  }
  setFit(String id,bool setvalue)async{
    filterMutation(filters: Filters.FIT,data: {"id":id,"boolean":setvalue});
  }
}