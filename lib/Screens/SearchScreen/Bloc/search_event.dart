part of 'search_bloc.dart';

abstract class SearchEvent {
  SearchEvent();
}

class PerformSearchEvent extends SearchEvent {
  final String? query;
  final int? page;

  PerformSearchEvent({this.query, this.page});
}
