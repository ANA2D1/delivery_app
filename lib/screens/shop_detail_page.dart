import 'package:flutter/material.dart';

class ShopDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop details"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(15)),
            height: 200,
            // child: Placeholder(),
          ),
          ListTile(
            title: Text("Shop name"),
            subtitle: Text("shop description"),
          ),
          ListTile(
            title: Text("Customer reviews"),
            subtitle: Row(
              children: [
                Icon(
                  Icons.star_rate,
                  size: 20,
                ),
                Icon(
                  Icons.star_rate,
                  size: 20,
                ),
                Icon(
                  Icons.star_rate,
                  size: 20,
                ),
                Icon(
                  Icons.star_rate,
                  size: 20,
                ),
                Icon(
                  Icons.star_rate,
                  size: 20,
                ),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text("Address"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text("Opens"),
            subtitle: Text("9:00 AM to 11:00 PM"),
          ),
        ],
      ),
    );
  }
}
