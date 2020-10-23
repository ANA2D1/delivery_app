import 'package:delivery_app/models/chat_model.dart';
import 'package:delivery_app/models/order_model.dart';
import 'package:delivery_app/utils/enums.dart';
import 'package:flutter/material.dart';

class CommandButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;

  CommandButton({@required this.title, this.onTap, this.color});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: this.onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            this.title,
            style:
                TextStyle(color: this.color != null ? this.color : Colors.blue),
          ),
        ));
  }
}

class ChatWidget extends StatelessWidget {
  final Chat chat;
  final List<CommandButton> buttons;
  ChatWidget({@required this.chat, this.buttons});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: chat.sender == "SYSTEM"
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: Card(
            color: chat.sender == "USER" ? Colors.blue : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75),
                  child: _getChild()),
            )),
      ),
    );
  }

  Widget _getChild() {
    if (chat.type == ChatType.text) {
      return Text(
        chat.title,
        style: TextStyle(
            color: chat.sender == "USER" ? Colors.white : Colors.black),
      );
    } else if (chat.type == ChatType.command) {
      return Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(chat.title),
          for (CommandButton btn in buttons) ...[Divider(), btn]
        ],
      );
    } else if (chat.type == ChatType.shop) {
      return Column(
        children: [
          Container(
            child: Text(
              chat.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                child: FlutterLogo(),
              ),
              Column(
                children: [Text(chat.value.name), Text(chat.value.address)],
              )
            ],
          )
        ],
      );
    } else if (chat.type == ChatType.pickUpLoaction ||
        chat.type == ChatType.dropLocation ||
        chat.type == ChatType.pickDropLocation) {
      return Column(
        children: [
          Container(
            child: Text(
              chat.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            height: 100,
            width: 100,
            child: FlutterLogo(),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                chat.value,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    } else if (chat.type == ChatType.needs) {
      return Column(
        children: [
          Container(
            child: Text(
              chat.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            child: Text(
              chat.value,
              style: TextStyle(color: Colors.white),
            ),
          ),
          for (CommandButton btn in buttons) ...[Divider(), btn]
          //  Container(child: Text(chat.title,style: TextStyle(color: Colors.white),),color: Colors.blue,),
        ],
      );
    }
    return SizedBox(
      height: 10,
    );
  }
}
