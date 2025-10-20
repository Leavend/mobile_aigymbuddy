// lib/database/type_converters.dart

import 'dart:convert';

import 'package:drift/drift.dart';

import '../common/domain/enums.dart';

// ===== TYPE CONVERTERS =====

class EnumTextConverter<T extends Enum> extends TypeConverter<T, String> {
  final List<T> values;
  const EnumTextConverter(this.values);

  @override
  T fromSql(String fromDb) {
    return values.byName(fromDb);
  }

  @override
  String toSql(T value) {
    return value.name;
  }
}

class MapJsonConverter extends TypeConverter<Map<String, dynamic>, String> {
  const MapJsonConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    return jsonDecode(fromDb) as Map<String, dynamic>;
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return jsonEncode(value);
  }
}