import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductDetailsPage(),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phonify Stores'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Breadcrumb(),
            const SizedBox(height: 10),
            const Text(
              'Apple iPhone 13 - Refurbished',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '4.7 Star Rating (21,671 User feedback)',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              'Good, 4 GB / 128 GB, Midnight',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              '₹40,799 ₹73,099 44% OFF',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Add to cart'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Buy now'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: const Text('Add to Wishlist'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Add to Compare'),
            ),
            const SizedBox(height: 10),
            const Text('Share product:', style: TextStyle(fontSize: 16)),
            // Add your share options here
            const SizedBox(height: 10),
            const Text('Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ServiceList(),
            const SizedBox(height: 20),
            Footer(),
          ],
        ),
      ),
    );
  }
}

class Breadcrumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Home > Buy Refurbished Mobiles > Buy Refurbished Apple > Apple iPhone 13 - Refurbished',
      style: TextStyle(fontSize: 14, color: Colors.blue),
    );
  }
}

class ServiceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sell Phone'),
        Text('Sell Television'),
        Text('Sell smart watch'),
        Text('Sell smart speakers'),
        Text('Sell DSLR Camera'),
        Text('Sell Earbuds'),
        Text('Repair Phone'),
        Text('Buy Phone'),
        Text('Recycle Phone'),
      ],
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('More Info',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('Terms & Conditions'),
        Text('Privacy Policy'),
        Text('Terms of Use'),
        Text('E-waste policy'),
        Text('Cookie Policy'),
        Text('GDPR Compliance'),
        Text('What is Refurbished'),
        SizedBox(height: 10),
        Text('Company',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('About'),
        Text('Careers'),
        Text('Culture'),
        Text('Blog'),
        Text('Articles'),
        Text('Press Releases'),
        Text('Become Phonify Partner'),
        SizedBox(height: 10),
        Text('Support',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('Getting started'),
        Text('Help center'),
        Text('Server status'),
        Text('Report a bug'),
        Text('Chat support'),
        SizedBox(height: 10),
        Text('Sell Device',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('Mobile Phone'),
        Text('Laptop'),
        Text('Tablet'),
        Text('iMac'),
        Text('Gaming Consoles'),
        SizedBox(height: 20),
        Text('Chat with us',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Have any Questions? Just ask'),
        SizedBox(height: 20),
        Text('Copyright © 2023  | All Rights Reserved',
            style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
