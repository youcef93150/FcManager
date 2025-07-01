<?php

namespace App\Controller;

use App\Entity\Actualites;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class ActualitesController extends AbstractController
{
    private function addCorsHeaders(JsonResponse $response): JsonResponse
    {
        $response->headers->set('Access-Control-Allow-Origin', 'http://localhost:5173');
        $response->headers->set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        $response->headers->set('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
        return $response;
    }

    #[Route('/api/actualites', name: 'actualites_list', methods: ['GET', 'OPTIONS'])]
    public function getActualites(EntityManagerInterface $em): JsonResponse
    {
        try {
            $actualites = $em->getRepository(Actualites::class)
                ->findBy([], ['datePublication' => 'DESC']);

            $actualitesData = [];
            foreach ($actualites as $actualite) {
                $actualitesData[] = [
                    'id' => $actualite->getId(),
                    'titre' => $actualite->getTitre(),
                    'contenu' => $actualite->getContenu(),
                    'date_publication' => $actualite->getDatePublication()->format('Y-m-d\TH:i:s'), // Format ISO 8601
                    'auteur' => $actualite->getAuteur(),
                    'image_url' => $actualite->getImageUrl(),
                    'statut' => $actualite->getStatut(),
                    'likes' => $actualite->getLikes(),
                    'commentaires' => $actualite->getCommentaires(),
                    'created_at' => $actualite->getCreatedAt()->format('Y-m-d\TH:i:s'), // Format ISO 8601
                    'updated_at' => $actualite->getUpdatedAt()->format('Y-m-d\TH:i:s')  // Format ISO 8601
                ];
            }

            $response = new JsonResponse($actualitesData);
            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la récupération des actualités',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/actualites', name: 'actualites_create', methods: ['POST', 'OPTIONS'])]
    public function addActualite(Request $request, EntityManagerInterface $em): JsonResponse
    {
        try {
            $data = json_decode($request->getContent(), true);

            $requiredFields = ['titre', 'contenu', 'auteur'];
            foreach ($requiredFields as $field) {
                if (!isset($data[$field]) || empty($data[$field])) {
                    $response = new JsonResponse(['error' => "Le champ '$field' est obligatoire"], 400);
                    return $this->addCorsHeaders($response);
                }
            }

            $actualite = new Actualites();
            $actualite->setTitre($data['titre']);
            $actualite->setContenu($data['contenu']);
            $actualite->setAuteur($data['auteur']);
            
            if (isset($data['image_url'])) {
                $actualite->setImageUrl($data['image_url']);
            }
            
            if (isset($data['statut'])) {
                $actualite->setStatut($data['statut']);
            }

            $em->persist($actualite);
            $em->flush();

            $response = new JsonResponse([
                'id' => $actualite->getId(),
                'message' => 'Actualité créée avec succès',
                'data' => [
                    'titre' => $actualite->getTitre(),
                    'date_publication' => $actualite->getDatePublication()->format('Y-m-d\TH:i:s'),
                    'auteur' => $actualite->getAuteur()
                ]
            ], 201);

            return $this->addCorsHeaders($response);

        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la création de l\'actualité',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    #[Route('/api/actualites/{id}', name: 'actualites_update', methods: ['PUT', 'OPTIONS'])]
    public function updateActualite(int $id, Request $request, EntityManagerInterface $em): JsonResponse
    {
        try {
            $actualite = $em->getRepository(Actualites::class)->find($id);

            if (!$actualite) {
                $response = new JsonResponse(['error' => 'Actualité non trouvée'], 404);
                return $this->addCorsHeaders($response);
            }

            $data = json_decode($request->getContent(), true);

            if (isset($data['titre'])) {
                $actualite->setTitre($data['titre']);
            }
            if (isset($data['contenu'])) {
                $actualite->setContenu($data['contenu']);
            }
            if (isset($data['auteur'])) {
                $actualite->setAuteur($data['auteur']);
            }
            if (isset($data['image_url'])) {
                $actualite->setImageUrl($data['image_url']);
            }
            if (isset($data['statut'])) {
                $actualite->setStatut($data['statut']);
            }
            
            $actualite->setUpdatedAt(new \DateTime());
            
            $em->flush();

            $response = new JsonResponse([
                'message' => 'Actualité modifiée avec succès',
                'data' => [
                    'id' => $actualite->getId(),
                    'titre' => $actualite->getTitre(),
                    'date_publication' => $actualite->getDatePublication()->format('Y-m-d\TH:i:s'),
                    'auteur' => $actualite->getAuteur(),
                    'statut' => $actualite->getStatut()
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

    #[Route('/api/actualites/{id}', name: 'actualites_delete', methods: ['DELETE', 'OPTIONS'])]
    public function deleteActualite(int $id, EntityManagerInterface $em): JsonResponse
    {
        try {
            $actualite = $em->getRepository(Actualites::class)->find($id);

            if (!$actualite) {
                $response = new JsonResponse(['error' => 'Actualité non trouvée'], 404);
                return $this->addCorsHeaders($response);
            }

            $em->remove($actualite);
            $em->flush();

            $response = new JsonResponse([
                'message' => 'Actualité supprimée avec succès',
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
}