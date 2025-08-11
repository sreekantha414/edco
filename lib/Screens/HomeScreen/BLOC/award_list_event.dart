part of 'award_list_bloc.dart';

abstract class AwardListEvent {
  AwardListEvent();
}

class PerformAwardListEvent extends AwardListEvent {
  final String? id;
  final int? page;
  final String? tag;
  final String? pagination;

  PerformAwardListEvent({this.id, required this.page, this.tag, this.pagination});
}
