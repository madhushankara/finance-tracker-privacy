import '../models/category.dart';
import '../models/enums.dart';

const Map<String, int> kDefaultCategoryColorHexById = <String, int>{
  'seed_exp_food': 0xFFFFB74D,
  'seed_exp_transport': 0xFF64B5F6,
  'seed_exp_shopping': 0xFFBA68C8,
  'seed_exp_home': 0xFF4DB6AC,
  'seed_exp_health': 0xFFE57373,
  'seed_exp_travel': 0xFFAED581,
  'seed_exp_education': 0xFF90A4AE,
  'seed_inc_salary': 0xFF81C784,
  'seed_inc_gift': 0xFFE57373,
};

int? defaultCategoryColorHexForId(String id) =>
    kDefaultCategoryColorHexById[id];

List<Category> buildDefaultCategories(DateTime now) {
  return const <({String id, String name, CategoryType type, String iconKey})>[
        (
          id: 'seed_exp_food',
          name: 'Food',
          type: CategoryType.expense,
          iconKey: 'food',
        ),
        (
          id: 'seed_exp_transport',
          name: 'Transport',
          type: CategoryType.expense,
          iconKey: 'transport',
        ),
        (
          id: 'seed_exp_shopping',
          name: 'Shopping',
          type: CategoryType.expense,
          iconKey: 'shopping',
        ),
        (
          id: 'seed_exp_home',
          name: 'Home',
          type: CategoryType.expense,
          iconKey: 'home',
        ),
        (
          id: 'seed_exp_health',
          name: 'Health',
          type: CategoryType.expense,
          iconKey: 'health',
        ),
        (
          id: 'seed_exp_travel',
          name: 'Travel',
          type: CategoryType.expense,
          iconKey: 'travel',
        ),
        (
          id: 'seed_exp_education',
          name: 'Education',
          type: CategoryType.expense,
          iconKey: 'education',
        ),
        (
          id: 'seed_inc_salary',
          name: 'Salary',
          type: CategoryType.income,
          iconKey: 'salary',
        ),
        (
          id: 'seed_inc_gift',
          name: 'Gift',
          type: CategoryType.income,
          iconKey: 'gift',
        ),
      ]
      .map((row) {
        return Category(
          id: row.id,
          name: row.name,
          type: row.type,
          parentId: null,
          iconKey: row.iconKey,
          colorHex: defaultCategoryColorHexForId(row.id),
          createdAt: now,
          updatedAt: now,
          archived: false,
        );
      })
      .toList(growable: false);
}
