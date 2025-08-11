part of 'favorite_list_bloc.dart';

abstract class FavoriteListEvent {
  FavoriteListEvent();
}

class PerformFavoriteListEvent extends FavoriteListEvent {
  final int? page;
  final String? cid;
  final String? pagination;

  PerformFavoriteListEvent({this.page, this.cid, this.pagination});
}
