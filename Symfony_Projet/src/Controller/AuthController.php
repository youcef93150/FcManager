<?php

namespace App\Controller;

use App\Entity\User;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Doctrine\ORM\EntityManagerInterface;

class AuthController extends AbstractController
{
    private $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    /**
     * Vérifie l'authentification avec le jeton d'API
     * 
     * @Route("/api/check-auth", name="check_auth", methods={"GET"})
     */
    public function checkAuth(Request $request): JsonResponse
    {
        // Récupérer le token depuis l'en-tête Authorization
        $token = $request->headers->get('Authorization');

        // Vérifier si le token est présent
        if (!$token) {
            return new JsonResponse(['error' => 'Token manquant'], JsonResponse::HTTP_UNAUTHORIZED);
        }

        // Supprimer 'Bearer ' pour ne conserver que le token
        $token = str_replace('Bearer ', '', $token);

        // Chercher l'utilisateur avec le token
        $user = $this->entityManager->getRepository(User::class)->findOneBy(['apiToken' => $token]);

        // Vérifier si l'utilisateur existe
        if (!$user) {
            return new JsonResponse(['error' => 'Utilisateur non trouvé'], JsonResponse::HTTP_UNAUTHORIZED);
        }

        // Si l'utilisateur est trouvé, retourner son rôle
        return new JsonResponse([
            'status' => 'success',
            'role' => $user->getRole() // Retourner le rôle de l'utilisateur
        ]);
    }
}
