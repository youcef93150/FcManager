-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : ven. 04 juil. 2025 à 16:40
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `vue_psg`
--

-- --------------------------------------------------------

--
-- Structure de la table `actualites`
--

CREATE TABLE `actualites` (
  `id` int(11) NOT NULL,
  `titre` varchar(255) NOT NULL,
  `contenu` longtext NOT NULL,
  `date_publication` datetime NOT NULL DEFAULT current_timestamp(),
  `auteur` varchar(100) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `statut` enum('brouillon','publie','archive') NOT NULL DEFAULT 'publie',
  `likes` int(11) NOT NULL DEFAULT 0,
  `commentaires` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `actualites`
--

INSERT INTO `actualites` (`id`, `titre`, `contenu`, `date_publication`, `auteur`, `image_url`, `statut`, `likes`, `commentaires`, `created_at`, `updated_at`) VALUES
(1, 'Victoire éclatante 3-0 contre Lille', 'Le PSG s\'impose avec brio au Parc des Princes grâce à un triplé de Mbappé. Une performance exceptionnelle qui confirme les ambitions parisiennes pour cette saison.', '2025-06-17 18:32:17', 'PSG Media', '/images/psg-lille-3-0.jpg', 'publie', 1250, 89, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(2, 'Nouveau partenariat stratégique annoncé', 'Le club parisien renforce ses alliances commerciales pour les prochaines saisons avec un accord majeur qui va révolutionner l\'expérience des supporters.', '2025-06-17 18:32:17', 'Direction Commerciale', '/images/nouveau-partenariat.jpg', 'publie', 856, 45, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(3, 'Stage d\'été au Qatar confirmé', 'Les joueurs se prépareront dans des conditions optimales pour la nouvelle saison dans les installations ultramodernes de Doha.', '2025-06-17 18:32:17', 'Staff Technique', '/images/stage-qatar.jpg', 'publie', 967, 52, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(4, 'Nouveau centre d\'entraînement inauguré', 'Le PSG inaugure ses nouvelles installations d\'entraînement à Poissy, un complexe de dernière génération pour préparer l\'avenir du club.', '2025-06-17 18:32:17', 'PSG Infrastructure', '/images/centre-entrainement.jpg', 'publie', 743, 34, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(5, 'Mbappé prolonge son contrat', 'La star française s\'engage pour trois années supplémentaires avec le Paris Saint-Germain, confirmant son attachement au projet parisien.', '2025-06-17 18:32:17', 'PSG Official', '/images/mbappe-prolongation.jpg', 'publie', 2150, 156, '2025-06-17 18:32:17', '2025-06-17 18:32:17'),
(6, 'Bienvenue sur le nouveau dashboard', 'Le système de gestion PSG est maintenant opérationnel avec toutes les fonctionnalités!', '2025-06-17 18:57:42', 'Admin', NULL, 'publie', 125, 15, '2025-06-17 18:57:42', '2025-06-17 18:57:42'),
(7, 'Préparation de la nouvelle saison', 'L\'équipe se prépare intensivement pour la saison 2025-2026 qui approche à grands pas.', '2025-06-17 18:57:42', 'PSG Media', NULL, 'publie', 89, 7, '2025-06-17 18:57:42', '2025-06-17 18:57:42'),
(10, 'aaa', 'qqqq', '2025-07-01 11:00:38', 'qqqqwww', NULL, 'publie', 0, 0, '2025-07-01 11:00:38', '2025-07-01 11:00:38'),
(11, 'momo', 'momomo', '2025-07-01 16:42:28', 'momomomomo', NULL, 'publie', 0, 0, '2025-07-01 16:42:28', '2025-07-01 16:42:28');

-- --------------------------------------------------------

--
-- Structure de la table `doctrine_migration_versions`
--

CREATE TABLE `doctrine_migration_versions` (
  `version` varchar(191) NOT NULL,
  `executed_at` datetime DEFAULT NULL,
  `execution_time` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `doctrine_migration_versions`
--

INSERT INTO `doctrine_migration_versions` (`version`, `executed_at`, `execution_time`) VALUES
('DoctrineMigrations\\Version20241206153243', '2024-12-19 11:41:30', 70),
('DoctrineMigrations\\Version20241225131239', '2024-12-25 14:12:59', 68),
('DoctrineMigrations\\Version20241225132856', '2024-12-25 14:29:03', 10),
('DoctrineMigrations\\Version20241225133359', '2024-12-25 14:34:05', 11),
('DoctrineMigrations\\Version20241227123535', '2024-12-27 13:35:39', 59),
('DoctrineMigrations\\Version20241230164354', '2024-12-30 17:43:59', 6),
('DoctrineMigrations\\Version20241231113054', '2024-12-31 12:30:59', 93),
('DoctrineMigrations\\Version20241231113514', '2024-12-31 12:35:17', 5),
('DoctrineMigrations\\Version20241231134710', '2024-12-31 14:47:12', 20),
('DoctrineMigrations\\Version20241231135013', '2024-12-31 14:50:15', 6),
('DoctrineMigrations\\Version20241231144001', '2024-12-31 15:40:04', 22);

-- --------------------------------------------------------

--
-- Structure de la table `entrainements`
--

CREATE TABLE `entrainements` (
  `id` int(11) NOT NULL,
  `titre` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `date_entrainement` datetime NOT NULL,
  `lieu` varchar(150) NOT NULL,
  `duree_minutes` int(11) NOT NULL DEFAULT 120,
  `type_entrainement` varchar(50) NOT NULL,
  `joueurs_convoques` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`joueurs_convoques`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `statut` varchar(20) DEFAULT 'programme',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `entrainements`
--

INSERT INTO `entrainements` (`id`, `titre`, `description`, `date_entrainement`, `lieu`, `duree_minutes`, `type_entrainement`, `joueurs_convoques`, `created_at`, `statut`, `updated_at`) VALUES
(2, 'Entraînement Tactique', 'Travail sur les phases offensives', '2025-06-25 10:00:00', 'Centre d\'entraînement Ooredoo', 120, 'Tactique', NULL, '2025-06-19 10:38:41', 'programme', '2025-06-19 10:38:41'),
(5, 'Séance Physique', 'Renforcement musculaire et endurance', '2025-06-22 09:30:00', 'Centre d\'entraînement Ooredoo', 90, 'Physique', NULL, '2025-06-19 10:50:27', 'programme', '2025-06-19 10:50:27'),
(6, 'Préparation Match', 'Préparation tactique pour le prochain match', '2025-06-24 15:00:00', 'Parc des Princes', 150, 'Préparation match', NULL, '2025-06-19 10:50:27', 'programme', '2025-06-19 10:50:27'),
(7, 'ppp', 'aaaa', '2025-06-20 08:00:00', 'Parc des Princes', 120, 'Technique', NULL, '2025-06-19 10:56:39', 'programme', '2025-06-19 10:56:39'),
(8, 'qsdaaaaaaa', 'dddddddddddddddddddddddddddddddddddddddddddddd', '2025-07-02 08:00:00', 'Centre d\'entraînement Ooredoo', 120, 'Physique', NULL, '2025-07-01 12:37:38', 'programme', '2025-07-01 12:37:38');

-- --------------------------------------------------------

--
-- Structure de la table `entrainement_joueurs`
--

CREATE TABLE `entrainement_joueurs` (
  `id` int(11) NOT NULL,
  `entrainement_id` int(11) NOT NULL,
  `joueur_id` int(11) NOT NULL,
  `present` tinyint(1) DEFAULT 0,
  `excuse` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `entrainement_joueurs`
--

INSERT INTO `entrainement_joueurs` (`id`, `entrainement_id`, `joueur_id`, `present`, `excuse`, `created_at`) VALUES
(6, 7, 11, 0, NULL, '2025-06-19 10:56:39'),
(7, 7, 10, 0, NULL, '2025-06-19 10:56:39'),
(8, 7, 12, 0, NULL, '2025-06-19 10:56:39'),
(9, 7, 14, 0, NULL, '2025-06-19 10:56:39');

-- --------------------------------------------------------

--
-- Structure de la table `joueurs`
--

CREATE TABLE `joueurs` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `poste` varchar(50) NOT NULL,
  `equipe` varchar(100) NOT NULL,
  `pays_origine` varchar(100) NOT NULL,
  `age` int(11) NOT NULL,
  `taille_cm` int(11) NOT NULL,
  `poids_kg` decimal(5,2) NOT NULL,
  `numero_maillot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `joueurs`
--

INSERT INTO `joueurs` (`id`, `nom`, `prenom`, `poste`, `equipe`, `pays_origine`, `age`, `taille_cm`, `poids_kg`, `numero_maillot`) VALUES
(1, 'Mbappe', 'Kylian', 'Attaquant', 'PSG', 'France', 24, 178, 73.50, 7),
(2, 'Donnarumma', 'Gianluigi', 'Gardien', 'PSG', 'Italie', 24, 196, 90.00, 99),
(3, 'Hakimi', 'Achraf', 'Défenseur', 'PSG', 'Maroc', 25, 181, 70.00, 2),
(4, 'Marquinhos', 'aos correa', 'Défenseur', 'PSG', 'Brésil', 29, 183, 75.00, 5),
(5, 'Verratti', 'Marco', 'Milieu', 'PSG', 'Italie', 31, 165, 60.00, 6),
(6, 'Ramos', 'Sergio', 'Défenseur', 'PSG', 'Espagne', 37, 184, 82.00, 4),
(7, 'Neymar', 'Jr', 'Attaquant', 'PSG', 'Brésil', 32, 175, 68.00, 10),
(8, 'Mendes', 'Nuno', 'Défenseur', 'PSG', 'Portugal', 21, 175, 70.00, 25),
(9, 'Ruiz', 'Fabian', 'Milieu', 'PSG', 'Espagne', 27, 189, 78.00, 8),
(10, 'Ekitike', 'Hugo', 'Attaquant', 'PSG', 'France', 21, 189, 74.00, 44),
(11, 'youcef', 'derouiche', 'Défenseur', 'PSG', 'Allemagne', 23, 184, 73.00, 23),
(12, 'samy', 'teignier', 'Attaquant', 'PSG', 'Maroc', 23, 180, 75.00, 10),
(14, 'younes', 'nadji', 'Gardien', 'PSG', 'Maroc', 23, 178, 78.00, 0),
(15, 'aaaaaaaa', 'qqqqqqqqqqq', 'Gardien', 'PSG', 'Argentine', 19, 174, 82.00, 17);

-- --------------------------------------------------------

--
-- Structure de la table `matchs`
--

CREATE TABLE `matchs` (
  `id` int(11) NOT NULL,
  `equipe_domicile` varchar(100) NOT NULL,
  `equipe_exterieur` varchar(100) NOT NULL,
  `date_match` datetime NOT NULL,
  `competition` varchar(100) NOT NULL,
  `stade` varchar(150) NOT NULL,
  `score_domicile` int(11) DEFAULT NULL,
  `score_exterieur` int(11) DEFAULT NULL,
  `statut` enum('programme','en_cours','termine','reporte') NOT NULL DEFAULT 'programme',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `matchs`
--

INSERT INTO `matchs` (`id`, `equipe_domicile`, `equipe_exterieur`, `date_match`, `competition`, `stade`, `score_domicile`, `score_exterieur`, `statut`, `created_at`) VALUES
(1, 'PSG', 'Olympique de Marseille', '2025-06-25 19:00:00', 'Ligue 1', 'Parc des Princes', NULL, NULL, 'programme', '2025-06-17 18:32:17'),
(2, 'AS Monaco', 'PSG', '2025-07-02 17:00:00', 'Ligue 1', 'Stade Louis II', NULL, NULL, 'programme', '2025-06-17 18:32:17'),
(3, 'PSG', 'Real Madrid', '2025-07-15 12:45:00', 'Champions League', 'Parc des Princes', 9, 4, 'termine', '2025-06-17 18:32:17'),
(8, 'PSG', 'Marseille', '2025-07-01 18:00:00', 'Ligue 1', 'Parc des Princes', 0, 0, 'termine', '2025-07-01 12:41:02'),
(9, 'PSG', 'marseille bebew', '2025-07-08 19:00:00', 'Coupe de France', 'boui,n', NULL, NULL, 'programme', '2025-07-01 12:56:57');

-- --------------------------------------------------------

--
-- Structure de la table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prix` double NOT NULL,
  `taille` varchar(10) DEFAULT NULL,
  `couleur` varchar(50) NOT NULL,
  `description` longtext NOT NULL,
  `stock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `product`
--

INSERT INTO `product` (`id`, `nom`, `prix`, `taille`, `couleur`, `description`, `stock`) VALUES
(32, 't shirt', 25, 'm', 'rouge', 'gregreg', 1500),
(33, 't shirt', 25, 'm', 'rouge', 'gregregz', 15),
(34, 't shirt', 25, 'm', 'rouge', 'gregregz', 15),
(35, 't shirt', 25, 'm', 'rouge', 'gregregz', 15),
(36, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(37, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(38, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(39, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(41, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(42, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(43, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(44, 'gregerger', 12, 'M', 'fezfef', 'fezfeez', 122),
(46, 'Tasse PSG', 12, 'M', 'Bleu', 'Tasse', 50),
(47, 'gfergregergergggggggggggggggggggggggg', 888, '', 'bleu', 'fezfezfez', 15),
(48, 'T-shirt PSG', 29.99, 'M', 'Bleu', 'T-shirt officiel du Paris Saint-Germain', 50),
(49, 'Maillot domicile', 120, 'S', 'Bleu/Rouge', 'T-shirt domicile', 50);

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(180) NOT NULL,
  `role` varchar(50) NOT NULL,
  `api_token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`id`, `password`, `email`, `role`, `api_token`) VALUES
(1, '$2y$10$1McxY/oB.QqU2hGxOHESP.NBn1WvIgdvk3utkKFFNuOjwbR/0zIbq', 'john.doe@example.com', 'utilisateurs', NULL),
(2, '$2y$10$8yAtYn3xBu3n0Qqht4o28eX7x5eht4uFeyvO2IPc3R3zIj6sm2Cpe', 'dellalcelia@gmail.com', 'utilisateurs', NULL),
(4, '$2y$10$2/olUxDkheYJcE6K3mME/uwepHEiRAM8n7useV0RUbwjhySCwlAWi', 'dellalceflia@gmail.com', 'utilisateurs', NULL),
(5, '$2y$10$ibc3GhOrLXb/mCozM3.qAefsh0hr56W/TzAGOrrCcAkCE8qmQljLu', 'youcef.derouiche93@gmail.com', 'utilisateurs', NULL),
(6, '$2y$10$y8clsbfhpXpG2/LwfGBLs.Y/9fevIuKF9NjZYKM/0jbpbwQ6yPLnq', 'rhehrehzzzzzzzzz@gmail.com', 'utilisateurs', NULL),
(8, '$2y$10$2VRPNyFE.Wpd/URTm.AdduSw8QXpYJVerfNwO6Ymy9ZbDIERYlZ7G', 'dozadjkzaojdfizejfie@outlook.com', 'utilisateurs', NULL),
(15, '$2y$10$oUDMWvUZK2TQdNu..W7MIuLPtgtCbDumbdBuc6Z0R37F.n2LfSk8a', 'yacine@gmail.com', 'admin', NULL),
(16, '$2y$10$NFoRysZmFkbpUrdd/E5YKeuejUR.JOdcHXh/3n7ky35VlKcnoyzcO', 'y@gmail.com', 'admin', '170c7a7d7781897c35d8bf4242c7226e5eaa4fee4357e6d7bb918c654e0933ea'),
(17, '$2y$10$HDbCm4hwaUxAf3TDY7UoHuuHozLGwPg0CWo5eqZyvpZkxhZuNSZ.G', 'user@gmail.com', 'utilisateurs', 'b1b0d0c4aa2f0402952b69ad907b2c414b4a7d4b68d2b47be20cadbf3301860c'),
(18, '$2y$10$Y4NUtWGZyV.xVvG1vgYtzu1fvE/PgfgFF/iFf92MBJVFneq0sGBQO', 'a@gmail.com', 'utilisateurs', '36f15e37f02214572f506af991e074400ef9f0a04d838434c305b62bbddc7841'),
(19, '$2y$10$HyVgLyf5nvuMQEtxasqeduub.3NhENwwhC9F/HCb3/XdMmSsZ1dky', 'usebr@gmail.com', 'utilisateurs', NULL),
(20, '$2y$10$YR8pSKFMYZjEfih.w6wnS.gTOTqHyJbXDdL9zWvN1/rhFpanG26lC', 'c@gmail.com', 'utilisateurs', '177e100c7b9a2bd14d4ef115bd1de44309fc055310ca81cdc8461bbec000f0fc'),
(21, '$2y$10$lQw40snUlMWCvHf/t6o1Oe.9GwS/w8Ehh2SNU2mfTtGOALsTORbLa', 'jean.dupont@example.com', 'utilisateurs', '4db9f4ab8e211ddd6400370a13483b6e925475d0041544d68e155a0aed29514d'),
(22, '$2y$13$dDMj74n14Qf/GLSmSipHIesee0gdfjl1cvlaRJtRVxmc9aKXZ0Nmm', 'jean.dupdont@example.com', 'utilisateurs', '7ac3d9f34ada652dbb48982174b88b9c'),
(23, '$2y$13$xWRJmQwSah9t/XTOwGx.LOnR8/NLoeCGdgEpz337H.lMJ5I7wyqVC', 'qr@gmail.com', 'utilisateurs', '97ed2223af3f81b988fad82837a5e448'),
(24, '$2y$13$HZPprWimIelYSHPktZOFXO5ne3OhX15GgH8xCfUANrrZRM3XGO1Ie', 'uadddaser@gmail.com', 'utilisateurs', '6e1bf93b016131308124bddadaddc477'),
(25, '$2y$13$a76r0diJtB11vOcVHTXY4.jvXGJIiLwsGFM5WuUMnlnwqB89vKt1W', 'sasdad@gre.com', 'utilisateurs', 'e19fb584fd86cf11b2cc6a8105486596'),
(26, '$2y$13$ge6piXRnhOI8l8c.MHM9LOs.eDSD6dkM73BLSXklw0EejFhOkW0HC', 'youu@gmail.com', 'utilisateurs', '16f475d4ae99ebdbba1dd6617a5f0abb'),
(27, '$2y$13$LPAb9927jB4oH4QbrLpMIeCC2BfM1FinqKLhGqVRCuNFRPCfKikoW', 'yy@gmail.com', 'utilisateurs', '95be2cd35f2c90de0e7252113020415f4011819ee7c0386a61b66d7f52b54da6');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `actualites`
--
ALTER TABLE `actualites`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `doctrine_migration_versions`
--
ALTER TABLE `doctrine_migration_versions`
  ADD PRIMARY KEY (`version`);

--
-- Index pour la table `entrainements`
--
ALTER TABLE `entrainements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_entrainements_date` (`date_entrainement`),
  ADD KEY `idx_entrainements_statut` (`statut`);

--
-- Index pour la table `entrainement_joueurs`
--
ALTER TABLE `entrainement_joueurs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_entrainement_joueur` (`entrainement_id`,`joueur_id`),
  ADD KEY `idx_entrainement_joueurs_entrainement` (`entrainement_id`),
  ADD KEY `idx_entrainement_joueurs_joueur` (`joueur_id`);

--
-- Index pour la table `joueurs`
--
ALTER TABLE `joueurs`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `matchs`
--
ALTER TABLE `matchs`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `actualites`
--
ALTER TABLE `actualites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `entrainements`
--
ALTER TABLE `entrainements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `entrainement_joueurs`
--
ALTER TABLE `entrainement_joueurs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `joueurs`
--
ALTER TABLE `joueurs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT pour la table `matchs`
--
ALTER TABLE `matchs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT pour la table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `entrainement_joueurs`
--
ALTER TABLE `entrainement_joueurs`
  ADD CONSTRAINT `entrainement_joueurs_ibfk_1` FOREIGN KEY (`entrainement_id`) REFERENCES `entrainements` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `entrainement_joueurs_ibfk_2` FOREIGN KEY (`joueur_id`) REFERENCES `joueurs` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
