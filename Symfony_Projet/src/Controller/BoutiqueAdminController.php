<?php

namespace App\Controller;

use App\Entity\Product;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;

class BoutiqueAdminController extends AbstractController
{
    private function addCorsHeaders(JsonResponse $response): JsonResponse
    {
        $response->headers->set('Access-Control-Allow-Origin', 'http://localhost:5173');
        $response->headers->set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        $response->headers->set('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
        return $response;
    }

    public function addProduct(Request $request, EntityManagerInterface $em): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        $requiredFields = ['nom', 'prix', 'taille', 'couleur', 'description', 'stock'];
        foreach ($requiredFields as $field) {
            if (!isset($data[$field])) {
                return $this->json(['error' => "Le champ '$field' est manquant."], 400);
            }
        }

        $product = new Product();
        $product->setNom($data['nom']);
        $product->setPrix((float) $data['prix']);
        $product->setTaille($data['taille']);
        $product->setCouleur($data['couleur']);
        $product->setDescription($data['description']);
        $product->setStock((int) $data['stock']);

        $em->persist($product);
        $em->flush();

        return $this->json([
            'id' => $product->getId(),
            'message' => 'Produit ajouté avec succès',
        ]);
    }

    public function getProducts(EntityManagerInterface $em): JsonResponse
    {
        try {
            $products = $em->getRepository(Product::class)->findAll();
            
            $productsData = [];
            foreach ($products as $product) {
                $productsData[] = [
                    'id' => $product->getId(),
                    'nom' => $product->getNom(),
                    'prix' => $product->getPrix(),
                    'taille' => $product->getTaille(),
                    'couleur' => $product->getCouleur(),
                    'description' => $product->getDescription(),
                    'stock' => $product->getStock()
                ];
            }
            
            $response = new JsonResponse($productsData);
            return $this->addCorsHeaders($response);
            
        } catch (\Exception $e) {
            $response = new JsonResponse([
                'error' => 'Erreur lors de la récupération des produits',
                'details' => $e->getMessage()
            ], 500);
            return $this->addCorsHeaders($response);
        }
    }

    public function deleteProduct(int $id, EntityManagerInterface $em): JsonResponse
    {
        $product = $em->getRepository(Product::class)->find($id);

        if (!$product) {
            return $this->json(['error' => 'Produit non trouvé'], 404);
        }

        $em->remove($product);
        $em->flush();

        return $this->json(['message' => 'Produit supprimé avec succès']);
    }

   // Méthode mise à jour du stock
    public function updateStock(Request $request, int $id, EntityManagerInterface $em): JsonResponse
    {
    $product = $em->getRepository(Product::class)->find($id);
    if (!$product) {
        return $this->json(['error' => 'Produit non trouvé'], 404);
    }

    $data = json_decode($request->getContent(), true);

    if (!isset($data['stock'])) {
        return $this->json(['error' => "Le champ 'stock' est manquant."], 400);
    }

    $product->setStock((int)$data['stock']);
    $em->flush();

    return $this->json(['message' => 'Stock mis à jour avec succès', 'product' => $product]);
}

}
