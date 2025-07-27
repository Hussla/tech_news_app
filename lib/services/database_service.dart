/// Database service for the Tech News application.
/// 
/// This service provides local persistence for saved articles using SQLite
/// through the sqflite plugin. It handles all database operations including
/// creating the database, inserting, updating, retrieving, and deleting articles.
/// 
/// The service uses the following key Flutter components and plugins:
/// - [sqflite] - For SQLite database operations on mobile platforms
/// - [path] - For constructing file paths in a platform-independent way
/// - [Database] - The core database class from sqflite
/// 
/// For the web demo, database operations are simulated with in-memory storage
/// since SQLite is not available in web browsers.
/// 
/// References:
/// - sqflite Plugin: https://pub.dev/packages/sqflite
/// - Path Plugin: https://pub.dev/packages/path
/// - SQLite: https://www.sqlite.org/index.html
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tech_news_app/models/article.dart';

/// The database service for the Tech News application.
/// 
/// This singleton class provides local persistence for saved articles using
/// SQLite through the sqflite plugin. It implements the repository pattern
/// to abstract database operations and provide a clean API for the rest
/// of the application.
/// 
/// The service handles all aspects of database management:
/// - Database creation and initialization
/// - Article insertion, update, retrieval, and deletion
/// - Connection management and error handling
/// - Data conversion between Article objects and database records
/// 
/// The class uses a private constructor and static instance to ensure
/// only one database connection exists throughout the application.
/// 
/// For the web demo, database operations are simulated with in-memory
/// storage since SQLite is not available in web browsers.
/// 
/// References:
/// - Singleton Pattern: https://en.wikipedia.org/wiki/Singleton_pattern
/// - Repository Pattern: https://www.martinfowler.com/eaaCatalog/repository.html
/// - sqflite: https://pub.dev/documentation/sqflite/latest/sqflite/sqflite-library.html
class DatabaseService {
  /// The name of the database file
  static const String _databaseName = 'tech_news.db';

  /// The version of the database schema
  static const int _databaseVersion = 2;

  /// The name of the table storing saved articles
  static const String _table = 'saved_articles';

  static const String columnId = '_id';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnContent = 'content';
  static const String columnUrl = 'url';
  static const String columnImageUrl = 'urlToImage';
  static const String columnPublishedAt = 'publishedAt';

  /// Private constructor to prevent direct instantiation.
  /// 
  /// This ensures the class follows the singleton pattern, allowing
  /// only one instance of the database service to exist.
  /// 
  /// References:
  /// - Singleton Pattern: https://en.wikipedia.org/wiki/Singleton_pattern
  DatabaseService._privateConstructor();

  /// The single instance of the DatabaseService.
  /// 
  /// This static instance ensures that only one database connection
  /// is created and shared throughout the application, following
  /// the singleton pattern.
  /// 
  /// References:
  /// - Singleton Pattern: https://en.wikipedia.org/wiki/Singleton_pattern
  static final DatabaseService instance = DatabaseService._privateConstructor();

  /// The cached database instance.
  /// 
  /// This private field stores the database connection once it has been
  /// initialized, ensuring that subsequent calls return the same connection.
  /// 
  /// References:
  /// - Database Connection: https://pub.dev/documentation/sqflite/latest/sqflite/Database-class.html
  static Database? _database;

