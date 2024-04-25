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
import 'dart:io' show Platform;

class BookPage extends StatefulWidget {
  final Car car;

  const BookPage({super.key, required this.car});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  BookController bookController = Get.put(BookController());
  FocusNode phoneFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    bookController.calculate.update((val) {
      val?.carId = widget.car.id;
    });
    bookController.end(
        bookController.start.value.add(Duration(days: widget.car.minDays)));
    bookController.calc();
    Timer(
      const Duration(microseconds: 100),
      () {
        bookController.formKey.currentState!.reset();
      },
    );
    bookController.area();
  }

  @override
  void dispose() {
    phoneFocus.dispose();
    emailFocus.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bookController.bookModel.update(
      (val) {
        val?.carId = widget.car.id;
      },
    );
    bookController.minDays(widget.car.minDays);

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
                  dayOverlayColor: const MaterialStatePropertyAll(Colors.white),
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
        var days = newDate.end.difference(newDate.start).inDays;
        if (days < widget.car.minDays) {
          bookController.isInRange(false);
        } else {
          bookController.isInRange(true);

          bookController.calc();
        }
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your Information'.tr,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Constant.iconColor)),
            ],
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                bookController.formKey.currentState?.reset();
                bookController.bookReset();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SvgPicture.asset(
                  'assets/imgs/trush.svg',
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
                  child: Obx(() {
                    return Form(
                      key: bookController.formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                'Pickup & Drop Off Date'.tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Constant.iconColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                                color: Constant.bgColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      bookController.total('');
                                      bookController.subTotal('');
                                      bookController.vat('');
                                      bookController.discount('');
                                      dateRange();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${bookController.start.value.day}/${bookController.start.value.month}/${bookController.start.value.year} - ${bookController.end.value.day}/${bookController.end.value.month}/${bookController.end.value.year}',
                                          style: TextStyle(
                                              color: Constant.iconColor),
                                        ),
                                        const Icon(
                                            Icons.calendar_month_outlined,
                                            size: 20,
                                            color: Colors.grey),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          if (bookController.isInRange.value == false)
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    '${'Minimum_days_For_Rant_Most_Be'.tr} ${widget.car.minDays}',
                                    style: const TextStyle(
                                        color: Color(0xffB53228)),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'PickUpLocation'.tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Constant.iconColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Transform.scale(
                                          scale: 1,
                                          child: Radio(
                                            fillColor: MaterialStatePropertyAll(
                                                bookController.calculate.value
                                                            .pick ==
                                                        0
                                                    ? Constant.mainColor
                                                    : Constant.dark),
                                            value: 0,
                                            groupValue: bookController
                                                .calculate.value.pick,
                                            onChanged: (value) {
                                              bookController.calculate
                                                  .update((val) {
                                                val?.pick = value;
                                              });
                                              bookController.calc();
                                            },
                                          ),
                                        ),
                                        Text('Self'.tr)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Transform.scale(
                                          scale: 1,
                                          child: Radio(
                                            fillColor: MaterialStatePropertyAll(
                                                bookController.calculate.value
                                                            .pick ==
                                                        1
                                                    ? Constant.mainColor
                                                    : Constant.dark),
                                            value: 1,
                                            groupValue: bookController
                                                .calculate.value.pick,
                                            onChanged: (value) {
                                              bookController.calculate
                                                  .update((val) {
                                                val?.pick = value;
                                              });

                                              bookController.calc();
                                            },
                                          ),
                                        ),
                                        Text('Deliver'.tr)
                                      ],
                                    ),
                                    if (bookController.isAreaReady.value ==
                                            true &&
                                        bookController.calculate.value.pick ==
                                            1)
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: DropdownButtonFormField(
                                                dropdownColor:
                                                    Constant.bgGrayColor,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Constant
                                                            .mainColor!),
                                                  ),
                                                ),
                                                isExpanded: true,
                                                value: bookController.calculate
                                                        .value.areaPick ??
                                                    bookController.areaModel
                                                        .value!.area[0].id,
                                                onChanged: (value) {
                                                  bookController.calculate
                                                      .update((val) {
                                                    val?.areaPick = value;
                                                  });
                                                  bookController.calc();
                                                },
                                                items: bookController
                                                    .areaModel.value!.area
                                                    .map((data) =>
                                                        DropdownMenuItem(
                                                            value: data.id,
                                                            child: Text(
                                                                data.name)))
                                                    .toList(),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'DropOffLocation'.tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Constant.iconColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Transform.scale(
                                          scale: 1,
                                          child: Radio(
                                            fillColor: MaterialStatePropertyAll(
                                                bookController.calculate.value
                                                            .drop ==
                                                        0
                                                    ? Constant.mainColor
                                                    : Constant.dark),
                                            value: 0,
                                            groupValue: bookController
                                                .calculate.value.drop,
                                            onChanged: (value) {
                                              bookController.calculate
                                                  .update((val) {
                                                val?.drop = value;
                                              });
                                              bookController.calc();
                                            },
                                          ),
                                        ),
                                        Text('Self'.tr)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Transform.scale(
                                          scale: 1,
                                          child: Radio(
                                            fillColor: MaterialStatePropertyAll(
                                                bookController.calculate.value
                                                            .drop ==
                                                        1
                                                    ? Constant.mainColor
                                                    : Constant.dark),
                                            value: 1,
                                            groupValue: bookController
                                                .calculate.value.drop,
                                            onChanged: (value) {
                                              bookController.calculate
                                                  .update((val) {
                                                val?.drop = value;
                                              });
                                              bookController.calc();
                                            },
                                          ),
                                        ),
                                        Text('Deliver'.tr)
                                      ],
                                    ),
                                    if (bookController.isAreaReady.value ==
                                            true &&
                                        bookController.calculate.value.drop ==
                                            1)
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: DropdownButtonFormField(
                                                dropdownColor:
                                                    Constant.bgGrayColor,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Constant
                                                            .mainColor!),
                                                  ),
                                                ),
                                                isExpanded: true,
                                                value: bookController.calculate
                                                        .value.areaDrop ??
                                                    bookController.areaModel
                                                        .value!.area[0].id,
                                                onChanged: (value) {
                                                  bookController.calculate
                                                      .update((val) {
                                                    val?.areaDrop = value;
                                                  });
                                                  bookController.calc();
                                                },
                                                items: bookController
                                                    .areaModel.value!.area
                                                    .map((data) =>
                                                        DropdownMenuItem(
                                                            value: data.id,
                                                            child: Text(
                                                                data.name)))
                                                    .toList(),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'PaymentMethod'.tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Constant.iconColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 1,
                                    child: Radio(
                                      fillColor: MaterialStatePropertyAll(
                                          bookController.bookModel.value
                                                      .rentalType ==
                                                  0
                                              ? Constant.mainColor
                                              : Constant.dark),
                                      value: 0,
                                      groupValue: bookController
                                          .bookModel.value.rentalType,
                                      onChanged: (value) {
                                        bookController.bookModel.update((val) {
                                          val?.rentalType = value;
                                        });
                                        // bookController.calc();
                                      },
                                    ),
                                  ),
                                  Text('PayLater'.tr)
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 1,
                                    child: Radio(
                                      fillColor: MaterialStatePropertyAll(
                                          bookController.bookModel.value
                                                      .rentalType ==
                                                  1
                                              ? Constant.mainColor
                                              : Constant.dark),
                                      value: 1,
                                      groupValue: bookController
                                          .bookModel.value.rentalType,
                                      onChanged: (value) {
                                        bookController.bookModel.update((val) {
                                          val?.rentalType = value;
                                        });
                                        // bookController.calc();
                                      },
                                    ),
                                  ),
                                  Text('PayNow'.tr)
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'DiscountCode'.tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Constant.iconColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                onChanged: (value) {
                                  bookController.calculate.update((val) {
                                    val?.code = value;
                                  });
                                  bookController.calc();
                                },
                                decoration: InputDecoration(
                                    hintText: 'EnterCode'.tr,
                                    border: const UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    filled: true,
                                    fillColor: const Color(0xffeeeeee)),
                                onSaved: (newValue) {
                                  bookController.bookModel.update((val) {
                                    val?.code = newValue;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Constant.bgGrayColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'SubTotal'.tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Constant.iconColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      bookController.subTotal.value,
                                      style: TextStyle(
                                          color: Constant.iconColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Discount'.tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Constant.iconColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      bookController.discount.value,
                                      style: TextStyle(
                                          color: Constant.iconColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Vat'.tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Constant.iconColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      bookController.vat.value,
                                      style: TextStyle(
                                          color: Constant.iconColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 2,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total'.tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Constant.iconColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      bookController.total.value,
                                      style: TextStyle(
                                          color: Constant.iconColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Constant.bgGrayColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Full Name'.tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Constant.iconColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.next,
                                  focusNode: nameFocus,
                                  onEditingComplete: () {
                                    nameFocus.unfocus();
                                    emailFocus.requestFocus();
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Enter Your Name'.tr,
                                      border: const UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      filled: true,
                                      fillColor: const Color(0xffeeeeee)),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Required Filed'.tr;
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    bookController.bookModel.update((val) {
                                      val?.name = newValue;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Email'.tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Constant.iconColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  focusNode: emailFocus,
                                  onEditingComplete: () {
                                    emailFocus.unfocus();
                                    phoneFocus.requestFocus();
                                  },
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                      if (!EmailValidator.validate(value)) {
                                        return 'Most be Email'.tr;
                                      }
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                      hintText: 'Enter Your Email'.tr,
                                      border: const UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      filled: true,
                                      fillColor: const Color(0xffeeeeee)),
                                  onSaved: (newValue) {
                                    bookController.bookModel.update((val) {
                                      val?.email = newValue;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Phone Number'.tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Constant.iconColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: IntlPhoneField(
                                    focusNode: phoneFocus,
                                    cursorColor: Constant.mainColor,
                                    textAlign:
                                        Get.locale.toString().substring(0, 2) ==
                                                'ar'
                                            ? TextAlign.right
                                            : TextAlign.left,
                                    textInputAction: TextInputAction.done,
                                    initialCountryCode: 'AE',
                                    searchText: 'Search'.tr,
                                    pickerDialogStyle: PickerDialogStyle(
                                      backgroundColor: Colors.white,
                                    ),
                                    languageCode:
                                        Get.locale.toString().substring(0, 2),
                                    invalidNumberMessage:
                                        'Invalid Phone Number'.tr,
                                    validator: (value) {
                                      if (value!.number.isEmpty) {
                                        return 'Required Filed'.tr;
                                      } else if (value.number.length < 9) {
                                        return 'Most be More Than 9'.tr;
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.phone,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      border: const UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      filled: true,
                                      fillColor: const Color(0xffeeeeee),
                                      hintText: 'Enter Your Phone'.tr,
                                      // errorText:
                                    ),
                                    onSaved: (newValue) {
                                      bookController.bookModel.update((val) {
                                        val?.phone =
                                            newValue?.completeNumber.toString();
                                        val?.countryCode =
                                            newValue?.countryCode;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                        focusColor: Constant.mainColor,
                        activeColor: Constant.mainColor,
                        value: bookController.isAccept.value,
                        onChanged: (newValue) {
                          setState(() => bookController.isAccept(newValue));
                        }),
                    GestureDetector(
                        child: Row(
                          children: [
                            Text('Accept'.tr,
                                style: const TextStyle(fontSize: 16)),
                            const Text(' '),
                            Text('Terms&Conditions'.tr,style: const TextStyle(fontSize: 16,color: Colors.blue),)
                          ],
                        ),
                        onTap: () {
                          Get.defaultDialog(
                            content: Flexible(
                              child: SingleChildScrollView(
                                child: Text('TermContent'.tr,
                                   ),
                              ),
                            ),
                            title: 'Terms&Conditions'.tr
                          );
                        }),
                  ]),
              Padding(
                padding: EdgeInsets.only(
                    left: 5, right: 5, bottom: Platform.isIOS ? 25 : 15),
                child: Row(
                  children: [
                    Expanded(
                      child: IgnorePointer(
                        ignoring: !bookController.isAccept.value,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    bookController.isAccept.value == true
                                        ? Constant.mainColor!
                                        : const Color(0xffc7a340)),
                                elevation: const MaterialStatePropertyAll(0),
                                shape: const MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                side: MaterialStatePropertyAll(
                                    BorderSide(color: Constant.mainColor!))),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              bookController.postBook();
                            },
                            child: bookController.isSubmitLoading.value == true
                                ? const Padding(
                                    padding: EdgeInsets.all(7.5),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 15.0, top: 10),
                                    child: Text(
                                      'Confirmation'.tr,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
