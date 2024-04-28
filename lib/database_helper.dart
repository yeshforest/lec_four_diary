import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/diary_model.dart';

class DatabaseHelper {
  static late Database database;

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // 데이터베이스 초기화 및 열기
  Future<void> initDatabase() async {
    //데이터베이스 경로 가져오기
    String path = join(await getDatabasesPath(), 'pic_diary.db');
    // 데이터베이스 열기 또는 생성
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE IF NOT EXISTS tb_diary(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        imageTopLeft BLOB,
        imageTopRight BLOB,
        imageBtmLeft BLOB,
        imageBtmRight BLOB,
        date INTEGER
          )
        ''');
      },
    );
  }

  // 데이터 저장
  Future<int> insertInfo(DiaryModel diary) async {
    return await database.insert('tb_diary', diary.toMap());
  }

  // 데이터 조회
  Future<List<DiaryModel>> getAllInfo() async {
    final List<Map<String, dynamic>> result =
        await database.query('tb_diary', orderBy: 'date DESC');
    return List.generate(result.length, (index) {
      return DiaryModel.formMap(result[index]);
    });
  }

  // 업데이트
  Future<int> updateInfo(DiaryModel diary) async {
    return await database.update(
      'tb_diary',
      diary.toMap(),
      where: 'id =?',
      whereArgs: [diary.id],
    );
  }

  // 데이터 삭제
  Future<int?> deleteInfo(int id) async{
    return await database.delete('tb_diary',where: 'id=?',whereArgs: [id],);
  }

  // 데이터베이스 닫기
  Future<void> closeDatabase() async{
    await database.close();
  }
}
