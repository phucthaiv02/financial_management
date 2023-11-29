import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:personal_financial_management/constants/color.dart';
import 'package:personal_financial_management/constants/default_categories.dart';
import 'package:personal_financial_management/models/category_model.dart';
import 'package:personal_financial_management/models/transaction_model.dart';
import 'package:personal_financial_management/utils/utilty.dart';

class CategoryScreen extends StatefulWidget {
  late String username;
  CategoryScreen({super.key, required this.username});

  @override
  CategoryScreenState createState() => CategoryScreenState(username: username);
}

class CategoryScreenState extends State<CategoryScreen> {
  late Box<CategoryModel> box;
  late String username;
  CategoryScreenState({required this.username});
  // List<CategoryModel> categories = [];
  List<CategoryModel> expenseCategories = [];
  List<CategoryModel> incomeCategories = [];

  @override
  void initState() {
    super.initState();
    openBox().then((_) {
      fetchCategories();
    });
  }

  Future<void> openBox() async {
    box = await Hive.openBox<CategoryModel>('categories');
  }

  Future<void> fetchCategories() async {
    expenseCategories = [
      ...box.values.where((category) => category.type == 'Expense'),
      ...defaultExpenseCategories
    ];

    incomeCategories = [
      ...box.values.where((category) => category.type == 'Income'),
      ...defaultIncomeCategories
    ];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Khoản thu/chi'),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Thu nhập',
              style: TextStyle(fontSize: 17, color: Colors.green),
            ),
          )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = incomeCategories[index];
                return ListTile(
                  leading: Image.asset(
                      'assets/images/${category.categoryImage}',
                      height: 40),
                  title: Text(category.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailsScreen(
                            category: category, username: username),
                      ),
                    );
                  },
                );
              },
              childCount: incomeCategories.length,
            ),
          ),
          const SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Chi tiêu',
                style: TextStyle(fontSize: 17, color: Colors.red)),
          )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = expenseCategories[index];
                return ListTile(
                  leading: Image.asset(
                      'assets/images/${category.categoryImage}',
                      height: 40),
                  title: Text(category.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailsScreen(
                            category: category, username: username),
                      ),
                    );
                  },
                );
              },
              childCount: expenseCategories.length,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryDetailsScreen extends StatefulWidget {
  final CategoryModel category;
  late String username;
  CategoryDetailsScreen(
      {super.key, required this.category, required this.username});

  @override
  State<CategoryDetailsScreen> createState() =>
      _CategoryDetailsScreenState(username: username);
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  late List<Transaction> filteredTransactions;
  late String username;
  _CategoryDetailsScreenState({required this.username});
  @override
  void initState() {
    super.initState();
    filterTransactions();
  }

  void filterTransactions() {
    final box = Hive.box<Transaction>('transactions_$username');
    filteredTransactions = box.values
        .where((transaction) =>
            transaction.category.title == widget.category.title)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        itemCount: filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = filteredTransactions[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                'assets/images/${transaction.category.categoryImage}',
                height: 40,
              ),
            ),
            title: Text(
              transaction.notes,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${transaction.createAt.day}/${transaction.createAt.month}/${transaction.createAt.year}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Text(
              formatCurrency(int.parse(transaction.amount)),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color:
                    transaction.type == 'Expense' ? Colors.red : Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
