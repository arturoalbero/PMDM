

# 2. Persistence

## What is persistence?

The set of data (variables, providers, etc.) that our application works with and that makes up its state disappears when the application process ends. **Persistence** consists of retaining this data across different executions, so that it survives when the application is closed. This information can be stored either on the device or on a remote server.

However, not all data has the same value or carries the same risks. Before choosing a strategy or library, we should consider questions such as:

- Is the data simple, or is it structured and relational?
- Should it be readable only on the same device, or across multiple devices?
- Is the data sensitive if someone gains access to the local files?
- Does the data need to be queried reactively, sorted, or filtered?

## Types of persistent data

There are several persistence solutions, depending on the nature of the data and its requirements or purpose. For example:

- Settings such as **the default theme, language, filters**, and, in general, any **simple value** that is not secret can be stored in the application's **preferences**, using the **`shared_preferences`** library.
- If we have **simple but sensitive data**, such as **tokens** or **authentication sessions**, we need a mechanism that stores this data locally but securely. In this case, we can use the **`flutter_secure_storage`** library.

  **Remembering an email address is not authentication**

  Saving the name or email address entered in a form allows us to pre-fill it again or simulate a session in a local example. It does not prove the user's identity. A real application must not store the password or consider someone authenticated simply because their email address was saved on the device.
- When we need to store **more complex data**, we must use **databases**. The Android and iOS mobile operating systems include a SQLite database by default, so we only need a library to access it or, better still, a complete ORM (Object-Relational Mapping tool), such as Floor or **Drift**. The latter is what we will cover in this unit.
- On the other hand, if the data is more **unstructured** but still needs to be stored locally, we can use libraries such as **Hive** or **Isar**, which provide **NoSQL** databases.
- Finally, if we want the data to be available **in the cloud** and accessible from different devices, we will need access to services such as **Supabase (SQL)** or **Firebase (NoSQL)**.

## From an in-memory architecture to a persistent architecture

Imagine that we are developing an application that manages certain information in memory, such as a project and its associated tasks, a shopping list containing different products, or a notes app with several notes.

At some point, the user will want to *save* this data and retrieve it later. In the example of a project task-management app, the execution flow would look something like this:

**Presentation / UI layer**
- View
- Save button
- `ProjectesNotifier` (ViewModel)
- Reactive reading provider
- Project view

**Domain layer**
- `GuardaProjecteUseCase`
- `ProjectesRepository` (contract / abstract class)

**Data access / infrastructure layer**
- `ProjectesLocalRepository` (implementation)
- `ProjectesLocalService`
- Drift / SQLite

With the layered architecture we use, the presentation/UI layer knows nothing about data persistence. It only receives actions through the ViewModel and passes them to the use cases, while listening to providers to update reactively.

Another common pattern introduced by this structure is the repository. As we can see, it now sits between the domain layer and the infrastructure layer. This separation has a clear purpose: to maintain the principle of separation of responsibilities.

- On the one hand, in the domain layer, it defines **what the repository can do** (which data it stores, retrieves, and so on).
- On the other hand, in the implementation layer, it specifies **how this is done**. This is where database access or, more generally, the chosen persistence mechanism comes into play.

As we can see, this is implemented by having the domain layer use an abstraction of the repository, while the data access layer implements that abstraction and injects it at runtime.

This means that the domain continues to work in terms of `Projecte` and `Tasca`, while the infrastructure converts these entities into database tables.

## Replacing the data source

Imagine that, after completing the application, we want to change the persistence layer and store the data in the cloud instead of keeping it on the device.

At the data access level, this would mean replacing the database access component (Drift, for example) with a different mechanism, such as Supabase.

In this case, neither the user interface nor the use cases should need to be modified, since they use the repository contract, which could look something like this:

```dart
abstract interface class ProjectesRepository {
  Future<void> guarda(Projecte projecte);
  Stream<List<Projecte>> observaProjectes();
}
```

**`abstract interface class` in Dart 3**

In Dart, classes already define an implicit interface. With Dart 3, we can be more explicit and write `abstract interface class` to indicate that the class cannot be instantiated and represents only a contract that other classes will implement using `implements`.

We can now provide several implementations of this contract, for example:

- `ProjectesLocalRepository` → `ProjectesLocalService` → Drift / SQLite
- `ProjectesRemoteRepository` → `ProjectesRemoteService` → Supabase

The important point is that the domain continues to depend on `ProjectesRepository`, not directly on `ProjectesLocalRepository` or Supabase.

In practice, however, it is not always just a matter of replacing one class. The cloud introduces authentication, per-user permissions, connectivity, remote errors and, if we want to work offline, synchronization.

**Applying this to the course project**

In `Healthys`, this same pattern allows us to turn the current shopping cart into a saved order and retrieve the order history.

## How to approach the rest of the unit

After this introduction, we should have a clearer understanding of the different persistence requirements.

Following this approach, in the next sections we will:

1. Differentiate between preferences and secrets.
2. Model persistent related data with Drift.
3. Connect the database to repositories and Riverpod.
4. Prepare a remote alternative using Supabase and per-user security.
5. Apply these concepts to the evolution of `Healthys` in the assignment.

# 3. Preferences and secure data

## Key-value persistence

When we only want to retain a simple setting, using a relational database would be excessive. The official `shared_preferences` package allows us to store key-value pairs with the following types:

