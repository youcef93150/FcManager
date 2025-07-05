<?php

namespace App\Controller;

use App\Entity\User;
use App\Repository\UserRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class LoginController extends AbstractController
{
    private $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    public function login(Request $request, UserRepository $userRepository): JsonResponse
    {
        // Gérer les requêtes OPTIONS pour CORS
        if ($request->getMethod() === 'OPTIONS') {
            $response = new JsonResponse();
            $response->headers->set('Access-Control-Allow-Origin', 'http://localhost:3000');
            $response->headers->set('Access-Control-Allow-Methods', 'POST, OPTIONS');
            $response->headers->set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
            return $response;
        }

        $data = json_decode($request->getContent(), true);
        $email = $data['email'] ?? null;
        $password = $data['password'] ?? null;

        if (!$email || !$password) {
            return new JsonResponse(['error' => 'Email et mot de passe requis'], JsonResponse::HTTP_BAD_REQUEST);
        }

        $user = $userRepository->findOneBy(['email' => $email]);

        if (!$user || !password_verify($password, $user->getPassword())) {
            return new JsonResponse(['error' => 'Identifiants incorrects'], JsonResponse::HTTP_UNAUTHORIZED);
        }

        // Génération d'un apiToken unique
        $token = bin2hex(random_bytes(32));
        $user->setApiToken($token);
        $this->entityManager->flush();

        $response = new JsonResponse([
            'status' => 'success',
            'message' => 'Connexion réussie',
            'token' => $token,
            'user' => [
                'id' => $user->getId(), 
                'email' => $user->getEmail(),
                'role' => $user->getRole()
            ]
        ]);

        // Headers CORS
        $response->headers->set('Access-Control-Allow-Origin', 'http://localhost:3000');
        $response->headers->set('Access-Control-Allow-Credentials', 'true');

        return $response;
    }

    public function register(Request $request, UserRepository $userRepository): JsonResponse
    {
        // Gérer les requêtes OPTIONS pour CORS
        if ($request->getMethod() === 'OPTIONS') {
            $response = new JsonResponse();
            $response->headers->set('Access-Control-Allow-Origin', 'http://localhost:3000');
            $response->headers->set('Access-Control-Allow-Methods', 'POST, OPTIONS');
            $response->headers->set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
            return $response;
        }

        $data = json_decode($request->getContent(), true);
        
        // Validation des données
        $email = $data['email'] ?? null;
        $password = $data['password'] ?? null;
        $nom = $data['nom'] ?? null;
        $prenom = $data['prenom'] ?? null;
        $role = $data['role'] ?? 'utilisateurs';

        if (!$email || !$password || !$nom || !$prenom) {
            return new JsonResponse(['error' => 'Tous les champs sont requis'], JsonResponse::HTTP_BAD_REQUEST);
        }

        // Vérifier si l'email existe déjà
        $existingUser = $userRepository->findOneBy(['email' => $email]);
        if ($existingUser) {
            return new JsonResponse(['error' => 'Un utilisateur avec cet email existe déjà'], JsonResponse::HTTP_CONFLICT);
        }

        // Créer le nouvel utilisateur
        $user = new User();
        $user->setEmail($email);
        $user->setPassword(password_hash($password, PASSWORD_DEFAULT));
        $user->setNom($nom);
        $user->setPrenom($prenom);
        $user->setRole($role);

        // Générer un token API
        $token = bin2hex(random_bytes(32));
        $user->setApiToken($token);

        // Sauvegarder en base
        $this->entityManager->persist($user);
        $this->entityManager->flush();

        $response = new JsonResponse([
            'status' => 'success',
            'message' => 'Inscription réussie',
            'token' => $token,
            'user' => [
                'id' => $user->getId(),
                'email' => $user->getEmail(),
                'nom' => $user->getNom(),
                'prenom' => $user->getPrenom(),
                'role' => $user->getRole()
            ]
        ]);

        // Headers CORS
        $response->headers->set('Access-Control-Allow-Origin', 'http://localhost:3000');
        $response->headers->set('Access-Control-Allow-Credentials', 'true');

        return $response;
    }
}