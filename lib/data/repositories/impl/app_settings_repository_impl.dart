import '../../datasources/drift/datasources/drift_app_settings_datasource.dart';
import '../../models/app_settings.dart';
import '../app_settings_repository.dart';

final class AppSettingsRepositoryImpl implements AppSettingsRepository {
  AppSettingsRepositoryImpl(this._dataSource);

  final DriftAppSettingsDataSource _dataSource;

  @override
  Stream<AppSettings> watch() => _dataSource.watch();

  @override
  Future<AppSettings> get() => _dataSource.get();

  @override
  Future<void> upsert(AppSettings settings) => _dataSource.upsert(settings);
}
