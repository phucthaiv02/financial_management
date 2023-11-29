// budget_screen.dar
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:personal_financial_management/models/category_model.dart';

class BudgetScreen extends StatefulWidget {
  final String currentUser;

  const BudgetScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  BudgetScreenState createState() =>
      BudgetScreenState(currentUser: currentUser);
}

class BudgetScreenState extends State<BudgetScreen> {
  late Box<CategoryModel> boxCategory;
  late String currentUser;
  late ValueNotifier<List<CategoryModel>> expenseCategoriesNotifier;
  BudgetScreenState({required this.currentUser});
  @override
  void initState() {
    super.initState();
    openBox().then((_) {
      fetchCategories();
    });
    expenseCategoriesNotifier = ValueNotifier<List<CategoryModel>>([]);
  }

  Future<void> openBox() async {
    boxCategory = await Hive.openBox<CategoryModel>('categories_$currentUser');
  }

  Future<void> fetchCategories() async {
    List<CategoryModel> fetchedCategories = boxCategory.values
        .where((category) => category.type == 'Expense')
        .toList();

    expenseCategoriesNotifier.value = fetchedCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Thiết lập ngân sách'),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Khoản chi tiêu',
                style: TextStyle(fontSize: 17, color: Colors.red),
              ),
            ),
          ),
          ValueListenableBuilder<List<CategoryModel>>(
            valueListenable: expenseCategoriesNotifier,
            builder: (context, expenseCategories, child) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = expenseCategories[index];
                    return ListTile(
                      leading: Image.asset(
                        'images/${category.categoryImage}',
                        height: 40,
                      ),
                      title: Row(
                        children: [
                          Text(category.title),
                          Spacer(),
                          Text(
                            "${category.monthlyBudget} VND",
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                      onTap: () {
                        _showDialog(index, category);
                      },
                    );
                  },
                  childCount: expenseCategories.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _showDialog(int index, CategoryModel category) {
    bool updatedBudget = false;
    TextEditingController valueController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cập nhật ngân sách tháng'),
          content: TextField(
            controller:
                TextEditingController(text: category.monthlyBudget.toString()),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              valueController.text = value;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                updatedBudget = false;
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  int newBudget = int.parse(valueController.text);
                  boxCategory.put(
                      index,
                      CategoryModel(
                          category.title, category.categoryImage, category.type,
                          monthlyBudget: newBudget));
                  List<CategoryModel> fetchedCategories = boxCategory.values
                      .where((category) => category.type == 'Expense')
                      .toList();
                  expenseCategoriesNotifier.value = fetchedCategories;
                });
                Navigator.pop(context);
              },
              child: const Text('Cập nhật'),
            ),
          ],
        );
      },
    );
  }
}
