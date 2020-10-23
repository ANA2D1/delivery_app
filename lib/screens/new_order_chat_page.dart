import 'package:delivery_app/blocs/bloc/neworder_bloc.dart';
import 'package:delivery_app/models/chat_model.dart';
import 'package:delivery_app/models/order_model.dart';
import 'package:delivery_app/repository/user_repo.dart';
import 'package:delivery_app/screens/map_page.dart';
import 'package:delivery_app/screens/order_chat_page.dart';
import 'package:delivery_app/screens/shop_list_page.dart';
import 'package:delivery_app/utils/constants.dart';
import 'package:delivery_app/utils/enums.dart';
import 'package:delivery_app/widgets/chat_widget.dart';
import 'package:delivery_app/widgets/map_widget.dart';
import 'package:delivery_app/widgets/write_needs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewOrderChatPage extends StatefulWidget {
  NewOrderChatPage({key}) : super(key: key);

  @override
  _NewOrderChatPageState createState() => _NewOrderChatPageState();
}

class _NewOrderChatPageState extends State<NewOrderChatPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    context.bloc<NeworderBloc>().add(ResetChatEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "new order",
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Delivery service"),
          actions: [
            IconButton(
                icon: Icon(Icons.restore),
                onPressed: () =>
                    context.bloc<NeworderBloc>().add(ResetChatEvent()))
          ],
        ),
        body: BlocConsumer<NeworderBloc, NeworderState>(
          // cubit: NeworderBloc(),

          builder: (context, state) {
            if (state is LoadingState) {
              return _body(
                context,
                state.chatsRepo,
                loading: true,
              );
            }
            if (state is NeworderInitial) {
              return _body(context, state.chatsRepo);
            }
            if (state is ChatViewState) {
              // state.newOrder.userId = context.repository<UserRepo>().user.id;
              state.newOrder.userId = Constants.customerId;
              return _body(context, state.chatsRepo,
                  orderModel: state.newOrder);
            }
            if (state is ChatViewLastOrderState) {
              return _body(context, state.chatsRepo);
            }
            if (state is ChatViewShopListState) {
              return _body(context, state.chatsRepo,
                  orderModel: state.newOrder);
            }
            if (state is ChatViewShopLocationState) {
              return _body(context, state.chatsRepo,
                  orderModel: state.newOrder);
            }
            if (state is ChatViewWriteItemsState) {
              return _body(context, state.chatsRepo,
                  orderModel: state.newOrder);
            }
            if (state is ChatViewDropLocationState) {
              return _body(context, state.chatsRepo,
                  orderModel: state.newOrder);
            }
            if (state is ChatViewPickDropLocationState) {
              return _body(context, state.chatsRepo,
                  orderModel: state.newOrder);
            }

            return SizedBox();
          },
          listener: (context, state) {
            if (state is ErrorState) {
              final snackbar = SnackBar(content: Text("Something went wrong"));
              _scaffoldKey.currentState.showSnackBar(snackbar);
              context.bloc<NeworderBloc>().add(ResetChatEvent());
            } else if (state is ChatViewUploadedState) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => OrderOfferPage(
                            orderModel: state.newOrder,
                          )));
            } else if (state is ChatViewLastOrderState) {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                        height: 250,
                        child: Center(child: Text("Old Orders")),
                      ));
              // _scaffoldKey.currentState
              //     .showBottomSheet((context) => Container(
              //           height: 250,
              //           child: Text("Old Orders"),
              //         ));
            } else if (state is ChatViewShopListState) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => ShopListPage()))
                  .then((shop) {
                if (shop != null) {
                  state.newOrder.shop = shop;
                  context.bloc<NeworderBloc>().add(ShopSelectedEvent(
                      chatsRepo: state.chatsRepo, orderModel: state.newOrder));
                }
              });
            } else if (state is ChatViewShopLocationState) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => MapWidget()))
                  .then((loc) {
                if (loc != null) {
                  state.newOrder.pickupLocation = loc;
                  context.bloc<NeworderBloc>().add(ShopLocationSelectedEvent(
                      chatsRepo: state.chatsRepo, orderModel: state.newOrder));
                }
              });
            } else if (state is ChatViewShopMenuState) {
            } else if (state is ChatViewWriteItemsState) {
              showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => WriteNeedsWidget(
                        needs: state.newOrder.description,
                      )).then((value) {
                if (value != null && value != '') {
                  state.newOrder.description = value;
                  context.bloc<NeworderBloc>().add(SubmitWriteNeedEvent(
                      chatsRepo: state.chatsRepo, orderModel: state.newOrder));
                }
              });
            }
            if (state is ChatViewDropLocationState) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => MapWidget()))
                  .then((loc) {
                if (loc != null) {
                  state.newOrder.dropLocation = loc;
                  context.bloc<NeworderBloc>().add(DropLoacationSelectedEvent(
                      chatsRepo: state.chatsRepo, orderModel: state.newOrder));
                }
              });
            }
            if (state is ChatViewPickDropLocationState) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => PickAndDropMap()))
                  .then((locs) {
                if (locs != null) {
                  state.newOrder.pickupLocation = locs[0];
                  state.newOrder.dropLocation = locs[1];
                  state.newOrder.distance = locs[2];
                  context.bloc<NeworderBloc>().add(
                      PickDropLoacationSelectedEvent(
                          chatsRepo: state.chatsRepo,
                          orderModel: state.newOrder));
                }
              });
            }
          },
          // buildWhen: (prevState, newState) {

          // },
          // listenWhen: (prevState, newState) {},
        ),
      ),
    );
  }

  Widget _body(BuildContext context, ChatsRepo chatsRepo,
      {bool loading = false, OrderModel orderModel}) {
    List<Chat> temp = [];
    final l = loading ? chatsRepo.chats.length + 1 : chatsRepo.chats.length;

    temp.addAll(chatsRepo.chats);
    if (loading) {
      temp.add(Chat());
    }
    final chats = temp.reversed.toList();
    return ListView.builder(
        // key: _listKey,
        reverse: true,
        shrinkWrap: true,
        itemCount: l,
        itemBuilder: (c, i) {
          if (loading && i == 0) {
            return Container(
              height: 50,
              width: 50,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final chat = chats[i];

          if (chat.type == ChatType.command || chat.type == ChatType.needs) {
            final btns = chat.buttons
                .map((button) => getButtons(
                    context, chatsRepo, button, chat.cmdActive,
                    orderModel: orderModel))
                .toList()
                .cast<CommandButton>();
            return ChatWidget(
              chat: chat,
              buttons: btns,
            );
          } else {
            return ChatWidget(chat: chat);
          }
        });
  }

  CommandButton getButtons(BuildContext context, ChatsRepo chatsRepo,
      ChatButtons button, bool active,
      {OrderModel orderModel}) {
    // print('${chatsRepo.chats[i].title}${active}');
    switch (button) {
      case ChatButtons.MyLastOrders:
        return CommandButton(
          title: "My Last Order",
          onTap: active
              ? () {
                  print(
                      "my last order button ${context.bloc<NeworderBloc>().hashCode}");
                  context
                      .bloc<NeworderBloc>()
                      .add(LastOrdersEvent(chatsRepo: chatsRepo));
                }
              : null,
        );
        break;
      case ChatButtons.NewOrders:
        return CommandButton(
          title: "New order",
          onTap: active
              ? () {
                  context
                      .bloc<NeworderBloc>()
                      .add(PlaceNewOrderEvent(chatsRepo: chatsRepo));
                }
              : null,
        );
        break;

      case ChatButtons.PackageDelivery:
        return CommandButton(
          title: "Package delivey",
          onTap: active
              ? () {
                  context
                      .bloc<NeworderBloc>()
                      .add(PackageDeliverEvent(chatsRepo: chatsRepo));
                }
              : null,
        );
        break;

      case ChatButtons.ShopList:
        return CommandButton(
          title: "Shop list",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(ShopListEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;

      case ChatButtons.ShopLocation:
        return CommandButton(
          title: "Location on map",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(ShopLocationEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;
      case ChatButtons.PickFromMenu:
        return CommandButton(
          title: "Pick from the menu",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(PickFromMenuEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;

      case ChatButtons.WriteWhatYouWant:
        return CommandButton(
          title: "Write what you want",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(WriteNeedEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;
      case ChatButtons.ChangePickFromMenu:
        return CommandButton(
          title: "Change",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(PickFromMenuEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;
      case ChatButtons.ChangeWriteWhatYouWant:
        return CommandButton(
          color: Colors.white,
          title: "Change",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(WriteNeedEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;
      case ChatButtons.DropLocation:
        return CommandButton(
          title: "Open map",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(DropLoacationEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;
      case ChatButtons.CashPayment:
        return CommandButton(
          title: "Cash",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(PaymentModeEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;

      case ChatButtons.Submit:
        return CommandButton(
          title: "Submit order",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(ConfirmOrderEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;
      case ChatButtons.Change:
        return CommandButton(
          title: "Change order",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(ModifyOrderEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;
      case ChatButtons.Cancel:
        return CommandButton(
          title: "Cancel order",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(CancelOrderEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;
      case ChatButtons.PickAndDropLocation:
        return CommandButton(
          title: "Share location",
          onTap: active
              ? () {
                  context.bloc<NeworderBloc>().add(PickDropLoacationEvent(
                      chatsRepo: chatsRepo, orderModel: orderModel));
                }
              : null,
        );
        break;

      default:
    }
    return CommandButton(
      title: "Package delivey",
      onTap: active
          ? () {
              context
                  .bloc<NeworderBloc>()
                  .add(PackageDeliverEvent(chatsRepo: chatsRepo));
            }
          : null,
    );
  }
}
