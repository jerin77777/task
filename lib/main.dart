import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/globals.dart';
import 'package:task/screens/products.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallet.background,
      appBar: AppBar(
        title: const Text(
          'Pagination Variants',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Pallet.appbar,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginationScroll()),
                );
              },
              child: Center(
                child: Text(
                  'Pagination Scroll',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Set border radius here
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor: Pallet.theme,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(180, 40),
                  maximumSize: const Size(180, 40)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginationNumbers()),
                );
              },
              child: Center(
                child: Text(
                  'Pagination Numbers',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Set border radius here
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor: Pallet.theme,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(180, 40),
                  maximumSize: const Size(180, 40)),
            ),
          ],
        ),
      ),
    );
  }
}
