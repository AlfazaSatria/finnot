# Conventions

## Request flow

```
Route → Controller → Model
```

- **Route** picks the controller method. API routes live in `routes/api.php` and use the `/api/v1` prefix. Current endpoints are public.
- **Controller** validates the request, runs the logic, talks to the model, and returns JSON.
- **Model** is the Eloquent class for a table. `App\Models\User` maps to the `users` table.
- **View** is a Blade page in `resources/views`. The API controllers return JSON, so they do not render a view.

## Example: health

`GET /api/v1/health` is handled by `HealthController`. The method returns the JSON response directly.

## Example: users

`UserController` is the full example. Each method reads or writes `User` and returns JSON.

| Method | Path | Controller method |
| --- | --- | --- |
| `GET` | `/api/v1/users` | `index` |
| `POST` | `/api/v1/users` | `store` |
| `GET` | `/api/v1/users/{id}` | `show` |
| `PUT` or `PATCH` | `/api/v1/users/{id}` | `update` |
| `DELETE` | `/api/v1/users/{id}` | `destroy` |

## Naming

| Piece | Pattern | Location |
| --- | --- | --- |
| Model | `User` | `app/Models` |
| Controller | `UserController` | `app/Http/Controllers/Api/V1` |
| View | `welcome.blade.php` | `resources/views` |

API paths use the `v1` prefix and kebab-case, for example `/api/v1/health`.

## API response

Controller responses use this shape:

```json
{
  "success": true,
  "message": "Users retrieved.",
  "data": {}
}
```

- `success`: boolean
- `message`: string
- `data`: object, array, or `null`

## Git

Short branches from `main`:

- `feat/<name>` — a new feature
- `fix/<name>` — a bug fix
- `chore/<name>` — configuration or tooling
- `docs/<name>` — documentation

Commits follow [Conventional Commits](https://www.conventionalcommits.org/): lowercase, with no trailing period.

- `feat: add task list endpoint`
- `fix: return 404 when user is missing`
- `chore: align pint rules`
- `docs: describe the user controller`
- `test: cover health endpoint`
- `refactor: load users in the controller`

One commit has one purpose. The subject states why the change exists.