- `String`
- `int`
- `double`
- `bool`
- `List<String>`

It is a good choice for dark mode, language, whether an introductory screen has been viewed, or the last email address/username used in an authentication form. However, this mechanism is not suitable for related collections or sensitive data.

### Do not use preferences for secrets

Preferences do not provide encrypted storage for passwords, access tokens or refresh tokens. In addition, the package documentation states that it should not be used for critical data.

## Installation and current API

Add the package:

```bash
flutter pub add shared_preferences
```

The package currently offers `SharedPreferencesAsync` and `SharedPreferencesWithCache`. The classic `SharedPreferences.getInstance()` API still exists, but it is considered an outdated API for new code.

We will use `SharedPreferencesAsync`: each read accesses the underlying storage and avoids cache-related problems when there is more than one isolate or Flutter engine.

### Isolates

An isolate is a Dart execution unit, somewhere between a process and a thread, that allows us to execute code in parallel without directly sharing variables with the rest of the application. When two isolates need to communicate, they do so by sending messages to each other.

Therefore, an isolate is not exactly a thread, since each isolate has its own memory space (there is no shared memory). However, it is not a process either, since it is not an independent execution.

### What does Flutter engine mean?

It is the native component that runs a Flutter instance and is responsible, among other things, for rendering the user interface. A Flutter engine executes Dart code in isolates, and in advanced scenarios an application may have more than one engine or more than one isolate.

The problem with preferences arises when different parts of the app maintain cached copies in memory: one of them might read an outdated value. `SharedPreferencesAsync` avoids this problem because it accesses the actual storage on every read.

## Usage example

The following code snippet shows how to use this API:

```dart
// Import the package
import 'package:shared_preferences/shared_preferences.dart';

// Create a SharedPreferencesAsync instance
final prefs = SharedPreferencesAsync();

// Store a String variable, for example, the language
await prefs.setString('idioma', 'ca');

// Retrieve a String value from preferences (the language as well)
final idioma = await prefs.getString('idioma') ?? 'ca';

// Store a Boolean variable (whether dark mode is enabled)
await prefs.setBool('mode_fosc', true);

// Retrieve the Boolean variable
final modeFosc = await prefs.getBool('mode_fosc') ?? false;

// Remove a SharedPreferences preference
await prefs.remove('idioma');
```

Notice that, in every operation we perform, whether writing to or reading from preferences, we use `await` to wait for the asynchronous operations to complete.

## A preferences service

Although we could import the library from anywhere in the code, architecturally it would not be a good idea to have preference keys scattered throughout the widgets.

Ideally, the data layer should encapsulate preferences in a service:

`lib/data/services/preferences_service.dart`

```dart
import 'package:shared_preferences/shared_preferences.dart';

// Create the service class
class PreferencesService {

  // Constructor that receives a SharedPreferencesAsync instance
  // (Dependency Injection pattern)
  PreferencesService(this._prefs);

  // Class properties
  // First, declare each preference as a property
  static const _keyLanguage = 'language';
  static const _keyDarkMode = 'dark_mode';
  final SharedPreferencesAsync _prefs;

  // Method to retrieve the language from preferences
  Future<String> readLanguage() async {
    return await _prefs.getString(_keyLanguage) ?? 'ca';
  }

  // Method to save the language
  Future<void> saveLanguage(String language) {
    return _prefs.setString(_keyLanguage, language);
  }

  // Method to read the theme
  Future<bool> readDarkMode() async {
    return await _prefs.getBool(_keyDarkMode) ?? false;
  }

  // Method to save the theme
  Future<void> saveDarkMode(bool enabled) {
    return _prefs.setBool(_keyDarkMode, enabled);
  }
}
```

This service hides the details of `shared_preferences`: the keys, default values and calls to `getString`, `setBool`, etc. From this point, we have two architectural options:

- If the application is very simple, we can inject `PreferencesService` directly through a provider and use it directly from the UI layer.
- If we want to maintain a complete layered structure, we can add a repository that depends on the service.

### When should we add a repository, and when should we not?

The repository should not simply repeat what the service does without adding anything.

Introducing a repository makes sense when we want the rest of the application to work with operations that are closer to the application's functionality, or when we want to prepare for changing the way data is stored in the future.

If we decide to include a repository, it would look like this:

```dart
// Create the class
class SettingsRepository {
  // Constructor with dependency injection
  SettingsRepository(this._service);

  // Declare the service
  final PreferencesService _service;

  // Methods for managing the language
  Future<String> getLanguage() => _service.readLanguage();

  Future<void> changeLanguage(String language) {
    return _service.saveLanguage(language);
  }

  // Methods for managing dark mode
  Future<bool> isDarkMode() => _service.readDarkMode();

  Future<void> changeDarkMode(bool isDark) {
    return _service.saveDarkMode(isDark);
  }
}
```

In this example, `SettingsRepository` is still very simple, but it gives us a single point from which the presentation layer can request the configuration. A Riverpod provider can then create this repository, retrieve the initial configuration and update it whenever the interface changes a setting.

## flutter_secure_storage

As mentioned earlier, `SharedPreferences` is useful when the data we want to store is simple.

However, when we want to store secret or confidential data, such as a token or a key, we will use `flutter_secure_storage`.

This package allows us to write key-value pairs to secure platform storage mechanisms, such as Keychain on Apple systems and system-protected encrypted storage on Android.

