import 'package:get/get.dart';

class ProductDetailController extends GetxController{
  RxInt _quantityItem = 1.obs;
  RxInt _sizeItem = 0.obs;
  RxBool _isFavorite = false.obs;

  int get quantity => _quantityItem.value;
  int get size => _sizeItem.value;
  bool get isFavorite => _isFavorite.value;

  setQuantityProduct(int quantityOfProduct)
  {
    _quantityItem.value = quantityOfProduct;
  }
  setSizeProduct(int sizeOfProduct)
  {
    _sizeItem.value = sizeOfProduct;
  }
  setIsFavoriteProduct(bool isFavoriteOfProduct)
  {
    _isFavorite.value = isFavoriteOfProduct;
  }
}