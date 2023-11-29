import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_financial_management/models/category_model.dart';
import 'package:personal_financial_management/models/login_info_model.dart';
import 'package:personal_financial_management/models/transaction_model.dart';
import 'package:personal_financial_management/presentation/screens/auth/welcome.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(LoginInfoAdapter());

  await Hive.openBox<LoginInfo>('userBox');
  // await Hive.openBox<Transaction>('transactions');
  // Hive.openBox<Transaction>('transactions_huyen');

  await Hive.openBox<CategoryModel>('categories');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
