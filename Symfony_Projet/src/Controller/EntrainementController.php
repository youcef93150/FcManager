<?php

namespace App\Controller;

use App\Entity\Entrainement;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class EntrainementController extends AbstractController
{
    #[Route('/api/entrainements', name: 'entrainements_list', methods: ['GET'])]
    public function getEntrainements(EntityManagerInterface $em): JsonResponse
    {
        try {
            $entrainements = $em->getRepository(Entrainement::class)->findAll();
            
            $entrainementsArray = [];
            foreach ($entrainements as $entrainement) {
                $entrainementsArray[] = [
                    'id' => $entrainement->getId(),
                    'titre' => $entrainement->getTitre(),
                    'description' => $entrainement->getDescription(),
                    'date_entrainement' => $entrainement->getDateEntrainement()->format('Y-m-d H:i:s'),
                    'lieu' => $entrainement->getLieu(),
                    'duree_minutes' => $entrainement->getDureeMinutes(),
                    'type_entrainement' => $entrainement->getTypeEntrainement(),
                    'created_at' => $entrainement->getCreatedAt()->format('Y-m-d H:i:s')
                ];
            }
            
            return new JsonResponse($entrainementsArray);
            
        } catch (\Exception $e) {
            return new JsonResponse([
                'error' => 'Erreur lors de la récupération des entraînements',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    #[Route('/api/entrainements', name: 'entrainements_create', methods: ['POST'])]
    public function createEntrainement(Request $request, EntityManagerInterface $em): JsonResponse
    {
        try {
            $data = json_decode($request->getContent(), true);
            
            if (!$data) {
                return new JsonResponse(['error' => 'Données JSON invalides'], 400);
            }
            
            $entrainement = new Entrainement();
            
            if (isset($data['titre']) && !empty($data['titre'])) {
                $entrainement->setTitre($data['titre']);
            } else {
                return new JsonResponse(['error' => 'Titre obligatoire'], 400);
            }
            
            if (isset($data['description'])) {
                $entrainement->setDescription($data['description']);
            }
            
            if (isset($data['date_entrainement']) && !empty($data['date_entrainement'])) {
                try {
                    $entrainement->setDateEntrainement(new \DateTime($data['date_entrainement']));
                } catch (\Exception $e) {
                    return new JsonResponse(['error' => 'Format de date invalide'], 400);
                }
            } else {
                return new JsonResponse(['error' => 'Date d\'entraînement obligatoire'], 400);
            }
            
            if (isset($data['lieu']) && !empty($data['lieu'])) {
                $entrainement->setLieu($data['lieu']);
            } else {
                return new JsonResponse(['error' => 'Lieu obligatoire'], 400);
            }
            
            if (isset($data['duree_minutes'])) {
                $entrainement->setDureeMinutes((int)$data['duree_minutes']);
            }
            
            if (isset($data['type_entrainement']) && !empty($data['type_entrainement'])) {
                $entrainement->setTypeEntrainement($data['type_entrainement']);
            } else {
                return new JsonResponse(['error' => 'Type d\'entraînement obligatoire'], 400);
            }
            
            $em->persist($entrainement);
            $em->flush();
            
            return new JsonResponse([
                'message' => 'Entraînement créé avec succès',
                'id' => $entrainement->getId()
            ], 201);
            
        } catch (\Exception $e) {
            return new JsonResponse([
                'error' => 'Erreur lors de la création',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    #[Route('/api/entrainements/{id}', name: 'entrainements_delete', methods: ['DELETE'])]
    public function deleteEntrainement(int $id, EntityManagerInterface $em): JsonResponse
    {
        try {
            $entrainement = $em->getRepository(Entrainement::class)->find($id);
            
            if (!$entrainement) {
                return new JsonResponse(['error' => 'Entraînement non trouvé'], 404);
            }
            
            $em->remove($entrainement);
            $em->flush();
            
            return new JsonResponse(['message' => 'Entraînement supprimé avec succès']);
            
        } catch (\Exception $e) {
            return new JsonResponse([
                'error' => 'Erreur lors de la suppression',
                'details' => $e->getMessage()
            ], 500);
        }
    }
}