<?php

namespace App\Controller;

use App\Entity\Matchs;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class MatchsController extends AbstractController
{
    private function addCorsHeaders(JsonResponse $response): JsonResponse
    {
        $response->headers->set('Access-Control-Allow-Origin', 'http://localhost:5173');
        $response->headers->set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        $response->headers->set('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
        return $response;
    }

    #[Route('/api/matchs', name: 'matchs_list', methods: ['GET'])]
    public function getMatchs(EntityManagerInterface $em): JsonResponse
    {
        try {
            $matchs = $em->getRepository(Matchs::class)->findAll();
            
            $matchsArray = [];
            foreach ($matchs as $match) {
                $matchsArray[] = [
                    'id' => $match->getId(),
                    'equipe_domicile' => $match->getEquipeDomicile(),
                    'equipe_exterieur' => $match->getEquipeExterieur(),
                    'date_match' => $match->getDateMatch()->format('Y-m-d H:i:s'),
                    'competition' => $match->getCompetition(),
                    'stade' => $match->getStade(),
                    'score_domicile' => $match->getScoreDomicile(),
                    'score_exterieur' => $match->getScoreExterieur(),
                    'statut' => $match->getStatut(),
                    'created_at' => $match->getCreatedAt()->format('Y-m-d H:i:s'),
                    // Champs calculés pour la compatibilité Vue.js
                    'lieu' => $match->getLieu(),
                    'equipe_adverse' => $match->getEquipeAdverse(),
                    'score_psg' => $match->getScorePsg(),
                    'score_adverse' => $match->getScoreAdverse()
                ];
            }
            
            $response = new JsonResponse($matchsArray);
            return $this->addCorsHeaders($response);
            
        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la récupération des matchs',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/matchs', name: 'matchs_create', methods: ['POST'])]
    public function createMatch(Request $request, EntityManagerInterface $em): JsonResponse
    {
        try {
            $data = json_decode($request->getContent(), true);
            
            // Vérifier les données reçues
            if (!$data) {
                return new JsonResponse(['error' => 'Données JSON invalides'], 400);
            }

            // Vérifier les champs obligatoires
            if (!isset($data['equipe_domicile']) || empty($data['equipe_domicile'])) {
                return new JsonResponse(['error' => 'Équipe domicile obligatoire'], 400);
            }
            if (!isset($data['equipe_exterieur']) || empty($data['equipe_exterieur'])) {
                return new JsonResponse(['error' => 'Équipe extérieur obligatoire'], 400);
            }
            if (!isset($data['date_match']) || empty($data['date_match'])) {
                return new JsonResponse(['error' => 'Date du match obligatoire'], 400);
            }
            if (!isset($data['competition']) || empty($data['competition'])) {
                return new JsonResponse(['error' => 'Compétition obligatoire'], 400);
            }
            if (!isset($data['stade']) || empty($data['stade'])) {
                return new JsonResponse(['error' => 'Stade obligatoire'], 400);
            }
            
            $match = new Matchs();
            
            $match->setEquipeDomicile($data['equipe_domicile']);
            $match->setEquipeExterieur($data['equipe_exterieur']);
            
            // Gérer la date
            try {
                $match->setDateMatch(new \DateTime($data['date_match']));
            } catch (\Exception $e) {
                return new JsonResponse(['error' => 'Format de date invalide'], 400);
            }
            
            $match->setCompetition($data['competition']);
            $match->setStade($data['stade']);
            
            // Champs optionnels
            if (isset($data['score_domicile']) && $data['score_domicile'] !== null) {
                $match->setScoreDomicile((int)$data['score_domicile']);
            }
            if (isset($data['score_exterieur']) && $data['score_exterieur'] !== null) {
                $match->setScoreExterieur((int)$data['score_exterieur']);
            }
            if (isset($data['statut']) && !empty($data['statut'])) {
                $match->setStatut($data['statut']);
            } else {
                $match->setStatut('programme'); // Valeur par défaut
            }
            
            $em->persist($match);
            $em->flush();
            
            return new JsonResponse([
                'message' => 'Match créé avec succès',
                'id' => $match->getId(),
                'match' => [
                    'id' => $match->getId(),
                    'equipe_domicile' => $match->getEquipeDomicile(),
                    'equipe_exterieur' => $match->getEquipeExterieur(),
                    'date_match' => $match->getDateMatch()->format('Y-m-d H:i:s'),
                    'competition' => $match->getCompetition(),
                    'stade' => $match->getStade(),
                    'statut' => $match->getStatut(),
                    'lieu' => $match->getLieu(),
                    'equipe_adverse' => $match->getEquipeAdverse()
                ]
            ], 201);
            
        } catch (\Exception $e) {
            return new JsonResponse([
                'error' => 'Erreur lors de la création',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    #[Route('/api/matchs/{id}', name: 'matchs_show', methods: ['GET'])]
    public function getMatch(int $id, EntityManagerInterface $em): JsonResponse
    {
        try {
            $match = $em->getRepository(Matchs::class)->find($id);
            
            if (!$match) {
                return new JsonResponse(['error' => 'Match non trouvé'], 404);
            }
            
            $matchData = [
                'id' => $match->getId(),
                'equipe_domicile' => $match->getEquipeDomicile(),
                'equipe_exterieur' => $match->getEquipeExterieur(),
                'date_match' => $match->getDateMatch()->format('Y-m-d H:i:s'),
                'competition' => $match->getCompetition(),
                'stade' => $match->getStade(),
                'score_domicile' => $match->getScoreDomicile(),
                'score_exterieur' => $match->getScoreExterieur(),
                'statut' => $match->getStatut(),
                'created_at' => $match->getCreatedAt()->format('Y-m-d H:i:s'),
                'lieu' => $match->getLieu(),
                'equipe_adverse' => $match->getEquipeAdverse(),
                'score_psg' => $match->getScorePsg(),
                'score_adverse' => $match->getScoreAdverse()
            ];
            
            return new JsonResponse($matchData);
            
        } catch (\Exception $e) {
            return new JsonResponse([
                'error' => 'Erreur lors de la récupération du match',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    #[Route('/api/matchs/{id}', name: 'matchs_update', methods: ['PUT'])]
    public function updateMatch(int $id, Request $request, EntityManagerInterface $em): JsonResponse
    {
        try {
            $match = $em->getRepository(Matchs::class)->find($id);
            
            if (!$match) {
                return new JsonResponse(['error' => 'Match non trouvé'], 404);
            }
            
            $data = json_decode($request->getContent(), true);
            
            if (!$data) {
                return new JsonResponse(['error' => 'Données JSON invalides'], 400);
            }
            
            // Mettre à jour les champs si présents
            if (isset($data['equipe_domicile']) && !empty($data['equipe_domicile'])) {
                $match->setEquipeDomicile($data['equipe_domicile']);
            }
            if (isset($data['equipe_exterieur']) && !empty($data['equipe_exterieur'])) {
                $match->setEquipeExterieur($data['equipe_exterieur']);
            }
            if (isset($data['date_match']) && !empty($data['date_match'])) {
                try {
                    $match->setDateMatch(new \DateTime($data['date_match']));
                } catch (\Exception $e) {
                    return new JsonResponse(['error' => 'Format de date invalide'], 400);
                }
            }
            if (isset($data['competition']) && !empty($data['competition'])) {
                $match->setCompetition($data['competition']);
            }
            if (isset($data['stade']) && !empty($data['stade'])) {
                $match->setStade($data['stade']);
            }
            if (isset($data['score_domicile'])) {
                $match->setScoreDomicile($data['score_domicile'] !== null ? (int)$data['score_domicile'] : null);
            }
            if (isset($data['score_exterieur'])) {
                $match->setScoreExterieur($data['score_exterieur'] !== null ? (int)$data['score_exterieur'] : null);
            }
            if (isset($data['statut']) && !empty($data['statut'])) {
                $match->setStatut($data['statut']);
            }
            
            $em->flush();
            
            return new JsonResponse([
                'message' => 'Match modifié avec succès',
                'match' => [
                    'id' => $match->getId(),
                    'equipe_domicile' => $match->getEquipeDomicile(),
                    'equipe_exterieur' => $match->getEquipeExterieur(),
                    'date_match' => $match->getDateMatch()->format('Y-m-d H:i:s'),
                    'competition' => $match->getCompetition(),
                    'stade' => $match->getStade(),
                    'score_domicile' => $match->getScoreDomicile(),
                    'score_exterieur' => $match->getScoreExterieur(),
                    'statut' => $match->getStatut(),
                    'lieu' => $match->getLieu(),
                    'equipe_adverse' => $match->getEquipeAdverse()
                ]
            ]);
            
        } catch (\Exception $e) {
            return new JsonResponse([
                'error' => 'Erreur lors de la modification',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    #[Route('/api/matchs/{id}', name: 'matchs_delete', methods: ['DELETE'])]
    public function deleteMatch(int $id, EntityManagerInterface $em): JsonResponse
    {
        try {
            $match = $em->getRepository(Matchs::class)->find($id);
            
            if (!$match) {
                return new JsonResponse(['error' => 'Match non trouvé'], 404);
            }
            
            $em->remove($match);
            $em->flush();
            
            return new JsonResponse(['message' => 'Match supprimé avec succès']);
            
        } catch (\Exception $e) {
            return new JsonResponse([
                'error' => 'Erreur lors de la suppression',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    #[Route('/api/matchs/stats', name: 'matchs_stats', methods: ['GET'])]
    public function getMatchsStats(EntityManagerInterface $em): JsonResponse
    {
        try {
            $totalMatchs = $em->getRepository(Matchs::class)
                ->createQueryBuilder('m')
                ->select('COUNT(m.id)')
                ->getQuery()
                ->getSingleScalarResult();

            $matchsJoues = $em->getRepository(Matchs::class)
                ->createQueryBuilder('m')
                ->select('COUNT(m.id)')
                ->where('m.statut = :statut')
                ->setParameter('statut', 'termine')
                ->getQuery()
                ->getSingleScalarResult();

            $prochainsMatchs = $em->getRepository(Matchs::class)
                ->createQueryBuilder('m')
                ->select('COUNT(m.id)')
                ->where('m.statut = :statut')
                ->setParameter('statut', 'programme')
                ->getQuery()
                ->getSingleScalarResult();

            // Calculer les victoires (PSG domicile et score_domicile > score_exterieur) 
            // OU (PSG extérieur et score_exterieur > score_domicile)
            $victoires = $em->getRepository(Matchs::class)
                ->createQueryBuilder('m')
                ->select('COUNT(m.id)')
                ->where('m.statut = :statut')
                ->andWhere('(
                    (m.equipeDomicile = :psg AND m.scoreDomicile > m.scoreExterieur) 
                    OR 
                    (m.equipeExterieur = :psg AND m.scoreExterieur > m.scoreDomicile)
                )')
                ->andWhere('m.scoreDomicile IS NOT NULL')
                ->andWhere('m.scoreExterieur IS NOT NULL')
                ->setParameter('statut', 'termine')
                ->setParameter('psg', 'PSG')
                ->getQuery()
                ->getSingleScalarResult();

            // Calculer les défaites
            $defaites = $em->getRepository(Matchs::class)
                ->createQueryBuilder('m')
                ->select('COUNT(m.id)')
                ->where('m.statut = :statut')
                ->andWhere('(
                    (m.equipeDomicile = :psg AND m.scoreDomicile < m.scoreExterieur) 
                    OR 
                    (m.equipeExterieur = :psg AND m.scoreExterieur < m.scoreDomicile)
                )')
                ->andWhere('m.scoreDomicile IS NOT NULL')
                ->andWhere('m.scoreExterieur IS NOT NULL')
                ->setParameter('statut', 'termine')
                ->setParameter('psg', 'PSG')
                ->getQuery()
                ->getSingleScalarResult();

            // Calculer les matchs nuls
            $nuls = $em->getRepository(Matchs::class)
                ->createQueryBuilder('m')
                ->select('COUNT(m.id)')
                ->where('m.statut = :statut')
                ->andWhere('(m.equipeDomicile = :psg OR m.equipeExterieur = :psg)')
                ->andWhere('m.scoreDomicile = m.scoreExterieur')
                ->andWhere('m.scoreDomicile IS NOT NULL')
                ->andWhere('m.scoreExterieur IS NOT NULL')
                ->setParameter('statut', 'termine')
                ->setParameter('psg', 'PSG')
                ->getQuery()
                ->getSingleScalarResult();

            return new JsonResponse([
                'totalMatchs' => (int)$totalMatchs,
                'matchsJoues' => (int)$matchsJoues,
                'victoires' => (int)$victoires,
                'defaites' => (int)$defaites,
                'nuls' => (int)$nuls,
                'prochainsMatchs' => (int)$prochainsMatchs,
                'pourcentageVictoires' => $matchsJoues > 0 ? round(($victoires / $matchsJoues) * 100, 1) : 0
            ]);

        } catch (\Exception $e) {
            return new JsonResponse([
                'error' => 'Erreur lors de la récupération des statistiques',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    #[Route('/api/matchs/prochains', name: 'matchs_prochains', methods: ['GET'])]
    public function getProchainsMatchs(EntityManagerInterface $em): JsonResponse
    {
        try {
            $prochainsMatchs = $em->getRepository(Matchs::class)
                ->createQueryBuilder('m')
                ->where('m.dateMatch > :now')
                ->andWhere('m.statut = :statut')
                ->setParameter('now', new \DateTime())
                ->setParameter('statut', 'programme')
                ->orderBy('m.dateMatch', 'ASC')
                ->setMaxResults(5)
                ->getQuery()
                ->getResult();

            $matchsArray = [];
            foreach ($prochainsMatchs as $match) {
                $matchsArray[] = [
                    'id' => $match->getId(),
                    'equipe_domicile' => $match->getEquipeDomicile(),
                    'equipe_exterieur' => $match->getEquipeExterieur(),
                    'date_match' => $match->getDateMatch()->format('Y-m-d H:i:s'),
                    'competition' => $match->getCompetition(),
                    'stade' => $match->getStade(),
                    'statut' => $match->getStatut(),
                    'lieu' => $match->getLieu(),
                    'equipe_adverse' => $match->getEquipeAdverse()
                ];
            }

            return new JsonResponse($matchsArray);

        } catch (\Exception $e) {
            return new JsonResponse([
                'error' => 'Erreur lors de la récupération des prochains matchs',
                'details' => $e->getMessage()
            ], 500);
        }
    }
}