<?php

namespace App\Controller;

use App\Entity\Joueurs;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class JoueurController extends AbstractController
{
    #[Route('/api/joueurs', name: 'get_joueurs', methods: ['GET'])]
    public function getJoueurs(EntityManagerInterface $entityManager): JsonResponse
    {
        $joueurs = $entityManager->getRepository(Joueurs::class)->findAll();
        $joueursData = array_map(function ($joueur) {
            return [
                'id' => $joueur->getId(),
                'nom' => $joueur->getNom(),
                'prenom' => $joueur->getPrenom(),
                'poste' => $joueur->getPoste(),
                'equipe' => $joueur->getEquipe(),
                'pays_origine' => $joueur->getPaysOrigine(), 
                'age' => $joueur->getAge(),
                'taille_cm' => $joueur->getTailleCm(),
                'poids_kg' => $joueur->getPoidsKg(),
                'numero_maillot' => $joueur->getNumeroMaillot(),
            ];
        }, $joueurs);

        return new JsonResponse($joueursData);
    }

    #[Route('/api/joueurs', name: 'add_joueur', methods: ['POST'])]
    public function addJoueur(Request $request, EntityManagerInterface $entityManager): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        $joueur = new Joueurs();
        $joueur->setNom($data['nom']);
        $joueur->setPrenom($data['prenom']);
        $joueur->setPoste($data['poste']);
        $joueur->setEquipe($data['equipe']);
        $joueur->setPaysOrigine($data['pays_origine']); 
        $joueur->setAge($data['age']);
        $joueur->setTailleCm($data['taille_cm']);
        $joueur->setPoidsKg($data['poids_kg']);
        $joueur->setNumeroMaillot($data['numero_maillot']);

        $entityManager->persist($joueur);
        $entityManager->flush();

        return new JsonResponse(['message' => 'Joueur ajouté avec succès'], 201);
    }

    #[Route('/api/joueurs/{id}', name: 'update_joueur', methods: ['PUT'])]
    public function updateJoueur(int $id, Request $request, EntityManagerInterface $entityManager): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $joueur = $entityManager->getRepository(Joueurs::class)->find($id);

        if (!$joueur) {
            return new JsonResponse(['message' => 'Joueur non trouvé'], 404);
        }

        $joueur->setNom($data['nom']);
        $joueur->setPrenom($data['prenom']);
        $joueur->setPoste($data['poste']);
        $joueur->setEquipe($data['equipe']);
        $joueur->setPaysOrigine($data['pays_origine']); 
        $joueur->setAge($data['age']);
        $joueur->setTailleCm($data['taille_cm']);
        $joueur->setPoidsKg($data['poids_kg']);
        $joueur->setNumeroMaillot($data['numero_maillot']);

        $entityManager->flush();

        return new JsonResponse(['message' => 'Joueur modifié avec succès']);
    }

    #[Route('/api/joueurs/{id}', name: 'delete_joueur', methods: ['DELETE'])]
    public function deleteJoueur(int $id, EntityManagerInterface $entityManager): JsonResponse
    {
        $joueur = $entityManager->getRepository(Joueurs::class)->find($id);

        if (!$joueur) {
            return new JsonResponse(['message' => 'Joueur non trouvé'], 404);
        }

        $entityManager->remove($joueur);
        $entityManager->flush();

        return new JsonResponse(['message' => 'Joueur supprimé avec succès']);
    }
}
