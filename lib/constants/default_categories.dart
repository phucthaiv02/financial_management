import 'package:personal_financial_management/models/category_model.dart';

final List<CategoryModel> defaultIncomeCategories = [
  CategoryModel('Tiền lương', 'Salary.png', 'Income'),
  CategoryModel('Quà tặng', 'Gifts.png', 'Income'),
  CategoryModel('Đầu tư', 'Investments.png', 'Income'),
  CategoryModel('Tiền vay/mượn', 'Rentals.png', 'Income'),
  CategoryModel('Tiền tiết kiệm', 'Savings.png', 'Income'),
  CategoryModel('Khác', 'Others.png', 'Income'),
];
final List<CategoryModel> defaultExpenseCategories = [
  CategoryModel('Ăn uống', 'Food.png', 'Expense'),
  CategoryModel('Xe cộ', 'Transportation.png', 'Expense'),
  CategoryModel('Giáo dục', 'Education.png', 'Expense'),
  CategoryModel('Thanh toán hóa đơn', 'Bills.png', 'Expense'),
  CategoryModel('Đi lại/ Di chuyển', 'Travels.png', 'Expense'),
  CategoryModel('Thú cưng', 'Pets.png', 'Expense'),
  CategoryModel('Thuế', 'Tax.png', 'Expense'),
  CategoryModel('Khác', 'Others.png', 'Income'),
];
