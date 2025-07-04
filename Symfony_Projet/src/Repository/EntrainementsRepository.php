<?php

namespace App\Repository;

use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * Repository pour les entraînements
 */
class EntrainementsRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        // Ici vous devriez avoir votre entité Entrainements
        // Pour l'instant, on utilise une classe fictive
        parent::__construct($registry, \stdClass::class);
    }
}
