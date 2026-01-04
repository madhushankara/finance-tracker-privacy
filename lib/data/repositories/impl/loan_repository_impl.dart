import '../../datasources/drift/datasources/drift_loan_datasource.dart';
import '../../models/loan.dart';
import '../loan_repository.dart';

final class LoanRepositoryImpl implements LoanRepository {
  LoanRepositoryImpl(this._dataSource);

  final DriftLoanDataSource _dataSource;

  @override
  Stream<List<Loan>> watchAll() => _dataSource.watchAll();

  @override
  Future<Loan?> getById(String id) => _dataSource.getById(id);

  @override
  Future<void> upsert(Loan loan) => _dataSource.upsert(loan);

  @override
  Future<void> deleteById(String id) => _dataSource.deleteById(id);
}
