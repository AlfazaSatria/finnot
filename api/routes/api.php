<?php

use App\Http\Controllers\Api\V1\HealthController;
use App\Http\Controllers\Api\V1\UserController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::get('/health', HealthController::class);

    Route::get('/users', [UserController::class, 'index']);
    Route::post('/users', [UserController::class, 'store']);
    Route::get('/users/{id}', [UserController::class, 'show'])->whereNumber('id');
    Route::match(['put', 'patch'], '/users/{id}', [UserController::class, 'update'])->whereNumber('id');
    Route::delete('/users/{id}', [UserController::class, 'destroy'])->whereNumber('id');
});
