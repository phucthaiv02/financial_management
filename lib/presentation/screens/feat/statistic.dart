import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_financial_management/constants/color.dart';
import 'package:personal_financial_management/models/transaction_model.dart';
import 'package:personal_financial_management/presentation/widgets/chart/circular_chart.dart';
import 'package:personal_financial_management/presentation/widgets/chart/column_chart.dart';
import 'package:personal_financial_management/utils/utilty.dart';

class Statistics extends StatefulWidget {
  late String username;

  Statistics({super.key, required this.username});

  get selectedDate => null;

  @override
  State<Statistics> createState() => _StatisticsState(username: username);
}

ValueNotifier<int> notifier = ValueNotifier<int>(0);

class _StatisticsState extends State<Statistics>
    with SingleTickerProviderStateMixin {
  late String username;
  late Box<Transaction> boxTransaction;
  _StatisticsState({required this.username}) {
    boxTransaction = Hive.box<Transaction>('transactions_$username');
  }

  List day = ['Ngày', 'Tuần', 'Tháng', 'Năm'];
  List listTransaction = [[], [], [], []];
  List<Transaction> currListTransaction = [];
  int indexColor = 0;

  DateTime selectedDate = DateTime.now();
  late int totalIn;
  late int totalEx;
  late int total;
  late TabController _tabController;
  late bool isCircularChartSelected;
  @override
  void initState() {
    super.initState();
    notifier.value = 0;
    isCircularChartSelected = false;
    _tabController = TabController(length: 2, vsync: this);
    boxTransaction.listenable().addListener(updateNotifier);
    fetchTransactions();
  }

  @override
  void dispose() {
    boxTransaction.listenable().removeListener(updateNotifier);
    _tabController.dispose();
    super.dispose();
  }

  void updateNotifier() {
    fetchTransactions();
  }

  void fetchTransactions() {
    listTransaction[0] = getTransactionToday(selectedDate, boxTransaction);
    listTransaction[1] = getTransactionWeek(selectedDate, boxTransaction);
    listTransaction[2] = getTransactionMonth(selectedDate, boxTransaction);
    listTransaction[3] = getTransactionYear(selectedDate, boxTransaction);
    totalIn = totalFilterdIncome(currListTransaction);
    totalEx = totalFilterdExpense(currListTransaction);
    total = totalIn - totalEx;
    // print(
    //   'total: $total $totalIn $totalEx',
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Thống kê'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: notifier,
          builder: (BuildContext context, int value, Widget? child) {
            // print(value);
            // print(currListTransaction);
            currListTransaction = listTransaction[value];
            totalIn = totalFilterdIncome(currListTransaction);
            totalEx = totalFilterdExpense(currListTransaction);
            total = totalIn - totalEx;
            // print(
            //   'total: $total $totalIn $totalEx',
            // );
            fetchTransactions();
            return customScrollView();
          },
        ),
      ),
    );
  }

  CustomScrollView customScrollView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                      4,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              indexColor = index;
                              notifier.value = index;
                              if (indexColor == 1) {
                                selectedDate = DateTime.now().subtract(
                                    Duration(days: DateTime.now().weekday - 1));
                              } else {
                                selectedDate = DateTime.now();
                              }

                              fetchTransactions();
                            });
                            // print(selectedDate);
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: indexColor == index
                                  ? primaryColor
                                  : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              day[index],
                              style: TextStyle(
                                color: indexColor == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getFormattedDate(indexColor, selectedDate),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  if (indexColor == 0) {
                                    selectedDate = selectedDate
                                        .subtract(const Duration(days: 1));
                                  } else if (indexColor == 1) {
                                    selectedDate = selectedDate
                                        .subtract(const Duration(days: 7));
                                  } else if (indexColor == 2) {
                                    selectedDate = DateTime(
                                        selectedDate.year,
                                        selectedDate.month - 1,
                                        selectedDate.day);
                                  } else if (indexColor == 3) {
                                    selectedDate = DateTime(
                                        selectedDate.year - 1,
                                        selectedDate.month,
                                        selectedDate.day);
                                  }
                                },
                              );
                              fetchTransactions();
                            },
                            icon: const Icon(Icons.arrow_back_ios_new)),
                        const SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(
                              () {
                                if (indexColor == 0) {
                                  selectedDate =
                                      selectedDate.add(const Duration(days: 1));
                                } else if (indexColor == 1) {
                                  selectedDate =
                                      selectedDate.add(const Duration(days: 7));
                                } else if (indexColor == 2) {
                                  selectedDate = DateTime(selectedDate.year,
                                      selectedDate.month + 1, selectedDate.day);
                                } else if (indexColor == 3) {
                                  selectedDate = DateTime(selectedDate.year + 1,
                                      selectedDate.month, selectedDate.day);
                                }
                                fetchTransactions();
                              },
                            );
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: primaryColor,
                  labelColor: primaryColor,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Biểu đồ cột'),
                    Tab(text: 'Biểu đồ tròn'),
                  ],
                  onTap: (index) {
                    setState(
                      () {
                        isCircularChartSelected = index == 1;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              isCircularChartSelected
                  ? Column(
                      children: [
                        CircularChart(
                            title: "Thu nhập",
                            currIndex: indexColor,
                            transactions: currListTransaction),
                        CircularChart(
                            title: "Chi tiêu",
                            currIndex: indexColor,
                            transactions: currListTransaction),
                      ],
                    )
                  : ColumnChart(
                      transactions: currListTransaction,
                      currIndex: indexColor,
                    ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
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
                                fontSize: 15,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          formatCurrency(totalIn),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
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
                                fontSize: 15,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          formatCurrency(totalEx),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            SizedBox(width: 30),
                            Text(
                              'Tổng cộng:',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          formatCurrency(total),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Các giao dịch',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                    'assets/images/${currListTransaction[index].category.categoryImage}',
                    height: 40),
              ),
              title: Text(
                currListTransaction[index].notes,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '${currListTransaction[index].createAt.day}/${currListTransaction[index].createAt.month}/${currListTransaction[index].createAt.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(
                formatCurrency(int.parse(currListTransaction[index].amount)),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: currListTransaction[index].type == 'Expense'
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            );
          }, childCount: currListTransaction.length),
        )
      ],
    );
  }
}