To add the library as a dependency to our project, run:

```bash
flutter pub add flutter_secure_storage
```

This library also provides an asynchronous API for secure storage, which we can use as follows:

```dart
// Import the package
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Service class for storing a token
class TokenSecureService {
  // Constructor with dependency injection
  TokenSecureService(this._storage);

  // Define the class properties (keys and Storage)
  static const _keyRefreshToken = 'refresh_token';
  final FlutterSecureStorage _storage;

  // Method to save the token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  // Method to read the token
  Future<String?> readRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  // Method to delete the token
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
  }
}
```

In Dart, we could also have returned the `Future` generated by `write`, `read` or `delete` directly, using `return _storage.read(...)`. In this example, we use `async` and `await` to emphasize that these operations are asynchronous and that, when we call them from a use case, repository or provider, we will need to wait for their result.

### Platform configuration

It is important to review the package's platform-specific configuration requirements:

- On Android, backup settings must be handled to avoid problems with restored encrypted keys.
- On Apple platforms, Keychain Sharing may need to be configured.
- The web implementation also has additional security considerations.

### SharedPreferences or SecureStorage?

It depends on the situation. Let's look at some examples of which option to use depending on what we want to store:

| Situation | Option |
|---|---|
| I want to remember the last email address entered | `SharedPreferencesAsync` |
| I want to retain a token issued by a backend | `flutter_secure_storage` |
| I want to save the password for automatic login | Do not do this |

### Do not store passwords

In the last case in the table above, remember that we must not store passwords in the application.

But aren't there many applications, especially web applications, that do store them?

Here we need to distinguish between the application itself and the browser or password manager, particularly in web environments. When the browser detects a form field containing a username and/or password that it has saved, it automatically fills in those fields.

The other option, as mentioned in the table, is not to store the password but to store a token that preserves the session.

### Storing keys in Healthys

In our example project, we will store the email address/username as a preference, without confusing it with an identity system.

# 4. Local database with Drift

## When a single value is no longer enough

An application may need to retain collections of data: projects with tasks, recipes with ingredients, lists with items, or invoices with line items. This data has its own structure, relationships and queries; storing it as key-value pairs is no longer convenient.

Drift is a reactive, typed library built on SQLite. It allows us to define tables directly in Dart, generate access code for them, and observe queries that update whenever the data changes.

The general process we will follow with Drift is:

1. Install the necessary dependencies.
2. Define the tables that will make up the database schema.
3. Define the database class, specifying which tables it contains and how the SQLite file is opened.
4. Generate the code automatically with `build_runner`, so that Drift creates the typed classes.
5. Create queries and read/write operations, preferably encapsulated in services or repositories.
6. Connect persistence to the UI through the providers and use cases in the application's architecture.

As an example, let's look at an application that models personal projects containing tasks:

**PROJECTS**

| Field | Type |
|---|---|
| `id` | `int` |
| `name` | `text` |
| `created_at` | `datetime` |

**TASKS**

| Field | Type |
|---|---|
| `id` | `int` |
| `project_id` | `int` |
| `title` | `text` |
| `completed` | `bool` |

Here we can see that a project consists of several tasks, and each task belongs to a single project.

## Repository containing the application

You can find this example application in the following GitHub repository.

## Installation

Following Drift's official configuration for Flutter, we need to install the following:

```bash
dart pub add drift drift_flutter path_provider dev:drift_dev dev:build_runner
```

This command adds both application dependencies and development dependencies:

- `drift`: the main library. It provides the classes for defining tables, queries, companions, migrations, transactions, etc.
- `drift_flutter`: adapts Drift to Flutter and makes it easier to open an SQLite database on native platforms. With `driftDatabase(name: ...)`, Drift can create the database file for us.
- `path_provider`: allows us to obtain application-specific paths in the file system, such as the app's documents or support directory. Although `drift_flutter` uses it indirectly in simple examples, it is the usual library when we need to decide where to store local files.
- `drift_dev`: generates Drift-specific code from the tables and the `@DriftDatabase` class.
- `build_runner`: runs Dart code generators. In this case, we will use it so that `drift_dev` creates the `.g.dart` file containing the typed classes.

On native platforms, the database will be stored as a local application file, usually with the `.sqlite` extension.

## Defining the tables

The first thing we need to define is the database tables. In Drift, we do this using Dart classes that extend `Table`:

`lib/data/database/tables.dart`

```dart
import 'package:drift/drift.dart';

// Define the Projects table.
// DataClassName specifies the name of the Dart class that Drift
// will generate to represent a row in this table.
@DataClassName('ProjecteRow')
class Projectes extends Table {

  // id: auto-incrementing integer column
  IntColumn get id => integer().autoIncrement()();

  // name: text column containing between 1 and 100 characters
  TextColumn get nom => text().withLength(min: 1, max: 100)();

  // createdAt: column containing the creation date and time
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Define the Tasks table and the generated class for each row.
@DataClassName('TascaRow')
class Tasques extends Table {

  // id: auto-incrementing numeric column
  IntColumn get id => integer().autoIncrement()();

  // projecteId: integer that acts as a foreign key to the project
  IntColumn get projecteId =>
      integer().references(Projectes, #id, onDelete: KeyAction.cascade)();

  // title: text column
  TextColumn get titol => text()();

  // completed: Boolean column
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}
```

