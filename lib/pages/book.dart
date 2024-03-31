import 'dart:async';
import 'package:dhile/constant.dart';
import 'package:dhile/controller/book_controller.dart';
import 'package:dhile/models/home.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';

class BookPage extends StatefulWidget {
  final Car car;

  const BookPage({super.key, required this.car});


  @override
  State<BookPage> createState() => _BookPageState();


}

class _BookPageState extends State<BookPage> {

  BookController bookController = Get.put(BookController());
  FocusNode phoneFocus=FocusNode();
  FocusNode emailFocus=FocusNode();

  @override
  void initState() {
    super.initState();
   Timer(const Duration(microseconds: 100),() {
     bookController.formKey.currentState!.reset();
   },);

  }
@override
  void dispose() {
    phoneFocus.dispose();
    emailFocus.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {



    bookController.bookModel.update((val) {
      val?.carId=widget.car.id;
    },);

    Future<void> dateRange() async {
      DateTimeRange? newDate = await showDateRangePicker(
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                datePickerTheme: DatePickerThemeData(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  // dayBackgroundColor: MaterialStatePropertyAll(Constant.navColorBg),
                  dividerColor: Constant.mainColor,

                  headerBackgroundColor: Constant.mainColor,
                  rangePickerBackgroundColor: Colors.white,
                  rangePickerHeaderBackgroundColor: Constant.mainColor,
                  rangePickerHeaderForegroundColor: Colors.white,

                  dayStyle: const TextStyle(color: Colors.white),
                  dayOverlayColor:
                  const MaterialStatePropertyAll(Colors.white),
                ),
                // colorScheme: ColorScheme.mainColor(primary: const Color(0xFF8CE7F1)),
                colorScheme: ColorScheme.light(

                  secondary: Constant.bgColor!,
                  primary: Constant.mainColor!,

                  // header background color
                  onPrimary: Colors.white,
                  onSecondary: Colors.white,
                  // header text color
                  onSurface: Constant.dark!,
                  surface: Constant.dark!,
                ),
              ),
              child: child!,
            );
          },
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          helpText: 'Rent Date'.tr,
          locale: Get.locale,
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 2),
          // if(newDate)
          initialDateRange: DateTimeRange(
              start: bookController.start.value, end: bookController.end.value),
          barrierColor: Constant.bgColor);
      if (newDate != null) {
        bookController.start(newDate.start);
        bookController.end(newDate.end);
      }
    }



    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: Text('Your Information'.tr,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Constant.iconColor)),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: (){
                bookController.formKey.currentState?.reset();
                bookController.bookReset();
                },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SvgPicture.asset('assets/imgs/trush.svg',
                ),
              ),
            )
          ],

        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Obx((){
                    return Form(
                      key: bookController.formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 45,
                          ),
                
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      bookController.bookModel.update((val) {
                                        val?.rentalType = 'daily';
                                      });
                
                                    },
                                    child: Container(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          color: bookController.bookModel.value
                                              .rentalType ==
                                              'daily'
                                              ? Constant.mainColor
                                              : Constant.bgColor),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.calendar_month_outlined,size: 20,color:  bookController.bookModel.value.rentalType == 'daily'
                                              ? Colors.black
                                              : Colors.grey),
                                          const SizedBox(width: 5,),
                                          Text('daily'.tr,
                                              style: TextStyle(
                                                  color:bookController.bookModel.value.rentalType  == 'daily'
                                                      ? Colors.black
                                                      : Colors.grey,
                                                  fontSize: 16
                                              ),
                                              textAlign: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                  )),
                              if (widget.car.monthlyPrice != null)
                                const SizedBox(width: 8,),
                              if (widget.car.monthlyPrice != null)
                                Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        bookController.bookModel.update((val) {
                                          val?.rentalType = 'monthly';
                                        });
                
                                      },
                                      child: Container(
                                        padding:
                                        const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            color: bookController.bookModel.value
                                                .rentalType ==
                                                'monthly'
                                                ? Constant.mainColor
                                                : Constant.bgColor),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.calendar_month_outlined,size: 20,color:  bookController.bookModel.value.rentalType == 'monthly'
                                                ? Colors.black
                                                : Colors.grey),
                                            const SizedBox(width: 5,),
                                            Text('monthly'.tr,
                                                style: TextStyle(
                                                    color:bookController.bookModel.value.rentalType  == 'monthly'
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    fontSize: 16
                                                ),
                                                textAlign: TextAlign.center),
                                          ],
                                        ),
                                      ),
                                    )),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Text(
                                'Pickup & Drop Off Date'.tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Constant.iconColor, fontSize: 18,fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                color: Constant.bgColor,
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            width: MediaQuery.of(context).size.width,
                
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: dateRange,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${bookController.start.value.day}/${bookController.start.value.month}/${bookController.start.value.year} - ${bookController.end.value.day}/${bookController.end.value.month}/${bookController.end.value.year}',
                                          style: TextStyle(
                                              color: Constant
                                                  .iconColor),
                                        ),
                                        const Icon(Icons.calendar_month_outlined,size: 20,color:Colors.grey),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Constant.bgGrayColor,
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                Text(
                                  'Full Name'.tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Constant.iconColor, fontSize: 16,fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10,),
                                TextFormField(
                                  autovalidateMode: AutovalidateMode
                                      .onUserInteraction,
                                  textInputAction:
                                  TextInputAction.next,
                                  decoration:  InputDecoration(
                                      hintText: 'Enter Your Name'.tr,
                                      border: const UnderlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.all(Radius.circular(10))),
                                      filled: true,
                                      fillColor: const Color(0xffeeeeee)
                
                                  ),
                                  validator: (value) {
                
                                    if (value!.isEmpty) {
                                      return 'Required Filed'.tr;
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    bookController.bookModel
                                        .update((val) {
                                      val?.name = newValue;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  'Email'.tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Constant.iconColor, fontSize: 16,fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10,),
                                TextFormField(
                                  focusNode: emailFocus,
                                  onEditingComplete: (){
                                    emailFocus.unfocus();
                                    phoneFocus.requestFocus();
                                  },
                                  textInputAction:
                                  TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                     if (!EmailValidator
                                        .validate(value)) {
                                      return 'Most be Email'.tr;
                                    }}
                                    return null;

                                  },
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  autovalidateMode: AutovalidateMode
                                      .onUserInteraction,
                
                                  decoration:  InputDecoration(
                                      hintText: 'Enter Your Email'.tr,
                                      border: const UnderlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.all(Radius.circular(10))),
                                      filled: true,
                                      fillColor: const Color(0xffeeeeee)
                                  ),
                                  onSaved: (newValue) {
                                    bookController.bookModel
                                        .update((val) {
                                      val?.email = newValue;
                                    });
                                  },
                                ),
                
                                const SizedBox(height: 10,),
                                Text(
                                  'Phone Number'.tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Constant.iconColor, fontSize: 16,fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10,),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: IntlPhoneField(
                                    focusNode: phoneFocus,
                                    cursorColor: Constant.mainColor,
                                    textAlign: Get.locale.toString().substring(0,2)=='ar'?TextAlign.right:TextAlign.left,
                                    textInputAction:
                                    TextInputAction.done ,
                                    initialCountryCode:'AE',
                                   searchText: 'Search'.tr,
                                   pickerDialogStyle: PickerDialogStyle(backgroundColor: Colors.white,),
                                   languageCode: Get.locale.toString().substring(0,2),
                                   invalidNumberMessage: 'Invalid Phone Number'.tr ,
                                    validator: (value) {
                                      if (value!.number.isEmpty) {
                                        return 'Required Filed'.tr;
                                      } else if (value.number.length < 9) {
                                        return 'Most be More Than 9'.tr;
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.phone,
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
                                    decoration:  InputDecoration(
                                      border: const UnderlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.all(Radius.circular(10))),
                                      filled: true,
                                      fillColor: const Color(0xffeeeeee),
                                      hintText: 'Enter Your Phone'.tr,
                                      // errorText:
                                    ),

                                    onSaved: (newValue) {
                                      bookController.bookModel
                                          .update((val) {
                                        val?.phone = newValue?.completeNumber.toString();
                                      });
                                    },
                                  ),
                                ),
                
                              ],
                            ),
                          ),
                
                
                
                
                        ],
                      ),
                    );
                
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Constant.mainColor),elevation: const MaterialStatePropertyAll(0),shape:const MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),side: MaterialStatePropertyAll(BorderSide(color: Constant.mainColor!))),
                          onPressed: () {

                            FocusScope.of(context).unfocus();
                            bookController.postBook();
                          },
                          child:
                          bookController.isSubmitLoading.value == true
                              ? const Padding(
                            padding: EdgeInsets.all(7.5),
                            child: CircularProgressIndicator(color: Colors.white,),
                          )
                              : Padding(
                            padding: const EdgeInsets.only(bottom: 15.0,top: 10),
                            child: Text('Confirmation'.tr,style: const TextStyle(color: Colors.black,fontSize: 18),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

}
