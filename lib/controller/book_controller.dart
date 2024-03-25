import 'package:dhile/api/api_service.dart';
import 'package:dhile/controller/main_controller.dart';
import 'package:dhile/models/book.dart';
import 'package:dhile/models/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:stripe_checkout/stripe_checkout.dart';


class BookController extends GetxController{


  BookController();

  Rx<bool> isLoading=true.obs;
  Rx<bool> isSubmitLoading=false.obs;
  Rx<bool> isFail=false.obs;


  final formKey = GlobalKey<FormState>();

  Rx<DateTime> start = DateTime.now().obs;
  Rx<DateTime> end = DateTime.now().add(Duration(days: 1)).obs;
  Rx <BookModel> bookModel=BookModel().obs;
  late ResponseModel response ;
  MainController mainController=MainController();



  void setDefData(){
    bookModel.update((val) {
      val?.rentalType='daily';
    });
  }


  Future<void> bookReset() async {
    try {

      bookModel.update((val) {
        val?.rentalType='daily';
        val?.email=null;
        val?.name=null;
        val?.phone=null;
        val?.fromDate=null;
        val?.toDate=null;
      });
      start(DateTime.now());
      end(DateTime.now().add(Duration(days: 1)));
    } catch (e) {
      print(e);
    }
  }



  Future<void> postBook()  async {
    formKey.currentState?.validate();
    if(formKey.currentState?.validate()==true) {
      formKey.currentState?.save();

      try {

        DateTime fromDate=DateTime(start.value.year,start.value.month,start.value.day,);
        DateTime toDate=DateTime(end.value.year,end.value.month,end.value.day,);


        isSubmitLoading(true);

        bookModel.update((val) {
          val?.fromDate = fromDate.toString();
          val?.toDate = toDate.toString();
        });

        if(toDate.isBefore(fromDate) || toDate.isAtSameMomentAs(fromDate)){
          Get.showSnackbar(
            GetSnackBar(
              title: 'Warning',
              message:'Time Incorrect',
              duration: 9.seconds,
              icon: const Icon(Icons.warning_amber,color: Colors.yellow),



            ),
          );
        }else{



          response = await ApiService().bookSubmit(bookModel.value);

          if(response.code!=1){
            mainController.responseCheck(response,null);
            isFail(true);

          }else{
            Get.offAllNamed("/thank");
          }
        }

      } finally {
        isSubmitLoading(false);
      }
    }
  }
  @override
  void onInit() {

    setDefData();
    super.onInit();
  }



}
