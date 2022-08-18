import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/screens/map_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationCubit>(
          create: (BuildContext context) => LocationCubit()..getLocation(),
        ),
        BlocProvider<BirdPostCubit>(
          create: (BuildContext context) => BirdPostCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xFFF7ECDE),
          colorScheme: ColorScheme.light().copyWith(
            primary: Color(0xFF9ED2C6),
            secondary: Color(0xFF54BAB9),
          ),
        ),
        home: MapScreen(),
      ),
    );
  }
}
