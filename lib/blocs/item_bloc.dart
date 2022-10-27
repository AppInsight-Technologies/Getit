import 'dart:async';

import '../models/categoriesfields.dart';
import '../models/sellingitemsfields.dart';
import '../providers/categoryitems.dart';
import '../providers/itemslist.dart';
import 'package:rxdart/subjects.dart';

class ItemBloc{
  final _itemstab = CategoriesItemsList();
  final _items = ItemsList();
  StreamController _itemsubNestedStreamController = BehaviorSubject<List<CategoriesFields>>();
  StreamController _itemNestedStreamController = BehaviorSubject<List<CategoriesFields>>();

  StreamController _itemStreamController = BehaviorSubject<List<SellingItemsFields>>();
  // StreamController _itemssubcatStreamController = StreamController<List<CategoriesFields>>();
  StreamSink<List<CategoriesFields>> get subnesteditem =>_itemsubNestedStreamController.sink;
  StreamSink<List<CategoriesFields>> get nesteditem =>_itemNestedStreamController.sink;
  Stream<List<CategoriesFields>> get nesteditemStream =>_itemNestedStreamController.stream;
  Stream<List<CategoriesFields>> get subnesteditemStream =>_itemsubNestedStreamController.stream;
Future<void> fetchitemNested({id, prevScreen}) async{
  print("bloc...."+id.toString());
    await _itemstab.fetchNestedCategory(id, prevScreen);
  }
  StreamSink<List<SellingItemsFields>> get itemsink => _itemStreamController.sink;
  Stream<List<SellingItemsFields>> get itemStream =>_itemStreamController.stream;
fetchitems(catId,type,startitem,checkinitialy)async{
   await _items.fetchItems(catId,type,startitem,checkinitialy);
  }
}
final itembloc = ItemBloc();