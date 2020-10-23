part of 'neworder_bloc.dart';

@immutable
abstract class NeworderState {}

class NeworderInitial extends NeworderState {
  final ChatsRepo chatsRepo = ChatsRepo(chats: [
    Chat(
      sender: 'SYSTEM',
      title: "Hello wellcome to We deliver!",
      type: ChatType.text,
    ),
    Chat(
      sender: 'SYSTEM',
      title: "We deliver every thing!",
      type: ChatType.text,
    ),
    Chat(
      sender: 'SYSTEM',
      title: "How can we be at your service?",
      type: ChatType.command,
      cmdActive: true,
      buttons: [
        ChatButtons.MyLastOrders,
        ChatButtons.NewOrders,
        ChatButtons.PackageDelivery
      ],
    ),
  ]);
}

class LoadingState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel orderModel;
  LoadingState({@required this.chatsRepo, this.orderModel});
}

class ErrorState extends NeworderState {}

// class ChatViewGreetingState extends NeworderState {
//   final List<Chat> chats;
//   ChatViewGreetingState({@required this.chats});
// }

class ChatViewLastOrderState extends NeworderState {
  final List<OrderModel> oldOrders;
  final ChatsRepo chatsRepo;
  ChatViewLastOrderState({@required this.chatsRepo, this.oldOrders});
}

class ChatViewState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewState({@required this.chatsRepo, this.newOrder});
}

class ChatViewNewOrderState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewNewOrderState({@required this.chatsRepo, this.newOrder});
}

class ChatViewShopListState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewShopListState({@required this.chatsRepo, this.newOrder});
}

class ChatViewShopLocationState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewShopLocationState({@required this.chatsRepo, this.newOrder});
}

class ChatViewShopMenuState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewShopMenuState({@required this.chatsRepo, this.newOrder});
}

class ChatViewWriteItemsState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewWriteItemsState({@required this.chatsRepo, this.newOrder});
}

class ChatViewDropLocationState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewDropLocationState({@required this.chatsRepo, this.newOrder});
}

class ChatViewPickDropLocationState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewPickDropLocationState({@required this.chatsRepo, this.newOrder});
}

class ChatViewAddCouponState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewAddCouponState({@required this.chatsRepo, this.newOrder});
}

class ChatViewConfirmedState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewConfirmedState({@required this.chatsRepo, this.newOrder});
}

class ChatViewUploadedState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewUploadedState({@required this.chatsRepo, this.newOrder});
}

class ChatViewOrderEditState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewOrderEditState({@required this.chatsRepo, this.newOrder});
}

class ChatViewCancellState extends NeworderState {
  final ChatsRepo chatsRepo;
  final OrderModel newOrder;
  ChatViewCancellState({@required this.chatsRepo, this.newOrder});
}
