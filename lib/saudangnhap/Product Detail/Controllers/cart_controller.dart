import 'package:get/get.dart';
import 'package:lunalovegood/model/cart_product_model.dart';

class CartController extends GetxController{

  RxList<CartProduct> _cart = <CartProduct>[].obs; // user all product items in cart
  RxList<int> _selectedProductList = <int>[].obs;
  RxBool _isSelectedAll = false.obs;
  RxDouble _total = 0.0.obs;
  List<CartProduct> get cartList => _cart.value;
  List<int> get isSelectProduct => _selectedProductList.value;
  bool get isSelectAll => _isSelectedAll.value;
  double get total => _total.value;
  setList(List<CartProduct> list)
  {
    _cart.value = list;

  }
  addSelectedProduct(int  productSelectID)
  {
    _selectedProductList.value.add(productSelectID);
    update();
  }
  deleteSelectedProduct(int  productSelectID)
  {
    _selectedProductList.value.remove(productSelectID);
    update();
  }
  setIsSelectedAll(){

    _isSelectedAll.value = !_isSelectedAll.value;
  }
  clearAllSelectedItems()
  {
    _selectedProductList.value.clear();
    update();
  }
  setTotal(double overallTotal)
  {
    _total.value = overallTotal;
  }
}