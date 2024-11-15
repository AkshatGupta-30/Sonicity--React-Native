import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sqflite/sqflite.dart';

class QueueDatabase {
  QueueDatabase._();
  static final QueueDatabase _instance = QueueDatabase._();
  factory QueueDatabase() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static const _databaseName = "queue.db";
  static const _databaseVersion = 1;
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}$_databaseName";
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  
  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE $dbQueueTbQueueDetails (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colName TEXT NOT NULL,
          $colDateCreated TEXT NOT NULL,
          $colSongCount INTEGER NOT NULL,
          $colSongIds TEXT,
          $colCurrentQueue INTEGER, 
          $colPlayingQueue INTEGER
        )
      '''
    );
  }

  static const colSongId = 'song_id';
  static const colAlbumId = 'album_id';
  static const colAlbumName = 'album_name';
  static const colArtistIds = 'artist_ids';
  static const colArtistNames = 'artist_names';
  static const colHasLyrics = 'hasLyrics';
  static const colYear = 'year';
  static const colReleaseDate = 'releaseDate';
  static const colDuration = 'duration';
  static const colLanguage = 'language';
  static const colDominantType = 'dominantType';
  static const colImgLow = 'img_low';
  static const colImgMed = 'img_med';
  static const colImgHigh = 'img_high';
  static const colDownload12kbps = 'download_12kbps';
  static const colDownload48kbps = 'download_48kbps';
  static const colDownload96kbps = 'download_96kbps';
  static const colDownload160kbps = 'download_160kbps';
  static const colDownload320kbps = 'download_320kbps';
  Future createQueue(String queueName, {bool isCurrent = false, bool isPlaying = false}) async {
    Database db = await _instance.database;
    await db.execute(// * Create queue
      '''
        CREATE TABLE ${queueTableName(queueName)} (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colSongId TEXT NOT NULL,
          $colName TEXT NOT NULL,
          $colAlbumId TEXT,
          $colAlbumName TEXT,
          $colArtistIds TEXT,
          $colArtistNames TEXT,
          $colHasLyrics INTEGER,
          $colYear TEXT,
          $colReleaseDate TEXT,
          $colDuration TEXT,
          $colLanguage TEXT,
          $colImgLow TEXT,
          $colImgMed TEXT,
          $colImgHigh TEXT,
          $colDownload12kbps TEXT,
          $colDownload48kbps TEXT,
          $colDownload96kbps TEXT,
          $colDownload160kbps TEXT,
          $colDownload320kbps TEXT
        )
      '''
    );
    if(isCurrent) {
      await db.rawUpdate(
        '''
          UPDATE $dbQueueTbQueueDetails 
          SET $colCurrentQueue = 0 
          WHERE $colCurrentQueue = 1
        '''
      );
    }
    if(isPlaying) {
      await db.rawUpdate(
        '''
          UPDATE $dbQueueTbQueueDetails 
          SET $colPlayingQueue = 0 
          WHERE $colPlayingQueue = 1
        '''
      );
    }
    await db.insert(
      dbQueueTbQueueDetails,
      {
        colName : queueTableName(queueName),
        colDateCreated : DateTime.now().toIso8601String(),
        colSongCount : 0,
        colSongIds : "" ,
        colCurrentQueue : (isCurrent) ? 1 : 0,
        colPlayingQueue : (isPlaying) ? 1 : 0
      }
    );
  }

  Future<void> deleteQueue(String queueName) async {
    Database db = await _instance.database;
    int id = int.parse((await db.query(dbQueueTbQueueDetails, columns: [colId], where: "$colName = ?", whereArgs: [queueTableName(queueName)])).first[colId].toString());
    await db.delete(dbQueueTbQueueDetails, where: "$colName = ?", whereArgs: [queueTableName(queueName)]);
    await db.execute('DROP TABLE IF EXISTS ${queueTableName(queueName)}');
    await _reorderIds(id);
    await _updateFirstRowCurrentQueue();
  }

  Future<void> renameQueue(String queueName, String newName) async {
    final db = await _instance.database;
    await db.update(
      dbQueueTbQueueDetails,
      {colName: newName},
      where: '$colName = ?',
      whereArgs: [queueTableName(queueName)]
    );
    await db.execute('ALTER TABLE ${queueTableName(queueName)} RENAME TO $newName');
  }

  Future<void> autoQueue(String queueLabel, List<Song> songs) async {
    queueLabel = queueTableName(queueLabel);
    if(await isQueuePresent(queueLabel)) {
      await deleteQueue(queueLabel);
    }
    await createQueue(queueLabel, isCurrent: true, isPlaying: true);
    for (Song song in songs) {
      await insertSong(queueLabel, song);
    }
  }


  Future<List<Queue>> get queues async {
    Database db = await _instance.database;
    List<Queue> queues = [];
    List<Map<String,dynamic>> queueResult = await db.query(dbQueueTbQueueDetails);
    for (var map in queueResult) {
      queues.add(Queue.fromDb(map));
    }
    return queues;
  }

  Future<void> reorderQueueRows(List<Queue> newOrderedQueue) async {
    final db = await _instance.database;
    await db.transaction((txn) async {
      for (int i = 0; i < newOrderedQueue.length; i++) {
        await txn.rawUpdate(
          '''
            UPDATE $dbQueueTbQueueDetails 
            SET $colId = ? WHERE $colName = ?
          ''',
          [i, queueTableName(newOrderedQueue[i].name)]
        );
      }
    });
  }

  Future<List<Song>> getSongs(String queueName) async {
    Database db = await _instance.database;
    List<Song> songs = [];
    List<Map<String,dynamic>> songsResult = await db.query(queueTableName(queueName));
    for (var map in songsResult) songs.add(Song.fromDb(map));
    return songs;
  }

  Future<void> insertSong(String queueName, Song song) async {
    Database db = await _instance.database;
    queueName = queueTableName(queueName);
    final res = await db.query(queueName, columns: [colSongId], where: "$colSongId = ?", whereArgs: [song.id]);
    if(res.isNotEmpty) return;
    await db.insert(
      queueName,
      song.toDb()
    ).then((_) async => await updateInMain(queueName, song, isInsert: true));
  }

  Future<void> deleteSong(String queueName, Song song) async {
    Database db = await _instance.database;
    queueName = queueTableName(queueName);
    final res = await db.query(queueName, columns: [colSongId], where: "$colSongId = ?", whereArgs: [song.id]);
    if(res.isEmpty) return;
    await db.delete(
      queueName,
      where: "$colSongId = ?",
      whereArgs: [song.id]
    ).then((_) async => await updateInMain(queueName, song, isInsert: false));
  }

  Future<void> updateInMain(String queueName, Song song, {required bool isInsert}) async {
    Database db = await _instance.database;
    List<Map<String, dynamic>> result = await db.query(dbQueueTbQueueDetails,
      columns: [colSongIds],
      where: '$colName = ?',
      whereArgs: [queueName],
    );

    // * Song Ids
    String existingIds = (result.isNotEmpty) ? result.first[colSongIds] : '';
    if (isInsert && !existingIds.contains(song.id)) {
      String updatedIds = existingIds.isEmpty ? song.id.toString() : '$existingIds,${song.id}';
      await db.rawUpdate(
        '''
          UPDATE $dbQueueTbQueueDetails 
          SET $colSongCount = $colSongCount + 1, $colSongIds = ? 
          WHERE $colName = ?
        ''',
        [updatedIds, queueName]
      );
    } else if (!isInsert && existingIds.contains(song.id.toString())) {
      String updatedIds = existingIds.replaceFirst(',${song.id}', '').replaceAll(song.id.toString(), '');
      await db.rawUpdate(
        '''
          UPDATE $dbQueueTbQueueDetails 
          SET $colSongCount = $colSongCount - 1, $colSongIds = ? 
          WHERE $colName = ?
        ''',
        [updatedIds, queueName]
      );
    }
  }

  Future<List<bool>> isSongPresent(Song song) async {
    final db = await _instance.database;
    List<bool> isSongPresent = [];
    List<Map<String,dynamic>> queryRes = await db.query(dbQueueTbQueueDetails, columns: [colSongIds]);
    if(queryRes.isEmpty) return [];
    for(var songId in queryRes) {
      if(songId[colSongIds].toString().contains(song.id)) isSongPresent.add(true);
      else isSongPresent.add(false);
    }
    return isSongPresent;
  }

  Future<bool> isQueuePresent(String queueName) async {
    final db = await _instance.database;
    try {
      await db.query(queueName);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<void> updateSelectedQueue(String queueName) async {
    final db = await _instance.database;
    queueName = queueTableName(queueName);
    await db.rawUpdate(
      '''
        UPDATE $dbQueueTbQueueDetails 
        SET $colCurrentQueue = 0
        WHERE $colCurrentQueue = 1
      ''',
    );
    await db.rawUpdate(
      '''
        UPDATE $dbQueueTbQueueDetails 
        SET $colCurrentQueue = 1
        WHERE $colName = ?
      ''',
      [queueName]
    );
  }

  Future<void> updatePlayingQueue(String queueName, {bool isPlaying = false}) async {
    final db = await _instance.database;
    queueName = queueTableName(queueName);
    await db.rawUpdate(
      '''
        UPDATE $dbQueueTbQueueDetails 
        SET $colPlayingQueue = 0
        WHERE $colPlayingQueue = 1
      ''',
    );
    if(isPlaying) {
      await db.rawUpdate(
        '''
          UPDATE $dbQueueTbQueueDetails 
          SET $colPlayingQueue = 1
          WHERE $colName = ?
        ''',
        [queueName]
      );
    }
  }

  Future<void> reorderSongs(String queueName, List<Song> newOrderedSongs) async {
    final db = await _instance.database;
    queueName = queueTableName(queueName);
    await db.rawDelete('DELETE FROM $queueName');
    for (Song song in newOrderedSongs) insertSong(queueName, song);
  }

  Future<int> get queueCount async {
    Database db = await _instance.database;
    int count = (await db.query(dbQueueTbQueueDetails)).length;
    return count;
  }

  Future<void> _reorderIds(int id) async {
    final db = await _instance.database;
    await db.transaction((txn) async {
      await txn.execute('''
        UPDATE $dbQueueTbQueueDetails
        SET $colId = $colId - 1
        WHERE $colId > $id
      ''');
    });
  }

  Future<void> _updateFirstRowCurrentQueue() async {
    final db = await _instance.database;
    await db.transaction((txn) async {
      await txn.execute('''
        UPDATE $dbQueueTbQueueDetails
        SET $colCurrentQueue = 1
        WHERE $colId = 1
      ''');
    });
  }

  String queueTableName(String queueName) => queueName.replaceAll(' - ', 'qpzm').replaceAll(' ', '_').replaceAll('.', '');

  void dispose() async {
    final db = await _instance.database;
    db.close();
  }
}