### Distinguishing between tables and entities

The `Projectes` and `Tasques` classes describe SQLite tables. They are not the application's domain entities, but rather descriptors of what the database will look like.

The `@DataClassName('ProjecteRow')` and `@DataClassName('TascaRow')` annotations specify the names of the Dart classes that Drift will generate to represent a row in the table (a project or a task).

Here, we have used the `Row` suffix to distinguish database rows (`ProjecteRow`, `TascaRow`) from domain entities (`Projecte`, `Tasca`) and avoid confusion.

The repository will be responsible for converting between these two representations: the rows generated by Drift and the domain entities.

## The database

Once we have defined the tables, we need to define the database. This class is the entry point to Drift: it specifies which tables are part of the schema, how the database is opened and which version it has.

`lib/data/database/app_database.dart`

```dart
// Drift's main library: annotations, migrations, data types, etc.
import 'package:drift/drift.dart';

// Drift integration with Flutter and SQLite on native platforms.
import 'package:drift_flutter/drift_flutter.dart';

// File where we defined the Projects and Tasks tables.
import 'tables.dart';

// This file will be generated automatically by Drift using build_runner.
// It will contain the _$AppDatabase class and other helper classes.
part 'app_database.g.dart';

// Tell Drift which tables are part of this database.
@DriftDatabase(tables: [Projectes, Tasques])

// AppDatabase is the class we will use in our application.
// It inherits from _$AppDatabase, which does not exist until we generate the code.
class AppDatabase extends _$AppDatabase {

  // Open or create the SQLite database with the specified name.
  // On native platforms, driftDatabase will create a local file for the app.
  AppDatabase() : super(driftDatabase(name: 'example_app'));

  // Database schema version.
  // When we change tables or columns, we will increment this number.
  @override
  int get schemaVersion => 1;

  // Database creation and update strategy.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        // When the database is created for the first time,
        // Drift will create all the tables declared in @DriftDatabase.
        onCreate: (m) => m.createAll(),
      );
}
```

Notice that `_$AppDatabase` and `app_database.g.dart` will appear as errors until we generate the code. Once the database has been declared, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This will create `app_database.g.dart`. This file must not be edited manually, since it is regenerated whenever tables or queries change.

## Inserting related data

If we want to save a project and all its associated tasks in a single operation, while guaranteeing atomicity and the all-or-nothing principle, we will need to use transactions.

### We are still in the data layer

The examples in this section show code that is very close to Drift: `ProjecteRow`, `TascaRow`, `ProjectesCompanion`, `TasquesCompanion`, `select`, `into`, `watch`, etc.

In a layered application, the repository will be responsible for converting between these persistence classes and the domain entities (`Projecte`, `Tasca`). Here, we show Drift code to understand how the database works internally.

Let's see how we would perform this operation:

`lib/data/services/projectes_local_service.dart`

```dart
// Method in the local service that encapsulates access to Drift.
// Returns the ID of the inserted project.
Future<int> insertProjecte(Projecte projecte) {
  // The project received as an argument
  // is a domain entity.

  // The transaction makes all operations execute as a single unit.
  // If any insertion fails, Drift rolls back the previous operations.
  return transaction(() async {

    // First, insert the main record into the Projects table.
    // into(projectes) indicates which table we want to insert into.
    final projecteId = await into(projectes).insert(
      // ProjectesCompanion.insert is the class generated by Drift
      // to prepare the data required for an insertion.
      ProjectesCompanion.insert(nom: projecte.nom),
    );

    // Once we have the project ID, we can insert the tasks.
    for (final tasca in projecte.tasques) {
      await into(tasques).insert(
        TasquesCompanion.insert(
          // Foreign key linking each task to the inserted project.
          projecteId: projecteId,
          titol: tasca.titol,

          // completada has a default value, but here we pass it explicitly.
          // Value(...) tells Drift that we want to provide this value.
          completada: Value(tasca.completada),
        ),
      );
    }

    // Return the ID in case the upper layer needs it.
    return projecteId;
  });
}
```

In a larger application, these operations can be placed in a `@DriftAccessor` (DAO) or in a local service. The repository will use them and map the data to the domain entities.

## Reactive queries

Drift can observe a query using `watch()`. Every change that affects the query emits a new list:

`lib/data/services/projectes_local_service.dart`

```dart
// Returns a Stream containing all projects.
// Whenever the table changes, Drift emits a new list.
Stream<List<ProjecteRow>> watchProjectes() {
  return (select(projectes)
        // Sort projects with the most recent ones first.
        ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
      // watch() turns the query into a reactive one.
      .watch();
}
```

To display the tasks belonging to a project:

`lib/data/services/projectes_local_service.dart`

```dart
// Returns the tasks associated with a specific project.
Stream<List<TascaRow>> watchTasques(int projecteId) {
  return (select(tasques)
        // Filter by the foreign key projecteId.
        ..where((row) => row.projecteId.equals(projecteId)))
      .watch();
}
```

In the next section, we will place these queries behind a repository and connect them to Riverpod.

## Migrations

When a new version of the app modifies the tables, we must increment `schemaVersion` and tell Drift how to update the existing tables.

Suppose that, in a new version, we have added an integer priority column to the `Tasques` class:

`lib/data/database/tables.dart`

```dart
// New optional column in the Tasks table.
IntColumn get prioritat => integer().nullable()();
```

