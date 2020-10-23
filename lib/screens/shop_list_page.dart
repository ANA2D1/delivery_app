import 'package:delivery_app/models/order_model.dart';
import 'package:delivery_app/models/shop_model.dart';
import 'package:delivery_app/screens/shop_detail_page.dart';
import 'package:flutter/material.dart';

class ShopListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop List Page"),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (c, i) => ShopListTile(),
      ),
    );
  }
}

class ShopListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ShopDetailPage())),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Card(
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlutterLogo(
                  size: 80,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Name of shop",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        "Description of this shop .",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      constraints: BoxConstraints(maxWidth: 75, maxHeight: 20),
                      // padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        "100 % OFF",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(
                        "2 km away",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