  /// Gets the database instance, initialising it if necessary.
  /// 
  /// This getter:
  /// 1. Returns the cached database instance if already initialised
  /// 2. Otherwise, initialises the database by:
  ///    * Getting the databases path
  ///    * Constructing the full database path
  ///    * Opening the database with the specified version and creation callback
  /// 3. Caches the database instance for future use
  /// 4. Returns the database instance
  /// 
  /// The method is asynchronous and returns a Future<Database> to handle
  /// the asynchronous nature of database operations.
  /// 
  /// References:
  /// - Future: https://api.flutter.dev/flutter/dart-async/Future-class.html
  /// - Database Initialisation: https://pub.dev/documentation/sqflite/latest/sqflite/openDatabase.html
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialises the database by creating the database file and schema.
  /// 
  /// This private method:
  /// 1. Gets the path to the databases directory using getDatabasesPath()
  /// 2. Constructs the full path to the database file using the path plugin
  /// 3. Opens the database with:
  ///    * The constructed path
  ///    * The current database version
  ///    * A callback to create the table schema when the database is first created
  /// 
  /// The method is asynchronous and returns a Future<Database> to handle
  /// the asynchronous nature of file system operations.
  /// 
  /// References:
  /// - Database Path: https://pub.dev/documentation/sqflite/latest/sqflite/getDatabasesPath.html
  /// - Path Joining: https://pub.dev/documentation/path/latest/path/join.html
  /// - Database Opening: https://pub.dev/documentation/sqflite/latest/sqflite/openDatabase.html
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Handles database schema upgrades when the version changes.
  /// 
  /// This private method is called by the openDatabase function when the
  /// database version is increased. It ensures that existing databases
  /// are properly upgraded to the new schema.
  /// 
  /// For version 2, it adds the urlToImage column if it doesn't exist.
  /// 
  /// The method is asynchronous and returns a Future to handle the
  /// asynchronous nature of database operations.
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2 && newVersion >= 2) {
      // Add urlToImage column for version 2
      await db.execute('ALTER TABLE $_table ADD COLUMN $columnImageUrl TEXT');
      // Add publishedAt column if it doesn't exist
      await db.execute('ALTER TABLE $_table ADD COLUMN $columnPublishedAt TEXT');
    }
  }

  /// Creates the database table schema when the database is first created.
  /// 
  /// This private method is called by the openDatabase function when the
  /// database is first created. It executes a SQL statement to create
  /// the saved_articles table with the following columns:
  /// - _id: Primary key with auto-increment
  /// - title: Article title (required)
  /// - description: Article description (optional)
  /// - content: Article content (optional)
  /// - url: Article URL (required, unique)
  /// - image_url: URL of the article's featured image (optional)
  /// - published_at: Publication date/time (required)
  /// 
  /// The method is asynchronous and returns a Future to handle the
  /// asynchronous nature of database operations.
  /// 
  /// References:
  /// - SQL CREATE TABLE: https://www.sqlite.org/lang_createtable.html
  /// - Database Schema: https://pub.dev/documentation/sqflite/latest/sqflite/Database/createTable.html
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $_table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT,
            $columnContent TEXT,
            $columnUrl TEXT NOT NULL UNIQUE,
            $columnImageUrl TEXT,
            $columnPublishedAt TEXT NOT NULL
          )
          ''');
  }

  /// Inserts a new article into the database.
  /// 
  /// This method:
  /// 1. Gets the database instance
  /// 2. Attempts to insert the article using its JSON representation
  /// 3. If the article already exists (DatabaseException):
  ///    * Updates the existing article instead
  /// 4. Returns the ID of the inserted/updated article
  /// 
  /// The method handles the case where an article with the same URL
  /// already exists by updating it instead of inserting a duplicate.
  /// 
  /// Returns a Future<int> containing the row ID of the inserted article.
  /// 
  /// References:
  /// - Database Insert: https://pub.dev/documentation/sqflite/latest/sqflite/Database/insert.html
  /// - Error Handling: https://dart.dev/guides/language/effective-dart/usage#do-use-on-clauses-in-catch-statements-for-flow-control
  Future<int> insert(Article article) async {
    final db = await database;
    try {
      return await db.insert(_table, article.toJson());
    } on DatabaseException {
      // Article already exists, update it instead
      return await update(article);
    }
  }

  /// Updates an existing article in the database.
  /// 
  /// This method:
  /// 1. Gets the database instance
  /// 2. Updates the article record where the URL matches the article's URL
  /// 3. Uses the article's JSON representation for the update
  /// 4. Returns the number of rows affected by the update
  /// 
  /// The method uses a WHERE clause to ensure only the article with
  /// the matching URL is updated, preventing accidental updates to
  /// other articles.
  /// 
  /// Returns a Future<int> containing the number of rows updated.
  /// 
  /// References:
  /// - Database Update: https://pub.dev/documentation/sqflite/latest/sqflite/Database/update.html
  /// - SQL WHERE Clause: https://www.sqlite.org/lang_update.html
  Future<int> update(Article article) async {
    final db = await database;
    return await db.update(
      _table,
      article.toJson(),
      where: '$columnUrl = ?',
      whereArgs: [article.url],
    );
  }

  /// Retrieves all saved articles from the database.
  /// 
  /// This method:
  /// 1. Gets the database instance
  /// 2. Queries all records from the saved_articles table
  /// 3. Converts each database record to an Article object
  /// 4. Returns a list of Article objects
  /// 
  /// The method uses List.generate to efficiently create the list of
  /// Article objects from the database query results.
  /// 
  /// Each database record is converted to an Article object by:
  /// - Using the title, description, content, URL, and image URL directly
  /// - Parsing the published_at string into a DateTime object
  /// 
  /// Returns a Future<List<Article>> containing all saved articles.
  /// 
  /// References:
  /// - Database Query: https://pub.dev/documentation/sqflite/latest/sqflite/Database/query.html
  /// - List Generation: https://api.flutter.dev/flutter/dart-core/List/List.generate.html
  /// - DateTime Parsing: https://api.flutter.dev/flutter/dart-core/DateTime/parse.html
  Future<List<Article>> getSavedArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_table);
    return List.generate(maps.length, (i) {
      return Article(
        title: maps[i][columnTitle],
        description: maps[i][columnDescription],
        content: maps[i][columnContent],
        url: maps[i][columnUrl],
        imageUrl: maps[i][columnImageUrl],
        publishedAt: DateTime.parse(maps[i][columnPublishedAt]),
      );
    });
  }

  /// Deletes a saved article from the database.
  /// 
  /// This method:
  /// 1. Gets the database instance
  /// 2. Deletes the article record where the URL matches the provided URL
  /// 3. Returns the number of rows deleted
  /// 
  /// The method uses a WHERE clause to ensure only the article with
  /// the matching URL is deleted, preventing accidental deletion of
  /// other articles.
  /// 
  /// Returns a Future<int> containing the number of rows deleted.
  /// 
  /// References:
  /// - Database Delete: https://pub.dev/documentation/sqflite/latest/sqflite/Database/delete.html
  /// - SQL WHERE Clause: https://www.sqlite.org/lang_delete.html
  Future<int> delete(String url) async {
    final db = await database;
    return await db.delete(
      _table,
      where: '$columnUrl = ?',
      whereArgs: [url],
    );
  }

  /// Closes the database connection.
  /// 
  /// This method:
  /// 1. Gets the database instance
  /// 2. Closes the database connection
  /// 
  /// The method should be called when the application is shutting down
  /// or when the database is no longer needed to free up resources.
  /// 
  /// Returns a Future<void> to handle the asynchronous nature of
  /// the database operation.
  /// 
  /// References:
  /// - Database Close: https://pub.dev/documentation/sqflite/latest/sqflite/Database/close.html
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
