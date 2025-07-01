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

    #[Route('/api/matchs', name: 'matchs_list', methods: ['GET', 'OPTIONS'])]
    public function getMatchs(EntityManagerInterface $em): JsonResponse
    {
        try {
            $matchs = $em->getRepository(Matchs::class)
                ->findBy([], ['date_match' => 'ASC']);

            $matchsData = [];
            foreach ($matchs as $match) {
                $matchsData[] = [
                    'id' => $match->getId(),
                    'equipe_domicile' => $match->getEquipeDomicile(),
                    'equipe_exterieur' => $match->getEquipeExterieure(),
                    'equipe_adverse' => $match->getEquipeAdverse(),
                    'lieu' => $match->getLieu(),
                    'date_match' => $match->getDateMatch()->format('Y-m-d\TH:i:s'),
                    'competition' => $match->getCompetition(),
                    'stade' => $match->getStade(),
                    'statut' => $match->getStatut(),
                    'score_domicile' => $match->getScoreDomicile(),
                    'score_exterieur' => $match->getScoreExterieure(),
                    'score_psg' => $match->getScorePsg(),
                    'score_adverse' => $match->getScoreAdverse(),
                    'is_psg_domicile' => $match->isPsgDomicile(),
                    'created_at' => $match->getCreatedAt()->format('Y-m-d\TH:i:s')
                ];
            }

            $response = new JsonResponse($matchsData);
            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la récupération des matchs',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/matchs', name: 'matchs_create', methods: ['POST', 'OPTIONS'])]
    public function addMatch(Request $request, EntityManagerInterface $em): JsonResponse
    {
        try {
            $data = json_decode($request->getContent(), true);

            $requiredFields = ['equipe_adverse', 'date_match', 'competition', 'lieu', 'stade'];
            foreach ($requiredFields as $field) {
                if (!isset($data[$field]) || empty($data[$field])) {
                    $response = new JsonResponse(['error' => "Le champ '$field' est obligatoire"], 400);
                    return $this->addCorsHeaders($response);
                }
            }

            $match = new Matchs();
            
            // Définir équipes selon le lieu
            if ($data['lieu'] === 'Domicile') {
                $match->setEquipeDomicile('PSG');
                $match->setEquipeExterieure($data['equipe_adverse']);
            } else {
                $match->setEquipeDomicile($data['equipe_adverse']);
                $match->setEquipeExterieure('PSG');
            }
            
            $match->setDateMatch(new \DateTime($data['date_match']));
            $match->setCompetition($data['competition']);
            $match->setStade($data['stade']);
            
            if (isset($data['statut'])) {
                $match->setStatut($data['statut']);
            }
            
            // Gérer les scores si fournis
            if (isset($data['score_psg']) && isset($data['score_adverse'])) {
                if ($data['lieu'] === 'Domicile') {
                    $match->setScoreDomicile($data['score_psg']);
                    $match->setScoreExterieure($data['score_adverse']);
                } else {
                    $match->setScoreDomicile($data['score_adverse']);
                    $match->setScoreExterieure($data['score_psg']);
                }
            }

            $em->persist($match);
            $em->flush();

            $response = new JsonResponse([
                'id' => $match->getId(),
                'message' => 'Match créé avec succès',
                'data' => [
                    'equipe_adverse' => $match->getEquipeAdverse(),
                    'date_match' => $match->getDateMatch()->format('Y-m-d\TH:i:s'),
                    'competition' => $match->getCompetition(),
                    'lieu' => $match->getLieu(),
                    'stade' => $match->getStade()
                ]
            ], 201);

            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la création du match',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/matchs/{id}', name: 'matchs_update', methods: ['PUT', 'OPTIONS'])]
    public function updateMatch(int $id, Request $request, EntityManagerInterface $em): JsonResponse
    {
        try {
            $match = $em->getRepository(Matchs::class)->find($id);

            if (!$match) {
                $response = new JsonResponse(['error' => 'Match non trouvé'], 404);
                return $this->addCorsHeaders($response);
            }

            $data = json_decode($request->getContent(), true);

            if (isset($data['equipe_adverse'])) {
                $equipe_adverse = $data['equipe_adverse'];
                $lieu = isset($data['lieu']) ? $data['lieu'] : $match->getLieu();
                
                if ($lieu === 'Domicile') {
                    $match->setEquipeDomicile('PSG');
                    $match->setEquipeExterieure($equipe_adverse);
                } else {
                    $match->setEquipeDomicile($equipe_adverse);
                    $match->setEquipeExterieure('PSG');
                }
            }
            
            if (isset($data['lieu'])) {
                $lieu = $data['lieu'];
                $equipe_adverse = $match->getEquipeAdverse();
                
                if ($lieu === 'Domicile') {
                    $match->setEquipeDomicile('PSG');
                    $match->setEquipeExterieure($equipe_adverse);
                } else {
                    $match->setEquipeDomicile($equipe_adverse);
                    $match->setEquipeExterieure('PSG');
                }
            }

            if (isset($data['date_match'])) {
                $match->setDateMatch(new \DateTime($data['date_match']));
            }
            if (isset($data['competition'])) {
                $match->setCompetition($data['competition']);
            }
            if (isset($data['stade'])) {
                $match->setStade($data['stade']);
            }
            if (isset($data['statut'])) {
                $match->setStatut($data['statut']);
            }

            // Gérer les scores
            if (isset($data['score_psg']) && isset($data['score_adverse'])) {
                if ($match->isPsgDomicile()) {
                    $match->setScoreDomicile($data['score_psg']);
                    $match->setScoreExterieure($data['score_adverse']);
                } else {
                    $match->setScoreDomicile($data['score_adverse']);
                    $match->setScoreExterieure($data['score_psg']);
                }
            }
            
            $em->flush();

            $response = new JsonResponse([
                'message' => 'Match modifié avec succès',
                'data' => [
                    'id' => $match->getId(),
                    'equipe_adverse' => $match->getEquipeAdverse(),
                    'date_match' => $match->getDateMatch()->format('Y-m-d\TH:i:s'),
                    'competition' => $match->getCompetition(),
                    'lieu' => $match->getLieu(),
                    'stade' => $match->getStade(),
                    'statut' => $match->getStatut()
                ]
            ]);

            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la modification',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/matchs/{id}', name: 'matchs_delete', methods: ['DELETE', 'OPTIONS'])]
    public function deleteMatch(int $id, EntityManagerInterface $em): JsonResponse
    {
        try {
            $match = $em->getRepository(Matchs::class)->find($id);

            if (!$match) {
                $response = new JsonResponse(['error' => 'Match non trouvé'], 404);
                return $this->addCorsHeaders($response);
            }

            $em->remove($match);
            $em->flush();

            $response = new JsonResponse([
                'message' => 'Match supprimé avec succès',
                'id' => $id
            ]);

            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la suppression',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/matchs/stats', name: 'matchs_stats', methods: ['GET', 'OPTIONS'])]
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

            $victoires = $em->getRepository(Matchs::class)
                ->createQueryBuilder('m')
                ->select('COUNT(m.id)')
                ->where('m.statut = :statut')
                ->andWhere('m.scoreDomicile IS NOT NULL')
                ->andWhere('m.scoreExterieur IS NOT NULL')
                ->andWhere(
                    '(m.equipe_domicile = :psg AND m.scoreDomicile > m.scoreExterieur) OR '.
                    '(m.equipe_exterieur = :psg AND m.scoreExterieur > m.scoreDomicile)'
                )
                ->setParameter('statut', 'termine')
                ->setParameter('psg', 'PSG')
                ->getQuery()
                ->getSingleScalarResult();

            $defaites = $em->getRepository(Matchs::class)
                ->createQueryBuilder('m')
                ->select('COUNT(m.id)')
                ->where('m.statut = :statut')
                ->andWhere('m.scoreDomicile IS NOT NULL')
                ->andWhere('m.scoreExterieur IS NOT NULL')
                ->andWhere(
                    '(m.equipe_domicile = :psg AND m.scoreDomicile < m.scoreExterieur) OR '.
                    '(m.equipe_exterieur = :psg AND m.scoreExterieur < m.scoreDomicile)'
                )
                ->setParameter('statut', 'termine')
                ->setParameter('psg', 'PSG')
                ->getQuery()
                ->getSingleScalarResult();

            $nuls = $em->getRepository(Matchs::class)
                ->createQueryBuilder('m')
                ->select('COUNT(m.id)')
                ->where('m.statut = :statut')
                ->andWhere('m.scoreDomicile IS NOT NULL')
                ->andWhere('m.scoreExterieur IS NOT NULL')
                ->andWhere('m.scoreDomicile = m.scoreExterieur')
                ->setParameter('statut', 'termine')
                ->getQuery()
                ->getSingleScalarResult();

            $prochainsMatchs = $em->getRepository(Matchs::class)
                ->createQueryBuilder('m')
                ->select('COUNT(m.id)')
                ->where('m.date_match > :now')
                ->andWhere('m.statut = :statut')
                ->setParameter('now', new \DateTime())
                ->setParameter('statut', 'programme')
                ->getQuery()
                ->getSingleScalarResult();

            $response = new JsonResponse([
                'totalMatchs' => (int)$totalMatchs,
                'matchsJoues' => (int)$matchsJoues,
                'victoires' => (int)$victoires,
                'defaites' => (int)$defaites,
                'nuls' => (int)$nuls,
                'prochainsMatchs' => (int)$prochainsMatchs,
                'pourcentageVictoires' => $matchsJoues > 0 ? round(($victoires / $matchsJoues) * 100, 1) : 0
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
}