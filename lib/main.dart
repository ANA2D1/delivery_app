import 'dart:developer';

import 'package:delivery_app/blocs/bloc/neworder_bloc.dart';
import 'package:delivery_app/repository/location_repo.dart';
import 'package:delivery_app/repository/offer_repo.dart';
import 'package:delivery_app/repository/order_repo.dart';
import 'package:delivery_app/repository/user_repo.dart';
import 'package:delivery_app/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'screens/phone_auth.dart';

void main() {
  runApp(
    ChangeNotifierProvider<LocationRepo>(
      create: (_) => LocationRepo(),
      lazy: false,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // OrderRepo orderRepo;
  UserRepo userRepo;

  @override
  void initState() {
    // orderRepo = OrderRepo();
    userRepo = UserRepo();
    super.initState();
  }

  @override
  void dispose() {
    userRepo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: userRepo),
        RepositoryProvider(create: (c) => OrderRepo()),
        RepositoryProvider(create: (c) => OfferRepo()),
      ],
      child: BlocProvider<NeworderBloc>(
        // lazy: false,
        create: (context) => NeworderBloc(),
        child: MaterialApp(
            // showPerformanceOverlay: true,

            title: 'Delivery app',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MobileNumberInputPage()),
      ),
    );
  }
}
