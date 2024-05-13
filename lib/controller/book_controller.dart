import 'package:dhile/api/api_service.dart';
import 'package:dhile/controller/main_controller.dart';
import 'package:dhile/models/area.dart';
import 'package:dhile/models/book.dart';
import 'package:dhile/models/calculater.dart';
import 'package:dhile/models/response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BookController extends GetxController{


  BookController();

  Rx<bool> isLoading=true.obs;
  Rx<bool> isAccept=false.obs;
  Rx<bool> isAreaReady=false.obs;
  Rx<bool> isSubmitLoading=false.obs;
  Rx<bool> isFail=false.obs;
  Rx<bool> isInRange=true.obs;
  Rx<int> minDays=1.obs;
  Rx<String> total=''.obs;
  Rx<String> subTotal=''.obs;
  Rx<String> vat=''.obs;
  Rx<String> discount=''.obs;


  final formKey = GlobalKey<FormState>();

  Rx<DateTime> start = DateTime.now().obs;
  Rx<DateTime> end = DateTime.now().add(const Duration(days: 1)).obs;
  Rx <BookModel> bookModel=BookModel().obs;
  Rx<Calculate> calculate = Calculate().obs;
  Rxn<AreaModel> areaModel = Rxn<AreaModel>();
  Rxn<CalculateModel> calculateModel = Rxn<CalculateModel>();
  Rxn<Book> book = Rxn<Book>();
  late ResponseModel response ;
  MainController mainController=MainController();



  void setDefData(){
    bookModel.update((val) {
      val?.rentalType=0;
    });
    calculate.update((val) {
      val?.pick=0;
      val?.drop=0;
    });
  }


  Future<void> bookReset() async {
    try {
      total('');
      subTotal('');
      vat('');
      discount('');

      bookModel.update((val) {
        val?.rentalType=0;
        val?.email=null;
        val?.name=null;
        val?.phone=null;
        val?.fromDate=null;
        val?.toDate=null;
        val?.code=null;

      });
      calculate.update((val) {
        val?.pick=0;
        val?.drop=0;
        val?.areaPick=areaModel.value!.area[0].id;
        val?.areaDrop=areaModel.value!.area[0].id;
        val?.code=null;
      });
      start(DateTime.now());
      end(DateTime.now().add(Duration(days: minDays.value)));
      calc();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }



  Future<void> calc()  async {

      try {

        total('');
        subTotal('');
        vat('');
        discount('');
        DateTime fromDate=DateTime(start.value.year,start.value.month,start.value.day,);
        DateTime toDate=DateTime(end.value.year,end.value.month,end.value.day,);
        // print(end.value);
        calculate.update((val) {
          val?.fromDate = fromDate.toString();
          val?.toDate = toDate.toString();
        });

          response = await ApiService().calcSubmit(calculate());

          if(response.code==1){
            // Get.offAllNamed("/thank");
            calculateModel(CalculateModel.fromJson(response.data));
            // print(calculateModel.value!.total);
            total(calculateModel.value?.total.toString());
            subTotal(calculateModel.value?.subTotal.toString());
            vat(calculateModel.value?.vat.toString());
            discount(calculateModel.value?.discount.toString());
          }


      } catch(e){
        if (kDebugMode) {
          print(e);
        }
      }

  }
  Future<void> area()  async {

      try {


          response = await ApiService().fetchArea();

          if(response.code==1){
            areaModel(AreaModel.fromJson(response.data));
            isAreaReady(true);
            calculate.update((val) {
              val?.areaPick=areaModel.value!.area[0].id;
              val?.areaDrop=areaModel.value!.area[0].id;
            });
          }


      } catch(e){
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
          val?.pick=calculate.value.pick;
          val?.drop=calculate.value.drop;
          val?.areaPick=calculate.value.areaPick;
          val?.areaDrop=calculate.value.areaDrop;
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
            book(Book.fromJson(response.data));
            if(bookModel.value.rentalType==0) {
              Get.offAllNamed("/thank");
            }else{
              Get.toNamed('/checkout',arguments: [book.value!.url.toString()]);
            }
          }
        }

      } finally {
        isSubmitLoading(false);
      }
    }
  }

  Future<bool> confirmPay(id)  async {
    try{

      response = await ApiService().confirmPay(id);
      // print(response.message);
      if(response.code!=1){
        mainController.responseCheck(response,null);
        return false;
      }else{

        return true;
      }

    }catch(e){
      print(e);
      return false;
    }


  }

  @override
  void onInit() {

    setDefData();
    super.onInit();
  }



}
