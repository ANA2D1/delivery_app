import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:delivery_app/models/chat_model.dart';
import 'package:delivery_app/models/order_model.dart';
import 'package:delivery_app/repository/order_repo.dart';
import 'package:delivery_app/utils/enums.dart';
import 'package:delivery_app/widgets/chat_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'neworder_event.dart';
part 'neworder_state.dart';

class NeworderBloc extends Bloc<NeworderEvent, NeworderState> {
  NeworderBloc() : super(NeworderInitial());
  OrderModel orderModel;
  // final List<ChatWidget> chats = [];

  // void _disableLastChatWidget() {
  //   final tempChat = chats.last;
  //   _removeLastChatWidget();
  //   chats.add(ChatWidget(
  //     chat: tempChat.chat,
  //     alignment: tempChat.alignment,
  //     buttons:
  //         tempChat.buttons.map((e) => CommandButton(title: e.title)).toList(),
  //   ));
  // }

  // _removeLastChatWidget() {
  //   chats.removeAt(chats.length - 1);
  // }

  @override
  Stream<NeworderState> mapEventToState(
    NeworderEvent event,
  ) async* {
    if (event is ResetChatEvent) {
      yield NeworderInitial();
    } else if (event is RefreshEvent) {
      yield ChatViewState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is LastOrdersEvent) {
      if (event.chatsRepo.chats.last.title != "Last orders") {
        event.chatsRepo.push(
            Chat(title: "Last orders", type: ChatType.text, sender: "USER"));
      }
      yield LoadingState(chatsRepo: event.chatsRepo);

      final List<OrderModel> oldOrders = await _getOldOrders();
      yield ChatViewLastOrderState(
          chatsRepo: event.chatsRepo, oldOrders: oldOrders);
      try {} catch (e) {
        yield ErrorState();
      }
    } else if (event is PlaceNewOrderEvent) {
      if (event.chatsRepo.chats.last.sender == "USER") {
        event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 2);
        event.chatsRepo.pop();
      } else if (event.chatsRepo.chats.last.sender == "SYSTEM") {
        event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 1);
      }
      event.chatsRepo.push(Chat(
        type: ChatType.text,
        sender: "USER",
        title: "New order",
      ));

