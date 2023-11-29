import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:personal_financial_management/constants/color.dart';
import 'package:personal_financial_management/models/transaction_model.dart';
import 'package:personal_financial_management/utils/utilty.dart';

class SearchScreen extends StatefulWidget {
  late String username;
  SearchScreen({Key? key, required this.username}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState(username: username);
}

class SearchScreenState extends State<SearchScreen> {
  late List<Transaction> filteredTransactions;
  late String username;
  SearchScreenState({required this.username});
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filterTransactions('');
  }

  void filterTransactions(String query) {
    final box = Hive.box<Transaction>('transactions_$username');
    filteredTransactions = box.values
        .where((transaction) =>
            transaction.notes.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Tìm kiếm'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              cursorColor: primaryColor,
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm theo ghi chú',
                labelStyle: const TextStyle(color: primaryColor),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  color: primaryColor,
                  onPressed: () {
                    searchController.clear();
                    filterTransactions('');
                    setState(() {});
                  },
                ),
              ),
              onChanged: (value) {
                filterTransactions(value);
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                      color: transaction.type == 'Expense'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
