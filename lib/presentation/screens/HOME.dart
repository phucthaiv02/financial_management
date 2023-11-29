import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:personal_financial_management/constants/color.dart';
import 'package:personal_financial_management/models/transaction_model.dart';
import 'package:personal_financial_management/presentation/screens/feat/add_transaction.dart';
import 'package:personal_financial_management/presentation/screens/feat/category.dart';
import 'package:personal_financial_management/presentation/screens/feat/dashboard.dart';
import 'package:personal_financial_management/presentation/screens/feat/search.dart';
import 'package:personal_financial_management/presentation/screens/feat/statistic.dart';

class Bottom extends StatefulWidget {
  late String currentUser;
  Bottom({super.key, required this.currentUser});

  @override
  State<Bottom> createState() => _BottomState(currentUser: currentUser);
}

class _BottomState extends State<Bottom> {
  late String currentUser;
  late int indexColor;
  late List<Widget> Screen;
  _BottomState({required this.currentUser}) {
    indexColor = 0;
    Screen = [
      Dashboard(username: currentUser),
      Statistics(username: currentUser),
      CategoryScreen(username: currentUser),
      SearchScreen(username: currentUser)
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Hive.openBox<Transaction>('transactions_$currentUser');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddScreen(username: currentUser),
            ),
          );
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(
                    () {
                      indexColor = 0;
                    },
                  );
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.home,
                    size: 30,
                    color: indexColor == 0 ? primaryColor : Colors.grey,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(
                    () {
                      indexColor = 1;
                    },
                  );
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.bar_chart_outlined,
                    size: 30,
                    color: indexColor == 1 ? primaryColor : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(
                    () {
                      indexColor = 2;
                    },
                  );
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.category_outlined,
                    size: 30,
                    color: indexColor == 2 ? primaryColor : Colors.grey,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 3;
                  });
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.search_outlined,
                    size: 30,
                    color: indexColor == 3 ? primaryColor : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Screen[indexColor],
    );
  }
}
