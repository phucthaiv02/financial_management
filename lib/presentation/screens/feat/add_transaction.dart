import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:personal_financial_management/constants/color.dart';
import 'package:personal_financial_management/constants/default_categories.dart';
import 'package:personal_financial_management/models/category_model.dart';
import 'package:personal_financial_management/models/transaction_model.dart';
import 'package:personal_financial_management/utils/utilty.dart';

class AddScreen extends StatefulWidget {
  late String username;
  AddScreen({super.key, required this.username});

  @override
  State<AddScreen> createState() => _AddScreenState(username: username);
}

class _AddScreenState extends State<AddScreen> {
  late String username;
  late Box<Transaction> boxTransaction;
  _AddScreenState({required this.username}) {
    boxTransaction = Hive.box<Transaction>('transactions_$username');
  }
  List<CategoryModel> incomeCategories = defaultIncomeCategories;
  List<CategoryModel> expenseCategories = defaultExpenseCategories;

  DateTime date = DateTime.now();
  CategoryModel? selectedCategoryItem;
  String? selectedTypeItem;

  late Box<CategoryModel> boxCatagories;
  List<CategoryModel> categories = [];

  final List<String> types = ['Income', 'Expense'];

  final TextEditingController explainC = TextEditingController();
  FocusNode explainFocus = FocusNode();
  final TextEditingController amountC = TextEditingController();
  FocusNode amountFocus = FocusNode();

  bool isAmountValid = true;

  @override
  void initState() {
    super.initState();
    explainFocus.addListener(() {
      setState(() {});
    });
    amountFocus.addListener(() {
      setState(() {});
    });

    openBox().then((_) {
      fetchCategories();
    });
  }

  Future<void> openBox() async {
    boxCatagories = await Hive.openBox<CategoryModel>('categories_$username');
  }

  Future<void> fetchCategories() async {
    categories = boxCatagories.values.toList();
    setState(() {
      incomeCategories = [
        // ...defaultIncomeCategories,
        ...boxCatagories.values
            .where((category) => category.type == 'Income')
            .toList(),
      ];
      expenseCategories = [
        // ...defaultExpenseCategories,
        ...boxCatagories.values
            .where((category) => category.type == 'Expense')
            .toList(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          backgroundAddContainer(context),
          Positioned(
            top: 120,
            child: mainAddContainer(),
          )
        ],
      )),
    );
  }

