part of 'award_detail_bloc.dart';

abstract class AwardDetailEvent {
  AwardDetailEvent();
}

class PerformAwardDetailEvent extends AwardDetailEvent {
  final String? id;
  PerformAwardDetailEvent({this.id});
}
