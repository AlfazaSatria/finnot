<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    public function index(): JsonResponse
    {
        $users = User::query()
            ->latest()
            ->get()
            ->map(fn (User $user): array => $this->userData($user))
            ->values();

        return $this->success($users, 'Users retrieved.');
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users,email'],
            'password' => ['required', 'string', 'min:8'],
        ]);

        $user = User::query()->create($data);

        return $this->success($this->userData($user), 'User created.', 201);
    }

    public function show(int $id): JsonResponse
    {
        $user = User::query()->findOrFail($id);

        return $this->success($this->userData($user), 'User retrieved.');
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $user = User::query()->findOrFail($id);

        $data = $request->validate([
            'name' => ['sometimes', 'required', 'string', 'max:255'],
            'email' => [
                'sometimes',
                'required',
                'string',
                'email',
                'max:255',
                Rule::unique('users', 'email')->ignore($user->id),
            ],
            'password' => ['sometimes', 'nullable', 'string', 'min:8'],
        ]);

        $user->update(array_filter(
            $data,
            fn (mixed $value): bool => $value !== null,
        ));

        return $this->success($this->userData($user->refresh()), 'User updated.');
    }

    public function destroy(int $id): JsonResponse
    {
        User::query()->findOrFail($id)->delete();

        return $this->success(null, 'User deleted.');
    }

    /**
     * @return array{id: int, name: string, email: string, created_at: string|null, updated_at: string|null}
     */
    private function userData(User $user): array
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'created_at' => $user->created_at?->toISOString(),
            'updated_at' => $user->updated_at?->toISOString(),
        ];
    }
}
