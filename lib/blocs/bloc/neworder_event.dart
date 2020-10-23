part of 'neworder_bloc.dart';

@immutable
abstract class NeworderEvent {}

class ResetChatEvent extends NeworderEvent {}

class RefreshEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  RefreshEvent({@required this.chatsRepo, @required this.orderModel});
}

class LastOrdersEvent extends NeworderEvent {
  final ChatsRepo chatsRepo;
  LastOrdersEvent({@required this.chatsRepo});
}

class PlaceNewOrderEvent extends NeworderEvent {
  final ChatsRepo chatsRepo;

  PlaceNewOrderEvent({@required this.chatsRepo});
}

class PackageDeliverEvent extends NeworderEvent {
  final ChatsRepo chatsRepo;

  PackageDeliverEvent({@required this.chatsRepo});
}

class ShopListEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  ShopListEvent({@required this.chatsRepo, @required this.orderModel});
}

class ShopSelectedEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;

  ShopSelectedEvent({@required this.chatsRepo, @required this.orderModel});
}

class ShopLocationEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  ShopLocationEvent({@required this.chatsRepo, @required this.orderModel});
}

class ShopLocationSelectedEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  ShopLocationSelectedEvent(
      {@required this.chatsRepo, @required this.orderModel});
}

class PickFromMenuEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  PickFromMenuEvent({@required this.chatsRepo, @required this.orderModel});
}

class SelectedFromMenuEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  SelectedFromMenuEvent({@required this.chatsRepo, @required this.orderModel});
}

class WriteNeedEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  WriteNeedEvent({@required this.chatsRepo, @required this.orderModel});
}

class SubmitWriteNeedEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  SubmitWriteNeedEvent({@required this.chatsRepo, @required this.orderModel});
}

class DropLoacationEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  DropLoacationEvent({@required this.chatsRepo, @required this.orderModel});
}

class DropLoacationSelectedEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  DropLoacationSelectedEvent(
      {@required this.chatsRepo, @required this.orderModel});
}

class PickDropLoacationEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  PickDropLoacationEvent({@required this.chatsRepo, @required this.orderModel});
}

class PickDropLoacationSelectedEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  PickDropLoacationSelectedEvent(
      {@required this.chatsRepo, @required this.orderModel});
}

class HaveCouponEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  HaveCouponEvent({@required this.chatsRepo, @required this.orderModel});
}

class PaymentModeEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  PaymentModeEvent({@required this.chatsRepo, @required this.orderModel});
}

class ConfirmOrderEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  ConfirmOrderEvent({@required this.chatsRepo, @required this.orderModel});
}

class ModifyOrderEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  ModifyOrderEvent({@required this.chatsRepo, @required this.orderModel});
}

class CancelOrderEvent extends NeworderEvent {
  final OrderModel orderModel;
  final ChatsRepo chatsRepo;
  CancelOrderEvent({@required this.chatsRepo, @required this.orderModel});
}