  Container mainAddContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      height: 680,
      width: 360,
      child: Column(children: [
        const SizedBox(
          height: 35,
        ),
        typeField(),
        const SizedBox(
          height: 35,
        ),
        noteField(),
        const SizedBox(
          height: 35,
        ),
        amountField(),
        const SizedBox(
          height: 35,
        ),
        categoryField(),
        const SizedBox(
          height: 35,
        ),
        timeField(),
        // const Spacer(),
        const SizedBox(
          height: 35,
        ),
        addTransaction(),
        const SizedBox(
          height: 20,
        )
      ]),
    );
  }

  GestureDetector addTransaction() {
    bool isWarningShown = false;

    return GestureDetector(
      onTap: () {
        if (selectedCategoryItem == null ||
            selectedTypeItem == null ||
            explainC.text.isEmpty ||
            amountC.text.isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Thông báo'),
              content: const Text('Hãy điền đầy đủ thông tin'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
          return;
        }
        if (selectedTypeItem == "Expense") {
          double amount = double.tryParse(amountC.text) ?? 0.0;

          CategoryModel currentBox = boxCatagories.values
              .where((category) =>
                  (category.type == 'Expense') &
                  (category.title == selectedCategoryItem?.title))
              .toList()[0];
          int moneyBudget = currentBox.monthlyBudget;
          if (selectedTypeItem == 'Expense' &&
              amount > moneyBudget &&
              !isWarningShown) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Ối !!!'),
                content: Text(
                    'Bạn vừa tiêu vào khoản ${currentBox.title} vượt quá giới hạn tháng này (${formatCurrency(moneyBudget)}). Bạn thật sự ổn chứ :( '),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
            isWarningShown = true;
            return;
          }
        }
        var newTransaction = Transaction(selectedTypeItem!, amountC.text, date,
            explainC.text, selectedCategoryItem!);
        boxTransaction.add(newTransaction);
        Navigator.of(context).pop();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: primaryColor,
        ),
        height: 50,
        width: 140,
        child: const Text(
          'Thêm',
          style: TextStyle(
              fontFamily: 'f',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ),
    );
  }

  Padding timeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: const Color(0xffC5C5C5))),
        width: double.infinity,
        child: TextButton(
          onPressed: () async {
            DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020, 1, 1),
                lastDate: DateTime(2030));
            if (newDate == null) return;
            setState(() {
              date = newDate;
            });
          },
          child: Text(
            'Ngày : ${date.day}/${date.month}/${date.year}',
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Padding amountField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        focusNode: amountFocus,
        controller: amountC,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          labelText: 'Số tiền',
          labelStyle: const TextStyle(fontSize: 17, color: Colors.grey),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: primaryColor)),
          errorText: isAmountValid ? null : 'Số tiền phải lớn hơn 0',
        ),
        onChanged: (value) {
          setState(
            () {
              if (value.isEmpty) {
                isAmountValid = true;
              } else {
                isAmountValid =
                    double.tryParse(value) != null && double.parse(value) > 0;
              }
            },
          );
        },
      ),
    );
  }

  Padding typeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: primaryColor,
            )),
        child: DropdownButton<String>(
          value: selectedTypeItem,
          items: types
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Row(children: [
                      SizedBox(
                        width: 40,
                        child: Image.asset('assets/images/$e.png'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        (e == 'Income' ? 'Thu nhập' : 'Chi tiêu'),
                        style: const TextStyle(fontSize: 15),
                      )
                    ]),
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => types
              .map((e) => Row(
                    children: [
                      SizedBox(
                        width: 42,
                        child: Image.asset('assets/images/$e.png'),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text((e == 'Income' ? 'Thu nhập' : 'Chi tiêu'))
                    ],
                  ))
              .toList(),
          hint: const Text(
            'Loại giao dịch',
            style: TextStyle(color: Colors.grey),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
          onChanged: ((value) {
            setState(() {
              selectedTypeItem = value!;
              selectedCategoryItem = null;
            });
          }),
        ),
      ),
    );
  }

  Padding noteField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        focusNode: explainFocus,
        controller: explainC,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          labelText: 'Ghi chú',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: primaryColor)),
        ),
      ),
    );
  }

  Padding categoryField() {
    final List<CategoryModel> currCategories =
        selectedTypeItem == 'Income' ? incomeCategories : expenseCategories;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: primaryColor,
          ),
        ),
        child: DropdownButton<CategoryModel>(
          value: selectedCategoryItem,
          items: currCategories
              .map(
                (e) => DropdownMenuItem<CategoryModel>(
                  value: e,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Image.asset('assets/images/${e.categoryImage}'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        e.title,
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
              )
              .toList(),
          selectedItemBuilder: (BuildContext context) => currCategories
              .map(
                (e) => Row(
                  children: [
                    SizedBox(
                      width: 42,
                      child: Image.asset('assets/images/${e.categoryImage}'),
                    ),
                    const SizedBox(width: 5),
                    Text(e.title),
                  ],
                ),
              )
              .toList(),
          hint: const Text(
            'Khoản thu/chi',
            style: TextStyle(color: Colors.grey),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
          onChanged: (value) {
            setState(() {
              selectedCategoryItem = value;
            });
          },
        ),
      ),
    );
  }

  Column backgroundAddContainer(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Thêm giao dịch",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Icon(
                      Icons.attach_file_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
