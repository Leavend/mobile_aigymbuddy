// lib/database/tables/ai_chat_messages.dart

part of '../app_db.dart';

class AiChatMessages extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get userId => text()
      .named('user_id')
      .customConstraint('NOT NULL REFERENCES users(id) ON DELETE CASCADE')();
  TextColumn get role => text()(); // 'user' | 'assistant'
  TextColumn get content => text()();
  TextColumn get suggestionType => text()
      .named('suggestion_type')
      .nullable()
      .map(const EnumTextConverter<SuggestionType>(SuggestionType.values))();
  TextColumn get meta => text().map(const MapJsonConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
