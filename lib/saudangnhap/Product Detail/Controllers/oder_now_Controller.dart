import 'package:get/get.dart';

class OderNowController extends GetxController{
  RxString _deliverySystem = "J&T".obs;
  RxString _paymentSystem = "VN Pay".obs;
  String get deliverySys => _deliverySystem.value;
  String get paymentSys => _paymentSystem.value;

    setDelivery(String newDeliverySystem){
      _deliverySystem.value = newDeliverySystem;

  }
    setPayment(String newPaymentSystem){
      _paymentSystem.value = newPaymentSystem;

  }
}