import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:material_ui/material_ui.dart';

class AppUser {
  const AppUser({required this.id, required this.name, required this.email});

  final int id;
  final String name;
  final String email;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late final Dio _dio;

  List<AppUser> _users = [];
  AppUser? _editing;
  String? _status;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final baseUrl = dotenv.isInitialized ? dotenv.env['API_BASE_URL'] : null;
    _dio = Dio(
      BaseOptions(
        baseUrl: (baseUrl == null || baseUrl.isEmpty)
            ? 'http://127.0.0.1:8000/api/v1'
            : baseUrl,
        headers: {'Accept': 'application/json'},
      ),
    );
    _loadUsers();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loading = true;
      _status = null;
    });

    try {
      final response = await _dio.get<Map<String, dynamic>>('/users');
      final rows = response.data?['data'] as List<dynamic>? ?? [];
      setState(() {
        _users = rows
            .map((row) => AppUser.fromJson(row as Map<String, dynamic>))
            .toList();
      });
    } on DioException catch (error) {
      setState(() => _status = _errorText(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openUser(AppUser user) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/users/${user.id}',
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) return;
      final loaded = AppUser.fromJson(data);
      setState(() {
        _editing = loaded;
        _name.text = loaded.name;
        _email.text = loaded.email;
        _password.clear();
        _status = 'Editing user ${loaded.id}. Leave password blank to keep it.';
      });
    } on DioException catch (error) {
      setState(() => _status = _errorText(error));
    }
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final password = _password.text;

    try {
      if (_editing == null) {
        await _dio.post<Map<String, dynamic>>(
          '/users',
          data: {'name': name, 'email': email, 'password': password},
        );
      } else {
        await _dio.put<Map<String, dynamic>>(
          '/users/${_editing!.id}',
          data: {
            'name': name,
            'email': email,
            if (password.isNotEmpty) 'password': password,
          },
        );
      }
      _clearForm();
      await _loadUsers();
    } on DioException catch (error) {
      setState(() => _status = _errorText(error));
    }
  }

  Future<void> _delete(AppUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete user'),
          content: Text('Delete ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    try {
      await _dio.delete<Map<String, dynamic>>('/users/${user.id}');
      if (_editing?.id == user.id) _clearForm();
      await _loadUsers();
    } on DioException catch (error) {
      setState(() => _status = _errorText(error));
    }
  }

  void _clearForm() {
    setState(() {
      _editing = null;
      _name.clear();
      _email.clear();
      _password.clear();
      _status = null;
    });
  }

  String _errorText(DioException error) {
    final body = error.response?.data;
    if (body is Map) {
      final details = body['data'];
      if (details is Map) {
        final lines = details.values
            .expand((value) => value is List ? value : [value])
            .join('\n');
        if (lines.isNotEmpty) return lines;
      }
      final message = body['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return 'Could not reach the API. Start it with php artisan serve.';
  }

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(title: const Text('Finnot')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            children: [
              Text('Users', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                _editing == null ? 'Add a user' : 'Edit user ${_editing!.id}',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  helperText: _editing == null
                      ? 'At least 8 characters'
                      : 'Leave blank to keep the current password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                children: [
                  FilledButton(onPressed: _save, child: const Text('Save')),
                  OutlinedButton(
                    onPressed: _clearForm,
                    child: const Text('Clear'),
                  ),
                ],
              ),
              if (_status != null) ...[
                const SizedBox(height: 16),
                Text(_status!, style: TextStyle(color: ink)),
              ],
              const SizedBox(height: 28),
              if (_loading) const LinearProgressIndicator(),
              if (!_loading && _users.isEmpty)
                const Text('No users yet.')
              else
                ..._users.map((user) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF241C16)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(user.email),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => _openUser(user),
                          child: const Text('Edit'),
                        ),
                        TextButton(
                          onPressed: () => _delete(user),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