We need to tell Drift something like: "When migrating from version 1 to version 2, add a new integer column for the priority":

`lib/data/database/app_database.dart`

```dart
// When modifying the schema, increment the version.
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration => MigrationStrategy(
      // For new installations, create all the tables
      // directly with the current schema.
      onCreate: (m) => m.createAll(),

      // For existing databases, specify how to move
      // from the previous version to the new one.
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // If the user had version 1, add the new column.
          await m.addColumn(tasques, tasques.prioritat);
        }
      },
    );
```

In production, we should also test migrations with existing data. In an initial exercise, we can work with version 1.

### Applying this to Healthys

An order history has the same relationship as the example: an order is the main item, and the purchased line items are the dependent items. We will need to adapt the names and fields, but not the principle of related tables, transactions and reactive queries.

# 5. Drift, repositories and Riverpod

## Keeping responsibilities separate

Drift is a data-layer technology. A `ConsumerWidget` should not call `insert()` or import `app_database.dart`: the user interface must continue to work even if one day we replace the local database with a remote service, for example.

For the projects and tasks example, the organization could be:

```text
lib/
  domain/
    entities/
      projecte.dart
      tasca.dart
    repositories/
      projectes_repository.dart
    usecases/projectes/
      guarda_projecte_usecase.dart
  data/
    database/
      app_database.dart
      tables.dart
    services/
      projectes_local_service.dart
    repositories/
      drift_projectes_repository.dart
  ui/
    providers/
      database_providers.dart
      projectes_provider.dart
```

## Entities and repository contract

The domain layer models the problem without importing Drift:

`lib/domain/entities/tasca.dart`

```dart
// Domain entity. It does not depend on Drift or SQLite.
class Tasca {
  const Tasca({required this.titol, this.completada = false});

  final String titol;
  final bool completada;
}
```

`lib/domain/entities/projecte.dart`

```dart
// Main domain entity.
// A project contains a list of tasks.
class Projecte {
  const Projecte({
    this.id,
    required this.nom,
    required this.createdAt,
    required this.tasques,
  });

  final int? id;
  final String nom;
  final DateTime createdAt;
  final List<Tasca> tasques;
}
```

The contract specifies the operations the application needs, without mentioning SQLite:

`lib/domain/repositories/projectes_repository.dart`

```dart
// Contract required by the domain.
// Concrete implementations will live in the data layer.
abstract interface class ProjectesRepository {
  Future<void> guarda(Projecte projecte);
  Stream<List<Projecte>> observaProjectes();
  Future<Projecte?> getById(int id);
}
```

### Reminder: what is a Stream?

Remember that a `Future` represents a future value that will arrive once: for example, the result of a one-off query.

A `Stream`, on the other hand, represents a sequence of values over time. In Drift, a query observed with `watch()` emits an initial list of results and emits another list whenever the data changes. That is why the contract can return `Stream<List<Projecte>>` when we want the user interface to stay up to date.

## Drift service and repository

The `ProjectesLocalService` service contains the Drift queries to the database.

Therefore, what we need to do now is implement the previously defined repository (`ProjectesRepository`) through `DriftProjectesRepository`. The domain layer uses the repository, and this implementation will use the service and convert the table rows (`ProjecteRow`) into entities (`Projecte`).

Let's see what it looks like:

`lib/data/repositories/drift_projectes_repository.dart`

```dart
// Implementation of the ProjectesRepository contract using Drift.
class DriftProjectesRepository implements ProjectesRepository {
  DriftProjectesRepository(this._service);

  // Local service containing the Drift-specific code.
  final ProjectesLocalService _service;

  @override
  Future<void> guarda(Projecte projecte) async {
    // Delegate the insertion to the local service.
    await _service.insertProjecte(projecte);
  }

  @override
  Stream<List<Projecte>> observaProjectes() {
    // The service returns persistence rows.
    // The repository transforms them into domain entities.
    return _service.watchProjectesWithTasks().map(
      // _toDomain is a private repository method that converts
      // Drift data into a Projecte entity.
      (rows) => rows.map(_toDomain).toList(),
    );
  }

  // Mapping method between the data layer and the domain layer.
  // In a real application, ProjecteWithTasks could be a helper class
  // returned by the service, containing a ProjecteRow and its TascaRow items.
  Projecte _toDomain(ProjecteWithTasks row) {
    return Projecte(
      id: row.projecte.id,
      nom: row.projecte.nom,
      createdAt: row.projecte.createdAt,
      tasques: row.tasques.map((tascaRow) {
        return Tasca(
          titol: tascaRow.titol,
          completada: tascaRow.completada,
        );
      }).toList(),
    );
  }
}
```

### Mapping related data

To reconstruct a `Projecte`, the service must also retrieve its tasks, using a join or grouped queries. In the example, we use a helper class called `ProjecteWithTasks` to represent this combined result.

In larger projects, we can extract these mappings into specific files, such as `projecte_mapper.dart`, as is done in other architectures such as Clean Architecture. In this section, we leave the mapping inside the repository to avoid adding more components than necessary.

## A write use case

Use cases can validate domain rules before delegating to the repository.

As an example, let's look at a use case for saving a project:

`lib/domain/usecases/projectes/guarda_projecte_usecase.dart`

