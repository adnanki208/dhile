import 'dart:convert';
FaqModel faqFromJson(String str) => FaqModel.fromJson(json.decode(str));



class FaqModel {
  List<Faq> faq;

  FaqModel({
    required this.faq,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    faq: List<Faq>.from(json["faq"].map((x) => Faq.fromJson(x))),
  );

}


class Faq {

  String question;
  String answer;

  Faq({
    required this.question,
    required this.answer,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    question: json["question"],
    answer: json["answer"],
  );

}
