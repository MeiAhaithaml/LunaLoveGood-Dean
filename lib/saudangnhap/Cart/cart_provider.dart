import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CartProvider with ChangeNotifier{
  int _counter = 0;
  int get counter => _counter;

  int _totalPrice = 0;
  int get totalPrice => _totalPrice;



  void _setPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setInt('total_price', _totalPrice);
    notifyListeners();
  }
    void _getPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter =prefs.getInt('cart_item')??0;
    _totalPrice= prefs.getInt('total_price') ?? 0;
    notifyListeners();
  }
  void addCounter (){
    _counter++;
    _setPrefItems();
    notifyListeners();
  }
  void removeCounter (){
    _counter--;
    _setPrefItems();
    notifyListeners();
  }
  int getCounter (){
    _getPrefItems();
    return _counter;

  }
  void addTotalPrice (int price){
    _totalPrice = _totalPrice+price;
    _setPrefItems();
    notifyListeners();
  }
  void removeTotalPrice (int price){
    _totalPrice = _totalPrice-price;
    _setPrefItems();
    notifyListeners();
  }
  int getTotalPrice (){
    _getPrefItems();
    return _totalPrice;

  }
}