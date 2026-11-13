# Finnot

Fullstack starter for learning **Flutter** (frontend) and **Laravel** (backend). It contains the project structure, configuration, and one example request flow.

| Folder | Contents |
| --- | --- |
| `api/` | Laravel |
| `mobile/` | Flutter |
| `docs/` | Conventions and roadmap |

Run the commands in each section from the repository root.

## Prerequisites

- PHP 8.3+
- Composer 2
- MySQL 8
- Flutter SDK stable (this project was created with Flutter 3.50 / Dart 3.14)

## API

```bash
cd api
composer install
cp .env.example .env
php artisan key:generate
```

Create the MySQL database. `.env.example` uses the database `finnot`, user `root`, and an empty password. Change `DB_DATABASE`, `DB_USERNAME`, and `DB_PASSWORD` when the local environment differs.

```sql
CREATE DATABASE finnot CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

```bash
php artisan migrate
php artisan serve
```

The API is available at `http://127.0.0.1:8000`. Current endpoints are public.

```bash
curl http://127.0.0.1:8000/api/v1/health
```

```json
{
  "success": true,
  "message": "Service is healthy.",
  "data": {
    "status": "ok"
  }
}
```

Users example:

| Method | Path | Action |
| --- | --- | --- |
| `GET` | `/api/v1/users` | List users |
| `POST` | `/api/v1/users` | Add a user (`name`, `email`, `password`) |
| `GET` | `/api/v1/users/{id}` | Get one user |
| `PUT` or `PATCH` | `/api/v1/users/{id}` | Edit a user |
| `DELETE` | `/api/v1/users/{id}` | Delete a user |

Seed sample users (`ava@example.com` / `password`, plus four more):

```bash
php artisan db:seed
```

```bash
php artisan test
./vendor/bin/pint --test
```

## Mobile

The Flutter app runs on **macOS** and **web** only.

```bash
cd mobile
flutter pub get
cp .env.example .env
flutter run -d macos
```

For the browser:

```bash
flutter run -d chrome
```

The first screen is a users form: list, add, edit, and delete. It calls the API with `dio` and reads `API_BASE_URL` from `.env`. `.env` is already listed under `flutter: assets` in `pubspec.yaml`. Start the API before opening the app. The type is Courier Prime, a typewriter face.

## Run on Windows

Laravel 13 needs **PHP 8.3 or newer**. Use Laragon or XAMPP to get PHP and MySQL, then run the API with `php artisan serve`. Install Flutter separately.

### Laragon

1. Download **Laragon Full** from [laragon.org](https://laragon.org) and install it.
2. Open Laragon and click **Start All**. MySQL must be running.
3. Menu **PHP → Version**. Select **PHP 8.3** or newer.
4. Open the Laragon terminal. Check the tools:

```bat
php -v
composer -V
```

5. Open **HeidiSQL** from the Laragon menu. Create a database named `finnot` with collation `utf8mb4_unicode_ci`. The default account is user `root` and an empty password, which matches `api/.env.example`.
6. Install the Flutter SDK for Windows: [docs.flutter.dev/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows). Add the `flutter\bin` folder to your PATH, open a new terminal, and run `flutter doctor`.
7. In the repository, start the API:

```bat
cd api
composer install
copy .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve
```

8. Open a second terminal at the repository root and start the app in Chrome. This app targets macOS and web only, so on Windows use the browser:

```bat
cd mobile
flutter pub get
copy .env.example .env
flutter run -d chrome
```

### XAMPP

1. Install a XAMPP build that includes **PHP 8.3 or newer**.
2. Open the **XAMPP Control Panel** and start **MySQL**. This project serves the API with `php artisan serve`.
3. Add `C:\xampp\php` to the system PATH. Close and reopen the terminal.
4. Install Composer from [getcomposer.org/download](https://getcomposer.org/download/) and point the installer at `C:\xampp\php\php.exe`.
5. Confirm both tools:

```bat
php -v
composer -V
```

6. Open [http://localhost/phpmyadmin](http://localhost/phpmyadmin). Create a database named `finnot` with collation `utf8mb4_unicode_ci`. The default XAMPP account is user `root` and an empty password.
7. Install Flutter the same way as in the Laragon steps, then run `flutter doctor`.
8. From the repository root, start the API:

```bat
cd api
composer install
copy .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve
```

9. In a second terminal, start the app in Chrome:

```bat
cd mobile
flutter pub get
copy .env.example .env
flutter run -d chrome
```

macOS and Chrome reach the API at `http://127.0.0.1:8000/api/v1`. That value is already set in `mobile/.env.example`.

## Health check

With `php artisan serve` running, open `http://127.0.0.1:8000/api/v1/health` in the browser, or call it from the terminal:

```bash
curl http://127.0.0.1:8000/api/v1/health
```

## Documentation

- [docs/CONVENTIONS.md](docs/CONVENTIONS.md) — Model, View, and Controller pattern, response format, and Git rules
- [docs/ROADMAP.md](docs/ROADMAP.md) — learning roadmap outline
