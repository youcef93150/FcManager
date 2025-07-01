<?php

namespace App\Controller;

use App\Entity\Entrainements;
use App\Entity\EntrainementJoueurs;
use App\Entity\Joueurs;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class EntrainementController extends AbstractController
{
    private function addCorsHeaders(JsonResponse $response): JsonResponse
    {
        $response->headers->set('Access-Control-Allow-Origin', 'http://localhost:5173');
        $response->headers->set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        $response->headers->set('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
        return $response;
    }

    #[Route('/api/entrainements', name: 'api_entrainements_list', methods: ['GET', 'OPTIONS'])]
    public function getEntrainements(EntityManagerInterface $em): JsonResponse
    {
        try {
            $entrainements = $em->getRepository(Entrainements::class)
                ->findBy([], ['dateEntrainement' => 'ASC']);

            $entrainementsData = [];
            foreach ($entrainements as $entrainement) {
                // Récupérer les joueurs convoqués
                $joueursConvoques = $em->createQueryBuilder()
                    ->select('j.id, j.nom, j.prenom, ej.present, ej.excuse')
                    ->from(EntrainementJoueurs::class, 'ej')
                    ->join(Joueurs::class, 'j', 'WITH', 'j.id = ej.joueurId')
                    ->where('ej.entrainementId = :entrainementId')
                    ->setParameter('entrainementId', $entrainement->getId())
                    ->getQuery()
                    ->getResult();

                $entrainementsData[] = [
                    'id' => $entrainement->getId(),
                    'titre' => $entrainement->getTitre(),
                    'description' => $entrainement->getDescription(),
                    'date_entrainement' => $entrainement->getDateEntrainement()->format('Y-m-d H:i:s'),
                    'lieu' => $entrainement->getLieu(),
                    'duree_minutes' => $entrainement->getDureeMinutes(),
                    'type_entrainement' => $entrainement->getStatut(),
                    'statut' => $entrainement->getStatut(),
                    'joueurs_convoques' => $joueursConvoques,
                    'nb_joueurs_convoques' => count($joueursConvoques)
                ];
            }

            $response = new JsonResponse($entrainementsData);
            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la récupération des entraînements',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/entrainements', name: 'api_entrainements_add', methods: ['POST', 'OPTIONS'])]
    public function addEntrainement(Request $request, EntityManagerInterface $em): JsonResponse
    {
        try {
            $data = json_decode($request->getContent(), true);

            $requiredFields = ['titre', 'date_entrainement', 'lieu', 'type_entrainement'];
            foreach ($requiredFields as $field) {
                if (!isset($data[$field]) || empty($data[$field])) {
                    $response = new JsonResponse(['error' => "Le champ '$field' est obligatoire"], 400);
                    return $this->addCorsHeaders($response);
                }
            }

            $entrainement = new Entrainements();
            $entrainement->setTitre($data['titre']);
            $entrainement->setDescription($data['description'] ?? '');
            $entrainement->setDateEntrainement(new \DateTime($data['date_entrainement']));
            $entrainement->setLieu($data['lieu']);
            $entrainement->setDureeMinutes($data['duree_minutes'] ?? 120);
            $entrainement->setTypeEntrainement($data['type_entrainement']);

            $em->persist($entrainement);
            $em->flush();

            // Assigner les joueurs si fournis
            if (isset($data['joueurs_ids']) && is_array($data['joueurs_ids'])) {
                foreach ($data['joueurs_ids'] as $joueurId) {
                    $entrainementJoueur = new EntrainementJoueurs();
                    $entrainementJoueur->setEntrainementId($entrainement->getId());
                    $entrainementJoueur->setJoueurId($joueurId);
                    
                    $em->persist($entrainementJoueur);
                }
                $em->flush();
            }

            $response = new JsonResponse([
                'id' => $entrainement->getId(),
                'message' => 'Entraînement créé avec succès',
                'data' => [
                    'titre' => $entrainement->getTitre(),
                    'date_entrainement' => $entrainement->getDateEntrainement()->format('Y-m-d H:i:s'),
                    'lieu' => $entrainement->getLieu(),
                    'nb_joueurs_assignes' => count($data['joueurs_ids'] ?? [])
                ]
            ], 201);

            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la création de l\'entraînement',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/entrainements/{id}', name: 'api_entrainements_update', methods: ['PUT', 'OPTIONS'])]
    public function updateEntrainement(int $id, Request $request, EntityManagerInterface $em): JsonResponse
    {
        try {
            $entrainement = $em->getRepository(Entrainements::class)->find($id);

            if (!$entrainement) {
                $response = new JsonResponse(['error' => 'Entraînement non trouvé'], 404);
                return $this->addCorsHeaders($response);
            }

            $data = json_decode($request->getContent(), true);

            if (isset($data['titre'])) {
                $entrainement->setTitre($data['titre']);
            }
            if (isset($data['description'])) {
                $entrainement->setDescription($data['description']);
            }
            if (isset($data['date_entrainement'])) {
                $entrainement->setDateEntrainement(new \DateTime($data['date_entrainement']));
            }
            if (isset($data['lieu'])) {
                $entrainement->setLieu($data['lieu']);
            }
            if (isset($data['duree_minutes'])) {
                $entrainement->setDureeMinutes($data['duree_minutes']);
            }
            if (isset($data['type_entrainement'])) {
                $entrainement->setTypeEntrainement($data['type_entrainement']);
            }
            if (isset($data['statut'])) {
                $entrainement->setStatut($data['statut']);
            }

            $entrainement->setUpdatedAt(new \DateTime());
            $em->flush();

            $response = new JsonResponse([
                'message' => 'Entraînement modifié avec succès',
                'data' => [
                    'id' => $entrainement->getId(),
                    'titre' => $entrainement->getTitre(),
                    'date_entrainement' => $entrainement->getDateEntrainement()->format('Y-m-d H:i:s')
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

    #[Route('/api/entrainements/{id}', name: 'api_entrainements_delete', methods: ['DELETE', 'OPTIONS'])]
    public function deleteEntrainement(int $id, EntityManagerInterface $em): JsonResponse
    {
        try {
            $entrainement = $em->getRepository(Entrainements::class)->find($id);

            if (!$entrainement) {
                $response = new JsonResponse(['error' => 'Entraînement non trouvé'], 404);
                return $this->addCorsHeaders($response);
            }

            $em->remove($entrainement);
            $em->flush();

            $response = new JsonResponse([
                'message' => 'Entraînement supprimé avec succès',
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

    #[Route('/api/entrainements/assigner', name: 'api_entrainements_assigner', methods: ['POST', 'OPTIONS'])]
    public function assignerJoueurEntrainement(Request $request, EntityManagerInterface $em): JsonResponse
    {
        try {
            $data = json_decode($request->getContent(), true);

            if (empty($data['entrainement_id']) || empty($data['joueur_id'])) {
                $response = new JsonResponse([
                    'error' => 'Les champs entrainement_id et joueur_id sont obligatoires'
                ], 400);
                return $this->addCorsHeaders($response);
            }

            $entrainement = $em->getRepository(Entrainements::class)->find($data['entrainement_id']);
            $joueur = $em->getRepository(Joueurs::class)->find($data['joueur_id']);

            if (!$entrainement || !$joueur) {
                $response = new JsonResponse(['error' => 'Entraînement ou joueur non trouvé'], 404);
                return $this->addCorsHeaders($response);
            }

            $existingAssignment = $em->getRepository(EntrainementJoueurs::class)
                ->findOneBy([
                    'entrainementId' => $data['entrainement_id'],
                    'joueurId' => $data['joueur_id']
                ]);

            if ($existingAssignment) {
                $response = new JsonResponse(['error' => 'Joueur déjà assigné à cet entraînement'], 409);
                return $this->addCorsHeaders($response);
            }

            $entrainementJoueur = new EntrainementJoueurs();
            $entrainementJoueur->setEntrainementId($data['entrainement_id']);
            $entrainementJoueur->setJoueurId($data['joueur_id']);

            $em->persist($entrainementJoueur);
            $em->flush();

            $response = new JsonResponse([
                'message' => 'Joueur assigné avec succès',
                'data' => [
                    'entrainement' => $entrainement->getTitre(),
                    'joueur' => $joueur->getPrenom() . ' ' . $joueur->getNom()
                ]
            ], 201);

            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de l\'assignation',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/entrainements/retirer', name: 'api_entrainements_retirer', methods: ['POST', 'OPTIONS'])]
    public function retirerJoueurEntrainement(Request $request, EntityManagerInterface $em): JsonResponse
    {
        try {
            $data = json_decode($request->getContent(), true);

            if (empty($data['entrainement_id']) || empty($data['joueur_id'])) {
                $response = new JsonResponse([
                    'error' => 'Les champs entrainement_id et joueur_id sont obligatoires'
                ], 400);
                return $this->addCorsHeaders($response);
            }

            $assignment = $em->getRepository(EntrainementJoueurs::class)
                ->findOneBy([
                    'entrainementId' => $data['entrainement_id'],
                    'joueurId' => $data['joueur_id']
                ]);

            if (!$assignment) {
                $response = new JsonResponse(['error' => 'Assignation non trouvée'], 404);
                return $this->addCorsHeaders($response);
            }

            $em->remove($assignment);
            $em->flush();

            $response = new JsonResponse([
                'message' => 'Joueur retiré avec succès de l\'entraînement'
            ]);

            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors du retrait',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }
}