      yield LoadingState(chatsRepo: event.chatsRepo);
      event.chatsRepo.push(Chat(
        sender: "SYSTEM",
        type: ChatType.command,
        title: "Okay so where do you wnat to make your order from ...?",
        cmdActive: true,
        buttons: [ChatButtons.ShopList, ChatButtons.ShopLocation],
      ));
      yield ChatViewState(
          chatsRepo: event.chatsRepo,
          newOrder: OrderModel(type: OrderType.shopping));
    } else if (event is ShopListEvent) {
      if (event.chatsRepo.chats.last.type == ChatType.command ||
          event.chatsRepo.chats.last.sender == "USER") {
        if (event.chatsRepo.chats.last.sender == "USER") {
          event.chatsRepo.pop();
        }
        event.chatsRepo.push(Chat(
          title: "Shop list",
          sender: "USER",
          type: ChatType.text,
        ));
      }
      yield ChatViewShopListState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is ShopSelectedEvent) {
      event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 2);
      event.chatsRepo.push(
        Chat(
          type: ChatType.shop,
          sender: "USER",
          title: "Good you picked this place to get your order",
          value: event.orderModel.shop,
        ),
      );
      event.chatsRepo.push(
        Chat(
            type: ChatType.command,
            cmdActive: true,
            sender: "SYSTEM",
            title: "What do you need from there?",
            buttons: [ChatButtons.PickFromMenu, ChatButtons.WriteWhatYouWant]),
      );
      yield ChatViewState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is ShopLocationEvent) {
      // if (event.chatsRepo.chats.last.type == ChatType.command ||
      //     event.chatsRepo.chats.last.sender == "USER") {
      if (event.chatsRepo.chats.last.sender == "USER") {
        event.chatsRepo.pop();
      }

      event.chatsRepo.push(Chat(
        title: "Location on map",
        sender: "USER",
        type: ChatType.text,
      ));
      // }
      yield ChatViewShopLocationState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is ShopLocationSelectedEvent) {
      event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 2);
      event.chatsRepo.push(
        Chat(
          type: ChatType.pickUpLoaction,
          sender: "USER",
          title: "Pick up location",
          value: "${event.orderModel.pickupLocation.addressLine}",
        ),
      );
      event.chatsRepo.push(
        Chat(
            type: ChatType.command,
            cmdActive: true,
            sender: "SYSTEM",
            title: "What do you need from there?",
            buttons: [ChatButtons.WriteWhatYouWant]),
      );
      yield ChatViewState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is PickFromMenuEvent) {
      yield ChatViewShopMenuState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is WriteNeedEvent) {
      yield ChatViewWriteItemsState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is SelectedFromMenuEvent) {
      event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 1);
      event.chatsRepo.push(Chat(
          type: ChatType.command,
          title: "Order details",
          value: event.orderModel.description,
          buttons: [ChatButtons.ChangePickFromMenu],
          cmdActive: true,
          sender: "USER"));
      event.chatsRepo.push(Chat(
          type: ChatType.command,
          title:
              "Now I need drop off location that you wnat us to deliver to it",
          buttons: [ChatButtons.DropLocation],
          cmdActive: true,
          sender: "SYSTEM"));
      yield ChatViewState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is SubmitWriteNeedEvent) {
      if (event.chatsRepo.chats.last.title == "What do you need from there?") {
        event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 1);
        event.chatsRepo.push(Chat(
            type: ChatType.needs,
            title: "Order details",
            value: event.orderModel.description,
            buttons: [ChatButtons.ChangeWriteWhatYouWant],
            cmdActive: true,
            sender: "USER"));
        if (event.orderModel.dropLocation == null) {
          event.chatsRepo.push(Chat(
              type: ChatType.command,
              title:
                  "Now I need drop off location that you wnat us to deliver to it",
              buttons: [ChatButtons.DropLocation],
              cmdActive: true,
              sender: "SYSTEM"));
        } else {
          event.chatsRepo.push(Chat(
            type: ChatType.command,
            title: "Okay, how do you want to pay for this order",
            buttons: [ChatButtons.CashPayment],
            cmdActive: true,
            sender: "SYSTEM",
          ));
        }
      } else if (event.chatsRepo.chats.last.title ==
          "All finished and your order is ready, is there anything you want to change") {
        event.chatsRepo.chats[event.chatsRepo.chats.length - 4].value =
            event.orderModel.description;
      } else {
        event.chatsRepo.chats[event.chatsRepo.chats.length - 2].value =
            event.orderModel.description;
      }
      yield ChatViewState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is DropLoacationEvent) {
      yield ChatViewDropLocationState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is DropLoacationSelectedEvent) {
      // if (event.chatsRepo.chats.last.title == "What do you need from there?") {
      event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 2);
      event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 1);
      event.chatsRepo.push(Chat(
          type: ChatType.dropLocation,
          title: "Drop location",
          value: "${event.orderModel.dropLocation.addressLine}",
          // buttons: [ChatButtons.ChangeWriteWhatYouWant],
          // cmdActive: true,
          sender: "USER"));
      event.chatsRepo.push(Chat(
        type: ChatType.command,
        title: "Okay, how do you want to pay for this order",
        buttons: [ChatButtons.CashPayment],
        cmdActive: true,
        sender: "SYSTEM",
      ));
      // } else {
      //   event.chatsRepo.chats[event.chatsRepo.chats.length - 2].value =
      //       event.orderModel.description;
      // }
      yield ChatViewState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is PaymentModeEvent) {
      // if (event.chatsRepo.chats.last.title == "What do you need from there?") {
      // event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 2);
      event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 1);
      event.chatsRepo
          .push(Chat(type: ChatType.text, title: "Cash", sender: "USER"));
      event.chatsRepo.push(Chat(
        type: ChatType.command,
        title:
            "All finished and your order is ready, is there anything you want to change",
        buttons: [ChatButtons.Submit, ChatButtons.Change, ChatButtons.Cancel],
        cmdActive: true,
        sender: "SYSTEM",
      ));
      // } else {
      //   event.chatsRepo.chats[event.chatsRepo.chats.length - 2].value =
      //       event.orderModel.description;
      // }
      yield ChatViewState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is ConfirmOrderEvent) {
      event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 1);
      yield LoadingState(chatsRepo: event.chatsRepo);
      final id = await _uploadOrder(event.orderModel);
      if (id != null) {
        event.orderModel.id = id;
        yield ChatViewUploadedState(
            chatsRepo: event.chatsRepo, newOrder: event.orderModel);
      } else
        yield ErrorState();
    } else if (event is ModifyOrderEvent) {
      event.orderModel;
    } else if (event is CancelOrderEvent) {
      yield NeworderInitial();
    } else if (event is PackageDeliverEvent) {
      if (event.chatsRepo.chats.last.sender == "USER") {
        event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 2);
        event.chatsRepo.pop();
      } else if (event.chatsRepo.chats.last.sender == "SYSTEM") {
        event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 1);
      }
      event.chatsRepo.push(Chat(
        type: ChatType.text,
        sender: "USER",
        title: "Package delivery",
      ));

      yield LoadingState(chatsRepo: event.chatsRepo);
      event.chatsRepo.push(Chat(
        sender: "SYSTEM",
        type: ChatType.command,
        title: "Sure, share with use the location of the pick up and drop off",
        cmdActive: true,
        buttons: [ChatButtons.PickAndDropLocation],
      ));
      yield ChatViewState(
          chatsRepo: event.chatsRepo,
          newOrder: OrderModel(type: OrderType.packageDelivery));
    } else if (event is PickDropLoacationEvent) {
      yield ChatViewPickDropLocationState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    } else if (event is PickDropLoacationSelectedEvent) {
      event.chatsRepo.disbleButton(event.chatsRepo.chats.length - 1);
      event.chatsRepo.push(
        Chat(
          type: ChatType.pickUpLoaction,
          sender: "USER",
          title: "Pick up and drop location",
          value: "${event.orderModel.distance} km",
        ),
      );
      event.chatsRepo.push(
        Chat(
            type: ChatType.command,
            cmdActive: true,
            sender: "SYSTEM",
            title: "What do you need from there?",
            buttons: [ChatButtons.WriteWhatYouWant]),
      );
      yield ChatViewState(
          chatsRepo: event.chatsRepo, newOrder: event.orderModel);
    }
  }

  _getOldOrders() async {
    await Future.delayed(Duration(seconds: 2));
    return null;
  }

  _uploadOrder(OrderModel orderModel) async {
    OrderRepo orderRepo = OrderRepo();
    orderModel.status = OrderStatus.subitted;
    return await orderRepo.create(orderModel);
  }
}
