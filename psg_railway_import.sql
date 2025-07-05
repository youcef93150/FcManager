-- Fichier SQL nettoyé pour Railway MySQL
-- Application PSG - Import des données

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET FOREIGN_KEY_CHECKS=0;

-- Structure de la table `actualites`
CREATE TABLE `actualites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) NOT NULL,
  `contenu` longtext NOT NULL,
  `date_publication` datetime NOT NULL DEFAULT current_timestamp(),
  `auteur` varchar(100) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `statut` enum('brouillon','publie','archive') NOT NULL DEFAULT 'publie',
  `likes` int(11) NOT NULL DEFAULT 0,
  `commentaires` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Données de la table `actualites`
INSERT INTO `actualites` (`id`, `titre`, `contenu`, `date_publication`, `auteur`, `image_url`, `statut`, `likes`, `commentaires`, `created_at`, `updated_at`) VALUES
(1, 'Victoire éclatante 3-0 contre Lille', 'Le PSG s\'impose avec brio au Parc des Princes grâce à un triplé de Mbappé. Une performance exceptionnelle qui confirme les ambitions parisiennes pour cette saison.', '2025-06-17 18:32:17', 'PSG Media', '/images/psg-lille-3-0.jpg', 'publie', 1250, 89, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(2, 'Nouveau partenariat stratégique annoncé', 'Le club parisien renforce ses alliances commerciales pour les prochaines saisons avec un accord majeur qui va révolutionner l\'expérience des supporters.', '2025-06-17 18:32:17', 'Direction Commerciale', '/images/nouveau-partenariat.jpg', 'publie', 856, 45, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(3, 'Stage d\'été au Qatar confirmé', 'Les joueurs se prépareront dans des conditions optimales pour la nouvelle saison dans les installations ultramodernes de Doha.', '2025-06-17 18:32:17', 'Staff Technique', '/images/stage-qatar.jpg', 'publie', 967, 52, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(4, 'Nouveau centre d\'entraînement inauguré', 'Le PSG inaugure ses nouvelles installations d\'entraînement à Poissy, un complexe de dernière génération pour préparer l\'avenir du club.', '2025-06-17 18:32:17', 'PSG Infrastructure', '/images/centre-entrainement.jpg', 'publie', 743, 34, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(5, 'Mbappé prolonge son contrat', 'La star française s\'engage pour trois années supplémentaires avec le Paris Saint-Germain, confirmant son attachement au projet parisien.', '2025-06-17 18:32:17', 'PSG Official', '/images/mbappe-prolongation.jpg', 'publie', 2150, 156, '2025-06-17 18:32:17', '2025-06-17 18:32:17');

-- Structure de la table `doctrine_migration_versions`
CREATE TABLE `doctrine_migration_versions` (
  `version` varchar(191) NOT NULL,
  `executed_at` datetime DEFAULT NULL,
  `execution_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Structure de la table `entrainements`
CREATE TABLE `entrainements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titre` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `date_entrainement` datetime NOT NULL,
  `lieu` varchar(150) NOT NULL,
  `duree_minutes` int(11) NOT NULL DEFAULT 120,
  `statut` enum('planifie','en_cours','termine','annule') NOT NULL DEFAULT 'planifie',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure de la table `joueurs`
CREATE TABLE `joueurs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `poste` varchar(50) NOT NULL,
  `numero_maillot` int(11) DEFAULT NULL,
  `date_naissance` date DEFAULT NULL,
  `nationalite` varchar(100) DEFAULT NULL,
  `taille` int(11) DEFAULT NULL,
  `poids` int(11) DEFAULT NULL,
  `statut` enum('actif','blesse','suspendu','inactive') NOT NULL DEFAULT 'actif',
  `photo_url` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_maillot` (`numero_maillot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Données de la table `joueurs`
INSERT INTO `joueurs` (`id`, `nom`, `prenom`, `poste`, `numero_maillot`, `date_naissance`, `nationalite`, `taille`, `poids`, `statut`, `photo_url`, `created_at`, `updated_at`) VALUES
(1, 'Mbappé', 'Kylian', 'Attaquant', 7, '1998-12-20', 'France', 178, 73, 'actif', '/images/mbappe.jpg', '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(2, 'Neymar', 'Jr', 'Attaquant', 10, '1992-02-05', 'Brésil', 175, 68, 'actif', '/images/neymar.jpg', '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(3, 'Messi', 'Lionel', 'Attaquant', 30, '1987-06-24', 'Argentine', 170, 67, 'actif', '/images/messi.jpg', '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(4, 'Verratti', 'Marco', 'Milieu', 6, '1992-11-05', 'Italie', 165, 60, 'actif', '/images/verratti.jpg', '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(5, 'Marquinhos', 'Marcos', 'Défenseur', 5, '1994-05-14', 'Brésil', 183, 75, 'actif', '/images/marquinhos.jpg', '2025-06-17 18:32:17', '2025-06-17 18:32:17');

-- Structure de la table `product`
CREATE TABLE `product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `stock_quantity` int(11) NOT NULL DEFAULT 0,
  `image_url` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Données de la table `product`
INSERT INTO `product` (`id`, `name`, `description`, `price`, `category`, `stock_quantity`, `image_url`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Maillot Domicile PSG 2025', 'Maillot officiel du Paris Saint-Germain pour la saison 2025', 89.99, 'Maillots', 150, '/images/maillot-domicile.jpg', 1, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(2, 'Écharpe PSG Classique', 'Écharpe officielle aux couleurs du PSG', 19.99, 'Accessoires', 200, '/images/echarpe-psg.jpg', 1, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(3, 'Casquette PSG Logo', 'Casquette ajustable avec logo PSG brodé', 24.99, 'Accessoires', 100, '/images/casquette-psg.jpg', 1, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(4, 'Maillot Extérieur PSG 2025', 'Maillot extérieur officiel PSG', 89.99, 'Maillots', 120, '/images/maillot-exterieur.jpg', 1, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(5, 'Short Officiel PSG', 'Short de sport aux couleurs du PSG', 39.99, 'Maillots', 80, '/images/short-psg.jpg', 1, '2025-06-17 18:32:17', '2025-06-17 18:32:17');

-- Structure de la table `user`
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(180) NOT NULL,
  `roles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`roles`)),
  `password` varchar(255) NOT NULL,
  `nom` varchar(100) DEFAULT NULL,
  `prenom` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_IDENTIFIER_EMAIL` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Données de la table `user`
INSERT INTO `user` (`id`, `email`, `roles`, `password`, `nom`, `prenom`, `created_at`, `updated_at`) VALUES
(1, 'admin@psg.fr', '[\"ROLE_ADMIN\"]', '$2y$13$hash_example_admin', 'Admin', 'PSG', '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(2, 'user@psg.fr', '[\"ROLE_USER\"]', '$2y$13$hash_example_user', 'Fan', 'PSG', '2025-06-17 18:32:17', '2025-06-17 18:32:17');

SET FOREIGN_KEY_CHECKS=1;
