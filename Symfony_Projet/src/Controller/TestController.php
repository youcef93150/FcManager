<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;

class TestController extends AbstractController
{
    public function ping(): JsonResponse
    {
        return new JsonResponse(['message' => 'pong', 'timestamp' => time()]);
    }

    public function index(): Response
    {
        return new Response('Railway Symfony is working!');
    }
}
