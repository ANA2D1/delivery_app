import 'package:carousel_pro/carousel_pro.dart';
import 'package:delivery_app/models/shop_model.dart';
import 'package:delivery_app/screens/shop_detail_page.dart';
import 'package:delivery_app/screens/shop_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Category category = Category(
    id: "1",
    name: "Super market",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            _carouselWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 20),
              child: Text("Popular near you"),
            ),
            _featuredSection(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 20),
              child: Text("Category"),
            ),
            _categorySection(),
          ],
        ),
      ),
    );
  }

  _categorySection() => Table(
        children: [
          TableRow(children: [
            CategoryCard(
              category: category,
            ),
            CategoryCard(
              category: category,
            ),
          ]),
          TableRow(children: [
            CategoryCard(
              category: category,
            ),
            CategoryCard(
              category: category,
            ),
          ]),
          TableRow(children: [
            CategoryCard(
              category: category,
            ),
            CategoryCard(
              category: category,
            ),
          ]),
          TableRow(children: [
            CategoryCard(
              category: category,
            ),
            CategoryCard(
              category: category,
            ),
          ])
        ],
      );
  _featuredSection() => SizedBox(
        height: 160,
        child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (c, i) {
              ShopModel shop = ShopModel(
                  // address: "Kg halli bangalore",
                  id: "10",
                  category: category,
                  name: "Hassain's market",
                  rating: 5.0);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                child: SizedBox(
                  child: FeaturedCard(
                    shop: shop,
                  ),
                ),
              );
            }),
      );

  _carouselWidget() => SizedBox(
      height: 200.0,
      // width: 350.0,
      child: Carousel(
        images: [
          NetworkImage(
              'https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),
          NetworkImage(
              'https://cdn-images-1.medium.com/max/2000/1*wnIEgP1gNMrK5gZU7QS0-A.jpeg'),
          // ExactAssetImage("assets/images/LaunchImage.jpg")
        ],
        dotSize: 4.0,
        dotSpacing: 15.0,
        dotColor: Colors.lightGreenAccent,
        indicatorBgPadding: 5.0,
        // dotBgColor: Colors.purple.withOpacity(0.5),
        borderRadius: true,
      ));
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => ShopListPage())),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(12),
              ),
              height: 130,
              width: 170,
            ),
            FlutterLogo(
              size: 130,
            ),
            Container(
              height: 130,
              width: 170,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black45,
                        Colors.transparent,
                        Colors.transparent
                      ])),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category.name,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FeaturedCard extends StatelessWidget {
  final ShopModel shop;

  const FeaturedCard({Key key, this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ShopDetailPage())),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      child: FlutterLogo(),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(shop.name),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(shop.category.name),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                // decoration: BoxDecoration(
                //     color: Colors.green, borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        shop.rating.toString(),
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
