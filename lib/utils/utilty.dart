import 'package:hive/hive.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:personal_financial_management/models/transaction_model.dart';

int totals = 0;

int totalBalance(Box<Transaction> box) {
  var transactions = box.values.toList();
  List listAmount = [0, 0];
  for (var i = 0; i < transactions.length; i++) {
    listAmount.add(transactions[i].type == 'Income'
        ? int.parse(transactions[i].amount)
        : int.parse(transactions[i].amount) * -1);
  }
  totals = listAmount.reduce((value, element) => value + element);
  return totals;
}

int totalIncome(Box<Transaction> box) {
  var transactions = box.values.toList();
  List listAmount = [0, 0];
  for (var i = 0; i < transactions.length; i++) {
    listAmount.add(transactions[i].type == 'Income'
        ? int.parse(transactions[i].amount)
        : 0);
  }
  totals = listAmount.reduce((value, element) => value + element);
  return totals;
}

int totalFilterdIncome(List<Transaction> transactions) {
  List listAmount = [0, 0];
  for (var i = 0; i < transactions.length; i++) {
    listAmount.add(transactions[i].type == 'Income'
        ? int.parse(transactions[i].amount)
        : 0);
  }
  totals = listAmount.reduce((value, element) => value + element);
  return totals;
}

int totalExpense(Box<Transaction> box) {
  var transactions = box.values.toList();
  List listAmount = [0, 0];
  for (var i = 0; i < transactions.length; i++) {
    listAmount.add(transactions[i].type == 'Income'
        ? 0
        : int.parse(transactions[i].amount));
  }
  totals = listAmount.reduce((value, element) => value + element);
  return totals;
}

int totalFilterdExpense(List<Transaction> transactions) {
  List listAmount = [0, 0];
  for (var i = 0; i < transactions.length; i++) {
    listAmount.add(transactions[i].type == 'Income'
        ? 0
        : int.parse(transactions[i].amount));
  }
  totals = listAmount.reduce((value, element) => value + element);
  return totals;
}

List<Transaction> getTransactionToday(
    DateTime selectedDay, Box<Transaction> box) {
  List<Transaction> result = [];
  var transactions = box.values.toList();
  for (var i = 0; i < transactions.length; i++) {
    if (transactions[i].createAt.day == selectedDay.day) {
      result.add(transactions[i]);
    }
  }

  return result;
}

List<Transaction> getTransactionWeek(
    DateTime selectedDate, Box<Transaction> box) {
  List<Transaction> result = [];
  var transactions = box.values.toList();
  for (var i = 0; i < transactions.length; i++) {
    // if (date.day - 7 <= transactions[i].createAt.day &&
    //     transactions[i].createAt.day <= date.day) {
    //   result.add(transactions[i]);
    // }
    if (isWithinCurrentWeek(transactions[i].createAt, selectedDate)) {
      result.add(transactions[i]);
    }
  }

  result.sort((a, b) => a.createAt.compareTo(b.createAt));

  return result;
}

bool isWithinCurrentWeek(DateTime date, DateTime selectedDate) {
  var startOfWeek = selectedDate;
  var endOfWeek = startOfWeek.add(const Duration(days: 6));
  // print(date);
  // print(startOfWeek);
  // print(endOfWeek);
  return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
      date.isBefore(endOfWeek);
}

List<Transaction> getTransactionMonth(
    DateTime selectedDate, Box<Transaction> box) {
  List<Transaction> result = [];
  var transactions = box.values.toList();
  for (var i = 0; i < transactions.length; i++) {
    if (transactions[i].createAt.month == selectedDate.month) {
      result.add(transactions[i]);
    }
  }

  result.sort((a, b) => a.createAt.compareTo(b.createAt));

  return result;
}

List<Transaction> getTransactionYear(
    DateTime selectedDate, Box<Transaction> box) {
  List<Transaction> result = [];
  var transactions = box.values.toList();
  for (var i = 0; i < transactions.length; i++) {
    if (transactions[i].createAt.year == selectedDate.year) {
      result.add(transactions[i]);
    }
  }

  result.sort((a, b) => a.createAt.compareTo(b.createAt));

  return result;
}

String formatCurrency(int value) {
  final format = NumberFormat.currency(
    symbol: '', // Empty symbol to remove the currency symbol
    decimalDigits: 0, // Number of decimal digits (set to 0 for VND)
    locale: 'vi_VN', // Vietnamese locale for formatting
  );

  return '${format.format(value)}VND'; // Append ' vnđ' to the formatted value
}

String getFormattedDate(int index, DateTime selectedDate) {
  switch (index) {
    case 0:
      return DateFormat('MMM dd, yyyy').format(selectedDate.toLocal());
    case 1:
      final startOfWeek =
          selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      return '${DateFormat('dd').format(startOfWeek)}-${DateFormat('dd').format(endOfWeek)} ${DateFormat('MMM, yyyy').format(selectedDate.toLocal())}';
    case 2:
      return DateFormat('MMM yyyy').format(selectedDate.toLocal());
    case 3:
      return DateFormat('yyyy').format(selectedDate.toLocal());
    default:
      return '';
  }
}