```dart
// Use case for saving a project.
class GuardaProjecteUseCase {
  GuardaProjecteUseCase(this._repository);

  // The use case depends on the contract, not on a specific implementation.
  final ProjectesRepository _repository;

  Future<void> execute(Projecte projecte) async {
    // Example of validation belonging to the domain or application.
    if (projecte.nom.trim().isEmpty) {
      throw ArgumentError('The name cannot be empty');
    }

    // If validation succeeds, delegate to the repository.
    await _repository.guarda(projecte);
  }
}
```

An important rule is that the UI should only confirm the action or clear the temporary state once the operation has completed successfully. If the write fails, the content the user was editing should not be lost.

## Dependency injection providers

We now have the main components: the database, the local service, the repository and the use case. We still need to decide who creates each object and how it becomes available to the rest of the application.

With Riverpod, we can create providers for these dependencies. This avoids having to construct them manually inside widgets and gives us a single place to decide which implementation to use.

For the database, we want to create a single `AppDatabase` instance and reuse it in the services and repositories. In addition, when Riverpod stops using this provider, we will close the database with `db.close()` to release resources.

Let's see how to do this:

`lib/ui/providers/projectes_provider.dart`

```dart
// Database provider.
// A shared AppDatabase instance is created.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  // When Riverpod disposes of this provider, close the connection.
  ref.onDispose(db.close);

  return db;
});

// Repository provider.
// Here we decide which concrete implementation to use.
final projectesRepositoryProvider = Provider<ProjectesRepository>((ref) {
  // Get the database created by the previous provider.
  final db = ref.watch(appDatabaseProvider);

  // Build the local service using the database.
  final service = ProjectesLocalService(db);

  // Return the concrete implementation of the ProjectesRepository contract.
  return DriftProjectesRepository(service);
});

// Use case provider.
// The UI can read it without manually constructing dependencies.
final guardaProjecteUseCaseProvider = Provider<GuardaProjecteUseCase>((ref) {
  return GuardaProjecteUseCase(ref.watch(projectesRepositoryProvider));
});
```

## Observing persisted data

Since Drift emits a `Stream`, Riverpod can expose it directly:

`lib/ui/providers/projectes_provider.dart`

```dart
// Reactive reading provider.
// Exposes the project list to the UI as an AsyncValue<List<Projecte>>.
final projectesProvider = StreamProvider<List<Projecte>>((ref) {
  // The repository hides whether the data comes from Drift, Supabase, etc.
  return ref.watch(projectesRepositoryProvider).observaProjectes();
});
```

The screen only decides how to display loading, errors and data:

`lib/ui/screens/projectes_screen.dart`

```dart
// The screen observes the provider.
final projectes = ref.watch(projectesProvider);

return projectes.when(
  // While we are still waiting for data.
  loading: () => const CircularProgressIndicator(),

  // If reading fails.
  error: (error, _) => Text('Could not load: $error'),

  // When the data arrives.
  data: (items) => ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      final projecte = items[index];
      return ListTile(
        title: Text(projecte.nom),
        subtitle: Text('${projecte.tasques.length} tasks'),
      );
    },
  ),
);
```

## Derived operations

Persistent data can also be reused to create new state.

For example, we might want to duplicate a project that has already been saved, replacing some of its tasks.

To do this, we would need to:

1. Read the selected project.
2. Create a copy without an ID and with a new date.
3. Allow the tasks to be modified before saving the project again.

The repository retrieves the data; the use case decides what duplication means for the domain; and the provider communicates the result to the user interface.

In our `Healthys` project, we could do the same to duplicate an order: retrieve the line items from a saved order and add them to the cart before confirming the new order.

# 6. Cloud persistence with Supabase

## Local persistence and remote persistence

Drift works very well for data belonging to a single installation. However, there are applications where users want to access their data from more than one device, share information or recover it after reinstalling the app.

In these cases, we need a remote data source. There are several options, such as Google's Firebase, which allows us to store collections of data, MongoDB Atlas and many others. In our case, since the data will be relational, we will use Supabase.

Supabase provides us with:

- A PostgreSQL database accessible through an API.
- An authentication system (Auth) to identify the actual user.
- The `supabase_flutter` Flutter client.
- Row Level Security (RLS), to enforce permissions in the database.

Remote storage does not directly replace local persistence. We can have an app that is entirely remote, a local app with a remote copy, or an offline-first app with synchronization. This last option requires us to address several issues, such as identifiers, conflicts, pending queues and retries.

## Setting up a project

To use Supabase in our applications, we first need to set up the project. To do this, we will follow these steps.

### 1. Create a project and obtain keys

First of all, we need to register and create our organization.

For registration, we can use, for example, our GitHub credentials.

Once we have an account, we need to create our organization.

Then we create the project, specifying its name, password and the region where the data will be stored.

### GitHub integration

When creating a project, Supabase may offer the option to connect it to GitHub. This integration is not necessary for a simple Flutter application. It is useful in projects with more advanced deployment workflows, where we want to link Git branches to Supabase environments or branches.

In this unit, we will work directly with the Supabase project from the dashboard and connect the Flutter app using the project URL and the public anon key.

Some security options are also requested:

**Enable Data API:** Enables Supabase's automatic API over the database. This is what allows us to access the database directly from Flutter. If it is not enabled, the database exists, but it is not exposed through the REST/PostgREST API used by the Supabase client.

**Automatic Expose New Tables:** Makes new tables automatically available through the Data API.

