<?php

namespace App\Controller;

use App\Entity\User;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class ApiController extends AbstractController
{
    private $entityManager;
    private $passwordHasher;

    public function __construct(EntityManagerInterface $entityManager, UserPasswordHasherInterface $passwordHasher)
    {
        $this->entityManager = $entityManager;
        $this->passwordHasher = $passwordHasher;
    }

    /**
     * Vérifie l'authentification avec le jeton d'API.
     * 
     * @Route("/api/check-auth", name="check_auth", methods={"GET"})
     */
    public function checkAuth(Request $request): JsonResponse
    {
        $token = $request->headers->get('Authorization');
        if (!$token) {
            return new JsonResponse(['error' => 'Token manquant'], JsonResponse::HTTP_UNAUTHORIZED);
        }

        $token = str_replace('Bearer ', '', $token);
        $user = $this->entityManager->getRepository(User::class)->findOneBy(['apiToken' => $token]);

        if (!$user) {
            return new JsonResponse(['error' => 'Utilisateur non trouvé'], JsonResponse::HTTP_UNAUTHORIZED);
        }

        return new JsonResponse([
            'status' => 'success',
            'role' => $user->getRole()
        ]);
    }

    /**
     * Inscrit un nouvel utilisateur.
    
     */
    public function register(Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        if (empty($data['email']) || empty($data['password']) || empty($data['role'])) {
            return new JsonResponse(['error' => 'Données invalides'], JsonResponse::HTTP_BAD_REQUEST);
        }

        $existingUser = $this->entityManager->getRepository(User::class)->findOneBy(['email' => $data['email']]);
        if ($existingUser) {
            return new JsonResponse(['error' => 'Un utilisateur avec cet email existe déjà'], JsonResponse::HTTP_CONFLICT);
        }

        $user = new User();
        $user->setEmail($data['email']);
        $user->setRole($data['role']);

        // Hachage du mot de passe
        $hashedPassword = $this->passwordHasher->hashPassword($user, $data['password']);
        $user->setPassword($hashedPassword);

        // Générer un token unique pour l'API
        $user->setApiToken(bin2hex(random_bytes(16)));

        $this->entityManager->persist($user);
        $this->entityManager->flush();

        return new JsonResponse(['message' => 'Utilisateur inscrit avec succès'], JsonResponse::HTTP_CREATED);
    }
}
