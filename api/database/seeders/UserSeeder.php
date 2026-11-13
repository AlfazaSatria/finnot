<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Seed a known user plus a few extra examples.
     * The known account is ava@example.com / password.
     */
    public function run(): void
    {
        User::factory()->create([
            'name' => 'Ava Rahman',
            'email' => 'ava@example.com',
            'password' => 'password',
        ]);

        User::factory()->count(4)->create();
    }
}
