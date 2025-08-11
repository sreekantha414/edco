part of 'set_favorite_bloc.dart';

abstract class SetFavoriteEvent {
  SetFavoriteEvent();
}

class PerformSetFavoriteEvent extends SetFavoriteEvent {
  final dynamic data;

  PerformSetFavoriteEvent({this.data});
}
