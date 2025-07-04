<?php

/**
 * This file has been auto-generated
 * by the Symfony Routing Component.
 */

return [
    false, // $matchHost
    [ // $staticRoutes
        '/api/login' => [[['_route' => 'api_login', '_controller' => 'App\\Controller\\LoginController::login'], null, ['POST' => 0, 'OPTIONS' => 1], null, false, false, null]],
        '/api/check-auth' => [[['_route' => 'auth_check', '_controller' => 'App\\Controller\\ApiController::checkAuth'], null, ['GET' => 0, 'OPTIONS' => 1], null, false, false, null]],
        '/api/dashboard/stats' => [[['_route' => 'dashboard_stats', '_controller' => 'App\\Controller\\DashboardController::getDashboardStats'], null, ['GET' => 0, 'OPTIONS' => 1], null, false, false, null]],
        '/api/dashboard/joueurs-stats' => [[['_route' => 'dashboard_joueurs_stats', '_controller' => 'App\\Controller\\DashboardController::getJoueursStats'], null, ['GET' => 0, 'OPTIONS' => 1], null, false, false, null]],
        '/api/dashboard/boutique-stats' => [[['_route' => 'dashboard_boutique_stats', '_controller' => 'App\\Controller\\DashboardController::getBoutiqueStats'], null, ['GET' => 0, 'OPTIONS' => 1], null, false, false, null]],
        '/api/joueurs' => [
            [['_route' => 'joueurs_list', '_controller' => 'App\\Controller\\JoueurController::getJoueurs'], null, ['GET' => 0, 'OPTIONS' => 1], null, false, false, null],
            [['_route' => 'joueurs_create', '_controller' => 'App\\Controller\\JoueurController::addJoueur'], null, ['POST' => 0, 'OPTIONS' => 1], null, false, false, null],
        ],
        '/api/produits' => [
            [['_route' => 'produits_list', '_controller' => 'App\\Controller\\BoutiqueAdminController::getProducts'], null, ['GET' => 0, 'OPTIONS' => 1], null, false, false, null],
            [['_route' => 'produits_create', '_controller' => 'App\\Controller\\BoutiqueAdminController::addProduct'], null, ['POST' => 0, 'OPTIONS' => 1], null, false, false, null],
        ],
        '/api/actualites' => [
            [['_route' => 'actualites_list', '_controller' => 'App\\Controller\\ActualitesController::getActualites'], null, ['GET' => 0, 'OPTIONS' => 1], null, false, false, null],
            [['_route' => 'actualites_create', '_controller' => 'App\\Controller\\ActualitesController::addActualite'], null, ['POST' => 0, 'OPTIONS' => 1], null, false, false, null],
        ],
        '/api/matchs' => [
            [['_route' => 'matchs_list', '_controller' => 'App\\Controller\\MatchsController::getMatchs'], null, ['GET' => 0, 'OPTIONS' => 1], null, false, false, null],
            [['_route' => 'matchs_create', '_controller' => 'App\\Controller\\MatchsController::createMatch'], null, ['POST' => 0, 'OPTIONS' => 1], null, false, false, null],
        ],
        '/api/entrainements' => [
            [['_route' => 'entrainements_list', '_controller' => 'App\\Controller\\EntrainementController::getEntrainements'], null, ['GET' => 0, 'OPTIONS' => 1], null, false, false, null],
            [['_route' => 'entrainements_create', '_controller' => 'App\\Controller\\EntrainementController::createEntrainement'], null, ['POST' => 0, 'OPTIONS' => 1], null, false, false, null],
        ],
    ],
    [ // $regexpList
        0 => '{^(?'
                .'|/api(?'
                    .'|/(?'
                        .'|\\.well\\-known/genid/([^/]++)(*:46)'
                        .'|errors/(\\d+)(*:65)'
                        .'|validation_errors/([^/]++)(*:98)'
                    .')'
                    .'|(?:/(index)(?:\\.([^/]++))?)?(*:134)'
                    .'|/(?'
                        .'|docs(?:\\.([^/]++))?(*:165)'
                        .'|contexts/([^.]+)(?:\\.(jsonld))?(*:204)'
                        .'|validation_errors/([^/]++)(?'
                            .'|(*:241)'
                        .')'
                        .'|joueurs/([^/]++)(?'
                            .'|(*:269)'
                        .')'
                        .'|produits/([^/]++)(?'
                            .'|(*:298)'
                            .'|/stock(*:312)'
                        .')'
                        .'|actualites/([^/]++)(?'
                            .'|(*:343)'
                        .')'
                        .'|matchs/(?'
                            .'|([^/]++)(?'
                                .'|(*:373)'
                            .')'
                            .'|stats(*:387)'
                        .')'
                        .'|entrainements/(?'
                            .'|([^/]++)(?'
                                .'|(*:424)'
                            .')'
                            .'|assigner(*:441)'
                            .'|retirer(*:456)'
                        .')'
                    .')'
                .')'
                .'|/_error/(\\d+)(?:\\.([^/]++))?(*:495)'
            .')/?$}sDu',
    ],
    [ // $dynamicRoutes
        46 => [[['_route' => 'api_genid', '_controller' => 'api_platform.action.not_exposed', '_api_respond' => 'true'], ['id'], ['GET' => 0, 'HEAD' => 1], null, false, true, null]],
        65 => [[['_route' => 'api_errors', '_controller' => 'api_platform.action.error_page'], ['status'], ['GET' => 0, 'HEAD' => 1], null, false, true, null]],
        98 => [[['_route' => 'api_validation_errors', '_controller' => 'api_platform.action.not_exposed'], ['id'], ['GET' => 0, 'HEAD' => 1], null, false, true, null]],
        134 => [[['_route' => 'api_entrypoint', '_controller' => 'api_platform.action.entrypoint', '_format' => '', '_api_respond' => 'true', 'index' => 'index'], ['index', '_format'], ['GET' => 0, 'HEAD' => 1], null, false, true, null]],
        165 => [[['_route' => 'api_doc', '_controller' => 'api_platform.action.documentation', '_format' => '', '_api_respond' => 'true'], ['_format'], ['GET' => 0, 'HEAD' => 1], null, false, true, null]],
        204 => [[['_route' => 'api_jsonld_context', '_controller' => 'api_platform.jsonld.action.context', '_format' => 'jsonld', '_api_respond' => 'true'], ['shortName', '_format'], ['GET' => 0, 'HEAD' => 1], null, false, true, null]],
        241 => [
            [['_route' => '_api_validation_errors_problem', '_controller' => 'api_platform.symfony.main_controller', '_format' => null, '_stateless' => true, '_api_resource_class' => 'ApiPlatform\\Validator\\Exception\\ValidationException', '_api_operation_name' => '_api_validation_errors_problem'], ['id'], ['GET' => 0], null, false, true, null],
            [['_route' => '_api_validation_errors_hydra', '_controller' => 'api_platform.symfony.main_controller', '_format' => null, '_stateless' => true, '_api_resource_class' => 'ApiPlatform\\Validator\\Exception\\ValidationException', '_api_operation_name' => '_api_validation_errors_hydra'], ['id'], ['GET' => 0], null, false, true, null],
            [['_route' => '_api_validation_errors_jsonapi', '_controller' => 'api_platform.symfony.main_controller', '_format' => null, '_stateless' => true, '_api_resource_class' => 'ApiPlatform\\Validator\\Exception\\ValidationException', '_api_operation_name' => '_api_validation_errors_jsonapi'], ['id'], ['GET' => 0], null, false, true, null],
        ],
        269 => [
            [['_route' => 'joueurs_update', '_controller' => 'App\\Controller\\JoueurController::updateJoueur'], ['id'], ['PUT' => 0, 'OPTIONS' => 1], null, false, true, null],
            [['_route' => 'joueurs_delete', '_controller' => 'App\\Controller\\JoueurController::deleteJoueur'], ['id'], ['DELETE' => 0, 'OPTIONS' => 1], null, false, true, null],
        ],
        298 => [[['_route' => 'produits_delete', '_controller' => 'App\\Controller\\BoutiqueAdminController::deleteProduct'], ['id'], ['DELETE' => 0, 'OPTIONS' => 1], null, false, true, null]],
        312 => [[['_route' => 'produits_update_stock', '_controller' => 'App\\Controller\\BoutiqueAdminController::updateStock'], ['id'], ['PUT' => 0, 'OPTIONS' => 1], null, false, false, null]],
        343 => [
            [['_route' => 'actualites_update', '_controller' => 'App\\Controller\\ActualitesController::updateActualite'], ['id'], ['PUT' => 0, 'OPTIONS' => 1], null, false, true, null],
            [['_route' => 'actualites_delete', '_controller' => 'App\\Controller\\ActualitesController::deleteActualite'], ['id'], ['DELETE' => 0, 'OPTIONS' => 1], null, false, true, null],
        ],
        373 => [
            [['_route' => 'matchs_update', '_controller' => 'App\\Controller\\MatchsController::updateMatch'], ['id'], ['PUT' => 0, 'OPTIONS' => 1], null, false, true, null],
            [['_route' => 'matchs_delete', '_controller' => 'App\\Controller\\MatchsController::deleteMatch'], ['id'], ['DELETE' => 0, 'OPTIONS' => 1], null, false, true, null],
        ],
        387 => [[['_route' => 'matchs_stats', '_controller' => 'App\\Controller\\MatchsController::getMatchsStats'], [], ['GET' => 0, 'OPTIONS' => 1], null, false, false, null]],
        424 => [
            [['_route' => 'entrainements_update', '_controller' => 'App\\Controller\\EntrainementController::updateEntrainement'], ['id'], ['PUT' => 0, 'OPTIONS' => 1], null, false, true, null],
            [['_route' => 'entrainements_delete', '_controller' => 'App\\Controller\\EntrainementController::deleteEntrainement'], ['id'], ['DELETE' => 0, 'OPTIONS' => 1], null, false, true, null],
        ],
        441 => [[['_route' => 'entrainements_assign', '_controller' => 'App\\Controller\\EntrainementController::assignerJoueurEntrainement'], [], ['POST' => 0, 'OPTIONS' => 1], null, false, false, null]],
        456 => [[['_route' => 'entrainements_remove', '_controller' => 'App\\Controller\\EntrainementController::retirerJoueurEntrainement'], [], ['POST' => 0, 'OPTIONS' => 1], null, false, false, null]],
        495 => [
            [['_route' => '_preview_error', '_controller' => 'error_controller::preview', '_format' => 'html'], ['code', '_format'], null, null, false, true, null],
            [null, null, null, null, false, false, 0],
        ],
    ],
    null, // $checkCondition
];
