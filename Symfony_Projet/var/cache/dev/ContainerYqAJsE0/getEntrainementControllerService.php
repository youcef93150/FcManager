<?php

namespace ContainerYqAJsE0;

use Symfony\Component\DependencyInjection\Argument\RewindableGenerator;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\DependencyInjection\Exception\RuntimeException;

/**
 * @internal This class has been auto-generated by the Symfony Dependency Injection Component.
 */
class getEntrainementControllerService extends App_KernelDevDebugContainer
{
    /**
     * Gets the public 'App\Controller\EntrainementController' shared autowired service.
     *
     * @return \App\Controller\EntrainementController
     */
    public static function do($container, $lazyLoad = true)
    {
        include_once \dirname(__DIR__, 4).''.\DIRECTORY_SEPARATOR.'vendor'.\DIRECTORY_SEPARATOR.'symfony'.\DIRECTORY_SEPARATOR.'framework-bundle'.\DIRECTORY_SEPARATOR.'Controller'.\DIRECTORY_SEPARATOR.'AbstractController.php';
        include_once \dirname(__DIR__, 4).''.\DIRECTORY_SEPARATOR.'src'.\DIRECTORY_SEPARATOR.'Controller'.\DIRECTORY_SEPARATOR.'EntrainementController.php';

        $container->services['App\\Controller\\EntrainementController'] = $instance = new \App\Controller\EntrainementController();

        $instance->setContainer(($container->privates['.service_locator.ZyP9f7K'] ?? $container->load('get_ServiceLocator_ZyP9f7KService'))->withContext('App\\Controller\\EntrainementController', $container));

        return $instance;
    }
}
