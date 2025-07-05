<?php

namespace App\Controller;

use App\Entity\User;
use App\Repository\UserRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

/**
 * @Route("/api")
 */
class LoginController extends AbstractController
{
    private $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    private function setCorsHeaders(JsonResponse $response): void
    {
        // Obtenir l'origine de la requête
        $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
        
        // Liste des origines autorisées
        $allowedOrigins = [
            'http://localhost:3000',
            'http://localhost:5173',
            'https://fcmanager-production.up.railway.app'
        ];
        
        // Vérifier si l'origine est dans la liste ou si c'est un domaine Vercel
        if (in_array($origin, $allowedOrigins) || preg_match('/^https:\/\/.*\.vercel\.app$/', $origin)) {
            $response->headers->set('Access-Control-Allow-Origin', $origin);
        }
        
        $response->headers->set('Access-Control-Allow-Credentials', 'true');
        $response->headers->set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        $response->headers->set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    }

    /**
     * @Route("/login", name="api_login", methods={"POST", "OPTIONS"})
     */
    public function login(Request $request, UserRepository $userRepository): JsonResponse
    {
        // Gérer les requêtes OPTIONS pour CORS
        if ($request->getMethod() === 'OPTIONS') {
            $response = new JsonResponse();
            $this->setCorsHeaders($response);
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
        $this->setCorsHeaders($response);

        return $response;
    }

    /**
     * @Route("/register", name="api_register", methods={"POST", "OPTIONS"})
     */
    public function register(Request $request, UserRepository $userRepository): JsonResponse
    {
        // Gérer les requêtes OPTIONS pour CORS
        if ($request->getMethod() === 'OPTIONS') {
            $response = new JsonResponse();
            $this->setCorsHeaders($response);
            return $response;
        }

        $data = json_decode($request->getContent(), true);
        
        // Validation des données
        $email = $data['email'] ?? null;
        $password = $data['password'] ?? null;
        $nom = $data['nom'] ?? null;
        $prenom = $data['prenom'] ?? null;

        if (!$email || !$password || !$nom || !$prenom) {
            $response = new JsonResponse(['error' => 'Tous les champs sont requis'], JsonResponse::HTTP_BAD_REQUEST);
            $this->setCorsHeaders($response);
            return $response;
        }

        // Vérifier si l'utilisateur existe déjà
        $existingUser = $userRepository->findOneBy(['email' => $email]);
        if ($existingUser) {
            $response = new JsonResponse(['error' => 'Un compte avec cet email existe déjà'], JsonResponse::HTTP_CONFLICT);
            $this->setCorsHeaders($response);
            return $response;
        }

        // Créer le nouvel utilisateur
        $user = new User();
        $user->setEmail($email);
        $user->setPassword(password_hash($password, PASSWORD_DEFAULT));
        $user->setNom($nom);
        $user->setPrenom($prenom);
        $user->setRole('user'); // Par défaut
        
        // Générer un token
        $token = bin2hex(random_bytes(32));
        $user->setApiToken($token);

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
        ], JsonResponse::HTTP_CREATED);

        // Headers CORS
        $this->setCorsHeaders($response);

        return $response;
    }
}
