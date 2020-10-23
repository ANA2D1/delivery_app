import 'package:flutter/material.dart';

class WriteNeedsWidget extends StatefulWidget {
  WriteNeedsWidget({this.needs});
  final String needs;
  @override
  _WriteNeedsWidgetState createState() => _WriteNeedsWidgetState();
}

class _WriteNeedsWidgetState extends State<WriteNeedsWidget> {
  TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController.text = widget.needs;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              tileColor: Colors.white,
              title: Text("Order"),
              trailing: InkWell(
                  child: Icon(Icons.close),
                  onTap: () => Navigator.pop(context)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Order details"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                color: Colors.white,
                child: TextField(
                  onChanged: (str) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      border: InputBorder.none,
                      fillColor: Colors.grey,
                      hintText: "Write your needs"),
                  controller: textEditingController,
                  maxLines: 20,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (textEditingController.text != '') {
                  Navigator.pop(context, textEditingController.text);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 30,
                  width: double.infinity,
                  color: textEditingController.text != ''
                      ? Colors.blue
                      : Colors.grey,
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
