<?php

namespace Tests\Feature;

use App\Models\User;
use Database\Seeders\UserSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_seeder_creates_a_known_account(): void
    {
        $this->seed(UserSeeder::class);

        $user = User::query()->where('email', 'ava@example.com')->first();

        $this->assertNotNull($user);
        $this->assertSame('Ava Rahman', $user->name);
        $this->assertTrue(Hash::check('password', $user->password));
        $this->assertSame(5, User::query()->count());
    }

    public function test_user_endpoints_support_list_create_show_update_and_delete(): void
    {
        $create = $this->postJson('/api/v1/users', [
            'name' => 'Mina Hart',
            'email' => 'mina@example.com',
            'password' => 'password',
        ]);

        $create->assertCreated()
            ->assertJsonPath('success', true)
            ->assertJsonPath('message', 'User created.')
            ->assertJsonPath('data.name', 'Mina Hart')
            ->assertJsonPath('data.email', 'mina@example.com')
            ->assertJsonMissingPath('data.password');

        $id = $create->json('data.id');

        $this->getJson('/api/v1/users')
            ->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonPath('message', 'Users retrieved.')
            ->assertJsonFragment([
                'id' => $id,
                'email' => 'mina@example.com',
            ]);

        $this->getJson("/api/v1/users/{$id}")
            ->assertOk()
            ->assertJsonPath('data.id', $id)
            ->assertJsonPath('data.name', 'Mina Hart');

        $this->putJson("/api/v1/users/{$id}", [
            'name' => 'Mina Cole',
        ])->assertOk()
            ->assertJsonPath('message', 'User updated.')
            ->assertJsonPath('data.name', 'Mina Cole')
            ->assertJsonPath('data.email', 'mina@example.com');

        $this->deleteJson("/api/v1/users/{$id}")
            ->assertOk()
            ->assertExactJson([
                'success' => true,
                'message' => 'User deleted.',
                'data' => null,
            ]);

        $this->getJson("/api/v1/users/{$id}")
            ->assertNotFound()
            ->assertJsonPath('success', false)
            ->assertJsonPath('message', 'Resource not found.');
    }

    public function test_store_user_rejects_invalid_input(): void
    {
        $this->postJson('/api/v1/users', [
            'email' => 'not-an-email',
        ])->assertUnprocessable()
            ->assertJsonPath('success', false)
            ->assertJsonPath('message', 'The given data was invalid.')
            ->assertJsonStructure([
                'data' => ['name', 'email', 'password'],
            ]);
    }
}
