import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../api_connection/api_connection.dart';
import 'admin_get_order.dart';
import 'login_admin_page.dart';
class AdminUploadItems extends StatefulWidget {
  const AdminUploadItems({super.key});

  @override
  State<AdminUploadItems> createState() => _AdminUploadItemsState();
}

class _AdminUploadItemsState extends State<AdminUploadItems> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;
  TextEditingController productNameController = TextEditingController();
  var productImageLink = "";
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productAverageStarController = TextEditingController();
  TextEditingController productInventoryController = TextEditingController();
  TextEditingController productTagsController = TextEditingController();
  TextEditingController productSizeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productCountBuyController = TextEditingController();
  bool isName = false;
  bool isPrice = false;
  bool isAverage = false;
  bool isInventory = false;
  bool isTag = false;
  bool isSize = false;
  bool isDescription = false;
  bool isCountBuy =false;

  //defaultScreen methods
  captureImageWithPhoneCamera() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);

    Get.back();

    setState(() => pickedImageXFile);
  }

  pickImageFromPhoneGallery() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    Get.back();

    setState(() => pickedImageXFile);
  }

  @override
  void initState() {
    super.initState();
    productNameController.addListener(() {
      setState(() {
        isName = productNameController.text.isNotEmpty;
      });
    });
    productAverageStarController.addListener(() {
      setState(() {
        isAverage = productAverageStarController.text.isNotEmpty;
      });
    });
    productDescriptionController.addListener(() {
      setState(() {
        isDescription = productDescriptionController.text.isNotEmpty;
      });
    });
    productInventoryController.addListener(() {
      setState(() {
        isInventory = productInventoryController.text.isNotEmpty;
      });
    });
    productPriceController.addListener(() {
      setState(() {
        isPrice = productPriceController.text.isNotEmpty;
      });
    });
    productSizeController.addListener(() {
      setState(() {
        isSize = productSizeController.text.isNotEmpty;
      });
    });
    productTagsController.addListener(() {
      setState(() {
        isTag = productTagsController.text.isNotEmpty;
      });
    });
    productCountBuyController.addListener(() {
      setState(() {
        isCountBuy = productCountBuyController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    productNameController.dispose();
    productPriceController.dispose();
    productTagsController.dispose();
    productSizeController.dispose();
    productDescriptionController.dispose();
    productInventoryController.dispose();
    productAverageStarController.dispose();
    productCountBuyController.dispose();
  }

  bool obscurePassword = true;

  showDialogBoxForImagePickingAndCapturing() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Ảnh sản phẩm",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  captureImageWithPhoneCamera();
                },
                child: const Text(
                  "Chụp bằng Camera điện thoại",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImageFromPhoneGallery();
                },
                child: const Text(
                  "Chọn hình ảnh từ thư viện điện thoại",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
  }

  //defaultScreen methods ends here

  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration:  const BoxDecoration(
           color:  Color(0xFFFF8B8B),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkResponse(
                onTap: () {
                 Get.to(const SignInAdminPage());
                  setState((){
                    pickedImageXFile=null;
                    productSizeController.clear();
                    productTagsController.clear();
                    productPriceController.clear();
                    productDescriptionController.clear();
                    productInventoryController.clear();
                    productAverageStarController.clear();
                    productNameController.clear();
                    productCountBuyController.clear();

                  });
                },
                child: SvgPicture.asset("assets/Exit.svg")),
            const Text("Chào mừng Admin",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),),
            InkResponse(
                onTap: () {
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>  AdminGetAllOrderScreen(),
                      ),
                    );
                  }
                },
                child: const Text("Đơn hàng",style: TextStyle(fontSize: 16,color: Colors.red),),),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate,
              color: Colors.black26,
              size: 200,
            ),

            //button
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () {
                  showDialogBoxForImagePickingAndCapturing();
                },
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 28,
                  ),
                  child: Text(
                    "Thêm sản phẩm",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
//uploadItemForm
  uploadItemImage() async{
 var requestImgurApi = http.MultipartRequest(
    "POST",
    Uri.parse("https://api.imgur.com/3/image")
  );

 String imageName = DateTime.now().microsecondsSinceEpoch.toString();
 requestImgurApi.fields['title'] = imageName;
 requestImgurApi.headers['Authorization'] = "Client-ID " + "2536a20ff6aad88";

 var imageFile = await http.MultipartFile.fromPath(
  'image',
     pickedImageXFile!.path,
   filename: imageName,

 );
 requestImgurApi.files.add(imageFile);
  var responseFromImgurApi = await requestImgurApi.send();
  var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
  var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);

  Map<String,dynamic> jsonRes = json.decode(resultFromImgurApi);
  productImageLink = (jsonRes["data"]["link"]).toString();
  String deleteHash =  (jsonRes["data"]["deletehash"]).toString();
 print("productImageLink :: ");
 print(productImageLink);

 print("deleteHash :: ");
 print(deleteHash);
  saveItemInfoToDatabase();

  }

  saveItemInfoToDatabase()async{

   List<String> tagsList = productTagsController.text.split(',');// hàng mới nhất, sản phẩm bán chạy, hoa hồng
   List<String> sizeList = productSizeController.text.split(',');// S,M,L

    try{
     var res = await http.post(Uri.parse(API.upLoadItems),
      body: {
        'item_id': '1',
        'name': productNameController.text.trim(),
        'average': productAverageStarController.text.trim(),
        'inventory':productInventoryController.text.trim(),
        'tag':tagsList.toString(),
        'sizes':sizeList.toString(),
        'description':productDescriptionController.text.trim(),
        'price':productPriceController.text.trim(),
        'image':productImageLink.toString(),
        'countBuy':productCountBuyController.text.trim()
      },
      );
     if(res.statusCode ==  200){
       var resBodyOfUpLoadItems = jsonDecode(res.body);

       if(resBodyOfUpLoadItems['success']== true)
       {
         Fluttertoast.showToast(msg: "Thêm sản phẩm thành công");
         setState((){
           pickedImageXFile=null;
           productSizeController.clear();
           productTagsController.clear();
           productPriceController.clear();
           productDescriptionController.clear();
           productInventoryController.clear();
           productAverageStarController.clear();
           productCountBuyController.clear();
           productNameController.clear();});
         Get.to(const AdminUploadItems());
       }
       else
       {
         Fluttertoast.showToast(msg: "Thêm sản phẩm không thành công");
       }
     }
     else{
       Fluttertoast.showToast(msg: "Khong hien status 200");
     }
    }
    catch(errorMsg)
    {
      print("error::" + errorMsg.toString());
    }
  }


  Widget uploadItemFormScreen() {
    return Scaffold(
      body: ListView(
        children: [
          //image
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(pickedImageXFile!.path),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _inputField('Tên sản phẩm*', productNameController),
              const SizedBox(
                height: 20,
              ),
              _inputField('Đánh giá', productAverageStarController),
              const SizedBox(
                height: 20,
              ),
              _inputField('Mô tả*', productDescriptionController),
              const SizedBox(
                height: 20,
              ),
              _inputField('Số lượng tồn kho*', productInventoryController),
              const SizedBox(
                height: 20,
              ),
              _inputField('Giá sản phẩm*', productPriceController),
              const SizedBox(
                height: 20,
              ),
              _inputField('Size sản phẩm*', productSizeController),
              const SizedBox(
                height: 20,
              ),
              _inputField('Loại sản phẩm*', productTagsController),
              const SizedBox(
                height: 20,
              ),
              _inputField('Số lượng đã bán*', productCountBuyController),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  uploadItemImage();
                },
                child: Container(
                  width: 298,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    color: isName &&
                            isDescription &&
                            isInventory &&
                            isPrice &&
                            isSize &&
                            isTag
                        ? const Color(0xFF000000)
                        : Colors.grey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        uploadItemImage();
                      },
                      child: const Text(
                        'Thêm sản phẩm',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 34,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _inputField(
    String hintText,
    TextEditingController controller,
  ) {
    return Container(
        width: 298,
        height: 60,
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: Color(0xFFCBD5E1),
            width: 1,
          )),
        ),
        child: TextField(
          style: const TextStyle(color: Color(0XFF262626)),
          controller: controller,
          decoration: InputDecoration(
            labelText: hintText,
            hintStyle: const TextStyle(
              color: Colors.black12,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ? defaultScreen() : uploadItemFormScreen();
  }
}
