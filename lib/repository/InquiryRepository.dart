import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';

class InquiryRepository{
  List<InquiryModel> inquiries;

  InquiryRepository(this.inquiries);

  List<InquiryModel> filter() =>
    inquiries.where(
            (element) => (element.active && currentUser.categories.indexOf(element.catId) != -1)).toList();


  factory InquiryRepository.fromList(List<DocumentSnapshot> inquiries){
    List<InquiryModel> _inquiries = [];
    inquiries.forEach((inquiry) {
      _inquiries.insert(0, InquiryModel.fromMap(inquiry));
    });

    return InquiryRepository(_inquiries);
  }

  factory InquiryRepository.init() => InquiryRepository([]);
}