**Enable Automatic RLS:** Automatically enables Row Level Security on new tables. RLS is the PostgreSQL/Supabase mechanism for specifying that a particular user can only view, create, modify or delete certain rows. If we enable RLS, tables will be protected by default. This is more secure, but it also means that the application will not be able to read or write data until we define the corresponding access policies.

Once the project has been created, we should save its URL from the dashboard, along with the publishable key shown under API Keys.

### Service_role API Keys

We must never include a `service_role` key in a Flutter application, since it allows privileged operations and must never reach the client.

Using these keys, we will create a configuration file, for example `env/dev.json` (outside `lib`), with the following content:

`env/dev.json`

```json
{
  "SUPABASE_URL": "https://your_database_url.supabase.co",
  "SUPABASE_PUBLISHABLE_KEY": "sb_publishable_key_for_your_database"
}
```

When we run the project, we will use:

```bash
flutter run --dart-define-from-file=env/dev.json
```

This reads the contents of the file and sets the environment variables that the Supabase Flutter client will need.

### Passing environment variables directly

In addition to using a file, we could also provide the environment variables directly using the `--dart-define` option, as follows:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your_database_url.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_key_for_your_database
```

### 2. Installing the Supabase client

To install the Supabase client in our project, run:

```bash
flutter pub add supabase_flutter
```

We can now connect to Supabase using the credentials in our file as follows:

`lib/main.dart`

```dart
Future<void> main() async {
  // Ensure that Flutter has initialized the engine before calling
  // native code or plugins, such as the Supabase client.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the global Supabase client before creating the UI.
  // The values come from --dart-define or --dart-define-from-file.
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    publishableKey: const String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY'),
  );

  // From this point on, any provider or service can access
  // Supabase.instance.client.
  runApp(const ProviderScope(child: MyApp()));
}
```

### String.fromEnvironment

`String.fromEnvironment` reads the values passed to the compiler using `--dart-define` or `--dart-define-from-file`. That is why we use them as constants.

### 3. Authentication

When table records are associated with a user, we need an authentication mechanism. Supabase Auth issues a verified session and allows us to identify the user using a UUID.

Let's look at how to perform the most common basic operations in an authentication service:

`lib/data/services/auth_service.dart`

```dart
// The client was initialized in main() and can be retrieved from Supabase.
final client = Supabase.instance.client;

// Register a new user. Depending on the project configuration, email
// confirmation may be required before the user can sign in.
await client.auth.signUp(email: email, password: password);

// Sign in with email and password. If successful, Supabase stores
// a session with tokens to identify subsequent requests.
await client.auth.signInWithPassword(email: email, password: password);

// UUID of the authenticated user. This is the identifier we will later
// compare with owner_id in the RLS policies.
final userId = client.auth.currentUser?.id;

// Sign out of the current session.
await client.auth.signOut();
```

If email confirmation is enabled in the Dashboard, `signUp()` creates the user, but there will be no session until the user confirms their email.

To make sure this option is enabled, go to the Authentication section.

From there, under **Configuration > Sign In/Providers > User Signup**, verify that the **Allow new users to sign up** option is enabled.

Sessions are managed using tokens. When the user signs in, Supabase returns a session containing an `access_token` in JWT format and a `refresh_token`.

The `supabase_flutter` library takes care of retaining this session and sending the token with subsequent requests, so we normally do not need to handle JWTs manually. This is why we must never store passwords.

### About JWT

Although we do not work directly with JWTs (JSON Web Tokens), PostgreSQL/Supabase uses them internally: functions such as `auth.uid()` obtain the user's identity from the request token.

## Example of per-user data

Returning to the example app for projects and tasks, when we save information in the cloud, we must specify which authenticated user each project belongs to.

### Repository containing the application

You can find a complete, working example using Supabase in the following GitHub repository.

We must bear in mind that, unlike Drift, Supabase does not automatically infer the tables from the Flutter code. If we think of Supabase as a PostgreSQL database in the cloud, we must create the entire database schema on the platform (tables, columns, primary keys, foreign keys, etc.).

There are several ways to create tables, including using the graphical interface, but perhaps the most direct option is the SQL editor. To do this, open the Dashboard for our project and look for the **SQL Editor** menu option.

From this screen, create a new SQL query with the following code:

`supabase/schema.sql`

```sql
-- Main table. Each project belongs to a Supabase Auth user.
-- Create the Projects table.
create table public.projectes (
  id bigint generated always as identity primary key,
  owner_id uuid not null references auth.users(id) on delete cascade,
  nom text not null,
  created_at timestamptz not null default now()
);

-- Child table. Tasks do not store owner_id directly because their
-- owner is inferred through the project to which they belong.
create table public.tasques (
  id bigint generated always as identity primary key,
  projecte_id bigint not null references public.projectes(id) on delete cascade,
  titol text not null,
  completada boolean not null default false
);
```

Click the **Run** button to execute it. If everything goes well, we will receive the message `Success. No rows returned` (since this is not a query as such, but rather the creation of the tables).

To see the result, go to **Database > Schema Visualizer**.

Here, we must bear in mind that the `owner_id` field is not based on text entered by the user, but on `auth.users(id)`, the authenticated identity.

## Row Level Security

Our client application needs to know the Supabase URL and public key to connect to the project. Even if we store these values in an `env` file and do not upload it to the repository, we cannot consider them secrets in a client application: any user could inspect the network traffic or the application package.

For this reason, real data protection cannot depend on hiding the public key or hiding buttons in the interface. Protection must be enforced by the database.

To do this, we will use RLS (Row Level Security), which applies rules in PostgreSQL and ensures that each request can only access permitted rows, even if someone constructs a request outside our app.

Let's look at the SQL code to enable this:

`supabase/policies.sql`

```sql
-- Enable RLS on both tables. From this point on, if there are no
-- policies, access is blocked by default.
alter table public.projectes enable row level security;
alter table public.tasques enable row level security;

