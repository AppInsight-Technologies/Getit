import 'package:rxdart/rxdart.dart';
import '../providers/cartItems.dart';
import '../providers/sellingitems.dart';

class HomeDisplayBloc {

  final featuredItemController = BehaviorSubject<SellingItemsList>.seeded(null);
  Stream<SellingItemsList> get featuredItem => featuredItemController.stream;
  Function(SellingItemsList) get setFeaturedItem => featuredItemController.sink.add;

  final cartItemController = BehaviorSubject<CartItems>.seeded(null);
  Stream<CartItems> get cartItem => cartItemController.stream;
  Function(CartItems) get setCartItem => cartItemController.sink.add;

  void dispose() {
    featuredItemController.close();
    cartItemController.close();
  }
}
