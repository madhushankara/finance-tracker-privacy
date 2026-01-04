// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTableTable extends AccountsTable
    with TableInfo<$AccountsTableTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AccountType>($AccountsTableTable.$convertertype);
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingBalanceMinorMeta =
      const VerificationMeta('openingBalanceMinor');
  @override
  late final GeneratedColumn<int> openingBalanceMinor = GeneratedColumn<int>(
    'opening_balance_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingBalanceScaleMeta =
      const VerificationMeta('openingBalanceScale');
  @override
  late final GeneratedColumn<int> openingBalanceScale = GeneratedColumn<int>(
    'opening_balance_scale',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _institutionMeta = const VerificationMeta(
    'institution',
  );
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
    'institution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    currencyCode,
    openingBalanceMinor,
    openingBalanceScale,
    institution,
    note,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('opening_balance_minor')) {
      context.handle(
        _openingBalanceMinorMeta,
        openingBalanceMinor.isAcceptableOrUnknown(
          data['opening_balance_minor']!,
          _openingBalanceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingBalanceMinorMeta);
    }
    if (data.containsKey('opening_balance_scale')) {
      context.handle(
        _openingBalanceScaleMeta,
        openingBalanceScale.isAcceptableOrUnknown(
          data['opening_balance_scale']!,
          _openingBalanceScaleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingBalanceScaleMeta);
    }
    if (data.containsKey('institution')) {
      context.handle(
        _institutionMeta,
        institution.isAcceptableOrUnknown(
          data['institution']!,
          _institutionMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $AccountsTableTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      openingBalanceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance_minor'],
      )!,
      openingBalanceScale: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance_scale'],
      )!,
      institution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AccountsTableTable createAlias(String alias) {
    return $AccountsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, int, int> $convertertype =
      const EnumIndexConverter<AccountType>(AccountType.values);
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final String name;
  final AccountType type;
  final String currencyCode;
  final int openingBalanceMinor;
  final int openingBalanceScale;
  final String? institution;
  final String? note;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AccountRow({
    required this.id,
    required this.name,
    required this.type,
    required this.currencyCode,
    required this.openingBalanceMinor,
    required this.openingBalanceScale,
    this.institution,
    this.note,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>(
        $AccountsTableTable.$convertertype.toSql(type),
      );
    }
    map['currency_code'] = Variable<String>(currencyCode);
    map['opening_balance_minor'] = Variable<int>(openingBalanceMinor);
    map['opening_balance_scale'] = Variable<int>(openingBalanceScale);
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccountsTableCompanion toCompanion(bool nullToAbsent) {
    return AccountsTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      currencyCode: Value(currencyCode),
      openingBalanceMinor: Value(openingBalanceMinor),
      openingBalanceScale: Value(openingBalanceScale),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $AccountsTableTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      openingBalanceMinor: serializer.fromJson<int>(
        json['openingBalanceMinor'],
      ),
      openingBalanceScale: serializer.fromJson<int>(
        json['openingBalanceScale'],
      ),
      institution: serializer.fromJson<String?>(json['institution']),
      note: serializer.fromJson<String?>(json['note']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(
        $AccountsTableTable.$convertertype.toJson(type),
      ),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'openingBalanceMinor': serializer.toJson<int>(openingBalanceMinor),
      'openingBalanceScale': serializer.toJson<int>(openingBalanceScale),
      'institution': serializer.toJson<String?>(institution),
      'note': serializer.toJson<String?>(note),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AccountRow copyWith({
    String? id,
    String? name,
    AccountType? type,
    String? currencyCode,
    int? openingBalanceMinor,
    int? openingBalanceScale,
    Value<String?> institution = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AccountRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    currencyCode: currencyCode ?? this.currencyCode,
    openingBalanceMinor: openingBalanceMinor ?? this.openingBalanceMinor,
    openingBalanceScale: openingBalanceScale ?? this.openingBalanceScale,
    institution: institution.present ? institution.value : this.institution,
    note: note.present ? note.value : this.note,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AccountRow copyWithCompanion(AccountsTableCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      openingBalanceMinor: data.openingBalanceMinor.present
          ? data.openingBalanceMinor.value
          : this.openingBalanceMinor,
      openingBalanceScale: data.openingBalanceScale.present
          ? data.openingBalanceScale.value
          : this.openingBalanceScale,
      institution: data.institution.present
          ? data.institution.value
          : this.institution,
      note: data.note.present ? data.note.value : this.note,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('openingBalanceMinor: $openingBalanceMinor, ')
          ..write('openingBalanceScale: $openingBalanceScale, ')
          ..write('institution: $institution, ')
          ..write('note: $note, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    currencyCode,
    openingBalanceMinor,
    openingBalanceScale,
    institution,
    note,
    archived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.currencyCode == this.currencyCode &&
          other.openingBalanceMinor == this.openingBalanceMinor &&
          other.openingBalanceScale == this.openingBalanceScale &&
          other.institution == this.institution &&
          other.note == this.note &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsTableCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<String> currencyCode;
  final Value<int> openingBalanceMinor;
  final Value<int> openingBalanceScale;
  final Value<String?> institution;
  final Value<String?> note;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AccountsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.openingBalanceMinor = const Value.absent(),
    this.openingBalanceScale = const Value.absent(),
    this.institution = const Value.absent(),
    this.note = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsTableCompanion.insert({
    required String id,
    required String name,
    required AccountType type,
    required String currencyCode,
    required int openingBalanceMinor,
    required int openingBalanceScale,
    this.institution = const Value.absent(),
    this.note = const Value.absent(),
    this.archived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       currencyCode = Value(currencyCode),
       openingBalanceMinor = Value(openingBalanceMinor),
       openingBalanceScale = Value(openingBalanceScale),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? currencyCode,
    Expression<int>? openingBalanceMinor,
    Expression<int>? openingBalanceScale,
    Expression<String>? institution,
    Expression<String>? note,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (openingBalanceMinor != null)
        'opening_balance_minor': openingBalanceMinor,
      if (openingBalanceScale != null)
        'opening_balance_scale': openingBalanceScale,
      if (institution != null) 'institution': institution,
      if (note != null) 'note': note,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<AccountType>? type,
    Value<String>? currencyCode,
    Value<int>? openingBalanceMinor,
    Value<int>? openingBalanceScale,
    Value<String?>? institution,
    Value<String?>? note,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AccountsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currencyCode: currencyCode ?? this.currencyCode,
      openingBalanceMinor: openingBalanceMinor ?? this.openingBalanceMinor,
      openingBalanceScale: openingBalanceScale ?? this.openingBalanceScale,
      institution: institution ?? this.institution,
      note: note ?? this.note,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $AccountsTableTable.$convertertype.toSql(type.value),
      );
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (openingBalanceMinor.present) {
      map['opening_balance_minor'] = Variable<int>(openingBalanceMinor.value);
    }
    if (openingBalanceScale.present) {
      map['opening_balance_scale'] = Variable<int>(openingBalanceScale.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('openingBalanceMinor: $openingBalanceMinor, ')
          ..write('openingBalanceScale: $openingBalanceScale, ')
          ..write('institution: $institution, ')
          ..write('note: $note, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategoryType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<CategoryType>($CategoriesTableTable.$convertertype);
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<int> colorHex = GeneratedColumn<int>(
    'color_hex',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    parentId,
    iconKey,
    colorHex,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $CategoriesTableTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      ),
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_hex'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryType, int, int> $convertertype =
      const EnumIndexConverter<CategoryType>(CategoryType.values);
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String name;
  final CategoryType type;
  final String? parentId;
  final String? iconKey;
  final int? colorHex;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    this.iconKey,
    this.colorHex,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>(
        $CategoriesTableTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || iconKey != null) {
      map['icon_key'] = Variable<String>(iconKey);
    }
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<int>(colorHex);
    }
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      iconKey: iconKey == null && nullToAbsent
          ? const Value.absent()
          : Value(iconKey),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $CategoriesTableTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      parentId: serializer.fromJson<String?>(json['parentId']),
      iconKey: serializer.fromJson<String?>(json['iconKey']),
      colorHex: serializer.fromJson<int?>(json['colorHex']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(
        $CategoriesTableTable.$convertertype.toJson(type),
      ),
      'parentId': serializer.toJson<String?>(parentId),
      'iconKey': serializer.toJson<String?>(iconKey),
      'colorHex': serializer.toJson<int?>(colorHex),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? name,
    CategoryType? type,
    Value<String?> parentId = const Value.absent(),
    Value<String?> iconKey = const Value.absent(),
    Value<int?> colorHex = const Value.absent(),
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    parentId: parentId.present ? parentId.value : this.parentId,
    iconKey: iconKey.present ? iconKey.value : this.iconKey,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CategoryRow copyWithCompanion(CategoriesTableCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('parentId: $parentId, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorHex: $colorHex, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    parentId,
    iconKey,
    colorHex,
    archived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.parentId == this.parentId &&
          other.iconKey == this.iconKey &&
          other.colorHex == this.colorHex &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<CategoryType> type;
  final Value<String?> parentId;
  final Value<String?> iconKey;
  final Value<int?> colorHex;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.parentId = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String name,
    required CategoryType type,
    this.parentId = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.archived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? parentId,
    Expression<String>? iconKey,
    Expression<int>? colorHex,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (parentId != null) 'parent_id': parentId,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorHex != null) 'color_hex': colorHex,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<CategoryType>? type,
    Value<String?>? parentId,
    Value<String?>? iconKey,
    Value<int?>? colorHex,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      iconKey: iconKey ?? this.iconKey,
      colorHex: colorHex ?? this.colorHex,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $CategoriesTableTable.$convertertype.toSql(type.value),
      );
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<int>(colorHex.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('parentId: $parentId, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorHex: $colorHex, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTableTable extends BudgetsTable
    with TableInfo<$BudgetsTableTable, BudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BudgetType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<BudgetType>($BudgetsTableTable.$convertertype);
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountScaleMeta = const VerificationMeta(
    'amountScale',
  );
  @override
  late final GeneratedColumn<int> amountScale = GeneratedColumn<int>(
    'amount_scale',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdsCsvMeta = const VerificationMeta(
    'categoryIdsCsv',
  );
  @override
  late final GeneratedColumn<String> categoryIdsCsv = GeneratedColumn<String>(
    'category_ids_csv',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    amountMinor,
    amountScale,
    currencyCode,
    categoryId,
    categoryIdsCsv,
    startDate,
    endDate,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('amount_scale')) {
      context.handle(
        _amountScaleMeta,
        amountScale.isAcceptableOrUnknown(
          data['amount_scale']!,
          _amountScaleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountScaleMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_ids_csv')) {
      context.handle(
        _categoryIdsCsvMeta,
        categoryIdsCsv.isAcceptableOrUnknown(
          data['category_ids_csv']!,
          _categoryIdsCsvMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $BudgetsTableTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      amountScale: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_scale'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      categoryIdsCsv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_ids_csv'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetsTableTable createAlias(String alias) {
    return $BudgetsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BudgetType, int, int> $convertertype =
      const EnumIndexConverter<BudgetType>(BudgetType.values);
}

class BudgetRow extends DataClass implements Insertable<BudgetRow> {
  final String id;
  final String name;
  final BudgetType type;
  final int amountMinor;
  final int amountScale;
  final String currencyCode;
  final String categoryId;

  /// Comma-separated category ids for multi-category budgets.
  ///
  /// Legacy rows may only have [categoryId] populated.
  final String categoryIdsCsv;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BudgetRow({
    required this.id,
    required this.name,
    required this.type,
    required this.amountMinor,
    required this.amountScale,
    required this.currencyCode,
    required this.categoryId,
    required this.categoryIdsCsv,
    this.startDate,
    this.endDate,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>(
        $BudgetsTableTable.$convertertype.toSql(type),
      );
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['amount_scale'] = Variable<int>(amountScale);
    map['currency_code'] = Variable<String>(currencyCode);
    map['category_id'] = Variable<String>(categoryId);
    map['category_ids_csv'] = Variable<String>(categoryIdsCsv);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetsTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetsTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      amountMinor: Value(amountMinor),
      amountScale: Value(amountScale),
      currencyCode: Value(currencyCode),
      categoryId: Value(categoryId),
      categoryIdsCsv: Value(categoryIdsCsv),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $BudgetsTableTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      amountScale: serializer.fromJson<int>(json['amountScale']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      categoryIdsCsv: serializer.fromJson<String>(json['categoryIdsCsv']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(
        $BudgetsTableTable.$convertertype.toJson(type),
      ),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'amountScale': serializer.toJson<int>(amountScale),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'categoryId': serializer.toJson<String>(categoryId),
      'categoryIdsCsv': serializer.toJson<String>(categoryIdsCsv),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BudgetRow copyWith({
    String? id,
    String? name,
    BudgetType? type,
    int? amountMinor,
    int? amountScale,
    String? currencyCode,
    String? categoryId,
    String? categoryIdsCsv,
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> endDate = const Value.absent(),
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BudgetRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    amountMinor: amountMinor ?? this.amountMinor,
    amountScale: amountScale ?? this.amountScale,
    currencyCode: currencyCode ?? this.currencyCode,
    categoryId: categoryId ?? this.categoryId,
    categoryIdsCsv: categoryIdsCsv ?? this.categoryIdsCsv,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BudgetRow copyWithCompanion(BudgetsTableCompanion data) {
    return BudgetRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      amountScale: data.amountScale.present
          ? data.amountScale.value
          : this.amountScale,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categoryIdsCsv: data.categoryIdsCsv.present
          ? data.categoryIdsCsv.value
          : this.categoryIdsCsv,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('amountScale: $amountScale, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryIdsCsv: $categoryIdsCsv, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    amountMinor,
    amountScale,
    currencyCode,
    categoryId,
    categoryIdsCsv,
    startDate,
    endDate,
    archived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.amountMinor == this.amountMinor &&
          other.amountScale == this.amountScale &&
          other.currencyCode == this.currencyCode &&
          other.categoryId == this.categoryId &&
          other.categoryIdsCsv == this.categoryIdsCsv &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetsTableCompanion extends UpdateCompanion<BudgetRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<BudgetType> type;
  final Value<int> amountMinor;
  final Value<int> amountScale;
  final Value<String> currencyCode;
  final Value<String> categoryId;
  final Value<String> categoryIdsCsv;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BudgetsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.amountScale = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryIdsCsv = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsTableCompanion.insert({
    required String id,
    required String name,
    required BudgetType type,
    required int amountMinor,
    required int amountScale,
    required String currencyCode,
    required String categoryId,
    this.categoryIdsCsv = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.archived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       amountMinor = Value(amountMinor),
       amountScale = Value(amountScale),
       currencyCode = Value(currencyCode),
       categoryId = Value(categoryId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BudgetRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<int>? amountMinor,
    Expression<int>? amountScale,
    Expression<String>? currencyCode,
    Expression<String>? categoryId,
    Expression<String>? categoryIdsCsv,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (amountScale != null) 'amount_scale': amountScale,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryIdsCsv != null) 'category_ids_csv': categoryIdsCsv,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<BudgetType>? type,
    Value<int>? amountMinor,
    Value<int>? amountScale,
    Value<String>? currencyCode,
    Value<String>? categoryId,
    Value<String>? categoryIdsCsv,
    Value<DateTime?>? startDate,
    Value<DateTime?>? endDate,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BudgetsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      amountMinor: amountMinor ?? this.amountMinor,
      amountScale: amountScale ?? this.amountScale,
      currencyCode: currencyCode ?? this.currencyCode,
      categoryId: categoryId ?? this.categoryId,
      categoryIdsCsv: categoryIdsCsv ?? this.categoryIdsCsv,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $BudgetsTableTable.$convertertype.toSql(type.value),
      );
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (amountScale.present) {
      map['amount_scale'] = Variable<int>(amountScale.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryIdsCsv.present) {
      map['category_ids_csv'] = Variable<String>(categoryIdsCsv.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('amountScale: $amountScale, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryIdsCsv: $categoryIdsCsv, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryCurrencyCodeMeta =
      const VerificationMeta('primaryCurrencyCode');
  @override
  late final GeneratedColumn<String> primaryCurrencyCode =
      GeneratedColumn<String>(
        'primary_currency_code',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<FirstDayOfWeek, int>
  firstDayOfWeek =
      GeneratedColumn<int>(
        'first_day_of_week',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<FirstDayOfWeek>(
        $AppSettingsTableTable.$converterfirstDayOfWeek,
      );
  @override
  late final GeneratedColumnWithTypeConverter<AppDateFormat, int> dateFormat =
      GeneratedColumn<int>(
        'date_format',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AppDateFormat>(
        $AppSettingsTableTable.$converterdateFormat,
      );
  static const VerificationMeta _useGroupingMeta = const VerificationMeta(
    'useGrouping',
  );
  @override
  late final GeneratedColumn<bool> useGrouping = GeneratedColumn<bool>(
    'use_grouping',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_grouping" IN (0, 1))',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DecimalSeparator, int>
  decimalSeparator =
      GeneratedColumn<int>(
        'decimal_separator',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DecimalSeparator>(
        $AppSettingsTableTable.$converterdecimalSeparator,
      );
  @override
  late final GeneratedColumnWithTypeConverter<AppThemeMode, int> themeMode =
      GeneratedColumn<int>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<AppThemeMode>($AppSettingsTableTable.$converterthemeMode);
  @override
  late final GeneratedColumnWithTypeConverter<AppAccentColor, int> accentColor =
      GeneratedColumn<int>(
        'accent_color',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<AppAccentColor>(
        $AppSettingsTableTable.$converteraccentColor,
      );
  static const VerificationMeta _useMaterialYouColorsMeta =
      const VerificationMeta('useMaterialYouColors');
  @override
  late final GeneratedColumn<bool> useMaterialYouColors = GeneratedColumn<bool>(
    'use_material_you_colors',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_material_you_colors" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _showExpenseInRedMeta = const VerificationMeta(
    'showExpenseInRed',
  );
  @override
  late final GeneratedColumn<bool> showExpenseInRed = GeneratedColumn<bool>(
    'show_expense_in_red',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_expense_in_red" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _authUserIdMeta = const VerificationMeta(
    'authUserId',
  );
  @override
  late final GeneratedColumn<String> authUserId = GeneratedColumn<String>(
    'auth_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authUsernameMeta = const VerificationMeta(
    'authUsername',
  );
  @override
  late final GeneratedColumn<String> authUsername = GeneratedColumn<String>(
    'auth_username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authDisplayNameMeta = const VerificationMeta(
    'authDisplayName',
  );
  @override
  late final GeneratedColumn<String> authDisplayName = GeneratedColumn<String>(
    'auth_display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authBirthdayMillisMeta =
      const VerificationMeta('authBirthdayMillis');
  @override
  late final GeneratedColumn<int> authBirthdayMillis = GeneratedColumn<int>(
    'auth_birthday_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authIsDemoMeta = const VerificationMeta(
    'authIsDemo',
  );
  @override
  late final GeneratedColumn<bool> authIsDemo = GeneratedColumn<bool>(
    'auth_is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auth_is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _demoDataSeededMeta = const VerificationMeta(
    'demoDataSeeded',
  );
  @override
  late final GeneratedColumn<bool> demoDataSeeded = GeneratedColumn<bool>(
    'demo_data_seeded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("demo_data_seeded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _homeFeatureCardsDismissedCsvMeta =
      const VerificationMeta('homeFeatureCardsDismissedCsv');
  @override
  late final GeneratedColumn<String> homeFeatureCardsDismissedCsv =
      GeneratedColumn<String>(
        'home_feature_cards_dismissed_csv',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _lastBirthdayCelebratedAtMillisMeta =
      const VerificationMeta('lastBirthdayCelebratedAtMillis');
  @override
  late final GeneratedColumn<int> lastBirthdayCelebratedAtMillis =
      GeneratedColumn<int>(
        'last_birthday_celebrated_at_millis',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _homeSectionOrderCsvMeta =
      const VerificationMeta('homeSectionOrderCsv');
  @override
  late final GeneratedColumn<String>
  homeSectionOrderCsv = GeneratedColumn<String>(
    'home_section_order_csv',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(
      'banner,accounts,budgets,goals,income_expenses,net_worth,overdue_upcoming,loans,long_term_loans,spending_graph,pie_chart,heat_map,transactions',
    ),
  );
  static const VerificationMeta _homeShowUsernameMeta = const VerificationMeta(
    'homeShowUsername',
  );
  @override
  late final GeneratedColumn<bool> homeShowUsername = GeneratedColumn<bool>(
    'home_show_username',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("home_show_username" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _homeShowBannerMeta = const VerificationMeta(
    'homeShowBanner',
  );
  @override
  late final GeneratedColumn<bool> homeShowBanner = GeneratedColumn<bool>(
    'home_show_banner',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("home_show_banner" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _homeShowAccountsMeta = const VerificationMeta(
    'homeShowAccounts',
  );
  @override
  late final GeneratedColumn<bool> homeShowAccounts = GeneratedColumn<bool>(
    'home_show_accounts',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("home_show_accounts" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _homeShowBudgetsMeta = const VerificationMeta(
    'homeShowBudgets',
  );
  @override
  late final GeneratedColumn<bool> homeShowBudgets = GeneratedColumn<bool>(
    'home_show_budgets',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("home_show_budgets" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _homeShowGoalsMeta = const VerificationMeta(
    'homeShowGoals',
  );
  @override
  late final GeneratedColumn<bool> homeShowGoals = GeneratedColumn<bool>(
    'home_show_goals',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("home_show_goals" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _homeShowIncomeAndExpensesMeta =
      const VerificationMeta('homeShowIncomeAndExpenses');
  @override
  late final GeneratedColumn<bool> homeShowIncomeAndExpenses =
      GeneratedColumn<bool>(
        'home_show_income_and_expenses',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("home_show_income_and_expenses" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _homeShowNetWorthMeta = const VerificationMeta(
    'homeShowNetWorth',
  );
  @override
  late final GeneratedColumn<bool> homeShowNetWorth = GeneratedColumn<bool>(
    'home_show_net_worth',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("home_show_net_worth" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _homeShowOverdueAndUpcomingMeta =
      const VerificationMeta('homeShowOverdueAndUpcoming');
  @override
  late final GeneratedColumn<bool> homeShowOverdueAndUpcoming =
      GeneratedColumn<bool>(
        'home_show_overdue_and_upcoming',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("home_show_overdue_and_upcoming" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _homeShowLoansMeta = const VerificationMeta(
    'homeShowLoans',
  );
  @override
  late final GeneratedColumn<bool> homeShowLoans = GeneratedColumn<bool>(
    'home_show_loans',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("home_show_loans" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _homeShowLongTermLoansMeta =
      const VerificationMeta('homeShowLongTermLoans');
  @override
  late final GeneratedColumn<bool> homeShowLongTermLoans =
      GeneratedColumn<bool>(
        'home_show_long_term_loans',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("home_show_long_term_loans" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _homeShowSpendingGraphMeta =
      const VerificationMeta('homeShowSpendingGraph');
  @override
  late final GeneratedColumn<bool> homeShowSpendingGraph =
      GeneratedColumn<bool>(
        'home_show_spending_graph',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("home_show_spending_graph" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _homeShowPieChartMeta = const VerificationMeta(
    'homeShowPieChart',
  );
  @override
  late final GeneratedColumn<bool> homeShowPieChart = GeneratedColumn<bool>(
    'home_show_pie_chart',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("home_show_pie_chart" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _homeShowHeatMapMeta = const VerificationMeta(
    'homeShowHeatMap',
  );
  @override
  late final GeneratedColumn<bool> homeShowHeatMap = GeneratedColumn<bool>(
    'home_show_heat_map',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("home_show_heat_map" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _homeShowTransactionsListMeta =
      const VerificationMeta('homeShowTransactionsList');
  @override
  late final GeneratedColumn<bool> homeShowTransactionsList =
      GeneratedColumn<bool>(
        'home_show_transactions_list',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("home_show_transactions_list" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _transactionReminderEnabledMeta =
      const VerificationMeta('transactionReminderEnabled');
  @override
  late final GeneratedColumn<bool> transactionReminderEnabled =
      GeneratedColumn<bool>(
        'transaction_reminder_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("transaction_reminder_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _transactionReminderTimeMinutesMeta =
      const VerificationMeta('transactionReminderTimeMinutes');
  @override
  late final GeneratedColumn<int> transactionReminderTimeMinutes =
      GeneratedColumn<int>(
        'transaction_reminder_time_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(1200),
      );
  static const VerificationMeta _upcomingTransactionsEnabledMeta =
      const VerificationMeta('upcomingTransactionsEnabled');
  @override
  late final GeneratedColumn<bool> upcomingTransactionsEnabled =
      GeneratedColumn<bool>(
        'upcoming_transactions_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("upcoming_transactions_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _requireBiometricOnLaunchMeta =
      const VerificationMeta('requireBiometricOnLaunch');
  @override
  late final GeneratedColumn<bool> requireBiometricOnLaunch =
      GeneratedColumn<bool>(
        'require_biometric_on_launch',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("require_biometric_on_launch" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _autoProcessScheduledOnAppOpenMeta =
      const VerificationMeta('autoProcessScheduledOnAppOpen');
  @override
  late final GeneratedColumn<bool> autoProcessScheduledOnAppOpen =
      GeneratedColumn<bool>(
        'auto_process_scheduled_on_app_open',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_process_scheduled_on_app_open" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _autoProcessRecurringOnAppOpenMeta =
      const VerificationMeta('autoProcessRecurringOnAppOpen');
  @override
  late final GeneratedColumn<bool> autoProcessRecurringOnAppOpen =
      GeneratedColumn<bool>(
        'auto_process_recurring_on_app_open',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_process_recurring_on_app_open" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _swipeBetweenTabsEnabledMeta =
      const VerificationMeta('swipeBetweenTabsEnabled');
  @override
  late final GeneratedColumn<bool> swipeBetweenTabsEnabled =
      GeneratedColumn<bool>(
        'swipe_between_tabs_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("swipe_between_tabs_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    primaryCurrencyCode,
    firstDayOfWeek,
    dateFormat,
    useGrouping,
    decimalSeparator,
    themeMode,
    accentColor,
    useMaterialYouColors,
    showExpenseInRed,
    onboardingCompleted,
    authUserId,
    authUsername,
    authDisplayName,
    authBirthdayMillis,
    authIsDemo,
    demoDataSeeded,
    homeFeatureCardsDismissedCsv,
    lastBirthdayCelebratedAtMillis,
    homeSectionOrderCsv,
    homeShowUsername,
    homeShowBanner,
    homeShowAccounts,
    homeShowBudgets,
    homeShowGoals,
    homeShowIncomeAndExpenses,
    homeShowNetWorth,
    homeShowOverdueAndUpcoming,
    homeShowLoans,
    homeShowLongTermLoans,
    homeShowSpendingGraph,
    homeShowPieChart,
    homeShowHeatMap,
    homeShowTransactionsList,
    transactionReminderEnabled,
    transactionReminderTimeMinutes,
    upcomingTransactionsEnabled,
    requireBiometricOnLaunch,
    languageCode,
    autoProcessScheduledOnAppOpen,
    autoProcessRecurringOnAppOpen,
    swipeBetweenTabsEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('primary_currency_code')) {
      context.handle(
        _primaryCurrencyCodeMeta,
        primaryCurrencyCode.isAcceptableOrUnknown(
          data['primary_currency_code']!,
          _primaryCurrencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryCurrencyCodeMeta);
    }
    if (data.containsKey('use_grouping')) {
      context.handle(
        _useGroupingMeta,
        useGrouping.isAcceptableOrUnknown(
          data['use_grouping']!,
          _useGroupingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_useGroupingMeta);
    }
    if (data.containsKey('use_material_you_colors')) {
      context.handle(
        _useMaterialYouColorsMeta,
        useMaterialYouColors.isAcceptableOrUnknown(
          data['use_material_you_colors']!,
          _useMaterialYouColorsMeta,
        ),
      );
    }
    if (data.containsKey('show_expense_in_red')) {
      context.handle(
        _showExpenseInRedMeta,
        showExpenseInRed.isAcceptableOrUnknown(
          data['show_expense_in_red']!,
          _showExpenseInRedMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('auth_user_id')) {
      context.handle(
        _authUserIdMeta,
        authUserId.isAcceptableOrUnknown(
          data['auth_user_id']!,
          _authUserIdMeta,
        ),
      );
    }
    if (data.containsKey('auth_username')) {
      context.handle(
        _authUsernameMeta,
        authUsername.isAcceptableOrUnknown(
          data['auth_username']!,
          _authUsernameMeta,
        ),
      );
    }
    if (data.containsKey('auth_display_name')) {
      context.handle(
        _authDisplayNameMeta,
        authDisplayName.isAcceptableOrUnknown(
          data['auth_display_name']!,
          _authDisplayNameMeta,
        ),
      );
    }
    if (data.containsKey('auth_birthday_millis')) {
      context.handle(
        _authBirthdayMillisMeta,
        authBirthdayMillis.isAcceptableOrUnknown(
          data['auth_birthday_millis']!,
          _authBirthdayMillisMeta,
        ),
      );
    }
    if (data.containsKey('auth_is_demo')) {
      context.handle(
        _authIsDemoMeta,
        authIsDemo.isAcceptableOrUnknown(
          data['auth_is_demo']!,
          _authIsDemoMeta,
        ),
      );
    }
    if (data.containsKey('demo_data_seeded')) {
      context.handle(
        _demoDataSeededMeta,
        demoDataSeeded.isAcceptableOrUnknown(
          data['demo_data_seeded']!,
          _demoDataSeededMeta,
        ),
      );
    }
    if (data.containsKey('home_feature_cards_dismissed_csv')) {
      context.handle(
        _homeFeatureCardsDismissedCsvMeta,
        homeFeatureCardsDismissedCsv.isAcceptableOrUnknown(
          data['home_feature_cards_dismissed_csv']!,
          _homeFeatureCardsDismissedCsvMeta,
        ),
      );
    }
    if (data.containsKey('last_birthday_celebrated_at_millis')) {
      context.handle(
        _lastBirthdayCelebratedAtMillisMeta,
        lastBirthdayCelebratedAtMillis.isAcceptableOrUnknown(
          data['last_birthday_celebrated_at_millis']!,
          _lastBirthdayCelebratedAtMillisMeta,
        ),
      );
    }
    if (data.containsKey('home_section_order_csv')) {
      context.handle(
        _homeSectionOrderCsvMeta,
        homeSectionOrderCsv.isAcceptableOrUnknown(
          data['home_section_order_csv']!,
          _homeSectionOrderCsvMeta,
        ),
      );
    }
    if (data.containsKey('home_show_username')) {
      context.handle(
        _homeShowUsernameMeta,
        homeShowUsername.isAcceptableOrUnknown(
          data['home_show_username']!,
          _homeShowUsernameMeta,
        ),
      );
    }
    if (data.containsKey('home_show_banner')) {
      context.handle(
        _homeShowBannerMeta,
        homeShowBanner.isAcceptableOrUnknown(
          data['home_show_banner']!,
          _homeShowBannerMeta,
        ),
      );
    }
    if (data.containsKey('home_show_accounts')) {
      context.handle(
        _homeShowAccountsMeta,
        homeShowAccounts.isAcceptableOrUnknown(
          data['home_show_accounts']!,
          _homeShowAccountsMeta,
        ),
      );
    }
    if (data.containsKey('home_show_budgets')) {
      context.handle(
        _homeShowBudgetsMeta,
        homeShowBudgets.isAcceptableOrUnknown(
          data['home_show_budgets']!,
          _homeShowBudgetsMeta,
        ),
      );
    }
    if (data.containsKey('home_show_goals')) {
      context.handle(
        _homeShowGoalsMeta,
        homeShowGoals.isAcceptableOrUnknown(
          data['home_show_goals']!,
          _homeShowGoalsMeta,
        ),
      );
    }
    if (data.containsKey('home_show_income_and_expenses')) {
      context.handle(
        _homeShowIncomeAndExpensesMeta,
        homeShowIncomeAndExpenses.isAcceptableOrUnknown(
          data['home_show_income_and_expenses']!,
          _homeShowIncomeAndExpensesMeta,
        ),
      );
    }
    if (data.containsKey('home_show_net_worth')) {
      context.handle(
        _homeShowNetWorthMeta,
        homeShowNetWorth.isAcceptableOrUnknown(
          data['home_show_net_worth']!,
          _homeShowNetWorthMeta,
        ),
      );
    }
    if (data.containsKey('home_show_overdue_and_upcoming')) {
      context.handle(
        _homeShowOverdueAndUpcomingMeta,
        homeShowOverdueAndUpcoming.isAcceptableOrUnknown(
          data['home_show_overdue_and_upcoming']!,
          _homeShowOverdueAndUpcomingMeta,
        ),
      );
    }
    if (data.containsKey('home_show_loans')) {
      context.handle(
        _homeShowLoansMeta,
        homeShowLoans.isAcceptableOrUnknown(
          data['home_show_loans']!,
          _homeShowLoansMeta,
        ),
      );
    }
    if (data.containsKey('home_show_long_term_loans')) {
      context.handle(
        _homeShowLongTermLoansMeta,
        homeShowLongTermLoans.isAcceptableOrUnknown(
          data['home_show_long_term_loans']!,
          _homeShowLongTermLoansMeta,
        ),
      );
    }
    if (data.containsKey('home_show_spending_graph')) {
      context.handle(
        _homeShowSpendingGraphMeta,
        homeShowSpendingGraph.isAcceptableOrUnknown(
          data['home_show_spending_graph']!,
          _homeShowSpendingGraphMeta,
        ),
      );
    }
    if (data.containsKey('home_show_pie_chart')) {
      context.handle(
        _homeShowPieChartMeta,
        homeShowPieChart.isAcceptableOrUnknown(
          data['home_show_pie_chart']!,
          _homeShowPieChartMeta,
        ),
      );
    }
    if (data.containsKey('home_show_heat_map')) {
      context.handle(
        _homeShowHeatMapMeta,
        homeShowHeatMap.isAcceptableOrUnknown(
          data['home_show_heat_map']!,
          _homeShowHeatMapMeta,
        ),
      );
    }
    if (data.containsKey('home_show_transactions_list')) {
      context.handle(
        _homeShowTransactionsListMeta,
        homeShowTransactionsList.isAcceptableOrUnknown(
          data['home_show_transactions_list']!,
          _homeShowTransactionsListMeta,
        ),
      );
    }
    if (data.containsKey('transaction_reminder_enabled')) {
      context.handle(
        _transactionReminderEnabledMeta,
        transactionReminderEnabled.isAcceptableOrUnknown(
          data['transaction_reminder_enabled']!,
          _transactionReminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('transaction_reminder_time_minutes')) {
      context.handle(
        _transactionReminderTimeMinutesMeta,
        transactionReminderTimeMinutes.isAcceptableOrUnknown(
          data['transaction_reminder_time_minutes']!,
          _transactionReminderTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('upcoming_transactions_enabled')) {
      context.handle(
        _upcomingTransactionsEnabledMeta,
        upcomingTransactionsEnabled.isAcceptableOrUnknown(
          data['upcoming_transactions_enabled']!,
          _upcomingTransactionsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('require_biometric_on_launch')) {
      context.handle(
        _requireBiometricOnLaunchMeta,
        requireBiometricOnLaunch.isAcceptableOrUnknown(
          data['require_biometric_on_launch']!,
          _requireBiometricOnLaunchMeta,
        ),
      );
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    }
    if (data.containsKey('auto_process_scheduled_on_app_open')) {
      context.handle(
        _autoProcessScheduledOnAppOpenMeta,
        autoProcessScheduledOnAppOpen.isAcceptableOrUnknown(
          data['auto_process_scheduled_on_app_open']!,
          _autoProcessScheduledOnAppOpenMeta,
        ),
      );
    }
    if (data.containsKey('auto_process_recurring_on_app_open')) {
      context.handle(
        _autoProcessRecurringOnAppOpenMeta,
        autoProcessRecurringOnAppOpen.isAcceptableOrUnknown(
          data['auto_process_recurring_on_app_open']!,
          _autoProcessRecurringOnAppOpenMeta,
        ),
      );
    }
    if (data.containsKey('swipe_between_tabs_enabled')) {
      context.handle(
        _swipeBetweenTabsEnabledMeta,
        swipeBetweenTabsEnabled.isAcceptableOrUnknown(
          data['swipe_between_tabs_enabled']!,
          _swipeBetweenTabsEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      primaryCurrencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_currency_code'],
      )!,
      firstDayOfWeek: $AppSettingsTableTable.$converterfirstDayOfWeek.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}first_day_of_week'],
        )!,
      ),
      dateFormat: $AppSettingsTableTable.$converterdateFormat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}date_format'],
        )!,
      ),
      useGrouping: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_grouping'],
      )!,
      decimalSeparator: $AppSettingsTableTable.$converterdecimalSeparator
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.int,
              data['${effectivePrefix}decimal_separator'],
            )!,
          ),
      themeMode: $AppSettingsTableTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
      accentColor: $AppSettingsTableTable.$converteraccentColor.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}accent_color'],
        )!,
      ),
      useMaterialYouColors: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_material_you_colors'],
      )!,
      showExpenseInRed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_expense_in_red'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      authUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_user_id'],
      ),
      authUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_username'],
      ),
      authDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_display_name'],
      ),
      authBirthdayMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}auth_birthday_millis'],
      ),
      authIsDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auth_is_demo'],
      )!,
      demoDataSeeded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}demo_data_seeded'],
      )!,
      homeFeatureCardsDismissedCsv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_feature_cards_dismissed_csv'],
      )!,
      lastBirthdayCelebratedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_birthday_celebrated_at_millis'],
      ),
      homeSectionOrderCsv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_section_order_csv'],
      )!,
      homeShowUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_username'],
      )!,
      homeShowBanner: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_banner'],
      )!,
      homeShowAccounts: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_accounts'],
      )!,
      homeShowBudgets: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_budgets'],
      )!,
      homeShowGoals: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_goals'],
      )!,
      homeShowIncomeAndExpenses: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_income_and_expenses'],
      )!,
      homeShowNetWorth: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_net_worth'],
      )!,
      homeShowOverdueAndUpcoming: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_overdue_and_upcoming'],
      )!,
      homeShowLoans: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_loans'],
      )!,
      homeShowLongTermLoans: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_long_term_loans'],
      )!,
      homeShowSpendingGraph: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_spending_graph'],
      )!,
      homeShowPieChart: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_pie_chart'],
      )!,
      homeShowHeatMap: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_heat_map'],
      )!,
      homeShowTransactionsList: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}home_show_transactions_list'],
      )!,
      transactionReminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}transaction_reminder_enabled'],
      )!,
      transactionReminderTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_reminder_time_minutes'],
      )!,
      upcomingTransactionsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}upcoming_transactions_enabled'],
      )!,
      requireBiometricOnLaunch: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}require_biometric_on_launch'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      autoProcessScheduledOnAppOpen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_process_scheduled_on_app_open'],
      )!,
      autoProcessRecurringOnAppOpen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_process_recurring_on_app_open'],
      )!,
      swipeBetweenTabsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}swipe_between_tabs_enabled'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FirstDayOfWeek, int, int> $converterfirstDayOfWeek =
      const EnumIndexConverter<FirstDayOfWeek>(FirstDayOfWeek.values);
  static JsonTypeConverter2<AppDateFormat, int, int> $converterdateFormat =
      const EnumIndexConverter<AppDateFormat>(AppDateFormat.values);
  static JsonTypeConverter2<DecimalSeparator, int, int>
  $converterdecimalSeparator = const EnumIndexConverter<DecimalSeparator>(
    DecimalSeparator.values,
  );
  static JsonTypeConverter2<AppThemeMode, int, int> $converterthemeMode =
      const EnumIndexConverter<AppThemeMode>(AppThemeMode.values);
  static JsonTypeConverter2<AppAccentColor, int, int> $converteraccentColor =
      const EnumIndexConverter<AppAccentColor>(AppAccentColor.values);
}

class AppSettingsRow extends DataClass implements Insertable<AppSettingsRow> {
  final int id;
  final String primaryCurrencyCode;
  final FirstDayOfWeek firstDayOfWeek;
  final AppDateFormat dateFormat;
  final bool useGrouping;
  final DecimalSeparator decimalSeparator;

  /// Theme mode selection.
  final AppThemeMode themeMode;

  /// Accent color selection.
  final AppAccentColor accentColor;

  /// Material You dynamic colors toggle.
  final bool useMaterialYouColors;

  /// Whether expense (debit) amounts are highlighted in red.
  ///
  /// Default is true to preserve existing behavior.
  final bool showExpenseInRed;

  /// Persisted onboarding state.
  ///
  /// Default is false so fresh installs see onboarding.
  /// Existing installs are migrated to true in schema v6.
  final bool onboardingCompleted;

  /// Local-only auth user id.
  final String? authUserId;

  /// Username used for demo/local auth.
  final String? authUsername;

  /// Display name shown in the UI.
  final String? authDisplayName;

  /// Birthday (stored as millisecondsSinceEpoch; date-only semantics in UI).
  final int? authBirthdayMillis;

  /// True when the current session is a demo user.
  final bool authIsDemo;

  /// One-time demo data seed guard.
  final bool demoDataSeeded;

  /// CSV of dismissed home preview card ids.
  final String homeFeatureCardsDismissedCsv;

  /// Last time we celebrated birthday in-app (millisecondsSinceEpoch).
  final int? lastBirthdayCelebratedAtMillis;

  /// CSV list of home section ids in display order.
  final String homeSectionOrderCsv;
  final bool homeShowUsername;
  final bool homeShowBanner;
  final bool homeShowAccounts;
  final bool homeShowBudgets;
  final bool homeShowGoals;
  final bool homeShowIncomeAndExpenses;
  final bool homeShowNetWorth;
  final bool homeShowOverdueAndUpcoming;
  final bool homeShowLoans;
  final bool homeShowLongTermLoans;
  final bool homeShowSpendingGraph;
  final bool homeShowPieChart;
  final bool homeShowHeatMap;
  final bool homeShowTransactionsList;
  final bool transactionReminderEnabled;

  /// Minutes since midnight local time.
  final int transactionReminderTimeMinutes;
  final bool upcomingTransactionsEnabled;
  final bool requireBiometricOnLaunch;
  final String languageCode;
  final bool autoProcessScheduledOnAppOpen;
  final bool autoProcessRecurringOnAppOpen;

  /// Allow swiping left/right to switch between main tabs.
  final bool swipeBetweenTabsEnabled;
  const AppSettingsRow({
    required this.id,
    required this.primaryCurrencyCode,
    required this.firstDayOfWeek,
    required this.dateFormat,
    required this.useGrouping,
    required this.decimalSeparator,
    required this.themeMode,
    required this.accentColor,
    required this.useMaterialYouColors,
    required this.showExpenseInRed,
    required this.onboardingCompleted,
    this.authUserId,
    this.authUsername,
    this.authDisplayName,
    this.authBirthdayMillis,
    required this.authIsDemo,
    required this.demoDataSeeded,
    required this.homeFeatureCardsDismissedCsv,
    this.lastBirthdayCelebratedAtMillis,
    required this.homeSectionOrderCsv,
    required this.homeShowUsername,
    required this.homeShowBanner,
    required this.homeShowAccounts,
    required this.homeShowBudgets,
    required this.homeShowGoals,
    required this.homeShowIncomeAndExpenses,
    required this.homeShowNetWorth,
    required this.homeShowOverdueAndUpcoming,
    required this.homeShowLoans,
    required this.homeShowLongTermLoans,
    required this.homeShowSpendingGraph,
    required this.homeShowPieChart,
    required this.homeShowHeatMap,
    required this.homeShowTransactionsList,
    required this.transactionReminderEnabled,
    required this.transactionReminderTimeMinutes,
    required this.upcomingTransactionsEnabled,
    required this.requireBiometricOnLaunch,
    required this.languageCode,
    required this.autoProcessScheduledOnAppOpen,
    required this.autoProcessRecurringOnAppOpen,
    required this.swipeBetweenTabsEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['primary_currency_code'] = Variable<String>(primaryCurrencyCode);
    {
      map['first_day_of_week'] = Variable<int>(
        $AppSettingsTableTable.$converterfirstDayOfWeek.toSql(firstDayOfWeek),
      );
    }
    {
      map['date_format'] = Variable<int>(
        $AppSettingsTableTable.$converterdateFormat.toSql(dateFormat),
      );
    }
    map['use_grouping'] = Variable<bool>(useGrouping);
    {
      map['decimal_separator'] = Variable<int>(
        $AppSettingsTableTable.$converterdecimalSeparator.toSql(
          decimalSeparator,
        ),
      );
    }
    {
      map['theme_mode'] = Variable<int>(
        $AppSettingsTableTable.$converterthemeMode.toSql(themeMode),
      );
    }
    {
      map['accent_color'] = Variable<int>(
        $AppSettingsTableTable.$converteraccentColor.toSql(accentColor),
      );
    }
    map['use_material_you_colors'] = Variable<bool>(useMaterialYouColors);
    map['show_expense_in_red'] = Variable<bool>(showExpenseInRed);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    if (!nullToAbsent || authUserId != null) {
      map['auth_user_id'] = Variable<String>(authUserId);
    }
    if (!nullToAbsent || authUsername != null) {
      map['auth_username'] = Variable<String>(authUsername);
    }
    if (!nullToAbsent || authDisplayName != null) {
      map['auth_display_name'] = Variable<String>(authDisplayName);
    }
    if (!nullToAbsent || authBirthdayMillis != null) {
      map['auth_birthday_millis'] = Variable<int>(authBirthdayMillis);
    }
    map['auth_is_demo'] = Variable<bool>(authIsDemo);
    map['demo_data_seeded'] = Variable<bool>(demoDataSeeded);
    map['home_feature_cards_dismissed_csv'] = Variable<String>(
      homeFeatureCardsDismissedCsv,
    );
    if (!nullToAbsent || lastBirthdayCelebratedAtMillis != null) {
      map['last_birthday_celebrated_at_millis'] = Variable<int>(
        lastBirthdayCelebratedAtMillis,
      );
    }
    map['home_section_order_csv'] = Variable<String>(homeSectionOrderCsv);
    map['home_show_username'] = Variable<bool>(homeShowUsername);
    map['home_show_banner'] = Variable<bool>(homeShowBanner);
    map['home_show_accounts'] = Variable<bool>(homeShowAccounts);
    map['home_show_budgets'] = Variable<bool>(homeShowBudgets);
    map['home_show_goals'] = Variable<bool>(homeShowGoals);
    map['home_show_income_and_expenses'] = Variable<bool>(
      homeShowIncomeAndExpenses,
    );
    map['home_show_net_worth'] = Variable<bool>(homeShowNetWorth);
    map['home_show_overdue_and_upcoming'] = Variable<bool>(
      homeShowOverdueAndUpcoming,
    );
    map['home_show_loans'] = Variable<bool>(homeShowLoans);
    map['home_show_long_term_loans'] = Variable<bool>(homeShowLongTermLoans);
    map['home_show_spending_graph'] = Variable<bool>(homeShowSpendingGraph);
    map['home_show_pie_chart'] = Variable<bool>(homeShowPieChart);
    map['home_show_heat_map'] = Variable<bool>(homeShowHeatMap);
    map['home_show_transactions_list'] = Variable<bool>(
      homeShowTransactionsList,
    );
    map['transaction_reminder_enabled'] = Variable<bool>(
      transactionReminderEnabled,
    );
    map['transaction_reminder_time_minutes'] = Variable<int>(
      transactionReminderTimeMinutes,
    );
    map['upcoming_transactions_enabled'] = Variable<bool>(
      upcomingTransactionsEnabled,
    );
    map['require_biometric_on_launch'] = Variable<bool>(
      requireBiometricOnLaunch,
    );
    map['language_code'] = Variable<String>(languageCode);
    map['auto_process_scheduled_on_app_open'] = Variable<bool>(
      autoProcessScheduledOnAppOpen,
    );
    map['auto_process_recurring_on_app_open'] = Variable<bool>(
      autoProcessRecurringOnAppOpen,
    );
    map['swipe_between_tabs_enabled'] = Variable<bool>(swipeBetweenTabsEnabled);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      primaryCurrencyCode: Value(primaryCurrencyCode),
      firstDayOfWeek: Value(firstDayOfWeek),
      dateFormat: Value(dateFormat),
      useGrouping: Value(useGrouping),
      decimalSeparator: Value(decimalSeparator),
      themeMode: Value(themeMode),
      accentColor: Value(accentColor),
      useMaterialYouColors: Value(useMaterialYouColors),
      showExpenseInRed: Value(showExpenseInRed),
      onboardingCompleted: Value(onboardingCompleted),
      authUserId: authUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(authUserId),
      authUsername: authUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(authUsername),
      authDisplayName: authDisplayName == null && nullToAbsent
          ? const Value.absent()
          : Value(authDisplayName),
      authBirthdayMillis: authBirthdayMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(authBirthdayMillis),
      authIsDemo: Value(authIsDemo),
      demoDataSeeded: Value(demoDataSeeded),
      homeFeatureCardsDismissedCsv: Value(homeFeatureCardsDismissedCsv),
      lastBirthdayCelebratedAtMillis:
          lastBirthdayCelebratedAtMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBirthdayCelebratedAtMillis),
      homeSectionOrderCsv: Value(homeSectionOrderCsv),
      homeShowUsername: Value(homeShowUsername),
      homeShowBanner: Value(homeShowBanner),
      homeShowAccounts: Value(homeShowAccounts),
      homeShowBudgets: Value(homeShowBudgets),
      homeShowGoals: Value(homeShowGoals),
      homeShowIncomeAndExpenses: Value(homeShowIncomeAndExpenses),
      homeShowNetWorth: Value(homeShowNetWorth),
      homeShowOverdueAndUpcoming: Value(homeShowOverdueAndUpcoming),
      homeShowLoans: Value(homeShowLoans),
      homeShowLongTermLoans: Value(homeShowLongTermLoans),
      homeShowSpendingGraph: Value(homeShowSpendingGraph),
      homeShowPieChart: Value(homeShowPieChart),
      homeShowHeatMap: Value(homeShowHeatMap),
      homeShowTransactionsList: Value(homeShowTransactionsList),
      transactionReminderEnabled: Value(transactionReminderEnabled),
      transactionReminderTimeMinutes: Value(transactionReminderTimeMinutes),
      upcomingTransactionsEnabled: Value(upcomingTransactionsEnabled),
      requireBiometricOnLaunch: Value(requireBiometricOnLaunch),
      languageCode: Value(languageCode),
      autoProcessScheduledOnAppOpen: Value(autoProcessScheduledOnAppOpen),
      autoProcessRecurringOnAppOpen: Value(autoProcessRecurringOnAppOpen),
      swipeBetweenTabsEnabled: Value(swipeBetweenTabsEnabled),
    );
  }

  factory AppSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      primaryCurrencyCode: serializer.fromJson<String>(
        json['primaryCurrencyCode'],
      ),
      firstDayOfWeek: $AppSettingsTableTable.$converterfirstDayOfWeek.fromJson(
        serializer.fromJson<int>(json['firstDayOfWeek']),
      ),
      dateFormat: $AppSettingsTableTable.$converterdateFormat.fromJson(
        serializer.fromJson<int>(json['dateFormat']),
      ),
      useGrouping: serializer.fromJson<bool>(json['useGrouping']),
      decimalSeparator: $AppSettingsTableTable.$converterdecimalSeparator
          .fromJson(serializer.fromJson<int>(json['decimalSeparator'])),
      themeMode: $AppSettingsTableTable.$converterthemeMode.fromJson(
        serializer.fromJson<int>(json['themeMode']),
      ),
      accentColor: $AppSettingsTableTable.$converteraccentColor.fromJson(
        serializer.fromJson<int>(json['accentColor']),
      ),
      useMaterialYouColors: serializer.fromJson<bool>(
        json['useMaterialYouColors'],
      ),
      showExpenseInRed: serializer.fromJson<bool>(json['showExpenseInRed']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      authUserId: serializer.fromJson<String?>(json['authUserId']),
      authUsername: serializer.fromJson<String?>(json['authUsername']),
      authDisplayName: serializer.fromJson<String?>(json['authDisplayName']),
      authBirthdayMillis: serializer.fromJson<int?>(json['authBirthdayMillis']),
      authIsDemo: serializer.fromJson<bool>(json['authIsDemo']),
      demoDataSeeded: serializer.fromJson<bool>(json['demoDataSeeded']),
      homeFeatureCardsDismissedCsv: serializer.fromJson<String>(
        json['homeFeatureCardsDismissedCsv'],
      ),
      lastBirthdayCelebratedAtMillis: serializer.fromJson<int?>(
        json['lastBirthdayCelebratedAtMillis'],
      ),
      homeSectionOrderCsv: serializer.fromJson<String>(
        json['homeSectionOrderCsv'],
      ),
      homeShowUsername: serializer.fromJson<bool>(json['homeShowUsername']),
      homeShowBanner: serializer.fromJson<bool>(json['homeShowBanner']),
      homeShowAccounts: serializer.fromJson<bool>(json['homeShowAccounts']),
      homeShowBudgets: serializer.fromJson<bool>(json['homeShowBudgets']),
      homeShowGoals: serializer.fromJson<bool>(json['homeShowGoals']),
      homeShowIncomeAndExpenses: serializer.fromJson<bool>(
        json['homeShowIncomeAndExpenses'],
      ),
      homeShowNetWorth: serializer.fromJson<bool>(json['homeShowNetWorth']),
      homeShowOverdueAndUpcoming: serializer.fromJson<bool>(
        json['homeShowOverdueAndUpcoming'],
      ),
      homeShowLoans: serializer.fromJson<bool>(json['homeShowLoans']),
      homeShowLongTermLoans: serializer.fromJson<bool>(
        json['homeShowLongTermLoans'],
      ),
      homeShowSpendingGraph: serializer.fromJson<bool>(
        json['homeShowSpendingGraph'],
      ),
      homeShowPieChart: serializer.fromJson<bool>(json['homeShowPieChart']),
      homeShowHeatMap: serializer.fromJson<bool>(json['homeShowHeatMap']),
      homeShowTransactionsList: serializer.fromJson<bool>(
        json['homeShowTransactionsList'],
      ),
      transactionReminderEnabled: serializer.fromJson<bool>(
        json['transactionReminderEnabled'],
      ),
      transactionReminderTimeMinutes: serializer.fromJson<int>(
        json['transactionReminderTimeMinutes'],
      ),
      upcomingTransactionsEnabled: serializer.fromJson<bool>(
        json['upcomingTransactionsEnabled'],
      ),
      requireBiometricOnLaunch: serializer.fromJson<bool>(
        json['requireBiometricOnLaunch'],
      ),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      autoProcessScheduledOnAppOpen: serializer.fromJson<bool>(
        json['autoProcessScheduledOnAppOpen'],
      ),
      autoProcessRecurringOnAppOpen: serializer.fromJson<bool>(
        json['autoProcessRecurringOnAppOpen'],
      ),
      swipeBetweenTabsEnabled: serializer.fromJson<bool>(
        json['swipeBetweenTabsEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'primaryCurrencyCode': serializer.toJson<String>(primaryCurrencyCode),
      'firstDayOfWeek': serializer.toJson<int>(
        $AppSettingsTableTable.$converterfirstDayOfWeek.toJson(firstDayOfWeek),
      ),
      'dateFormat': serializer.toJson<int>(
        $AppSettingsTableTable.$converterdateFormat.toJson(dateFormat),
      ),
      'useGrouping': serializer.toJson<bool>(useGrouping),
      'decimalSeparator': serializer.toJson<int>(
        $AppSettingsTableTable.$converterdecimalSeparator.toJson(
          decimalSeparator,
        ),
      ),
      'themeMode': serializer.toJson<int>(
        $AppSettingsTableTable.$converterthemeMode.toJson(themeMode),
      ),
      'accentColor': serializer.toJson<int>(
        $AppSettingsTableTable.$converteraccentColor.toJson(accentColor),
      ),
      'useMaterialYouColors': serializer.toJson<bool>(useMaterialYouColors),
      'showExpenseInRed': serializer.toJson<bool>(showExpenseInRed),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'authUserId': serializer.toJson<String?>(authUserId),
      'authUsername': serializer.toJson<String?>(authUsername),
      'authDisplayName': serializer.toJson<String?>(authDisplayName),
      'authBirthdayMillis': serializer.toJson<int?>(authBirthdayMillis),
      'authIsDemo': serializer.toJson<bool>(authIsDemo),
      'demoDataSeeded': serializer.toJson<bool>(demoDataSeeded),
      'homeFeatureCardsDismissedCsv': serializer.toJson<String>(
        homeFeatureCardsDismissedCsv,
      ),
      'lastBirthdayCelebratedAtMillis': serializer.toJson<int?>(
        lastBirthdayCelebratedAtMillis,
      ),
      'homeSectionOrderCsv': serializer.toJson<String>(homeSectionOrderCsv),
      'homeShowUsername': serializer.toJson<bool>(homeShowUsername),
      'homeShowBanner': serializer.toJson<bool>(homeShowBanner),
      'homeShowAccounts': serializer.toJson<bool>(homeShowAccounts),
      'homeShowBudgets': serializer.toJson<bool>(homeShowBudgets),
      'homeShowGoals': serializer.toJson<bool>(homeShowGoals),
      'homeShowIncomeAndExpenses': serializer.toJson<bool>(
        homeShowIncomeAndExpenses,
      ),
      'homeShowNetWorth': serializer.toJson<bool>(homeShowNetWorth),
      'homeShowOverdueAndUpcoming': serializer.toJson<bool>(
        homeShowOverdueAndUpcoming,
      ),
      'homeShowLoans': serializer.toJson<bool>(homeShowLoans),
      'homeShowLongTermLoans': serializer.toJson<bool>(homeShowLongTermLoans),
      'homeShowSpendingGraph': serializer.toJson<bool>(homeShowSpendingGraph),
      'homeShowPieChart': serializer.toJson<bool>(homeShowPieChart),
      'homeShowHeatMap': serializer.toJson<bool>(homeShowHeatMap),
      'homeShowTransactionsList': serializer.toJson<bool>(
        homeShowTransactionsList,
      ),
      'transactionReminderEnabled': serializer.toJson<bool>(
        transactionReminderEnabled,
      ),
      'transactionReminderTimeMinutes': serializer.toJson<int>(
        transactionReminderTimeMinutes,
      ),
      'upcomingTransactionsEnabled': serializer.toJson<bool>(
        upcomingTransactionsEnabled,
      ),
      'requireBiometricOnLaunch': serializer.toJson<bool>(
        requireBiometricOnLaunch,
      ),
      'languageCode': serializer.toJson<String>(languageCode),
      'autoProcessScheduledOnAppOpen': serializer.toJson<bool>(
        autoProcessScheduledOnAppOpen,
      ),
      'autoProcessRecurringOnAppOpen': serializer.toJson<bool>(
        autoProcessRecurringOnAppOpen,
      ),
      'swipeBetweenTabsEnabled': serializer.toJson<bool>(
        swipeBetweenTabsEnabled,
      ),
    };
  }

  AppSettingsRow copyWith({
    int? id,
    String? primaryCurrencyCode,
    FirstDayOfWeek? firstDayOfWeek,
    AppDateFormat? dateFormat,
    bool? useGrouping,
    DecimalSeparator? decimalSeparator,
    AppThemeMode? themeMode,
    AppAccentColor? accentColor,
    bool? useMaterialYouColors,
    bool? showExpenseInRed,
    bool? onboardingCompleted,
    Value<String?> authUserId = const Value.absent(),
    Value<String?> authUsername = const Value.absent(),
    Value<String?> authDisplayName = const Value.absent(),
    Value<int?> authBirthdayMillis = const Value.absent(),
    bool? authIsDemo,
    bool? demoDataSeeded,
    String? homeFeatureCardsDismissedCsv,
    Value<int?> lastBirthdayCelebratedAtMillis = const Value.absent(),
    String? homeSectionOrderCsv,
    bool? homeShowUsername,
    bool? homeShowBanner,
    bool? homeShowAccounts,
    bool? homeShowBudgets,
    bool? homeShowGoals,
    bool? homeShowIncomeAndExpenses,
    bool? homeShowNetWorth,
    bool? homeShowOverdueAndUpcoming,
    bool? homeShowLoans,
    bool? homeShowLongTermLoans,
    bool? homeShowSpendingGraph,
    bool? homeShowPieChart,
    bool? homeShowHeatMap,
    bool? homeShowTransactionsList,
    bool? transactionReminderEnabled,
    int? transactionReminderTimeMinutes,
    bool? upcomingTransactionsEnabled,
    bool? requireBiometricOnLaunch,
    String? languageCode,
    bool? autoProcessScheduledOnAppOpen,
    bool? autoProcessRecurringOnAppOpen,
    bool? swipeBetweenTabsEnabled,
  }) => AppSettingsRow(
    id: id ?? this.id,
    primaryCurrencyCode: primaryCurrencyCode ?? this.primaryCurrencyCode,
    firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
    dateFormat: dateFormat ?? this.dateFormat,
    useGrouping: useGrouping ?? this.useGrouping,
    decimalSeparator: decimalSeparator ?? this.decimalSeparator,
    themeMode: themeMode ?? this.themeMode,
    accentColor: accentColor ?? this.accentColor,
    useMaterialYouColors: useMaterialYouColors ?? this.useMaterialYouColors,
    showExpenseInRed: showExpenseInRed ?? this.showExpenseInRed,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    authUserId: authUserId.present ? authUserId.value : this.authUserId,
    authUsername: authUsername.present ? authUsername.value : this.authUsername,
    authDisplayName: authDisplayName.present
        ? authDisplayName.value
        : this.authDisplayName,
    authBirthdayMillis: authBirthdayMillis.present
        ? authBirthdayMillis.value
        : this.authBirthdayMillis,
    authIsDemo: authIsDemo ?? this.authIsDemo,
    demoDataSeeded: demoDataSeeded ?? this.demoDataSeeded,
    homeFeatureCardsDismissedCsv:
        homeFeatureCardsDismissedCsv ?? this.homeFeatureCardsDismissedCsv,
    lastBirthdayCelebratedAtMillis: lastBirthdayCelebratedAtMillis.present
        ? lastBirthdayCelebratedAtMillis.value
        : this.lastBirthdayCelebratedAtMillis,
    homeSectionOrderCsv: homeSectionOrderCsv ?? this.homeSectionOrderCsv,
    homeShowUsername: homeShowUsername ?? this.homeShowUsername,
    homeShowBanner: homeShowBanner ?? this.homeShowBanner,
    homeShowAccounts: homeShowAccounts ?? this.homeShowAccounts,
    homeShowBudgets: homeShowBudgets ?? this.homeShowBudgets,
    homeShowGoals: homeShowGoals ?? this.homeShowGoals,
    homeShowIncomeAndExpenses:
        homeShowIncomeAndExpenses ?? this.homeShowIncomeAndExpenses,
    homeShowNetWorth: homeShowNetWorth ?? this.homeShowNetWorth,
    homeShowOverdueAndUpcoming:
        homeShowOverdueAndUpcoming ?? this.homeShowOverdueAndUpcoming,
    homeShowLoans: homeShowLoans ?? this.homeShowLoans,
    homeShowLongTermLoans: homeShowLongTermLoans ?? this.homeShowLongTermLoans,
    homeShowSpendingGraph: homeShowSpendingGraph ?? this.homeShowSpendingGraph,
    homeShowPieChart: homeShowPieChart ?? this.homeShowPieChart,
    homeShowHeatMap: homeShowHeatMap ?? this.homeShowHeatMap,
    homeShowTransactionsList:
        homeShowTransactionsList ?? this.homeShowTransactionsList,
    transactionReminderEnabled:
        transactionReminderEnabled ?? this.transactionReminderEnabled,
    transactionReminderTimeMinutes:
        transactionReminderTimeMinutes ?? this.transactionReminderTimeMinutes,
    upcomingTransactionsEnabled:
        upcomingTransactionsEnabled ?? this.upcomingTransactionsEnabled,
    requireBiometricOnLaunch:
        requireBiometricOnLaunch ?? this.requireBiometricOnLaunch,
    languageCode: languageCode ?? this.languageCode,
    autoProcessScheduledOnAppOpen:
        autoProcessScheduledOnAppOpen ?? this.autoProcessScheduledOnAppOpen,
    autoProcessRecurringOnAppOpen:
        autoProcessRecurringOnAppOpen ?? this.autoProcessRecurringOnAppOpen,
    swipeBetweenTabsEnabled:
        swipeBetweenTabsEnabled ?? this.swipeBetweenTabsEnabled,
  );
  AppSettingsRow copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      primaryCurrencyCode: data.primaryCurrencyCode.present
          ? data.primaryCurrencyCode.value
          : this.primaryCurrencyCode,
      firstDayOfWeek: data.firstDayOfWeek.present
          ? data.firstDayOfWeek.value
          : this.firstDayOfWeek,
      dateFormat: data.dateFormat.present
          ? data.dateFormat.value
          : this.dateFormat,
      useGrouping: data.useGrouping.present
          ? data.useGrouping.value
          : this.useGrouping,
      decimalSeparator: data.decimalSeparator.present
          ? data.decimalSeparator.value
          : this.decimalSeparator,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      accentColor: data.accentColor.present
          ? data.accentColor.value
          : this.accentColor,
      useMaterialYouColors: data.useMaterialYouColors.present
          ? data.useMaterialYouColors.value
          : this.useMaterialYouColors,
      showExpenseInRed: data.showExpenseInRed.present
          ? data.showExpenseInRed.value
          : this.showExpenseInRed,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      authUserId: data.authUserId.present
          ? data.authUserId.value
          : this.authUserId,
      authUsername: data.authUsername.present
          ? data.authUsername.value
          : this.authUsername,
      authDisplayName: data.authDisplayName.present
          ? data.authDisplayName.value
          : this.authDisplayName,
      authBirthdayMillis: data.authBirthdayMillis.present
          ? data.authBirthdayMillis.value
          : this.authBirthdayMillis,
      authIsDemo: data.authIsDemo.present
          ? data.authIsDemo.value
          : this.authIsDemo,
      demoDataSeeded: data.demoDataSeeded.present
          ? data.demoDataSeeded.value
          : this.demoDataSeeded,
      homeFeatureCardsDismissedCsv: data.homeFeatureCardsDismissedCsv.present
          ? data.homeFeatureCardsDismissedCsv.value
          : this.homeFeatureCardsDismissedCsv,
      lastBirthdayCelebratedAtMillis:
          data.lastBirthdayCelebratedAtMillis.present
          ? data.lastBirthdayCelebratedAtMillis.value
          : this.lastBirthdayCelebratedAtMillis,
      homeSectionOrderCsv: data.homeSectionOrderCsv.present
          ? data.homeSectionOrderCsv.value
          : this.homeSectionOrderCsv,
      homeShowUsername: data.homeShowUsername.present
          ? data.homeShowUsername.value
          : this.homeShowUsername,
      homeShowBanner: data.homeShowBanner.present
          ? data.homeShowBanner.value
          : this.homeShowBanner,
      homeShowAccounts: data.homeShowAccounts.present
          ? data.homeShowAccounts.value
          : this.homeShowAccounts,
      homeShowBudgets: data.homeShowBudgets.present
          ? data.homeShowBudgets.value
          : this.homeShowBudgets,
      homeShowGoals: data.homeShowGoals.present
          ? data.homeShowGoals.value
          : this.homeShowGoals,
      homeShowIncomeAndExpenses: data.homeShowIncomeAndExpenses.present
          ? data.homeShowIncomeAndExpenses.value
          : this.homeShowIncomeAndExpenses,
      homeShowNetWorth: data.homeShowNetWorth.present
          ? data.homeShowNetWorth.value
          : this.homeShowNetWorth,
      homeShowOverdueAndUpcoming: data.homeShowOverdueAndUpcoming.present
          ? data.homeShowOverdueAndUpcoming.value
          : this.homeShowOverdueAndUpcoming,
      homeShowLoans: data.homeShowLoans.present
          ? data.homeShowLoans.value
          : this.homeShowLoans,
      homeShowLongTermLoans: data.homeShowLongTermLoans.present
          ? data.homeShowLongTermLoans.value
          : this.homeShowLongTermLoans,
      homeShowSpendingGraph: data.homeShowSpendingGraph.present
          ? data.homeShowSpendingGraph.value
          : this.homeShowSpendingGraph,
      homeShowPieChart: data.homeShowPieChart.present
          ? data.homeShowPieChart.value
          : this.homeShowPieChart,
      homeShowHeatMap: data.homeShowHeatMap.present
          ? data.homeShowHeatMap.value
          : this.homeShowHeatMap,
      homeShowTransactionsList: data.homeShowTransactionsList.present
          ? data.homeShowTransactionsList.value
          : this.homeShowTransactionsList,
      transactionReminderEnabled: data.transactionReminderEnabled.present
          ? data.transactionReminderEnabled.value
          : this.transactionReminderEnabled,
      transactionReminderTimeMinutes:
          data.transactionReminderTimeMinutes.present
          ? data.transactionReminderTimeMinutes.value
          : this.transactionReminderTimeMinutes,
      upcomingTransactionsEnabled: data.upcomingTransactionsEnabled.present
          ? data.upcomingTransactionsEnabled.value
          : this.upcomingTransactionsEnabled,
      requireBiometricOnLaunch: data.requireBiometricOnLaunch.present
          ? data.requireBiometricOnLaunch.value
          : this.requireBiometricOnLaunch,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      autoProcessScheduledOnAppOpen: data.autoProcessScheduledOnAppOpen.present
          ? data.autoProcessScheduledOnAppOpen.value
          : this.autoProcessScheduledOnAppOpen,
      autoProcessRecurringOnAppOpen: data.autoProcessRecurringOnAppOpen.present
          ? data.autoProcessRecurringOnAppOpen.value
          : this.autoProcessRecurringOnAppOpen,
      swipeBetweenTabsEnabled: data.swipeBetweenTabsEnabled.present
          ? data.swipeBetweenTabsEnabled.value
          : this.swipeBetweenTabsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRow(')
          ..write('id: $id, ')
          ..write('primaryCurrencyCode: $primaryCurrencyCode, ')
          ..write('firstDayOfWeek: $firstDayOfWeek, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('useGrouping: $useGrouping, ')
          ..write('decimalSeparator: $decimalSeparator, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentColor: $accentColor, ')
          ..write('useMaterialYouColors: $useMaterialYouColors, ')
          ..write('showExpenseInRed: $showExpenseInRed, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('authUserId: $authUserId, ')
          ..write('authUsername: $authUsername, ')
          ..write('authDisplayName: $authDisplayName, ')
          ..write('authBirthdayMillis: $authBirthdayMillis, ')
          ..write('authIsDemo: $authIsDemo, ')
          ..write('demoDataSeeded: $demoDataSeeded, ')
          ..write(
            'homeFeatureCardsDismissedCsv: $homeFeatureCardsDismissedCsv, ',
          )
          ..write(
            'lastBirthdayCelebratedAtMillis: $lastBirthdayCelebratedAtMillis, ',
          )
          ..write('homeSectionOrderCsv: $homeSectionOrderCsv, ')
          ..write('homeShowUsername: $homeShowUsername, ')
          ..write('homeShowBanner: $homeShowBanner, ')
          ..write('homeShowAccounts: $homeShowAccounts, ')
          ..write('homeShowBudgets: $homeShowBudgets, ')
          ..write('homeShowGoals: $homeShowGoals, ')
          ..write('homeShowIncomeAndExpenses: $homeShowIncomeAndExpenses, ')
          ..write('homeShowNetWorth: $homeShowNetWorth, ')
          ..write('homeShowOverdueAndUpcoming: $homeShowOverdueAndUpcoming, ')
          ..write('homeShowLoans: $homeShowLoans, ')
          ..write('homeShowLongTermLoans: $homeShowLongTermLoans, ')
          ..write('homeShowSpendingGraph: $homeShowSpendingGraph, ')
          ..write('homeShowPieChart: $homeShowPieChart, ')
          ..write('homeShowHeatMap: $homeShowHeatMap, ')
          ..write('homeShowTransactionsList: $homeShowTransactionsList, ')
          ..write('transactionReminderEnabled: $transactionReminderEnabled, ')
          ..write(
            'transactionReminderTimeMinutes: $transactionReminderTimeMinutes, ',
          )
          ..write('upcomingTransactionsEnabled: $upcomingTransactionsEnabled, ')
          ..write('requireBiometricOnLaunch: $requireBiometricOnLaunch, ')
          ..write('languageCode: $languageCode, ')
          ..write(
            'autoProcessScheduledOnAppOpen: $autoProcessScheduledOnAppOpen, ',
          )
          ..write(
            'autoProcessRecurringOnAppOpen: $autoProcessRecurringOnAppOpen, ',
          )
          ..write('swipeBetweenTabsEnabled: $swipeBetweenTabsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    primaryCurrencyCode,
    firstDayOfWeek,
    dateFormat,
    useGrouping,
    decimalSeparator,
    themeMode,
    accentColor,
    useMaterialYouColors,
    showExpenseInRed,
    onboardingCompleted,
    authUserId,
    authUsername,
    authDisplayName,
    authBirthdayMillis,
    authIsDemo,
    demoDataSeeded,
    homeFeatureCardsDismissedCsv,
    lastBirthdayCelebratedAtMillis,
    homeSectionOrderCsv,
    homeShowUsername,
    homeShowBanner,
    homeShowAccounts,
    homeShowBudgets,
    homeShowGoals,
    homeShowIncomeAndExpenses,
    homeShowNetWorth,
    homeShowOverdueAndUpcoming,
    homeShowLoans,
    homeShowLongTermLoans,
    homeShowSpendingGraph,
    homeShowPieChart,
    homeShowHeatMap,
    homeShowTransactionsList,
    transactionReminderEnabled,
    transactionReminderTimeMinutes,
    upcomingTransactionsEnabled,
    requireBiometricOnLaunch,
    languageCode,
    autoProcessScheduledOnAppOpen,
    autoProcessRecurringOnAppOpen,
    swipeBetweenTabsEnabled,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsRow &&
          other.id == this.id &&
          other.primaryCurrencyCode == this.primaryCurrencyCode &&
          other.firstDayOfWeek == this.firstDayOfWeek &&
          other.dateFormat == this.dateFormat &&
          other.useGrouping == this.useGrouping &&
          other.decimalSeparator == this.decimalSeparator &&
          other.themeMode == this.themeMode &&
          other.accentColor == this.accentColor &&
          other.useMaterialYouColors == this.useMaterialYouColors &&
          other.showExpenseInRed == this.showExpenseInRed &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.authUserId == this.authUserId &&
          other.authUsername == this.authUsername &&
          other.authDisplayName == this.authDisplayName &&
          other.authBirthdayMillis == this.authBirthdayMillis &&
          other.authIsDemo == this.authIsDemo &&
          other.demoDataSeeded == this.demoDataSeeded &&
          other.homeFeatureCardsDismissedCsv ==
              this.homeFeatureCardsDismissedCsv &&
          other.lastBirthdayCelebratedAtMillis ==
              this.lastBirthdayCelebratedAtMillis &&
          other.homeSectionOrderCsv == this.homeSectionOrderCsv &&
          other.homeShowUsername == this.homeShowUsername &&
          other.homeShowBanner == this.homeShowBanner &&
          other.homeShowAccounts == this.homeShowAccounts &&
          other.homeShowBudgets == this.homeShowBudgets &&
          other.homeShowGoals == this.homeShowGoals &&
          other.homeShowIncomeAndExpenses == this.homeShowIncomeAndExpenses &&
          other.homeShowNetWorth == this.homeShowNetWorth &&
          other.homeShowOverdueAndUpcoming == this.homeShowOverdueAndUpcoming &&
          other.homeShowLoans == this.homeShowLoans &&
          other.homeShowLongTermLoans == this.homeShowLongTermLoans &&
          other.homeShowSpendingGraph == this.homeShowSpendingGraph &&
          other.homeShowPieChart == this.homeShowPieChart &&
          other.homeShowHeatMap == this.homeShowHeatMap &&
          other.homeShowTransactionsList == this.homeShowTransactionsList &&
          other.transactionReminderEnabled == this.transactionReminderEnabled &&
          other.transactionReminderTimeMinutes ==
              this.transactionReminderTimeMinutes &&
          other.upcomingTransactionsEnabled ==
              this.upcomingTransactionsEnabled &&
          other.requireBiometricOnLaunch == this.requireBiometricOnLaunch &&
          other.languageCode == this.languageCode &&
          other.autoProcessScheduledOnAppOpen ==
              this.autoProcessScheduledOnAppOpen &&
          other.autoProcessRecurringOnAppOpen ==
              this.autoProcessRecurringOnAppOpen &&
          other.swipeBetweenTabsEnabled == this.swipeBetweenTabsEnabled);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsRow> {
  final Value<int> id;
  final Value<String> primaryCurrencyCode;
  final Value<FirstDayOfWeek> firstDayOfWeek;
  final Value<AppDateFormat> dateFormat;
  final Value<bool> useGrouping;
  final Value<DecimalSeparator> decimalSeparator;
  final Value<AppThemeMode> themeMode;
  final Value<AppAccentColor> accentColor;
  final Value<bool> useMaterialYouColors;
  final Value<bool> showExpenseInRed;
  final Value<bool> onboardingCompleted;
  final Value<String?> authUserId;
  final Value<String?> authUsername;
  final Value<String?> authDisplayName;
  final Value<int?> authBirthdayMillis;
  final Value<bool> authIsDemo;
  final Value<bool> demoDataSeeded;
  final Value<String> homeFeatureCardsDismissedCsv;
  final Value<int?> lastBirthdayCelebratedAtMillis;
  final Value<String> homeSectionOrderCsv;
  final Value<bool> homeShowUsername;
  final Value<bool> homeShowBanner;
  final Value<bool> homeShowAccounts;
  final Value<bool> homeShowBudgets;
  final Value<bool> homeShowGoals;
  final Value<bool> homeShowIncomeAndExpenses;
  final Value<bool> homeShowNetWorth;
  final Value<bool> homeShowOverdueAndUpcoming;
  final Value<bool> homeShowLoans;
  final Value<bool> homeShowLongTermLoans;
  final Value<bool> homeShowSpendingGraph;
  final Value<bool> homeShowPieChart;
  final Value<bool> homeShowHeatMap;
  final Value<bool> homeShowTransactionsList;
  final Value<bool> transactionReminderEnabled;
  final Value<int> transactionReminderTimeMinutes;
  final Value<bool> upcomingTransactionsEnabled;
  final Value<bool> requireBiometricOnLaunch;
  final Value<String> languageCode;
  final Value<bool> autoProcessScheduledOnAppOpen;
  final Value<bool> autoProcessRecurringOnAppOpen;
  final Value<bool> swipeBetweenTabsEnabled;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.primaryCurrencyCode = const Value.absent(),
    this.firstDayOfWeek = const Value.absent(),
    this.dateFormat = const Value.absent(),
    this.useGrouping = const Value.absent(),
    this.decimalSeparator = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.useMaterialYouColors = const Value.absent(),
    this.showExpenseInRed = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.authUserId = const Value.absent(),
    this.authUsername = const Value.absent(),
    this.authDisplayName = const Value.absent(),
    this.authBirthdayMillis = const Value.absent(),
    this.authIsDemo = const Value.absent(),
    this.demoDataSeeded = const Value.absent(),
    this.homeFeatureCardsDismissedCsv = const Value.absent(),
    this.lastBirthdayCelebratedAtMillis = const Value.absent(),
    this.homeSectionOrderCsv = const Value.absent(),
    this.homeShowUsername = const Value.absent(),
    this.homeShowBanner = const Value.absent(),
    this.homeShowAccounts = const Value.absent(),
    this.homeShowBudgets = const Value.absent(),
    this.homeShowGoals = const Value.absent(),
    this.homeShowIncomeAndExpenses = const Value.absent(),
    this.homeShowNetWorth = const Value.absent(),
    this.homeShowOverdueAndUpcoming = const Value.absent(),
    this.homeShowLoans = const Value.absent(),
    this.homeShowLongTermLoans = const Value.absent(),
    this.homeShowSpendingGraph = const Value.absent(),
    this.homeShowPieChart = const Value.absent(),
    this.homeShowHeatMap = const Value.absent(),
    this.homeShowTransactionsList = const Value.absent(),
    this.transactionReminderEnabled = const Value.absent(),
    this.transactionReminderTimeMinutes = const Value.absent(),
    this.upcomingTransactionsEnabled = const Value.absent(),
    this.requireBiometricOnLaunch = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.autoProcessScheduledOnAppOpen = const Value.absent(),
    this.autoProcessRecurringOnAppOpen = const Value.absent(),
    this.swipeBetweenTabsEnabled = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String primaryCurrencyCode,
    required FirstDayOfWeek firstDayOfWeek,
    required AppDateFormat dateFormat,
    required bool useGrouping,
    required DecimalSeparator decimalSeparator,
    this.themeMode = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.useMaterialYouColors = const Value.absent(),
    this.showExpenseInRed = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.authUserId = const Value.absent(),
    this.authUsername = const Value.absent(),
    this.authDisplayName = const Value.absent(),
    this.authBirthdayMillis = const Value.absent(),
    this.authIsDemo = const Value.absent(),
    this.demoDataSeeded = const Value.absent(),
    this.homeFeatureCardsDismissedCsv = const Value.absent(),
    this.lastBirthdayCelebratedAtMillis = const Value.absent(),
    this.homeSectionOrderCsv = const Value.absent(),
    this.homeShowUsername = const Value.absent(),
    this.homeShowBanner = const Value.absent(),
    this.homeShowAccounts = const Value.absent(),
    this.homeShowBudgets = const Value.absent(),
    this.homeShowGoals = const Value.absent(),
    this.homeShowIncomeAndExpenses = const Value.absent(),
    this.homeShowNetWorth = const Value.absent(),
    this.homeShowOverdueAndUpcoming = const Value.absent(),
    this.homeShowLoans = const Value.absent(),
    this.homeShowLongTermLoans = const Value.absent(),
    this.homeShowSpendingGraph = const Value.absent(),
    this.homeShowPieChart = const Value.absent(),
    this.homeShowHeatMap = const Value.absent(),
    this.homeShowTransactionsList = const Value.absent(),
    this.transactionReminderEnabled = const Value.absent(),
    this.transactionReminderTimeMinutes = const Value.absent(),
    this.upcomingTransactionsEnabled = const Value.absent(),
    this.requireBiometricOnLaunch = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.autoProcessScheduledOnAppOpen = const Value.absent(),
    this.autoProcessRecurringOnAppOpen = const Value.absent(),
    this.swipeBetweenTabsEnabled = const Value.absent(),
  }) : primaryCurrencyCode = Value(primaryCurrencyCode),
       firstDayOfWeek = Value(firstDayOfWeek),
       dateFormat = Value(dateFormat),
       useGrouping = Value(useGrouping),
       decimalSeparator = Value(decimalSeparator);
  static Insertable<AppSettingsRow> custom({
    Expression<int>? id,
    Expression<String>? primaryCurrencyCode,
    Expression<int>? firstDayOfWeek,
    Expression<int>? dateFormat,
    Expression<bool>? useGrouping,
    Expression<int>? decimalSeparator,
    Expression<int>? themeMode,
    Expression<int>? accentColor,
    Expression<bool>? useMaterialYouColors,
    Expression<bool>? showExpenseInRed,
    Expression<bool>? onboardingCompleted,
    Expression<String>? authUserId,
    Expression<String>? authUsername,
    Expression<String>? authDisplayName,
    Expression<int>? authBirthdayMillis,
    Expression<bool>? authIsDemo,
    Expression<bool>? demoDataSeeded,
    Expression<String>? homeFeatureCardsDismissedCsv,
    Expression<int>? lastBirthdayCelebratedAtMillis,
    Expression<String>? homeSectionOrderCsv,
    Expression<bool>? homeShowUsername,
    Expression<bool>? homeShowBanner,
    Expression<bool>? homeShowAccounts,
    Expression<bool>? homeShowBudgets,
    Expression<bool>? homeShowGoals,
    Expression<bool>? homeShowIncomeAndExpenses,
    Expression<bool>? homeShowNetWorth,
    Expression<bool>? homeShowOverdueAndUpcoming,
    Expression<bool>? homeShowLoans,
    Expression<bool>? homeShowLongTermLoans,
    Expression<bool>? homeShowSpendingGraph,
    Expression<bool>? homeShowPieChart,
    Expression<bool>? homeShowHeatMap,
    Expression<bool>? homeShowTransactionsList,
    Expression<bool>? transactionReminderEnabled,
    Expression<int>? transactionReminderTimeMinutes,
    Expression<bool>? upcomingTransactionsEnabled,
    Expression<bool>? requireBiometricOnLaunch,
    Expression<String>? languageCode,
    Expression<bool>? autoProcessScheduledOnAppOpen,
    Expression<bool>? autoProcessRecurringOnAppOpen,
    Expression<bool>? swipeBetweenTabsEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (primaryCurrencyCode != null)
        'primary_currency_code': primaryCurrencyCode,
      if (firstDayOfWeek != null) 'first_day_of_week': firstDayOfWeek,
      if (dateFormat != null) 'date_format': dateFormat,
      if (useGrouping != null) 'use_grouping': useGrouping,
      if (decimalSeparator != null) 'decimal_separator': decimalSeparator,
      if (themeMode != null) 'theme_mode': themeMode,
      if (accentColor != null) 'accent_color': accentColor,
      if (useMaterialYouColors != null)
        'use_material_you_colors': useMaterialYouColors,
      if (showExpenseInRed != null) 'show_expense_in_red': showExpenseInRed,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (authUserId != null) 'auth_user_id': authUserId,
      if (authUsername != null) 'auth_username': authUsername,
      if (authDisplayName != null) 'auth_display_name': authDisplayName,
      if (authBirthdayMillis != null)
        'auth_birthday_millis': authBirthdayMillis,
      if (authIsDemo != null) 'auth_is_demo': authIsDemo,
      if (demoDataSeeded != null) 'demo_data_seeded': demoDataSeeded,
      if (homeFeatureCardsDismissedCsv != null)
        'home_feature_cards_dismissed_csv': homeFeatureCardsDismissedCsv,
      if (lastBirthdayCelebratedAtMillis != null)
        'last_birthday_celebrated_at_millis': lastBirthdayCelebratedAtMillis,
      if (homeSectionOrderCsv != null)
        'home_section_order_csv': homeSectionOrderCsv,
      if (homeShowUsername != null) 'home_show_username': homeShowUsername,
      if (homeShowBanner != null) 'home_show_banner': homeShowBanner,
      if (homeShowAccounts != null) 'home_show_accounts': homeShowAccounts,
      if (homeShowBudgets != null) 'home_show_budgets': homeShowBudgets,
      if (homeShowGoals != null) 'home_show_goals': homeShowGoals,
      if (homeShowIncomeAndExpenses != null)
        'home_show_income_and_expenses': homeShowIncomeAndExpenses,
      if (homeShowNetWorth != null) 'home_show_net_worth': homeShowNetWorth,
      if (homeShowOverdueAndUpcoming != null)
        'home_show_overdue_and_upcoming': homeShowOverdueAndUpcoming,
      if (homeShowLoans != null) 'home_show_loans': homeShowLoans,
      if (homeShowLongTermLoans != null)
        'home_show_long_term_loans': homeShowLongTermLoans,
      if (homeShowSpendingGraph != null)
        'home_show_spending_graph': homeShowSpendingGraph,
      if (homeShowPieChart != null) 'home_show_pie_chart': homeShowPieChart,
      if (homeShowHeatMap != null) 'home_show_heat_map': homeShowHeatMap,
      if (homeShowTransactionsList != null)
        'home_show_transactions_list': homeShowTransactionsList,
      if (transactionReminderEnabled != null)
        'transaction_reminder_enabled': transactionReminderEnabled,
      if (transactionReminderTimeMinutes != null)
        'transaction_reminder_time_minutes': transactionReminderTimeMinutes,
      if (upcomingTransactionsEnabled != null)
        'upcoming_transactions_enabled': upcomingTransactionsEnabled,
      if (requireBiometricOnLaunch != null)
        'require_biometric_on_launch': requireBiometricOnLaunch,
      if (languageCode != null) 'language_code': languageCode,
      if (autoProcessScheduledOnAppOpen != null)
        'auto_process_scheduled_on_app_open': autoProcessScheduledOnAppOpen,
      if (autoProcessRecurringOnAppOpen != null)
        'auto_process_recurring_on_app_open': autoProcessRecurringOnAppOpen,
      if (swipeBetweenTabsEnabled != null)
        'swipe_between_tabs_enabled': swipeBetweenTabsEnabled,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? primaryCurrencyCode,
    Value<FirstDayOfWeek>? firstDayOfWeek,
    Value<AppDateFormat>? dateFormat,
    Value<bool>? useGrouping,
    Value<DecimalSeparator>? decimalSeparator,
    Value<AppThemeMode>? themeMode,
    Value<AppAccentColor>? accentColor,
    Value<bool>? useMaterialYouColors,
    Value<bool>? showExpenseInRed,
    Value<bool>? onboardingCompleted,
    Value<String?>? authUserId,
    Value<String?>? authUsername,
    Value<String?>? authDisplayName,
    Value<int?>? authBirthdayMillis,
    Value<bool>? authIsDemo,
    Value<bool>? demoDataSeeded,
    Value<String>? homeFeatureCardsDismissedCsv,
    Value<int?>? lastBirthdayCelebratedAtMillis,
    Value<String>? homeSectionOrderCsv,
    Value<bool>? homeShowUsername,
    Value<bool>? homeShowBanner,
    Value<bool>? homeShowAccounts,
    Value<bool>? homeShowBudgets,
    Value<bool>? homeShowGoals,
    Value<bool>? homeShowIncomeAndExpenses,
    Value<bool>? homeShowNetWorth,
    Value<bool>? homeShowOverdueAndUpcoming,
    Value<bool>? homeShowLoans,
    Value<bool>? homeShowLongTermLoans,
    Value<bool>? homeShowSpendingGraph,
    Value<bool>? homeShowPieChart,
    Value<bool>? homeShowHeatMap,
    Value<bool>? homeShowTransactionsList,
    Value<bool>? transactionReminderEnabled,
    Value<int>? transactionReminderTimeMinutes,
    Value<bool>? upcomingTransactionsEnabled,
    Value<bool>? requireBiometricOnLaunch,
    Value<String>? languageCode,
    Value<bool>? autoProcessScheduledOnAppOpen,
    Value<bool>? autoProcessRecurringOnAppOpen,
    Value<bool>? swipeBetweenTabsEnabled,
  }) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      primaryCurrencyCode: primaryCurrencyCode ?? this.primaryCurrencyCode,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      dateFormat: dateFormat ?? this.dateFormat,
      useGrouping: useGrouping ?? this.useGrouping,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
      useMaterialYouColors: useMaterialYouColors ?? this.useMaterialYouColors,
      showExpenseInRed: showExpenseInRed ?? this.showExpenseInRed,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      authUserId: authUserId ?? this.authUserId,
      authUsername: authUsername ?? this.authUsername,
      authDisplayName: authDisplayName ?? this.authDisplayName,
      authBirthdayMillis: authBirthdayMillis ?? this.authBirthdayMillis,
      authIsDemo: authIsDemo ?? this.authIsDemo,
      demoDataSeeded: demoDataSeeded ?? this.demoDataSeeded,
      homeFeatureCardsDismissedCsv:
          homeFeatureCardsDismissedCsv ?? this.homeFeatureCardsDismissedCsv,
      lastBirthdayCelebratedAtMillis:
          lastBirthdayCelebratedAtMillis ?? this.lastBirthdayCelebratedAtMillis,
      homeSectionOrderCsv: homeSectionOrderCsv ?? this.homeSectionOrderCsv,
      homeShowUsername: homeShowUsername ?? this.homeShowUsername,
      homeShowBanner: homeShowBanner ?? this.homeShowBanner,
      homeShowAccounts: homeShowAccounts ?? this.homeShowAccounts,
      homeShowBudgets: homeShowBudgets ?? this.homeShowBudgets,
      homeShowGoals: homeShowGoals ?? this.homeShowGoals,
      homeShowIncomeAndExpenses:
          homeShowIncomeAndExpenses ?? this.homeShowIncomeAndExpenses,
      homeShowNetWorth: homeShowNetWorth ?? this.homeShowNetWorth,
      homeShowOverdueAndUpcoming:
          homeShowOverdueAndUpcoming ?? this.homeShowOverdueAndUpcoming,
      homeShowLoans: homeShowLoans ?? this.homeShowLoans,
      homeShowLongTermLoans:
          homeShowLongTermLoans ?? this.homeShowLongTermLoans,
      homeShowSpendingGraph:
          homeShowSpendingGraph ?? this.homeShowSpendingGraph,
      homeShowPieChart: homeShowPieChart ?? this.homeShowPieChart,
      homeShowHeatMap: homeShowHeatMap ?? this.homeShowHeatMap,
      homeShowTransactionsList:
          homeShowTransactionsList ?? this.homeShowTransactionsList,
      transactionReminderEnabled:
          transactionReminderEnabled ?? this.transactionReminderEnabled,
      transactionReminderTimeMinutes:
          transactionReminderTimeMinutes ?? this.transactionReminderTimeMinutes,
      upcomingTransactionsEnabled:
          upcomingTransactionsEnabled ?? this.upcomingTransactionsEnabled,
      requireBiometricOnLaunch:
          requireBiometricOnLaunch ?? this.requireBiometricOnLaunch,
      languageCode: languageCode ?? this.languageCode,
      autoProcessScheduledOnAppOpen:
          autoProcessScheduledOnAppOpen ?? this.autoProcessScheduledOnAppOpen,
      autoProcessRecurringOnAppOpen:
          autoProcessRecurringOnAppOpen ?? this.autoProcessRecurringOnAppOpen,
      swipeBetweenTabsEnabled:
          swipeBetweenTabsEnabled ?? this.swipeBetweenTabsEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (primaryCurrencyCode.present) {
      map['primary_currency_code'] = Variable<String>(
        primaryCurrencyCode.value,
      );
    }
    if (firstDayOfWeek.present) {
      map['first_day_of_week'] = Variable<int>(
        $AppSettingsTableTable.$converterfirstDayOfWeek.toSql(
          firstDayOfWeek.value,
        ),
      );
    }
    if (dateFormat.present) {
      map['date_format'] = Variable<int>(
        $AppSettingsTableTable.$converterdateFormat.toSql(dateFormat.value),
      );
    }
    if (useGrouping.present) {
      map['use_grouping'] = Variable<bool>(useGrouping.value);
    }
    if (decimalSeparator.present) {
      map['decimal_separator'] = Variable<int>(
        $AppSettingsTableTable.$converterdecimalSeparator.toSql(
          decimalSeparator.value,
        ),
      );
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(
        $AppSettingsTableTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    if (accentColor.present) {
      map['accent_color'] = Variable<int>(
        $AppSettingsTableTable.$converteraccentColor.toSql(accentColor.value),
      );
    }
    if (useMaterialYouColors.present) {
      map['use_material_you_colors'] = Variable<bool>(
        useMaterialYouColors.value,
      );
    }
    if (showExpenseInRed.present) {
      map['show_expense_in_red'] = Variable<bool>(showExpenseInRed.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (authUserId.present) {
      map['auth_user_id'] = Variable<String>(authUserId.value);
    }
    if (authUsername.present) {
      map['auth_username'] = Variable<String>(authUsername.value);
    }
    if (authDisplayName.present) {
      map['auth_display_name'] = Variable<String>(authDisplayName.value);
    }
    if (authBirthdayMillis.present) {
      map['auth_birthday_millis'] = Variable<int>(authBirthdayMillis.value);
    }
    if (authIsDemo.present) {
      map['auth_is_demo'] = Variable<bool>(authIsDemo.value);
    }
    if (demoDataSeeded.present) {
      map['demo_data_seeded'] = Variable<bool>(demoDataSeeded.value);
    }
    if (homeFeatureCardsDismissedCsv.present) {
      map['home_feature_cards_dismissed_csv'] = Variable<String>(
        homeFeatureCardsDismissedCsv.value,
      );
    }
    if (lastBirthdayCelebratedAtMillis.present) {
      map['last_birthday_celebrated_at_millis'] = Variable<int>(
        lastBirthdayCelebratedAtMillis.value,
      );
    }
    if (homeSectionOrderCsv.present) {
      map['home_section_order_csv'] = Variable<String>(
        homeSectionOrderCsv.value,
      );
    }
    if (homeShowUsername.present) {
      map['home_show_username'] = Variable<bool>(homeShowUsername.value);
    }
    if (homeShowBanner.present) {
      map['home_show_banner'] = Variable<bool>(homeShowBanner.value);
    }
    if (homeShowAccounts.present) {
      map['home_show_accounts'] = Variable<bool>(homeShowAccounts.value);
    }
    if (homeShowBudgets.present) {
      map['home_show_budgets'] = Variable<bool>(homeShowBudgets.value);
    }
    if (homeShowGoals.present) {
      map['home_show_goals'] = Variable<bool>(homeShowGoals.value);
    }
    if (homeShowIncomeAndExpenses.present) {
      map['home_show_income_and_expenses'] = Variable<bool>(
        homeShowIncomeAndExpenses.value,
      );
    }
    if (homeShowNetWorth.present) {
      map['home_show_net_worth'] = Variable<bool>(homeShowNetWorth.value);
    }
    if (homeShowOverdueAndUpcoming.present) {
      map['home_show_overdue_and_upcoming'] = Variable<bool>(
        homeShowOverdueAndUpcoming.value,
      );
    }
    if (homeShowLoans.present) {
      map['home_show_loans'] = Variable<bool>(homeShowLoans.value);
    }
    if (homeShowLongTermLoans.present) {
      map['home_show_long_term_loans'] = Variable<bool>(
        homeShowLongTermLoans.value,
      );
    }
    if (homeShowSpendingGraph.present) {
      map['home_show_spending_graph'] = Variable<bool>(
        homeShowSpendingGraph.value,
      );
    }
    if (homeShowPieChart.present) {
      map['home_show_pie_chart'] = Variable<bool>(homeShowPieChart.value);
    }
    if (homeShowHeatMap.present) {
      map['home_show_heat_map'] = Variable<bool>(homeShowHeatMap.value);
    }
    if (homeShowTransactionsList.present) {
      map['home_show_transactions_list'] = Variable<bool>(
        homeShowTransactionsList.value,
      );
    }
    if (transactionReminderEnabled.present) {
      map['transaction_reminder_enabled'] = Variable<bool>(
        transactionReminderEnabled.value,
      );
    }
    if (transactionReminderTimeMinutes.present) {
      map['transaction_reminder_time_minutes'] = Variable<int>(
        transactionReminderTimeMinutes.value,
      );
    }
    if (upcomingTransactionsEnabled.present) {
      map['upcoming_transactions_enabled'] = Variable<bool>(
        upcomingTransactionsEnabled.value,
      );
    }
    if (requireBiometricOnLaunch.present) {
      map['require_biometric_on_launch'] = Variable<bool>(
        requireBiometricOnLaunch.value,
      );
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (autoProcessScheduledOnAppOpen.present) {
      map['auto_process_scheduled_on_app_open'] = Variable<bool>(
        autoProcessScheduledOnAppOpen.value,
      );
    }
    if (autoProcessRecurringOnAppOpen.present) {
      map['auto_process_recurring_on_app_open'] = Variable<bool>(
        autoProcessRecurringOnAppOpen.value,
      );
    }
    if (swipeBetweenTabsEnabled.present) {
      map['swipe_between_tabs_enabled'] = Variable<bool>(
        swipeBetweenTabsEnabled.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('primaryCurrencyCode: $primaryCurrencyCode, ')
          ..write('firstDayOfWeek: $firstDayOfWeek, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('useGrouping: $useGrouping, ')
          ..write('decimalSeparator: $decimalSeparator, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentColor: $accentColor, ')
          ..write('useMaterialYouColors: $useMaterialYouColors, ')
          ..write('showExpenseInRed: $showExpenseInRed, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('authUserId: $authUserId, ')
          ..write('authUsername: $authUsername, ')
          ..write('authDisplayName: $authDisplayName, ')
          ..write('authBirthdayMillis: $authBirthdayMillis, ')
          ..write('authIsDemo: $authIsDemo, ')
          ..write('demoDataSeeded: $demoDataSeeded, ')
          ..write(
            'homeFeatureCardsDismissedCsv: $homeFeatureCardsDismissedCsv, ',
          )
          ..write(
            'lastBirthdayCelebratedAtMillis: $lastBirthdayCelebratedAtMillis, ',
          )
          ..write('homeSectionOrderCsv: $homeSectionOrderCsv, ')
          ..write('homeShowUsername: $homeShowUsername, ')
          ..write('homeShowBanner: $homeShowBanner, ')
          ..write('homeShowAccounts: $homeShowAccounts, ')
          ..write('homeShowBudgets: $homeShowBudgets, ')
          ..write('homeShowGoals: $homeShowGoals, ')
          ..write('homeShowIncomeAndExpenses: $homeShowIncomeAndExpenses, ')
          ..write('homeShowNetWorth: $homeShowNetWorth, ')
          ..write('homeShowOverdueAndUpcoming: $homeShowOverdueAndUpcoming, ')
          ..write('homeShowLoans: $homeShowLoans, ')
          ..write('homeShowLongTermLoans: $homeShowLongTermLoans, ')
          ..write('homeShowSpendingGraph: $homeShowSpendingGraph, ')
          ..write('homeShowPieChart: $homeShowPieChart, ')
          ..write('homeShowHeatMap: $homeShowHeatMap, ')
          ..write('homeShowTransactionsList: $homeShowTransactionsList, ')
          ..write('transactionReminderEnabled: $transactionReminderEnabled, ')
          ..write(
            'transactionReminderTimeMinutes: $transactionReminderTimeMinutes, ',
          )
          ..write('upcomingTransactionsEnabled: $upcomingTransactionsEnabled, ')
          ..write('requireBiometricOnLaunch: $requireBiometricOnLaunch, ')
          ..write('languageCode: $languageCode, ')
          ..write(
            'autoProcessScheduledOnAppOpen: $autoProcessScheduledOnAppOpen, ',
          )
          ..write(
            'autoProcessRecurringOnAppOpen: $autoProcessRecurringOnAppOpen, ',
          )
          ..write('swipeBetweenTabsEnabled: $swipeBetweenTabsEnabled')
          ..write(')'))
        .toString();
  }
}

class $GoalsTableTable extends GoalsTable
    with TableInfo<$GoalsTableTable, GoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMinorMeta = const VerificationMeta(
    'targetMinor',
  );
  @override
  late final GeneratedColumn<int> targetMinor = GeneratedColumn<int>(
    'target_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetScaleMeta = const VerificationMeta(
    'targetScale',
  );
  @override
  late final GeneratedColumn<int> targetScale = GeneratedColumn<int>(
    'target_scale',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedMinorMeta = const VerificationMeta(
    'savedMinor',
  );
  @override
  late final GeneratedColumn<int> savedMinor = GeneratedColumn<int>(
    'saved_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _savedScaleMeta = const VerificationMeta(
    'savedScale',
  );
  @override
  late final GeneratedColumn<int> savedScale = GeneratedColumn<int>(
    'saved_scale',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    currencyCode,
    targetMinor,
    targetScale,
    savedMinor,
    savedScale,
    targetDate,
    note,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('target_minor')) {
      context.handle(
        _targetMinorMeta,
        targetMinor.isAcceptableOrUnknown(
          data['target_minor']!,
          _targetMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetMinorMeta);
    }
    if (data.containsKey('target_scale')) {
      context.handle(
        _targetScaleMeta,
        targetScale.isAcceptableOrUnknown(
          data['target_scale']!,
          _targetScaleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetScaleMeta);
    }
    if (data.containsKey('saved_minor')) {
      context.handle(
        _savedMinorMeta,
        savedMinor.isAcceptableOrUnknown(data['saved_minor']!, _savedMinorMeta),
      );
    }
    if (data.containsKey('saved_scale')) {
      context.handle(
        _savedScaleMeta,
        savedScale.isAcceptableOrUnknown(data['saved_scale']!, _savedScaleMeta),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      targetMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_minor'],
      )!,
      targetScale: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_scale'],
      )!,
      savedMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saved_minor'],
      ),
      savedScale: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saved_scale'],
      ),
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GoalsTableTable createAlias(String alias) {
    return $GoalsTableTable(attachedDatabase, alias);
  }
}

class GoalRow extends DataClass implements Insertable<GoalRow> {
  final String id;
  final String name;
  final String currencyCode;
  final int targetMinor;
  final int targetScale;
  final int? savedMinor;
  final int? savedScale;
  final DateTime? targetDate;
  final String? note;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GoalRow({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.targetMinor,
    required this.targetScale,
    this.savedMinor,
    this.savedScale,
    this.targetDate,
    this.note,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['currency_code'] = Variable<String>(currencyCode);
    map['target_minor'] = Variable<int>(targetMinor);
    map['target_scale'] = Variable<int>(targetScale);
    if (!nullToAbsent || savedMinor != null) {
      map['saved_minor'] = Variable<int>(savedMinor);
    }
    if (!nullToAbsent || savedScale != null) {
      map['saved_scale'] = Variable<int>(savedScale);
    }
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GoalsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalsTableCompanion(
      id: Value(id),
      name: Value(name),
      currencyCode: Value(currencyCode),
      targetMinor: Value(targetMinor),
      targetScale: Value(targetScale),
      savedMinor: savedMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(savedMinor),
      savedScale: savedScale == null && nullToAbsent
          ? const Value.absent()
          : Value(savedScale),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      targetMinor: serializer.fromJson<int>(json['targetMinor']),
      targetScale: serializer.fromJson<int>(json['targetScale']),
      savedMinor: serializer.fromJson<int?>(json['savedMinor']),
      savedScale: serializer.fromJson<int?>(json['savedScale']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      note: serializer.fromJson<String?>(json['note']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'targetMinor': serializer.toJson<int>(targetMinor),
      'targetScale': serializer.toJson<int>(targetScale),
      'savedMinor': serializer.toJson<int?>(savedMinor),
      'savedScale': serializer.toJson<int?>(savedScale),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'note': serializer.toJson<String?>(note),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GoalRow copyWith({
    String? id,
    String? name,
    String? currencyCode,
    int? targetMinor,
    int? targetScale,
    Value<int?> savedMinor = const Value.absent(),
    Value<int?> savedScale = const Value.absent(),
    Value<DateTime?> targetDate = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GoalRow(
    id: id ?? this.id,
    name: name ?? this.name,
    currencyCode: currencyCode ?? this.currencyCode,
    targetMinor: targetMinor ?? this.targetMinor,
    targetScale: targetScale ?? this.targetScale,
    savedMinor: savedMinor.present ? savedMinor.value : this.savedMinor,
    savedScale: savedScale.present ? savedScale.value : this.savedScale,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    note: note.present ? note.value : this.note,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GoalRow copyWithCompanion(GoalsTableCompanion data) {
    return GoalRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      targetMinor: data.targetMinor.present
          ? data.targetMinor.value
          : this.targetMinor,
      targetScale: data.targetScale.present
          ? data.targetScale.value
          : this.targetScale,
      savedMinor: data.savedMinor.present
          ? data.savedMinor.value
          : this.savedMinor,
      savedScale: data.savedScale.present
          ? data.savedScale.value
          : this.savedScale,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      note: data.note.present ? data.note.value : this.note,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('targetMinor: $targetMinor, ')
          ..write('targetScale: $targetScale, ')
          ..write('savedMinor: $savedMinor, ')
          ..write('savedScale: $savedScale, ')
          ..write('targetDate: $targetDate, ')
          ..write('note: $note, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    currencyCode,
    targetMinor,
    targetScale,
    savedMinor,
    savedScale,
    targetDate,
    note,
    archived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.currencyCode == this.currencyCode &&
          other.targetMinor == this.targetMinor &&
          other.targetScale == this.targetScale &&
          other.savedMinor == this.savedMinor &&
          other.savedScale == this.savedScale &&
          other.targetDate == this.targetDate &&
          other.note == this.note &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GoalsTableCompanion extends UpdateCompanion<GoalRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> currencyCode;
  final Value<int> targetMinor;
  final Value<int> targetScale;
  final Value<int?> savedMinor;
  final Value<int?> savedScale;
  final Value<DateTime?> targetDate;
  final Value<String?> note;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GoalsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.targetMinor = const Value.absent(),
    this.targetScale = const Value.absent(),
    this.savedMinor = const Value.absent(),
    this.savedScale = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.note = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsTableCompanion.insert({
    required String id,
    required String name,
    required String currencyCode,
    required int targetMinor,
    required int targetScale,
    this.savedMinor = const Value.absent(),
    this.savedScale = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.note = const Value.absent(),
    this.archived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       currencyCode = Value(currencyCode),
       targetMinor = Value(targetMinor),
       targetScale = Value(targetScale),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GoalRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? currencyCode,
    Expression<int>? targetMinor,
    Expression<int>? targetScale,
    Expression<int>? savedMinor,
    Expression<int>? savedScale,
    Expression<DateTime>? targetDate,
    Expression<String>? note,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (targetMinor != null) 'target_minor': targetMinor,
      if (targetScale != null) 'target_scale': targetScale,
      if (savedMinor != null) 'saved_minor': savedMinor,
      if (savedScale != null) 'saved_scale': savedScale,
      if (targetDate != null) 'target_date': targetDate,
      if (note != null) 'note': note,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? currencyCode,
    Value<int>? targetMinor,
    Value<int>? targetScale,
    Value<int?>? savedMinor,
    Value<int?>? savedScale,
    Value<DateTime?>? targetDate,
    Value<String?>? note,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GoalsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      currencyCode: currencyCode ?? this.currencyCode,
      targetMinor: targetMinor ?? this.targetMinor,
      targetScale: targetScale ?? this.targetScale,
      savedMinor: savedMinor ?? this.savedMinor,
      savedScale: savedScale ?? this.savedScale,
      targetDate: targetDate ?? this.targetDate,
      note: note ?? this.note,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (targetMinor.present) {
      map['target_minor'] = Variable<int>(targetMinor.value);
    }
    if (targetScale.present) {
      map['target_scale'] = Variable<int>(targetScale.value);
    }
    if (savedMinor.present) {
      map['saved_minor'] = Variable<int>(savedMinor.value);
    }
    if (savedScale.present) {
      map['saved_scale'] = Variable<int>(savedScale.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('targetMinor: $targetMinor, ')
          ..write('targetScale: $targetScale, ')
          ..write('savedMinor: $savedMinor, ')
          ..write('savedScale: $savedScale, ')
          ..write('targetDate: $targetDate, ')
          ..write('note: $note, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LoansTableTable extends LoansTable
    with TableInfo<$LoansTableTable, LoanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LoanType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LoanType>($LoansTableTable.$convertertype);
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _principalMinorMeta = const VerificationMeta(
    'principalMinor',
  );
  @override
  late final GeneratedColumn<int> principalMinor = GeneratedColumn<int>(
    'principal_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _principalScaleMeta = const VerificationMeta(
    'principalScale',
  );
  @override
  late final GeneratedColumn<int> principalScale = GeneratedColumn<int>(
    'principal_scale',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interestAprBpsMeta = const VerificationMeta(
    'interestAprBps',
  );
  @override
  late final GeneratedColumn<int> interestAprBps = GeneratedColumn<int>(
    'interest_apr_bps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lenderMeta = const VerificationMeta('lender');
  @override
  late final GeneratedColumn<String> lender = GeneratedColumn<String>(
    'lender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _termMonthsMeta = const VerificationMeta(
    'termMonths',
  );
  @override
  late final GeneratedColumn<int> termMonths = GeneratedColumn<int>(
    'term_months',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    currencyCode,
    principalMinor,
    principalScale,
    interestAprBps,
    lender,
    startDate,
    termMonths,
    note,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('principal_minor')) {
      context.handle(
        _principalMinorMeta,
        principalMinor.isAcceptableOrUnknown(
          data['principal_minor']!,
          _principalMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalMinorMeta);
    }
    if (data.containsKey('principal_scale')) {
      context.handle(
        _principalScaleMeta,
        principalScale.isAcceptableOrUnknown(
          data['principal_scale']!,
          _principalScaleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalScaleMeta);
    }
    if (data.containsKey('interest_apr_bps')) {
      context.handle(
        _interestAprBpsMeta,
        interestAprBps.isAcceptableOrUnknown(
          data['interest_apr_bps']!,
          _interestAprBpsMeta,
        ),
      );
    }
    if (data.containsKey('lender')) {
      context.handle(
        _lenderMeta,
        lender.isAcceptableOrUnknown(data['lender']!, _lenderMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('term_months')) {
      context.handle(
        _termMonthsMeta,
        termMonths.isAcceptableOrUnknown(data['term_months']!, _termMonthsMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $LoansTableTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      principalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}principal_minor'],
      )!,
      principalScale: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}principal_scale'],
      )!,
      interestAprBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interest_apr_bps'],
      ),
      lender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lender'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      termMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}term_months'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LoansTableTable createAlias(String alias) {
    return $LoansTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LoanType, int, int> $convertertype =
      const EnumIndexConverter<LoanType>(LoanType.values);
}

class LoanRow extends DataClass implements Insertable<LoanRow> {
  final String id;
  final String name;
  final LoanType type;
  final String currencyCode;
  final int principalMinor;
  final int principalScale;
  final int? interestAprBps;
  final String? lender;
  final DateTime? startDate;
  final int? termMonths;
  final String? note;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LoanRow({
    required this.id,
    required this.name,
    required this.type,
    required this.currencyCode,
    required this.principalMinor,
    required this.principalScale,
    this.interestAprBps,
    this.lender,
    this.startDate,
    this.termMonths,
    this.note,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>($LoansTableTable.$convertertype.toSql(type));
    }
    map['currency_code'] = Variable<String>(currencyCode);
    map['principal_minor'] = Variable<int>(principalMinor);
    map['principal_scale'] = Variable<int>(principalScale);
    if (!nullToAbsent || interestAprBps != null) {
      map['interest_apr_bps'] = Variable<int>(interestAprBps);
    }
    if (!nullToAbsent || lender != null) {
      map['lender'] = Variable<String>(lender);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || termMonths != null) {
      map['term_months'] = Variable<int>(termMonths);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LoansTableCompanion toCompanion(bool nullToAbsent) {
    return LoansTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      currencyCode: Value(currencyCode),
      principalMinor: Value(principalMinor),
      principalScale: Value(principalScale),
      interestAprBps: interestAprBps == null && nullToAbsent
          ? const Value.absent()
          : Value(interestAprBps),
      lender: lender == null && nullToAbsent
          ? const Value.absent()
          : Value(lender),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      termMonths: termMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(termMonths),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LoanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $LoansTableTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      principalMinor: serializer.fromJson<int>(json['principalMinor']),
      principalScale: serializer.fromJson<int>(json['principalScale']),
      interestAprBps: serializer.fromJson<int?>(json['interestAprBps']),
      lender: serializer.fromJson<String?>(json['lender']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      termMonths: serializer.fromJson<int?>(json['termMonths']),
      note: serializer.fromJson<String?>(json['note']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(
        $LoansTableTable.$convertertype.toJson(type),
      ),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'principalMinor': serializer.toJson<int>(principalMinor),
      'principalScale': serializer.toJson<int>(principalScale),
      'interestAprBps': serializer.toJson<int?>(interestAprBps),
      'lender': serializer.toJson<String?>(lender),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'termMonths': serializer.toJson<int?>(termMonths),
      'note': serializer.toJson<String?>(note),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LoanRow copyWith({
    String? id,
    String? name,
    LoanType? type,
    String? currencyCode,
    int? principalMinor,
    int? principalScale,
    Value<int?> interestAprBps = const Value.absent(),
    Value<String?> lender = const Value.absent(),
    Value<DateTime?> startDate = const Value.absent(),
    Value<int?> termMonths = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LoanRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    currencyCode: currencyCode ?? this.currencyCode,
    principalMinor: principalMinor ?? this.principalMinor,
    principalScale: principalScale ?? this.principalScale,
    interestAprBps: interestAprBps.present
        ? interestAprBps.value
        : this.interestAprBps,
    lender: lender.present ? lender.value : this.lender,
    startDate: startDate.present ? startDate.value : this.startDate,
    termMonths: termMonths.present ? termMonths.value : this.termMonths,
    note: note.present ? note.value : this.note,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LoanRow copyWithCompanion(LoansTableCompanion data) {
    return LoanRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      principalMinor: data.principalMinor.present
          ? data.principalMinor.value
          : this.principalMinor,
      principalScale: data.principalScale.present
          ? data.principalScale.value
          : this.principalScale,
      interestAprBps: data.interestAprBps.present
          ? data.interestAprBps.value
          : this.interestAprBps,
      lender: data.lender.present ? data.lender.value : this.lender,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      termMonths: data.termMonths.present
          ? data.termMonths.value
          : this.termMonths,
      note: data.note.present ? data.note.value : this.note,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('principalMinor: $principalMinor, ')
          ..write('principalScale: $principalScale, ')
          ..write('interestAprBps: $interestAprBps, ')
          ..write('lender: $lender, ')
          ..write('startDate: $startDate, ')
          ..write('termMonths: $termMonths, ')
          ..write('note: $note, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    currencyCode,
    principalMinor,
    principalScale,
    interestAprBps,
    lender,
    startDate,
    termMonths,
    note,
    archived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.currencyCode == this.currencyCode &&
          other.principalMinor == this.principalMinor &&
          other.principalScale == this.principalScale &&
          other.interestAprBps == this.interestAprBps &&
          other.lender == this.lender &&
          other.startDate == this.startDate &&
          other.termMonths == this.termMonths &&
          other.note == this.note &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LoansTableCompanion extends UpdateCompanion<LoanRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<LoanType> type;
  final Value<String> currencyCode;
  final Value<int> principalMinor;
  final Value<int> principalScale;
  final Value<int?> interestAprBps;
  final Value<String?> lender;
  final Value<DateTime?> startDate;
  final Value<int?> termMonths;
  final Value<String?> note;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LoansTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.principalMinor = const Value.absent(),
    this.principalScale = const Value.absent(),
    this.interestAprBps = const Value.absent(),
    this.lender = const Value.absent(),
    this.startDate = const Value.absent(),
    this.termMonths = const Value.absent(),
    this.note = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LoansTableCompanion.insert({
    required String id,
    required String name,
    required LoanType type,
    required String currencyCode,
    required int principalMinor,
    required int principalScale,
    this.interestAprBps = const Value.absent(),
    this.lender = const Value.absent(),
    this.startDate = const Value.absent(),
    this.termMonths = const Value.absent(),
    this.note = const Value.absent(),
    this.archived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       currencyCode = Value(currencyCode),
       principalMinor = Value(principalMinor),
       principalScale = Value(principalScale),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LoanRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? currencyCode,
    Expression<int>? principalMinor,
    Expression<int>? principalScale,
    Expression<int>? interestAprBps,
    Expression<String>? lender,
    Expression<DateTime>? startDate,
    Expression<int>? termMonths,
    Expression<String>? note,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (principalMinor != null) 'principal_minor': principalMinor,
      if (principalScale != null) 'principal_scale': principalScale,
      if (interestAprBps != null) 'interest_apr_bps': interestAprBps,
      if (lender != null) 'lender': lender,
      if (startDate != null) 'start_date': startDate,
      if (termMonths != null) 'term_months': termMonths,
      if (note != null) 'note': note,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LoansTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<LoanType>? type,
    Value<String>? currencyCode,
    Value<int>? principalMinor,
    Value<int>? principalScale,
    Value<int?>? interestAprBps,
    Value<String?>? lender,
    Value<DateTime?>? startDate,
    Value<int?>? termMonths,
    Value<String?>? note,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LoansTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currencyCode: currencyCode ?? this.currencyCode,
      principalMinor: principalMinor ?? this.principalMinor,
      principalScale: principalScale ?? this.principalScale,
      interestAprBps: interestAprBps ?? this.interestAprBps,
      lender: lender ?? this.lender,
      startDate: startDate ?? this.startDate,
      termMonths: termMonths ?? this.termMonths,
      note: note ?? this.note,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $LoansTableTable.$convertertype.toSql(type.value),
      );
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (principalMinor.present) {
      map['principal_minor'] = Variable<int>(principalMinor.value);
    }
    if (principalScale.present) {
      map['principal_scale'] = Variable<int>(principalScale.value);
    }
    if (interestAprBps.present) {
      map['interest_apr_bps'] = Variable<int>(interestAprBps.value);
    }
    if (lender.present) {
      map['lender'] = Variable<String>(lender.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (termMonths.present) {
      map['term_months'] = Variable<int>(termMonths.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('principalMinor: $principalMinor, ')
          ..write('principalScale: $principalScale, ')
          ..write('interestAprBps: $interestAprBps, ')
          ..write('lender: $lender, ')
          ..write('startDate: $startDate, ')
          ..write('termMonths: $termMonths, ')
          ..write('note: $note, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TransactionType>($TransactionsTableTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TransactionStatus>(
        $TransactionsTableTable.$converterstatus,
      );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta(
    'toAccountId',
  );
  @override
  late final GeneratedColumn<String> toAccountId = GeneratedColumn<String>(
    'to_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountScaleMeta = const VerificationMeta(
    'amountScale',
  );
  @override
  late final GeneratedColumn<int> amountScale = GeneratedColumn<int>(
    'amount_scale',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastExecutedAtMeta = const VerificationMeta(
    'lastExecutedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastExecutedAt =
      GeneratedColumn<DateTime>(
        'last_executed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<RecurrenceType?, int>
  recurrenceType =
      GeneratedColumn<int>(
        'recurrence_type',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<RecurrenceType?>(
        $TransactionsTableTable.$converterrecurrenceTypen,
      );
  static const VerificationMeta _recurrenceIntervalMeta =
      const VerificationMeta('recurrenceInterval');
  @override
  late final GeneratedColumn<int> recurrenceInterval = GeneratedColumn<int>(
    'recurrence_interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _recurrenceEndAtMeta = const VerificationMeta(
    'recurrenceEndAt',
  );
  @override
  late final GeneratedColumn<DateTime> recurrenceEndAt =
      GeneratedColumn<DateTime>(
        'recurrence_end_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    status,
    accountId,
    toAccountId,
    categoryId,
    budgetId,
    currencyCode,
    amountMinor,
    amountScale,
    occurredAt,
    title,
    note,
    merchant,
    reference,
    createdAt,
    updatedAt,
    lastExecutedAt,
    recurrenceType,
    recurrenceInterval,
    recurrenceEndAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
        _toAccountIdMeta,
        toAccountId.isAcceptableOrUnknown(
          data['to_account_id']!,
          _toAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('amount_scale')) {
      context.handle(
        _amountScaleMeta,
        amountScale.isAcceptableOrUnknown(
          data['amount_scale']!,
          _amountScaleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountScaleMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_executed_at')) {
      context.handle(
        _lastExecutedAtMeta,
        lastExecutedAt.isAcceptableOrUnknown(
          data['last_executed_at']!,
          _lastExecutedAtMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_interval')) {
      context.handle(
        _recurrenceIntervalMeta,
        recurrenceInterval.isAcceptableOrUnknown(
          data['recurrence_interval']!,
          _recurrenceIntervalMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_end_at')) {
      context.handle(
        _recurrenceEndAtMeta,
        recurrenceEndAt.isAcceptableOrUnknown(
          data['recurrence_end_at']!,
          _recurrenceEndAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: $TransactionsTableTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      status: $TransactionsTableTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      toAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_account_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      amountScale: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_scale'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      ),
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastExecutedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_executed_at'],
      ),
      recurrenceType: $TransactionsTableTable.$converterrecurrenceTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}recurrence_type'],
        ),
      ),
      recurrenceInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurrence_interval'],
      )!,
      recurrenceEndAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recurrence_end_at'],
      ),
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, int, int> $convertertype =
      const EnumIndexConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<TransactionStatus, int, int> $converterstatus =
      const EnumIndexConverter<TransactionStatus>(TransactionStatus.values);
  static JsonTypeConverter2<RecurrenceType, int, int> $converterrecurrenceType =
      const EnumIndexConverter<RecurrenceType>(RecurrenceType.values);
  static JsonTypeConverter2<RecurrenceType?, int?, int?>
  $converterrecurrenceTypen = JsonTypeConverter2.asNullable(
    $converterrecurrenceType,
  );
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final String id;
  final TransactionType type;
  final TransactionStatus status;
  final String accountId;
  final String? toAccountId;
  final String? categoryId;
  final String? budgetId;
  final String currencyCode;
  final int amountMinor;
  final int amountScale;
  final DateTime occurredAt;
  final String? title;
  final String? note;
  final String? merchant;
  final String? reference;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastExecutedAt;
  final RecurrenceType? recurrenceType;
  final int recurrenceInterval;
  final DateTime? recurrenceEndAt;
  const TransactionRow({
    required this.id,
    required this.type,
    required this.status,
    required this.accountId,
    this.toAccountId,
    this.categoryId,
    this.budgetId,
    required this.currencyCode,
    required this.amountMinor,
    required this.amountScale,
    required this.occurredAt,
    this.title,
    this.note,
    this.merchant,
    this.reference,
    required this.createdAt,
    required this.updatedAt,
    this.lastExecutedAt,
    this.recurrenceType,
    required this.recurrenceInterval,
    this.recurrenceEndAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['type'] = Variable<int>(
        $TransactionsTableTable.$convertertype.toSql(type),
      );
    }
    {
      map['status'] = Variable<int>(
        $TransactionsTableTable.$converterstatus.toSql(status),
      );
    }
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<String>(toAccountId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || budgetId != null) {
      map['budget_id'] = Variable<String>(budgetId);
    }
    map['currency_code'] = Variable<String>(currencyCode);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['amount_scale'] = Variable<int>(amountScale);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastExecutedAt != null) {
      map['last_executed_at'] = Variable<DateTime>(lastExecutedAt);
    }
    if (!nullToAbsent || recurrenceType != null) {
      map['recurrence_type'] = Variable<int>(
        $TransactionsTableTable.$converterrecurrenceTypen.toSql(recurrenceType),
      );
    }
    map['recurrence_interval'] = Variable<int>(recurrenceInterval);
    if (!nullToAbsent || recurrenceEndAt != null) {
      map['recurrence_end_at'] = Variable<DateTime>(recurrenceEndAt);
    }
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      type: Value(type),
      status: Value(status),
      accountId: Value(accountId),
      toAccountId: toAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(toAccountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      budgetId: budgetId == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetId),
      currencyCode: Value(currencyCode),
      amountMinor: Value(amountMinor),
      amountScale: Value(amountScale),
      occurredAt: Value(occurredAt),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastExecutedAt: lastExecutedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastExecutedAt),
      recurrenceType: recurrenceType == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceType),
      recurrenceInterval: Value(recurrenceInterval),
      recurrenceEndAt: recurrenceEndAt == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceEndAt),
    );
  }

  factory TransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<String>(json['id']),
      type: $TransactionsTableTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      status: $TransactionsTableTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      accountId: serializer.fromJson<String>(json['accountId']),
      toAccountId: serializer.fromJson<String?>(json['toAccountId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      budgetId: serializer.fromJson<String?>(json['budgetId']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      amountScale: serializer.fromJson<int>(json['amountScale']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      title: serializer.fromJson<String?>(json['title']),
      note: serializer.fromJson<String?>(json['note']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      reference: serializer.fromJson<String?>(json['reference']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastExecutedAt: serializer.fromJson<DateTime?>(json['lastExecutedAt']),
      recurrenceType: $TransactionsTableTable.$converterrecurrenceTypen
          .fromJson(serializer.fromJson<int?>(json['recurrenceType'])),
      recurrenceInterval: serializer.fromJson<int>(json['recurrenceInterval']),
      recurrenceEndAt: serializer.fromJson<DateTime?>(json['recurrenceEndAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<int>(
        $TransactionsTableTable.$convertertype.toJson(type),
      ),
      'status': serializer.toJson<int>(
        $TransactionsTableTable.$converterstatus.toJson(status),
      ),
      'accountId': serializer.toJson<String>(accountId),
      'toAccountId': serializer.toJson<String?>(toAccountId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'budgetId': serializer.toJson<String?>(budgetId),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'amountScale': serializer.toJson<int>(amountScale),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'title': serializer.toJson<String?>(title),
      'note': serializer.toJson<String?>(note),
      'merchant': serializer.toJson<String?>(merchant),
      'reference': serializer.toJson<String?>(reference),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastExecutedAt': serializer.toJson<DateTime?>(lastExecutedAt),
      'recurrenceType': serializer.toJson<int?>(
        $TransactionsTableTable.$converterrecurrenceTypen.toJson(
          recurrenceType,
        ),
      ),
      'recurrenceInterval': serializer.toJson<int>(recurrenceInterval),
      'recurrenceEndAt': serializer.toJson<DateTime?>(recurrenceEndAt),
    };
  }

  TransactionRow copyWith({
    String? id,
    TransactionType? type,
    TransactionStatus? status,
    String? accountId,
    Value<String?> toAccountId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> budgetId = const Value.absent(),
    String? currencyCode,
    int? amountMinor,
    int? amountScale,
    DateTime? occurredAt,
    Value<String?> title = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> merchant = const Value.absent(),
    Value<String?> reference = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastExecutedAt = const Value.absent(),
    Value<RecurrenceType?> recurrenceType = const Value.absent(),
    int? recurrenceInterval,
    Value<DateTime?> recurrenceEndAt = const Value.absent(),
  }) => TransactionRow(
    id: id ?? this.id,
    type: type ?? this.type,
    status: status ?? this.status,
    accountId: accountId ?? this.accountId,
    toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    budgetId: budgetId.present ? budgetId.value : this.budgetId,
    currencyCode: currencyCode ?? this.currencyCode,
    amountMinor: amountMinor ?? this.amountMinor,
    amountScale: amountScale ?? this.amountScale,
    occurredAt: occurredAt ?? this.occurredAt,
    title: title.present ? title.value : this.title,
    note: note.present ? note.value : this.note,
    merchant: merchant.present ? merchant.value : this.merchant,
    reference: reference.present ? reference.value : this.reference,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastExecutedAt: lastExecutedAt.present
        ? lastExecutedAt.value
        : this.lastExecutedAt,
    recurrenceType: recurrenceType.present
        ? recurrenceType.value
        : this.recurrenceType,
    recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
    recurrenceEndAt: recurrenceEndAt.present
        ? recurrenceEndAt.value
        : this.recurrenceEndAt,
  );
  TransactionRow copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      toAccountId: data.toAccountId.present
          ? data.toAccountId.value
          : this.toAccountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      amountScale: data.amountScale.present
          ? data.amountScale.value
          : this.amountScale,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      reference: data.reference.present ? data.reference.value : this.reference,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastExecutedAt: data.lastExecutedAt.present
          ? data.lastExecutedAt.value
          : this.lastExecutedAt,
      recurrenceType: data.recurrenceType.present
          ? data.recurrenceType.value
          : this.recurrenceType,
      recurrenceInterval: data.recurrenceInterval.present
          ? data.recurrenceInterval.value
          : this.recurrenceInterval,
      recurrenceEndAt: data.recurrenceEndAt.present
          ? data.recurrenceEndAt.value
          : this.recurrenceEndAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('budgetId: $budgetId, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('amountScale: $amountScale, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('merchant: $merchant, ')
          ..write('reference: $reference, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastExecutedAt: $lastExecutedAt, ')
          ..write('recurrenceType: $recurrenceType, ')
          ..write('recurrenceInterval: $recurrenceInterval, ')
          ..write('recurrenceEndAt: $recurrenceEndAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    type,
    status,
    accountId,
    toAccountId,
    categoryId,
    budgetId,
    currencyCode,
    amountMinor,
    amountScale,
    occurredAt,
    title,
    note,
    merchant,
    reference,
    createdAt,
    updatedAt,
    lastExecutedAt,
    recurrenceType,
    recurrenceInterval,
    recurrenceEndAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.status == this.status &&
          other.accountId == this.accountId &&
          other.toAccountId == this.toAccountId &&
          other.categoryId == this.categoryId &&
          other.budgetId == this.budgetId &&
          other.currencyCode == this.currencyCode &&
          other.amountMinor == this.amountMinor &&
          other.amountScale == this.amountScale &&
          other.occurredAt == this.occurredAt &&
          other.title == this.title &&
          other.note == this.note &&
          other.merchant == this.merchant &&
          other.reference == this.reference &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastExecutedAt == this.lastExecutedAt &&
          other.recurrenceType == this.recurrenceType &&
          other.recurrenceInterval == this.recurrenceInterval &&
          other.recurrenceEndAt == this.recurrenceEndAt);
}

class TransactionsTableCompanion extends UpdateCompanion<TransactionRow> {
  final Value<String> id;
  final Value<TransactionType> type;
  final Value<TransactionStatus> status;
  final Value<String> accountId;
  final Value<String?> toAccountId;
  final Value<String?> categoryId;
  final Value<String?> budgetId;
  final Value<String> currencyCode;
  final Value<int> amountMinor;
  final Value<int> amountScale;
  final Value<DateTime> occurredAt;
  final Value<String?> title;
  final Value<String?> note;
  final Value<String?> merchant;
  final Value<String?> reference;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastExecutedAt;
  final Value<RecurrenceType?> recurrenceType;
  final Value<int> recurrenceInterval;
  final Value<DateTime?> recurrenceEndAt;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.accountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.amountScale = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.merchant = const Value.absent(),
    this.reference = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastExecutedAt = const Value.absent(),
    this.recurrenceType = const Value.absent(),
    this.recurrenceInterval = const Value.absent(),
    this.recurrenceEndAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    required String id,
    required TransactionType type,
    required TransactionStatus status,
    required String accountId,
    this.toAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.budgetId = const Value.absent(),
    required String currencyCode,
    required int amountMinor,
    required int amountScale,
    required DateTime occurredAt,
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.merchant = const Value.absent(),
    this.reference = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastExecutedAt = const Value.absent(),
    this.recurrenceType = const Value.absent(),
    this.recurrenceInterval = const Value.absent(),
    this.recurrenceEndAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       status = Value(status),
       accountId = Value(accountId),
       currencyCode = Value(currencyCode),
       amountMinor = Value(amountMinor),
       amountScale = Value(amountScale),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TransactionRow> custom({
    Expression<String>? id,
    Expression<int>? type,
    Expression<int>? status,
    Expression<String>? accountId,
    Expression<String>? toAccountId,
    Expression<String>? categoryId,
    Expression<String>? budgetId,
    Expression<String>? currencyCode,
    Expression<int>? amountMinor,
    Expression<int>? amountScale,
    Expression<DateTime>? occurredAt,
    Expression<String>? title,
    Expression<String>? note,
    Expression<String>? merchant,
    Expression<String>? reference,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastExecutedAt,
    Expression<int>? recurrenceType,
    Expression<int>? recurrenceInterval,
    Expression<DateTime>? recurrenceEndAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (accountId != null) 'account_id': accountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (categoryId != null) 'category_id': categoryId,
      if (budgetId != null) 'budget_id': budgetId,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (amountScale != null) 'amount_scale': amountScale,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (merchant != null) 'merchant': merchant,
      if (reference != null) 'reference': reference,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastExecutedAt != null) 'last_executed_at': lastExecutedAt,
      if (recurrenceType != null) 'recurrence_type': recurrenceType,
      if (recurrenceInterval != null) 'recurrence_interval': recurrenceInterval,
      if (recurrenceEndAt != null) 'recurrence_end_at': recurrenceEndAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith({
    Value<String>? id,
    Value<TransactionType>? type,
    Value<TransactionStatus>? status,
    Value<String>? accountId,
    Value<String?>? toAccountId,
    Value<String?>? categoryId,
    Value<String?>? budgetId,
    Value<String>? currencyCode,
    Value<int>? amountMinor,
    Value<int>? amountScale,
    Value<DateTime>? occurredAt,
    Value<String?>? title,
    Value<String?>? note,
    Value<String?>? merchant,
    Value<String?>? reference,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastExecutedAt,
    Value<RecurrenceType?>? recurrenceType,
    Value<int>? recurrenceInterval,
    Value<DateTime?>? recurrenceEndAt,
    Value<int>? rowid,
  }) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      categoryId: categoryId ?? this.categoryId,
      budgetId: budgetId ?? this.budgetId,
      currencyCode: currencyCode ?? this.currencyCode,
      amountMinor: amountMinor ?? this.amountMinor,
      amountScale: amountScale ?? this.amountScale,
      occurredAt: occurredAt ?? this.occurredAt,
      title: title ?? this.title,
      note: note ?? this.note,
      merchant: merchant ?? this.merchant,
      reference: reference ?? this.reference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastExecutedAt: lastExecutedAt ?? this.lastExecutedAt,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      recurrenceEndAt: recurrenceEndAt ?? this.recurrenceEndAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $TransactionsTableTable.$convertertype.toSql(type.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $TransactionsTableTable.$converterstatus.toSql(status.value),
      );
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<String>(toAccountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (amountScale.present) {
      map['amount_scale'] = Variable<int>(amountScale.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastExecutedAt.present) {
      map['last_executed_at'] = Variable<DateTime>(lastExecutedAt.value);
    }
    if (recurrenceType.present) {
      map['recurrence_type'] = Variable<int>(
        $TransactionsTableTable.$converterrecurrenceTypen.toSql(
          recurrenceType.value,
        ),
      );
    }
    if (recurrenceInterval.present) {
      map['recurrence_interval'] = Variable<int>(recurrenceInterval.value);
    }
    if (recurrenceEndAt.present) {
      map['recurrence_end_at'] = Variable<DateTime>(recurrenceEndAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('budgetId: $budgetId, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('amountScale: $amountScale, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('merchant: $merchant, ')
          ..write('reference: $reference, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastExecutedAt: $lastExecutedAt, ')
          ..write('recurrenceType: $recurrenceType, ')
          ..write('recurrenceInterval: $recurrenceInterval, ')
          ..write('recurrenceEndAt: $recurrenceEndAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTableTable accountsTable = $AccountsTableTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $BudgetsTableTable budgetsTable = $BudgetsTableTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final $GoalsTableTable goalsTable = $GoalsTableTable(this);
  late final $LoansTableTable loansTable = $LoansTableTable(this);
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accountsTable,
    categoriesTable,
    budgetsTable,
    appSettingsTable,
    goalsTable,
    loansTable,
    transactionsTable,
  ];
}

typedef $$AccountsTableTableCreateCompanionBuilder =
    AccountsTableCompanion Function({
      required String id,
      required String name,
      required AccountType type,
      required String currencyCode,
      required int openingBalanceMinor,
      required int openingBalanceScale,
      Value<String?> institution,
      Value<String?> note,
      Value<bool> archived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AccountsTableTableUpdateCompanionBuilder =
    AccountsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<AccountType> type,
      Value<String> currencyCode,
      Value<int> openingBalanceMinor,
      Value<int> openingBalanceScale,
      Value<String?> institution,
      Value<String?> note,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AccountsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AccountType, AccountType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalanceMinor => $composableBuilder(
    column: $table.openingBalanceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalanceScale => $composableBuilder(
    column: $table.openingBalanceScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalanceMinor => $composableBuilder(
    column: $table.openingBalanceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalanceScale => $composableBuilder(
    column: $table.openingBalanceScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get openingBalanceMinor => $composableBuilder(
    column: $table.openingBalanceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get openingBalanceScale => $composableBuilder(
    column: $table.openingBalanceScale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AccountsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTableTable,
          AccountRow,
          $$AccountsTableTableFilterComposer,
          $$AccountsTableTableOrderingComposer,
          $$AccountsTableTableAnnotationComposer,
          $$AccountsTableTableCreateCompanionBuilder,
          $$AccountsTableTableUpdateCompanionBuilder,
          (
            AccountRow,
            BaseReferences<_$AppDatabase, $AccountsTableTable, AccountRow>,
          ),
          AccountRow,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableTableManager(_$AppDatabase db, $AccountsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AccountType> type = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> openingBalanceMinor = const Value.absent(),
                Value<int> openingBalanceScale = const Value.absent(),
                Value<String?> institution = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsTableCompanion(
                id: id,
                name: name,
                type: type,
                currencyCode: currencyCode,
                openingBalanceMinor: openingBalanceMinor,
                openingBalanceScale: openingBalanceScale,
                institution: institution,
                note: note,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required AccountType type,
                required String currencyCode,
                required int openingBalanceMinor,
                required int openingBalanceScale,
                Value<String?> institution = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AccountsTableCompanion.insert(
                id: id,
                name: name,
                type: type,
                currencyCode: currencyCode,
                openingBalanceMinor: openingBalanceMinor,
                openingBalanceScale: openingBalanceScale,
                institution: institution,
                note: note,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTableTable,
      AccountRow,
      $$AccountsTableTableFilterComposer,
      $$AccountsTableTableOrderingComposer,
      $$AccountsTableTableAnnotationComposer,
      $$AccountsTableTableCreateCompanionBuilder,
      $$AccountsTableTableUpdateCompanionBuilder,
      (
        AccountRow,
        BaseReferences<_$AppDatabase, $AccountsTableTable, AccountRow>,
      ),
      AccountRow,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      required String id,
      required String name,
      required CategoryType type,
      Value<String?> parentId,
      Value<String?> iconKey,
      Value<int?> colorHex,
      Value<bool> archived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<CategoryType> type,
      Value<String?> parentId,
      Value<String?> iconKey,
      Value<int?> colorHex,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CategoryType, CategoryType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CategoryType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoryRow,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (
            CategoryRow,
            BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryRow>,
          ),
          CategoryRow,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<CategoryType> type = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String?> iconKey = const Value.absent(),
                Value<int?> colorHex = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                name: name,
                type: type,
                parentId: parentId,
                iconKey: iconKey,
                colorHex: colorHex,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required CategoryType type,
                Value<String?> parentId = const Value.absent(),
                Value<String?> iconKey = const Value.absent(),
                Value<int?> colorHex = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                name: name,
                type: type,
                parentId: parentId,
                iconKey: iconKey,
                colorHex: colorHex,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoryRow,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (
        CategoryRow,
        BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryRow>,
      ),
      CategoryRow,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableTableCreateCompanionBuilder =
    BudgetsTableCompanion Function({
      required String id,
      required String name,
      required BudgetType type,
      required int amountMinor,
      required int amountScale,
      required String currencyCode,
      required String categoryId,
      Value<String> categoryIdsCsv,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      Value<bool> archived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BudgetsTableTableUpdateCompanionBuilder =
    BudgetsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<BudgetType> type,
      Value<int> amountMinor,
      Value<int> amountScale,
      Value<String> currencyCode,
      Value<String> categoryId,
      Value<String> categoryIdsCsv,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BudgetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BudgetType, BudgetType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountScale => $composableBuilder(
    column: $table.amountScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryIdsCsv => $composableBuilder(
    column: $table.categoryIdsCsv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountScale => $composableBuilder(
    column: $table.amountScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryIdsCsv => $composableBuilder(
    column: $table.categoryIdsCsv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BudgetType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountScale => $composableBuilder(
    column: $table.amountScale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryIdsCsv => $composableBuilder(
    column: $table.categoryIdsCsv,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTableTable,
          BudgetRow,
          $$BudgetsTableTableFilterComposer,
          $$BudgetsTableTableOrderingComposer,
          $$BudgetsTableTableAnnotationComposer,
          $$BudgetsTableTableCreateCompanionBuilder,
          $$BudgetsTableTableUpdateCompanionBuilder,
          (
            BudgetRow,
            BaseReferences<_$AppDatabase, $BudgetsTableTable, BudgetRow>,
          ),
          BudgetRow,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableTableManager(_$AppDatabase db, $BudgetsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<BudgetType> type = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<int> amountScale = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> categoryIdsCsv = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsTableCompanion(
                id: id,
                name: name,
                type: type,
                amountMinor: amountMinor,
                amountScale: amountScale,
                currencyCode: currencyCode,
                categoryId: categoryId,
                categoryIdsCsv: categoryIdsCsv,
                startDate: startDate,
                endDate: endDate,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required BudgetType type,
                required int amountMinor,
                required int amountScale,
                required String currencyCode,
                required String categoryId,
                Value<String> categoryIdsCsv = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsTableCompanion.insert(
                id: id,
                name: name,
                type: type,
                amountMinor: amountMinor,
                amountScale: amountScale,
                currencyCode: currencyCode,
                categoryId: categoryId,
                categoryIdsCsv: categoryIdsCsv,
                startDate: startDate,
                endDate: endDate,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTableTable,
      BudgetRow,
      $$BudgetsTableTableFilterComposer,
      $$BudgetsTableTableOrderingComposer,
      $$BudgetsTableTableAnnotationComposer,
      $$BudgetsTableTableCreateCompanionBuilder,
      $$BudgetsTableTableUpdateCompanionBuilder,
      (BudgetRow, BaseReferences<_$AppDatabase, $BudgetsTableTable, BudgetRow>),
      BudgetRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      required String primaryCurrencyCode,
      required FirstDayOfWeek firstDayOfWeek,
      required AppDateFormat dateFormat,
      required bool useGrouping,
      required DecimalSeparator decimalSeparator,
      Value<AppThemeMode> themeMode,
      Value<AppAccentColor> accentColor,
      Value<bool> useMaterialYouColors,
      Value<bool> showExpenseInRed,
      Value<bool> onboardingCompleted,
      Value<String?> authUserId,
      Value<String?> authUsername,
      Value<String?> authDisplayName,
      Value<int?> authBirthdayMillis,
      Value<bool> authIsDemo,
      Value<bool> demoDataSeeded,
      Value<String> homeFeatureCardsDismissedCsv,
      Value<int?> lastBirthdayCelebratedAtMillis,
      Value<String> homeSectionOrderCsv,
      Value<bool> homeShowUsername,
      Value<bool> homeShowBanner,
      Value<bool> homeShowAccounts,
      Value<bool> homeShowBudgets,
      Value<bool> homeShowGoals,
      Value<bool> homeShowIncomeAndExpenses,
      Value<bool> homeShowNetWorth,
      Value<bool> homeShowOverdueAndUpcoming,
      Value<bool> homeShowLoans,
      Value<bool> homeShowLongTermLoans,
      Value<bool> homeShowSpendingGraph,
      Value<bool> homeShowPieChart,
      Value<bool> homeShowHeatMap,
      Value<bool> homeShowTransactionsList,
      Value<bool> transactionReminderEnabled,
      Value<int> transactionReminderTimeMinutes,
      Value<bool> upcomingTransactionsEnabled,
      Value<bool> requireBiometricOnLaunch,
      Value<String> languageCode,
      Value<bool> autoProcessScheduledOnAppOpen,
      Value<bool> autoProcessRecurringOnAppOpen,
      Value<bool> swipeBetweenTabsEnabled,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<String> primaryCurrencyCode,
      Value<FirstDayOfWeek> firstDayOfWeek,
      Value<AppDateFormat> dateFormat,
      Value<bool> useGrouping,
      Value<DecimalSeparator> decimalSeparator,
      Value<AppThemeMode> themeMode,
      Value<AppAccentColor> accentColor,
      Value<bool> useMaterialYouColors,
      Value<bool> showExpenseInRed,
      Value<bool> onboardingCompleted,
      Value<String?> authUserId,
      Value<String?> authUsername,
      Value<String?> authDisplayName,
      Value<int?> authBirthdayMillis,
      Value<bool> authIsDemo,
      Value<bool> demoDataSeeded,
      Value<String> homeFeatureCardsDismissedCsv,
      Value<int?> lastBirthdayCelebratedAtMillis,
      Value<String> homeSectionOrderCsv,
      Value<bool> homeShowUsername,
      Value<bool> homeShowBanner,
      Value<bool> homeShowAccounts,
      Value<bool> homeShowBudgets,
      Value<bool> homeShowGoals,
      Value<bool> homeShowIncomeAndExpenses,
      Value<bool> homeShowNetWorth,
      Value<bool> homeShowOverdueAndUpcoming,
      Value<bool> homeShowLoans,
      Value<bool> homeShowLongTermLoans,
      Value<bool> homeShowSpendingGraph,
      Value<bool> homeShowPieChart,
      Value<bool> homeShowHeatMap,
      Value<bool> homeShowTransactionsList,
      Value<bool> transactionReminderEnabled,
      Value<int> transactionReminderTimeMinutes,
      Value<bool> upcomingTransactionsEnabled,
      Value<bool> requireBiometricOnLaunch,
      Value<String> languageCode,
      Value<bool> autoProcessScheduledOnAppOpen,
      Value<bool> autoProcessRecurringOnAppOpen,
      Value<bool> swipeBetweenTabsEnabled,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryCurrencyCode => $composableBuilder(
    column: $table.primaryCurrencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FirstDayOfWeek, FirstDayOfWeek, int>
  get firstDayOfWeek => $composableBuilder(
    column: $table.firstDayOfWeek,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<AppDateFormat, AppDateFormat, int>
  get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get useGrouping => $composableBuilder(
    column: $table.useGrouping,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DecimalSeparator, DecimalSeparator, int>
  get decimalSeparator => $composableBuilder(
    column: $table.decimalSeparator,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<AppThemeMode, AppThemeMode, int>
  get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<AppAccentColor, AppAccentColor, int>
  get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get useMaterialYouColors => $composableBuilder(
    column: $table.useMaterialYouColors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showExpenseInRed => $composableBuilder(
    column: $table.showExpenseInRed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authUserId => $composableBuilder(
    column: $table.authUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authUsername => $composableBuilder(
    column: $table.authUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authDisplayName => $composableBuilder(
    column: $table.authDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get authBirthdayMillis => $composableBuilder(
    column: $table.authBirthdayMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get authIsDemo => $composableBuilder(
    column: $table.authIsDemo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get demoDataSeeded => $composableBuilder(
    column: $table.demoDataSeeded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get homeFeatureCardsDismissedCsv => $composableBuilder(
    column: $table.homeFeatureCardsDismissedCsv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastBirthdayCelebratedAtMillis => $composableBuilder(
    column: $table.lastBirthdayCelebratedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get homeSectionOrderCsv => $composableBuilder(
    column: $table.homeSectionOrderCsv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowUsername => $composableBuilder(
    column: $table.homeShowUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowBanner => $composableBuilder(
    column: $table.homeShowBanner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowAccounts => $composableBuilder(
    column: $table.homeShowAccounts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowBudgets => $composableBuilder(
    column: $table.homeShowBudgets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowGoals => $composableBuilder(
    column: $table.homeShowGoals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowIncomeAndExpenses => $composableBuilder(
    column: $table.homeShowIncomeAndExpenses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowNetWorth => $composableBuilder(
    column: $table.homeShowNetWorth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowOverdueAndUpcoming => $composableBuilder(
    column: $table.homeShowOverdueAndUpcoming,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowLoans => $composableBuilder(
    column: $table.homeShowLoans,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowLongTermLoans => $composableBuilder(
    column: $table.homeShowLongTermLoans,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowSpendingGraph => $composableBuilder(
    column: $table.homeShowSpendingGraph,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowPieChart => $composableBuilder(
    column: $table.homeShowPieChart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowHeatMap => $composableBuilder(
    column: $table.homeShowHeatMap,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get homeShowTransactionsList => $composableBuilder(
    column: $table.homeShowTransactionsList,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get transactionReminderEnabled => $composableBuilder(
    column: $table.transactionReminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get transactionReminderTimeMinutes => $composableBuilder(
    column: $table.transactionReminderTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get upcomingTransactionsEnabled => $composableBuilder(
    column: $table.upcomingTransactionsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requireBiometricOnLaunch => $composableBuilder(
    column: $table.requireBiometricOnLaunch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoProcessScheduledOnAppOpen => $composableBuilder(
    column: $table.autoProcessScheduledOnAppOpen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoProcessRecurringOnAppOpen => $composableBuilder(
    column: $table.autoProcessRecurringOnAppOpen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get swipeBetweenTabsEnabled => $composableBuilder(
    column: $table.swipeBetweenTabsEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryCurrencyCode => $composableBuilder(
    column: $table.primaryCurrencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstDayOfWeek => $composableBuilder(
    column: $table.firstDayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useGrouping => $composableBuilder(
    column: $table.useGrouping,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get decimalSeparator => $composableBuilder(
    column: $table.decimalSeparator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useMaterialYouColors => $composableBuilder(
    column: $table.useMaterialYouColors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showExpenseInRed => $composableBuilder(
    column: $table.showExpenseInRed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authUserId => $composableBuilder(
    column: $table.authUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authUsername => $composableBuilder(
    column: $table.authUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authDisplayName => $composableBuilder(
    column: $table.authDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get authBirthdayMillis => $composableBuilder(
    column: $table.authBirthdayMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get authIsDemo => $composableBuilder(
    column: $table.authIsDemo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get demoDataSeeded => $composableBuilder(
    column: $table.demoDataSeeded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homeFeatureCardsDismissedCsv =>
      $composableBuilder(
        column: $table.homeFeatureCardsDismissedCsv,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get lastBirthdayCelebratedAtMillis => $composableBuilder(
    column: $table.lastBirthdayCelebratedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homeSectionOrderCsv => $composableBuilder(
    column: $table.homeSectionOrderCsv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowUsername => $composableBuilder(
    column: $table.homeShowUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowBanner => $composableBuilder(
    column: $table.homeShowBanner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowAccounts => $composableBuilder(
    column: $table.homeShowAccounts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowBudgets => $composableBuilder(
    column: $table.homeShowBudgets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowGoals => $composableBuilder(
    column: $table.homeShowGoals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowIncomeAndExpenses => $composableBuilder(
    column: $table.homeShowIncomeAndExpenses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowNetWorth => $composableBuilder(
    column: $table.homeShowNetWorth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowOverdueAndUpcoming => $composableBuilder(
    column: $table.homeShowOverdueAndUpcoming,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowLoans => $composableBuilder(
    column: $table.homeShowLoans,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowLongTermLoans => $composableBuilder(
    column: $table.homeShowLongTermLoans,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowSpendingGraph => $composableBuilder(
    column: $table.homeShowSpendingGraph,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowPieChart => $composableBuilder(
    column: $table.homeShowPieChart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowHeatMap => $composableBuilder(
    column: $table.homeShowHeatMap,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get homeShowTransactionsList => $composableBuilder(
    column: $table.homeShowTransactionsList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get transactionReminderEnabled => $composableBuilder(
    column: $table.transactionReminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get transactionReminderTimeMinutes => $composableBuilder(
    column: $table.transactionReminderTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get upcomingTransactionsEnabled => $composableBuilder(
    column: $table.upcomingTransactionsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requireBiometricOnLaunch => $composableBuilder(
    column: $table.requireBiometricOnLaunch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoProcessScheduledOnAppOpen => $composableBuilder(
    column: $table.autoProcessScheduledOnAppOpen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoProcessRecurringOnAppOpen => $composableBuilder(
    column: $table.autoProcessRecurringOnAppOpen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get swipeBetweenTabsEnabled => $composableBuilder(
    column: $table.swipeBetweenTabsEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get primaryCurrencyCode => $composableBuilder(
    column: $table.primaryCurrencyCode,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FirstDayOfWeek, int> get firstDayOfWeek =>
      $composableBuilder(
        column: $table.firstDayOfWeek,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<AppDateFormat, int> get dateFormat =>
      $composableBuilder(
        column: $table.dateFormat,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get useGrouping => $composableBuilder(
    column: $table.useGrouping,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DecimalSeparator, int>
  get decimalSeparator => $composableBuilder(
    column: $table.decimalSeparator,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AppThemeMode, int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppAccentColor, int> get accentColor =>
      $composableBuilder(
        column: $table.accentColor,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get useMaterialYouColors => $composableBuilder(
    column: $table.useMaterialYouColors,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showExpenseInRed => $composableBuilder(
    column: $table.showExpenseInRed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authUserId => $composableBuilder(
    column: $table.authUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authUsername => $composableBuilder(
    column: $table.authUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authDisplayName => $composableBuilder(
    column: $table.authDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get authBirthdayMillis => $composableBuilder(
    column: $table.authBirthdayMillis,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get authIsDemo => $composableBuilder(
    column: $table.authIsDemo,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get demoDataSeeded => $composableBuilder(
    column: $table.demoDataSeeded,
    builder: (column) => column,
  );

  GeneratedColumn<String> get homeFeatureCardsDismissedCsv =>
      $composableBuilder(
        column: $table.homeFeatureCardsDismissedCsv,
        builder: (column) => column,
      );

  GeneratedColumn<int> get lastBirthdayCelebratedAtMillis => $composableBuilder(
    column: $table.lastBirthdayCelebratedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get homeSectionOrderCsv => $composableBuilder(
    column: $table.homeSectionOrderCsv,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowUsername => $composableBuilder(
    column: $table.homeShowUsername,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowBanner => $composableBuilder(
    column: $table.homeShowBanner,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowAccounts => $composableBuilder(
    column: $table.homeShowAccounts,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowBudgets => $composableBuilder(
    column: $table.homeShowBudgets,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowGoals => $composableBuilder(
    column: $table.homeShowGoals,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowIncomeAndExpenses => $composableBuilder(
    column: $table.homeShowIncomeAndExpenses,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowNetWorth => $composableBuilder(
    column: $table.homeShowNetWorth,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowOverdueAndUpcoming => $composableBuilder(
    column: $table.homeShowOverdueAndUpcoming,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowLoans => $composableBuilder(
    column: $table.homeShowLoans,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowLongTermLoans => $composableBuilder(
    column: $table.homeShowLongTermLoans,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowSpendingGraph => $composableBuilder(
    column: $table.homeShowSpendingGraph,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowPieChart => $composableBuilder(
    column: $table.homeShowPieChart,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowHeatMap => $composableBuilder(
    column: $table.homeShowHeatMap,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get homeShowTransactionsList => $composableBuilder(
    column: $table.homeShowTransactionsList,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get transactionReminderEnabled => $composableBuilder(
    column: $table.transactionReminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get transactionReminderTimeMinutes => $composableBuilder(
    column: $table.transactionReminderTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get upcomingTransactionsEnabled => $composableBuilder(
    column: $table.upcomingTransactionsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requireBiometricOnLaunch => $composableBuilder(
    column: $table.requireBiometricOnLaunch,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoProcessScheduledOnAppOpen => $composableBuilder(
    column: $table.autoProcessScheduledOnAppOpen,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoProcessRecurringOnAppOpen => $composableBuilder(
    column: $table.autoProcessRecurringOnAppOpen,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get swipeBetweenTabsEnabled => $composableBuilder(
    column: $table.swipeBetweenTabsEnabled,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsRow,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsRow
            >,
          ),
          AppSettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> primaryCurrencyCode = const Value.absent(),
                Value<FirstDayOfWeek> firstDayOfWeek = const Value.absent(),
                Value<AppDateFormat> dateFormat = const Value.absent(),
                Value<bool> useGrouping = const Value.absent(),
                Value<DecimalSeparator> decimalSeparator = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<AppAccentColor> accentColor = const Value.absent(),
                Value<bool> useMaterialYouColors = const Value.absent(),
                Value<bool> showExpenseInRed = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<String?> authUserId = const Value.absent(),
                Value<String?> authUsername = const Value.absent(),
                Value<String?> authDisplayName = const Value.absent(),
                Value<int?> authBirthdayMillis = const Value.absent(),
                Value<bool> authIsDemo = const Value.absent(),
                Value<bool> demoDataSeeded = const Value.absent(),
                Value<String> homeFeatureCardsDismissedCsv =
                    const Value.absent(),
                Value<int?> lastBirthdayCelebratedAtMillis =
                    const Value.absent(),
                Value<String> homeSectionOrderCsv = const Value.absent(),
                Value<bool> homeShowUsername = const Value.absent(),
                Value<bool> homeShowBanner = const Value.absent(),
                Value<bool> homeShowAccounts = const Value.absent(),
                Value<bool> homeShowBudgets = const Value.absent(),
                Value<bool> homeShowGoals = const Value.absent(),
                Value<bool> homeShowIncomeAndExpenses = const Value.absent(),
                Value<bool> homeShowNetWorth = const Value.absent(),
                Value<bool> homeShowOverdueAndUpcoming = const Value.absent(),
                Value<bool> homeShowLoans = const Value.absent(),
                Value<bool> homeShowLongTermLoans = const Value.absent(),
                Value<bool> homeShowSpendingGraph = const Value.absent(),
                Value<bool> homeShowPieChart = const Value.absent(),
                Value<bool> homeShowHeatMap = const Value.absent(),
                Value<bool> homeShowTransactionsList = const Value.absent(),
                Value<bool> transactionReminderEnabled = const Value.absent(),
                Value<int> transactionReminderTimeMinutes =
                    const Value.absent(),
                Value<bool> upcomingTransactionsEnabled = const Value.absent(),
                Value<bool> requireBiometricOnLaunch = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<bool> autoProcessScheduledOnAppOpen =
                    const Value.absent(),
                Value<bool> autoProcessRecurringOnAppOpen =
                    const Value.absent(),
                Value<bool> swipeBetweenTabsEnabled = const Value.absent(),
              }) => AppSettingsTableCompanion(
                id: id,
                primaryCurrencyCode: primaryCurrencyCode,
                firstDayOfWeek: firstDayOfWeek,
                dateFormat: dateFormat,
                useGrouping: useGrouping,
                decimalSeparator: decimalSeparator,
                themeMode: themeMode,
                accentColor: accentColor,
                useMaterialYouColors: useMaterialYouColors,
                showExpenseInRed: showExpenseInRed,
                onboardingCompleted: onboardingCompleted,
                authUserId: authUserId,
                authUsername: authUsername,
                authDisplayName: authDisplayName,
                authBirthdayMillis: authBirthdayMillis,
                authIsDemo: authIsDemo,
                demoDataSeeded: demoDataSeeded,
                homeFeatureCardsDismissedCsv: homeFeatureCardsDismissedCsv,
                lastBirthdayCelebratedAtMillis: lastBirthdayCelebratedAtMillis,
                homeSectionOrderCsv: homeSectionOrderCsv,
                homeShowUsername: homeShowUsername,
                homeShowBanner: homeShowBanner,
                homeShowAccounts: homeShowAccounts,
                homeShowBudgets: homeShowBudgets,
                homeShowGoals: homeShowGoals,
                homeShowIncomeAndExpenses: homeShowIncomeAndExpenses,
                homeShowNetWorth: homeShowNetWorth,
                homeShowOverdueAndUpcoming: homeShowOverdueAndUpcoming,
                homeShowLoans: homeShowLoans,
                homeShowLongTermLoans: homeShowLongTermLoans,
                homeShowSpendingGraph: homeShowSpendingGraph,
                homeShowPieChart: homeShowPieChart,
                homeShowHeatMap: homeShowHeatMap,
                homeShowTransactionsList: homeShowTransactionsList,
                transactionReminderEnabled: transactionReminderEnabled,
                transactionReminderTimeMinutes: transactionReminderTimeMinutes,
                upcomingTransactionsEnabled: upcomingTransactionsEnabled,
                requireBiometricOnLaunch: requireBiometricOnLaunch,
                languageCode: languageCode,
                autoProcessScheduledOnAppOpen: autoProcessScheduledOnAppOpen,
                autoProcessRecurringOnAppOpen: autoProcessRecurringOnAppOpen,
                swipeBetweenTabsEnabled: swipeBetweenTabsEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String primaryCurrencyCode,
                required FirstDayOfWeek firstDayOfWeek,
                required AppDateFormat dateFormat,
                required bool useGrouping,
                required DecimalSeparator decimalSeparator,
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<AppAccentColor> accentColor = const Value.absent(),
                Value<bool> useMaterialYouColors = const Value.absent(),
                Value<bool> showExpenseInRed = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<String?> authUserId = const Value.absent(),
                Value<String?> authUsername = const Value.absent(),
                Value<String?> authDisplayName = const Value.absent(),
                Value<int?> authBirthdayMillis = const Value.absent(),
                Value<bool> authIsDemo = const Value.absent(),
                Value<bool> demoDataSeeded = const Value.absent(),
                Value<String> homeFeatureCardsDismissedCsv =
                    const Value.absent(),
                Value<int?> lastBirthdayCelebratedAtMillis =
                    const Value.absent(),
                Value<String> homeSectionOrderCsv = const Value.absent(),
                Value<bool> homeShowUsername = const Value.absent(),
                Value<bool> homeShowBanner = const Value.absent(),
                Value<bool> homeShowAccounts = const Value.absent(),
                Value<bool> homeShowBudgets = const Value.absent(),
                Value<bool> homeShowGoals = const Value.absent(),
                Value<bool> homeShowIncomeAndExpenses = const Value.absent(),
                Value<bool> homeShowNetWorth = const Value.absent(),
                Value<bool> homeShowOverdueAndUpcoming = const Value.absent(),
                Value<bool> homeShowLoans = const Value.absent(),
                Value<bool> homeShowLongTermLoans = const Value.absent(),
                Value<bool> homeShowSpendingGraph = const Value.absent(),
                Value<bool> homeShowPieChart = const Value.absent(),
                Value<bool> homeShowHeatMap = const Value.absent(),
                Value<bool> homeShowTransactionsList = const Value.absent(),
                Value<bool> transactionReminderEnabled = const Value.absent(),
                Value<int> transactionReminderTimeMinutes =
                    const Value.absent(),
                Value<bool> upcomingTransactionsEnabled = const Value.absent(),
                Value<bool> requireBiometricOnLaunch = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<bool> autoProcessScheduledOnAppOpen =
                    const Value.absent(),
                Value<bool> autoProcessRecurringOnAppOpen =
                    const Value.absent(),
                Value<bool> swipeBetweenTabsEnabled = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                id: id,
                primaryCurrencyCode: primaryCurrencyCode,
                firstDayOfWeek: firstDayOfWeek,
                dateFormat: dateFormat,
                useGrouping: useGrouping,
                decimalSeparator: decimalSeparator,
                themeMode: themeMode,
                accentColor: accentColor,
                useMaterialYouColors: useMaterialYouColors,
                showExpenseInRed: showExpenseInRed,
                onboardingCompleted: onboardingCompleted,
                authUserId: authUserId,
                authUsername: authUsername,
                authDisplayName: authDisplayName,
                authBirthdayMillis: authBirthdayMillis,
                authIsDemo: authIsDemo,
                demoDataSeeded: demoDataSeeded,
                homeFeatureCardsDismissedCsv: homeFeatureCardsDismissedCsv,
                lastBirthdayCelebratedAtMillis: lastBirthdayCelebratedAtMillis,
                homeSectionOrderCsv: homeSectionOrderCsv,
                homeShowUsername: homeShowUsername,
                homeShowBanner: homeShowBanner,
                homeShowAccounts: homeShowAccounts,
                homeShowBudgets: homeShowBudgets,
                homeShowGoals: homeShowGoals,
                homeShowIncomeAndExpenses: homeShowIncomeAndExpenses,
                homeShowNetWorth: homeShowNetWorth,
                homeShowOverdueAndUpcoming: homeShowOverdueAndUpcoming,
                homeShowLoans: homeShowLoans,
                homeShowLongTermLoans: homeShowLongTermLoans,
                homeShowSpendingGraph: homeShowSpendingGraph,
                homeShowPieChart: homeShowPieChart,
                homeShowHeatMap: homeShowHeatMap,
                homeShowTransactionsList: homeShowTransactionsList,
                transactionReminderEnabled: transactionReminderEnabled,
                transactionReminderTimeMinutes: transactionReminderTimeMinutes,
                upcomingTransactionsEnabled: upcomingTransactionsEnabled,
                requireBiometricOnLaunch: requireBiometricOnLaunch,
                languageCode: languageCode,
                autoProcessScheduledOnAppOpen: autoProcessScheduledOnAppOpen,
                autoProcessRecurringOnAppOpen: autoProcessRecurringOnAppOpen,
                swipeBetweenTabsEnabled: swipeBetweenTabsEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsRow,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsTableTable, AppSettingsRow>,
      ),
      AppSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableTableCreateCompanionBuilder =
    GoalsTableCompanion Function({
      required String id,
      required String name,
      required String currencyCode,
      required int targetMinor,
      required int targetScale,
      Value<int?> savedMinor,
      Value<int?> savedScale,
      Value<DateTime?> targetDate,
      Value<String?> note,
      Value<bool> archived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GoalsTableTableUpdateCompanionBuilder =
    GoalsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> currencyCode,
      Value<int> targetMinor,
      Value<int> targetScale,
      Value<int?> savedMinor,
      Value<int?> savedScale,
      Value<DateTime?> targetDate,
      Value<String?> note,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMinor => $composableBuilder(
    column: $table.targetMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetScale => $composableBuilder(
    column: $table.targetScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savedMinor => $composableBuilder(
    column: $table.savedMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savedScale => $composableBuilder(
    column: $table.savedScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMinor => $composableBuilder(
    column: $table.targetMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetScale => $composableBuilder(
    column: $table.targetScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savedMinor => $composableBuilder(
    column: $table.savedMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savedScale => $composableBuilder(
    column: $table.savedScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetMinor => $composableBuilder(
    column: $table.targetMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetScale => $composableBuilder(
    column: $table.targetScale,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savedMinor => $composableBuilder(
    column: $table.savedMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savedScale => $composableBuilder(
    column: $table.savedScale,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTableTable,
          GoalRow,
          $$GoalsTableTableFilterComposer,
          $$GoalsTableTableOrderingComposer,
          $$GoalsTableTableAnnotationComposer,
          $$GoalsTableTableCreateCompanionBuilder,
          $$GoalsTableTableUpdateCompanionBuilder,
          (GoalRow, BaseReferences<_$AppDatabase, $GoalsTableTable, GoalRow>),
          GoalRow,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableTableManager(_$AppDatabase db, $GoalsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> targetMinor = const Value.absent(),
                Value<int> targetScale = const Value.absent(),
                Value<int?> savedMinor = const Value.absent(),
                Value<int?> savedScale = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion(
                id: id,
                name: name,
                currencyCode: currencyCode,
                targetMinor: targetMinor,
                targetScale: targetScale,
                savedMinor: savedMinor,
                savedScale: savedScale,
                targetDate: targetDate,
                note: note,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String currencyCode,
                required int targetMinor,
                required int targetScale,
                Value<int?> savedMinor = const Value.absent(),
                Value<int?> savedScale = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion.insert(
                id: id,
                name: name,
                currencyCode: currencyCode,
                targetMinor: targetMinor,
                targetScale: targetScale,
                savedMinor: savedMinor,
                savedScale: savedScale,
                targetDate: targetDate,
                note: note,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTableTable,
      GoalRow,
      $$GoalsTableTableFilterComposer,
      $$GoalsTableTableOrderingComposer,
      $$GoalsTableTableAnnotationComposer,
      $$GoalsTableTableCreateCompanionBuilder,
      $$GoalsTableTableUpdateCompanionBuilder,
      (GoalRow, BaseReferences<_$AppDatabase, $GoalsTableTable, GoalRow>),
      GoalRow,
      PrefetchHooks Function()
    >;
typedef $$LoansTableTableCreateCompanionBuilder =
    LoansTableCompanion Function({
      required String id,
      required String name,
      required LoanType type,
      required String currencyCode,
      required int principalMinor,
      required int principalScale,
      Value<int?> interestAprBps,
      Value<String?> lender,
      Value<DateTime?> startDate,
      Value<int?> termMonths,
      Value<String?> note,
      Value<bool> archived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LoansTableTableUpdateCompanionBuilder =
    LoansTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<LoanType> type,
      Value<String> currencyCode,
      Value<int> principalMinor,
      Value<int> principalScale,
      Value<int?> interestAprBps,
      Value<String?> lender,
      Value<DateTime?> startDate,
      Value<int?> termMonths,
      Value<String?> note,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LoansTableTableFilterComposer
    extends Composer<_$AppDatabase, $LoansTableTable> {
  $$LoansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LoanType, LoanType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get principalMinor => $composableBuilder(
    column: $table.principalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get principalScale => $composableBuilder(
    column: $table.principalScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interestAprBps => $composableBuilder(
    column: $table.interestAprBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lender => $composableBuilder(
    column: $table.lender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get termMonths => $composableBuilder(
    column: $table.termMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LoansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTableTable> {
  $$LoansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get principalMinor => $composableBuilder(
    column: $table.principalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get principalScale => $composableBuilder(
    column: $table.principalScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interestAprBps => $composableBuilder(
    column: $table.interestAprBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lender => $composableBuilder(
    column: $table.lender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get termMonths => $composableBuilder(
    column: $table.termMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTableTable> {
  $$LoansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LoanType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get principalMinor => $composableBuilder(
    column: $table.principalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get principalScale => $composableBuilder(
    column: $table.principalScale,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interestAprBps => $composableBuilder(
    column: $table.interestAprBps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lender =>
      $composableBuilder(column: $table.lender, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get termMonths => $composableBuilder(
    column: $table.termMonths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LoansTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoansTableTable,
          LoanRow,
          $$LoansTableTableFilterComposer,
          $$LoansTableTableOrderingComposer,
          $$LoansTableTableAnnotationComposer,
          $$LoansTableTableCreateCompanionBuilder,
          $$LoansTableTableUpdateCompanionBuilder,
          (LoanRow, BaseReferences<_$AppDatabase, $LoansTableTable, LoanRow>),
          LoanRow,
          PrefetchHooks Function()
        > {
  $$LoansTableTableTableManager(_$AppDatabase db, $LoansTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<LoanType> type = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> principalMinor = const Value.absent(),
                Value<int> principalScale = const Value.absent(),
                Value<int?> interestAprBps = const Value.absent(),
                Value<String?> lender = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<int?> termMonths = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LoansTableCompanion(
                id: id,
                name: name,
                type: type,
                currencyCode: currencyCode,
                principalMinor: principalMinor,
                principalScale: principalScale,
                interestAprBps: interestAprBps,
                lender: lender,
                startDate: startDate,
                termMonths: termMonths,
                note: note,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required LoanType type,
                required String currencyCode,
                required int principalMinor,
                required int principalScale,
                Value<int?> interestAprBps = const Value.absent(),
                Value<String?> lender = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<int?> termMonths = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LoansTableCompanion.insert(
                id: id,
                name: name,
                type: type,
                currencyCode: currencyCode,
                principalMinor: principalMinor,
                principalScale: principalScale,
                interestAprBps: interestAprBps,
                lender: lender,
                startDate: startDate,
                termMonths: termMonths,
                note: note,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LoansTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoansTableTable,
      LoanRow,
      $$LoansTableTableFilterComposer,
      $$LoansTableTableOrderingComposer,
      $$LoansTableTableAnnotationComposer,
      $$LoansTableTableCreateCompanionBuilder,
      $$LoansTableTableUpdateCompanionBuilder,
      (LoanRow, BaseReferences<_$AppDatabase, $LoansTableTable, LoanRow>),
      LoanRow,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableTableCreateCompanionBuilder =
    TransactionsTableCompanion Function({
      required String id,
      required TransactionType type,
      required TransactionStatus status,
      required String accountId,
      Value<String?> toAccountId,
      Value<String?> categoryId,
      Value<String?> budgetId,
      required String currencyCode,
      required int amountMinor,
      required int amountScale,
      required DateTime occurredAt,
      Value<String?> title,
      Value<String?> note,
      Value<String?> merchant,
      Value<String?> reference,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> lastExecutedAt,
      Value<RecurrenceType?> recurrenceType,
      Value<int> recurrenceInterval,
      Value<DateTime?> recurrenceEndAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableTableUpdateCompanionBuilder =
    TransactionsTableCompanion Function({
      Value<String> id,
      Value<TransactionType> type,
      Value<TransactionStatus> status,
      Value<String> accountId,
      Value<String?> toAccountId,
      Value<String?> categoryId,
      Value<String?> budgetId,
      Value<String> currencyCode,
      Value<int> amountMinor,
      Value<int> amountScale,
      Value<DateTime> occurredAt,
      Value<String?> title,
      Value<String?> note,
      Value<String?> merchant,
      Value<String?> reference,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastExecutedAt,
      Value<RecurrenceType?> recurrenceType,
      Value<int> recurrenceInterval,
      Value<DateTime?> recurrenceEndAt,
      Value<int> rowid,
    });

class $$TransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, int>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionStatus, TransactionStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountScale => $composableBuilder(
    column: $table.amountScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastExecutedAt => $composableBuilder(
    column: $table.lastExecutedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RecurrenceType?, RecurrenceType, int>
  get recurrenceType => $composableBuilder(
    column: $table.recurrenceType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get recurrenceInterval => $composableBuilder(
    column: $table.recurrenceInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recurrenceEndAt => $composableBuilder(
    column: $table.recurrenceEndAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountScale => $composableBuilder(
    column: $table.amountScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastExecutedAt => $composableBuilder(
    column: $table.lastExecutedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurrenceType => $composableBuilder(
    column: $table.recurrenceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurrenceInterval => $composableBuilder(
    column: $table.recurrenceInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recurrenceEndAt => $composableBuilder(
    column: $table.recurrenceEndAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountScale => $composableBuilder(
    column: $table.amountScale,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastExecutedAt => $composableBuilder(
    column: $table.lastExecutedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RecurrenceType?, int> get recurrenceType =>
      $composableBuilder(
        column: $table.recurrenceType,
        builder: (column) => column,
      );

  GeneratedColumn<int> get recurrenceInterval => $composableBuilder(
    column: $table.recurrenceInterval,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recurrenceEndAt => $composableBuilder(
    column: $table.recurrenceEndAt,
    builder: (column) => column,
  );
}

class $$TransactionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionRow,
          $$TransactionsTableTableFilterComposer,
          $$TransactionsTableTableOrderingComposer,
          $$TransactionsTableTableAnnotationComposer,
          $$TransactionsTableTableCreateCompanionBuilder,
          $$TransactionsTableTableUpdateCompanionBuilder,
          (
            TransactionRow,
            BaseReferences<
              _$AppDatabase,
              $TransactionsTableTable,
              TransactionRow
            >,
          ),
          TransactionRow,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableTableManager(
    _$AppDatabase db,
    $TransactionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<TransactionType> type = const Value.absent(),
                Value<TransactionStatus> status = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> budgetId = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<int> amountScale = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastExecutedAt = const Value.absent(),
                Value<RecurrenceType?> recurrenceType = const Value.absent(),
                Value<int> recurrenceInterval = const Value.absent(),
                Value<DateTime?> recurrenceEndAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion(
                id: id,
                type: type,
                status: status,
                accountId: accountId,
                toAccountId: toAccountId,
                categoryId: categoryId,
                budgetId: budgetId,
                currencyCode: currencyCode,
                amountMinor: amountMinor,
                amountScale: amountScale,
                occurredAt: occurredAt,
                title: title,
                note: note,
                merchant: merchant,
                reference: reference,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastExecutedAt: lastExecutedAt,
                recurrenceType: recurrenceType,
                recurrenceInterval: recurrenceInterval,
                recurrenceEndAt: recurrenceEndAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required TransactionType type,
                required TransactionStatus status,
                required String accountId,
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> budgetId = const Value.absent(),
                required String currencyCode,
                required int amountMinor,
                required int amountScale,
                required DateTime occurredAt,
                Value<String?> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> lastExecutedAt = const Value.absent(),
                Value<RecurrenceType?> recurrenceType = const Value.absent(),
                Value<int> recurrenceInterval = const Value.absent(),
                Value<DateTime?> recurrenceEndAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion.insert(
                id: id,
                type: type,
                status: status,
                accountId: accountId,
                toAccountId: toAccountId,
                categoryId: categoryId,
                budgetId: budgetId,
                currencyCode: currencyCode,
                amountMinor: amountMinor,
                amountScale: amountScale,
                occurredAt: occurredAt,
                title: title,
                note: note,
                merchant: merchant,
                reference: reference,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastExecutedAt: lastExecutedAt,
                recurrenceType: recurrenceType,
                recurrenceInterval: recurrenceInterval,
                recurrenceEndAt: recurrenceEndAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTableTable,
      TransactionRow,
      $$TransactionsTableTableFilterComposer,
      $$TransactionsTableTableOrderingComposer,
      $$TransactionsTableTableAnnotationComposer,
      $$TransactionsTableTableCreateCompanionBuilder,
      $$TransactionsTableTableUpdateCompanionBuilder,
      (
        TransactionRow,
        BaseReferences<_$AppDatabase, $TransactionsTableTable, TransactionRow>,
      ),
      TransactionRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db, _db.accountsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$BudgetsTableTableTableManager get budgetsTable =>
      $$BudgetsTableTableTableManager(_db, _db.budgetsTable);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db, _db.goalsTable);
  $$LoansTableTableTableManager get loansTable =>
      $$LoansTableTableTableManager(_db, _db.loansTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
}
