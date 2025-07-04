<?php

namespace App\Tests\Controller;

use PHPUnit\Framework\TestCase;
use App\Controller\ApiController;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\HttpFoundation\Request;

class ApiControllerTest extends TestCase
{
    public function testControllerCanBeInstantiated(): void
    {
        // Mock des dépendances
        $entityManager = $this->createMock(EntityManagerInterface::class);
        $passwordHasher = $this->createMock(UserPasswordHasherInterface::class);
        
        // Test que le contrôleur peut être instancié
        $controller = new ApiController($entityManager, $passwordHasher);
        
        $this->assertInstanceOf(ApiController::class, $controller);
    }
    
    public function testRequestObjectCanBeCreated(): void
    {
        // Test pour vérifier que les classes Symfony fonctionnent
        $request = new Request();
        
        $this->assertInstanceOf(Request::class, $request);
        $this->assertEquals('GET', $request->getMethod());
    }
    
}
