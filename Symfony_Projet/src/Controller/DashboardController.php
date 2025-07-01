<?php

namespace App\Controller;

use App\Entity\Actualites;
use App\Entity\Joueurs;
use App\Entity\Product;
use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;

class DashboardController extends AbstractController
{
    private function addCorsHeaders(JsonResponse $response): JsonResponse
    {
        $response->headers->set('Access-Control-Allow-Origin', 'http://localhost:5173');
        $response->headers->set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        $response->headers->set('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
        return $response;
    }

    #[Route('/api/dashboard/stats', name: 'dashboard_stats', methods: ['GET', 'OPTIONS'])]
    public function getDashboardStats(EntityManagerInterface $entityManager): JsonResponse
    {
        try {
            // 1. Compter les joueurs dans l'équipe PSG
            $totalJoueurs = $entityManager->getRepository(Joueurs::class)
                ->createQueryBuilder('j')
                ->select('COUNT(j.id)')
                ->where('j.equipe = :equipe')
                ->setParameter('equipe', 'PSG')
                ->getQuery()
                ->getSingleScalarResult();

            // 2. Compter les produits et calculer le stock total
            $stockQuery = $entityManager->getRepository(Product::class)
                ->createQueryBuilder('p')
                ->select('SUM(p.stock) as totalStock, COUNT(p.id) as totalProduits')
                ->getQuery()
                ->getSingleResult();

            $totalStock = $stockQuery['totalStock'] ?? 0;
            $totalProduits = $stockQuery['totalProduits'] ?? 0;

            // 3. Compter les actualités publiées
            $totalActualites = 0;
            try {
                $totalActualites = $entityManager->getRepository(Actualites::class)
                    ->createQueryBuilder('a')
                    ->select('COUNT(a.id)')
                    ->where('a.statut = :statut')
                    ->setParameter('statut', 'publie')
                    ->getQuery()
                    ->getSingleScalarResult();
            } catch (\Exception $e) {
                // Table actualites peut ne pas exister
            }

            // 4. Calculer les revenus potentiels (prix * stock)
            $revenusQuery = $entityManager->getRepository(Product::class)
                ->createQueryBuilder('p')
                ->select('SUM(p.prix * p.stock) as revenus')
                ->getQuery()
                ->getSingleResult();

            $revenus = $revenusQuery['revenus'] ?? 0;
            $revenusFormattes = $this->formatMoney($revenus);

            // 5. Compter les utilisateurs par rôle
            $totalUtilisateurs = $entityManager->getRepository(User::class)
                ->createQueryBuilder('u')
                ->select('COUNT(u.id)')
                ->getQuery()
                ->getSingleScalarResult();

            $totalAdmins = $entityManager->getRepository(User::class)
                ->createQueryBuilder('u')
                ->select('COUNT(u.id)')
                ->where('u.role = :role')
                ->setParameter('role', 'admin')
                ->getQuery()
                ->getSingleScalarResult();

            // 6. Top 5 des produits les plus chers
            $topProduits = $entityManager->getRepository(Product::class)
                ->createQueryBuilder('p')
                ->select('p.nom, p.prix, p.stock')
                ->orderBy('p.prix', 'DESC')
                ->setMaxResults(5)
                ->getQuery()
                ->getResult();

            $response = new JsonResponse([
                // Statistiques principales
                'totalJoueurs' => (int)$totalJoueurs,
                'totalStock' => (int)$totalStock,
                'totalProduits' => (int)$totalProduits,
                'totalActualites' => (int)$totalActualites,
                'revenus' => $revenusFormattes,
                'totalUtilisateurs' => (int)$totalUtilisateurs,
                'totalAdmins' => (int)$totalAdmins,
                
                // Données détaillées
                'topProduits' => $topProduits,
                
                // Métadonnées
                'lastUpdate' => (new \DateTime())->format('Y-m-d H:i:s')
            ]);

            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la récupération des statistiques',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/dashboard/joueurs-stats', name: 'dashboard_joueurs_stats', methods: ['GET', 'OPTIONS'])]
    public function getJoueursStats(EntityManagerInterface $entityManager): JsonResponse
    {
        try {
            $statsParPoste = $entityManager->getRepository(Joueurs::class)
                ->createQueryBuilder('j')
                ->select('j.poste, COUNT(j.id) as nombre, AVG(j.age) as ageMoyen')
                ->where('j.equipe = :equipe')
                ->setParameter('equipe', 'PSG')
                ->groupBy('j.poste')
                ->getQuery()
                ->getResult();

            $response = new JsonResponse([
                'statsParPoste' => $statsParPoste
            ]);

            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la récupération des stats joueurs'
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/dashboard/boutique-stats', name: 'dashboard_boutique_stats', methods: ['GET', 'OPTIONS'])]
    public function getBoutiqueStats(EntityManagerInterface $entityManager): JsonResponse
    {
        try {
            $produitsStockFaible = $entityManager->getRepository(Product::class)
                ->createQueryBuilder('p')
                ->select('p.nom, p.stock, p.prix')
                ->where('p.stock <= :seuil')
                ->setParameter('seuil', 10)
                ->orderBy('p.stock', 'ASC')
                ->getQuery()
                ->getResult();

            $response = new JsonResponse([
                'produitsStockFaible' => $produitsStockFaible,
                'alertesStock' => count($produitsStockFaible)
            ]);

            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la récupération des stats boutique'
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    private function formatMoney(float $amount): string
    {
        if ($amount >= 1000000) {
            return number_format($amount / 1000000, 1) . 'M€';
        } elseif ($amount >= 1000) {
            return number_format($amount / 1000, 1) . 'K€';
        } else {
            return number_format($amount, 2) . '€';
        }
    }
}