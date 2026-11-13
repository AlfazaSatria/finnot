<?php

namespace Tests\Feature;

use Tests\TestCase;

class HealthTest extends TestCase
{
    public function test_health_endpoint_returns_the_standard_api_response(): void
    {
        $response = $this->getJson('/api/v1/health');

        $response->assertOk()
            ->assertExactJson([
                'success' => true,
                'message' => 'Service is healthy.',
                'data' => [
                    'status' => 'ok',
                ],
            ]);
    }
}
