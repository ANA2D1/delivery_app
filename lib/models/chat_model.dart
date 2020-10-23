import 'package:delivery_app/utils/enums.dart';

class Chat {
  String title;
  var value;
  String sender;
  ChatType type;
  bool cmdActive;
  List<ChatButtons> buttons;
  Chat(
      {this.title,
      this.value,
      this.buttons,
      this.sender,
      this.type,
      this.cmdActive});
}

class ChatsRepo {
  List<Chat> _chats = [];
  List<Chat> get chats => this._chats;
  void push(Chat chat) => this._chats.add(chat);
  void pop() => this._chats.removeLast();
  ChatsRepo({List<Chat> chats}) {
    this._chats = chats;
  }
  void disbleButton(int index) {
    this._chats[index].cmdActive = false;
  }

  void enableButton(int index) {
    this._chats[index].cmdActive = true;
  }
}
