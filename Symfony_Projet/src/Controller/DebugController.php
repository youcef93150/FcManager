<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class DebugController extends AbstractController
{
    /**
     * @Route("/api/debug-headers", name="debug_headers", methods={"GET"})
     */
    public function debugHeaders(Request $request): JsonResponse
    {
        return new JsonResponse([
            'headers' => $request->headers->all(),
            'server' => $_SERVER,
            'authorization' => $request->headers->get('Authorization'),
            'http_authorization' => $_SERVER['HTTP_AUTHORIZATION'] ?? 'not set',
            'redirect_http_authorization' => $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] ?? 'not set',
        ]);
    }
}