-- General table permissions for the authenticated role.
-- RLS policies will then decide which specific rows it can use.
grant select, insert on public.projectes to authenticated;
grant select, insert on public.tasques to authenticated;

-- A user can only read projects where owner_id matches
-- their authenticated identifier.
create policy "Users can view their own projects"
on public.projectes for select to authenticated
using ((select auth.uid()) = owner_id);

-- When inserting a project, we also require owner_id to be that of
-- the authenticated user. This prevents users from creating projects for others.
create policy "Users can create their own projects"
on public.projectes for insert to authenticated
with check ((select auth.uid()) = owner_id);

-- To read tasks, we check the parent project: a task is accessible
-- only if the project belongs to the authenticated user.
create policy "Users can view their own tasks"
on public.tasques for select to authenticated
using (
  exists (
    select 1 from public.projectes p
    where p.id = projecte_id and p.owner_id = (select auth.uid())
  )
);

-- When creating tasks, we apply the same idea: they can only be created
-- within projects belonging to the current user.
create policy "Users can create their own tasks"
on public.tasques for insert to authenticated
with check (
  exists (
    select 1 from public.projectes p
    where p.id = projecte_id and p.owner_id = (select auth.uid())
  )
);
```

Once the script has been executed, we can review what has been applied from the Dashboard by going to **Authentication > Policies**.

### The policy is part of the design

With these policies, two users can use the same API, but each can only retrieve their own projects and tasks. We should always test this separation using more than one user.

This means that the client does not need to add a security filter such as `owner_id = userId` to every query. For example, we can query the projects table, and PostgreSQL will apply the RLS policies before returning the rows.

We can still add functional filters, such as `projecte_id = 3`, to display the tasks belonging to a particular project, but user separation must not depend on the Flutter code.

### Public data and authenticated writes

If we want only authenticated users to be able to create data, but allow any client to read it, we do not need to disable RLS. We can keep RLS enabled and define different policies for each operation: a `select` policy for the `anon` role (anonymous users) and an `insert` policy for the `authenticated` role.

For example, a table containing news, products or published content could allow public reading while reserving creation or modification for authenticated users.

Disabling RLS would only be reasonable for genuinely public tables with no row-level access rules. In general, it is better to leave RLS enabled and define the policies explicitly.

## Remote service and repository

Returning to our application code, its architecture will be practically the same, with only the data access layer changing. In this case, the service will be the only component that knows about `SupabaseClient`:

`lib/data/services/projectes_remote_service.dart`

```dart
class ProjectesRemoteService {
  ProjectesRemoteService(this._client); // Dependency injection

  // The client is encapsulated inside the service. Upper layers do not
  // need to know about Supabase's specific API.
  final SupabaseClient _client;

  Future<List<Map<String, dynamic>>> getProjectes() async {
    // Retrieve the projects and their associated tasks in the same query.
    // Supabase applies the RLS policies before returning the rows.
    return await _client
        .from('projectes')
        .select('*, tasques(*)')
        .order('created_at', ascending: false);
  }
}
```

`SupabaseProjectesRepository` can implement a contract equivalent to the Drift repository and map JSON data to domain entities. The choice of implementation is made in the providers:

`lib/ui/providers/projectes_provider.dart`

```dart
final projectesRepositoryProvider = Provider<ProjectesRepository>((ref) {
  // Here we choose the remote data source. The rest of the app will continue
  // working with the ProjectesRepository contract.
  final client = Supabase.instance.client;
  return SupabaseProjectesRepository(ProjectesRemoteService(client));
});
```

The view and use cases do not need to know whether the repository queries SQLite or PostgreSQL.

## Local reading, remote reading and Realtime

With Drift, we used `Stream` because the local database can notify the application whenever a table changes. This means that if we insert or modify a task, the screen is automatically rebuilt with the new data.

With Supabase, we can start in a simpler way: perform a one-off query using a `Future`, display the result and reload the data after a write operation. For example, we save a task and, once the operation is complete, request the list from the server again.

Realtime is an additional Supabase feature that allows us to subscribe to remote database changes. It would be useful if we wanted a screen to update automatically when another device or another user modifies the data. It is not always necessary for an initial version.

For this reason, the repository contract must express how we want to consume the data. If the screen needs continuous updates, exposing a `Stream` makes sense. If it only needs to load and refresh data at specific times, returning a `Future` may be sufficient.

### Applying this to the course project

To save the order history in `Healthys` in the cloud, we will work with `Comandes` (Orders) instead of Projects, and their dependent rows will be the order line items.

The essential idea does not change: a main row with `owner_id`, child rows protected through the relationship, and RLS verified using two users.

## References

- First Supabase project with Flutter
- Initializing Supabase in Flutter
- Authentication and sessions
- Row Level Security

