<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Doctrine\ORM\EntityManagerInterface;

class HealthController extends AbstractController
{
    private EntityManagerInterface $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    public function health(): JsonResponse
    {
        try {
            // Test de la connexion à la base de données
            $connection = $this->entityManager->getConnection();
            $connection->executeQuery('SELECT 1');
            
            $dbStatus = 'connected';
        } catch (\Exception $e) {
            $dbStatus = 'error: ' . $e->getMessage();
        }

        return new JsonResponse([
            'status' => 'ok',
            'service' => 'PSG Manager API',
            'version' => '1.0.0',
            'environment' => $_ENV['APP_ENV'] ?? 'unknown',
            'database' => $dbStatus,
            'timestamp' => date('Y-m-d H:i:s'),
            'railway' => [
                'service' => $_ENV['RAILWAY_SERVICE_NAME'] ?? 'unknown',
                'environment' => $_ENV['RAILWAY_ENVIRONMENT'] ?? 'unknown'
            ]
        ]);
    }
}
