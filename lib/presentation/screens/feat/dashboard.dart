import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_financial_management/constants/color.dart';
import 'package:personal_financial_management/constants/days.dart';
import 'package:personal_financial_management/models/transaction_model.dart';
import 'package:personal_financial_management/presentation/screens/feat/setting.dart';
import 'package:personal_financial_management/utils/utilty.dart';

class Dashboard extends StatefulWidget {
  late String username;
  Dashboard({super.key, required this.username});

  @override
  State<Dashboard> createState() => _Dashboard(username: username);
}

class _Dashboard extends State<Dashboard> {
  late String username;
  late Transaction transactionHistory;
  late Box<Transaction> boxTransaction;
  _Dashboard({required this.username}) {
    boxTransaction = Hive.box<Transaction>('transactions_$username');
  }

  // late int totalIn;
  // late int totalEx;
  // late int total;
  @override
  void initState() {
    super.initState();
    boxTransaction = Hive.box<Transaction>('transactions_$username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Bảng điều khiển'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: boxTransaction.listenable(),
          builder: (context, value, child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                      height: 340, child: _head(boxTransaction, username)),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lịch sử giao dịch',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  transactionHistory = boxTransaction.values.toList()[index];
                  return listTransaction(transactionHistory, index);
                }, childCount: boxTransaction.length)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget listTransaction(Transaction transactionHistory, int index) {
    return Dismissible(
        key: UniqueKey(),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Thông báo"),
                content: const Text("Bạn muốn xóa giao dịch này chứ?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Hủy"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Xóa"),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          transactionHistory.delete();
        },
        child: getTransaction(index, transactionHistory));
  }

  ListTile getTransaction(int index, Transaction transactionHistory) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
            'assets/images/${transactionHistory.category.categoryImage}',
            height: 40),
      ),
      title: Text(
        transactionHistory.notes,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${days[transactionHistory.createAt.weekday - 1]}  ${transactionHistory.createAt.day}/${transactionHistory.createAt.month}/${transactionHistory.createAt.year}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        formatCurrency(int.parse(transactionHistory.amount)),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
          color:
              transactionHistory.type == 'Expense' ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}

Stack _head(boxTransaction, String username) {
  return Stack(
    children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                    top: 30,
                    right: 30,
                    child: Builder(builder: (context) {
                      return IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingScreen(
                                      currentUSer: username,
                                    )),
                          );
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      );
                    })),
                Padding(
                    padding: const EdgeInsets.only(top: 40, left: 30),
                    child: Text(
                      "Xin chào ${username.toUpperCase()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            height: 180,
            width: 360,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: secondaryColor,
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 6,
                ),
              ],
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Số dư',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        formatCurrency(totalBalance(boxTransaction)),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20),
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.black,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Thu nhập',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.black,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Chi tiêu',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                          SizedBox(width: 30),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency(totalIncome(boxTransaction)),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        formatCurrency(totalExpense(boxTransaction)),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ],
  );
}
