import '../models/loan.dart';

abstract class LoanRepository {
  Stream<List<Loan>> watchAll();

  Future<Loan?> getById(String id);

  Future<void> upsert(Loan loan);

  Future<void> deleteById(String id);
}
