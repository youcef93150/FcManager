-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 31 déc. 2024 à 21:28
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
(4, 'Marquinhos', '', 'Défenseur', 'PSG', 'Brésil', 29, 183, 75.00, 5),
(5, 'Verratti', 'Marco', 'Milieu', 'PSG', 'Italie', 31, 165, 60.00, 6),
(6, 'Ramos', 'Sergio', 'Défenseur', 'PSG', 'Espagne', 37, 184, 82.00, 4),
(7, 'Neymar', 'Jr', 'Attaquant', 'PSG', 'Brésil', 32, 175, 68.00, 10),
(8, 'Mendes', 'Nuno', 'Défenseur', 'PSG', 'Portugal', 21, 175, 70.00, 25),
(9, 'Ruiz', 'Fabian', 'Milieu', 'PSG', 'Espagne', 27, 189, 78.00, 8),
(10, 'Ekitike', 'Hugo', 'Attaquant', 'PSG', 'France', 21, 189, 74.00, 44),
(11, 'youcef', 'derouiche', 'Défenseur', 'PSG', 'Allemagne', 23, 184, 73.00, 23),
(12, 'samy', 'teignier', 'Attaquant', 'PSG', 'Maroc', 23, 180, 75.00, 10),
(14, 'younes', 'nadji', 'Gardien', 'PSG', 'Maroc', 23, 178, 78.00, 0);

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
(31, 't shirt', 25, 'm', 'rouge', 'gregreg', 32),
(32, 't shirt', 25, 'm', 'rouge', 'gregreg', 15),
(33, 't shirt', 25, 'm', 'rouge', 'gregregz', 15),
(34, 't shirt', 25, 'm', 'rouge', 'gregregz', 15),
(35, 't shirt', 25, 'm', 'rouge', 'gregregz', 15),
(36, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(37, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(38, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(39, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(40, 't shirt', 25, 'xs', 'rouge', 'gregregz', 27),
(41, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(42, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(43, 't shirt', 25, 'xs', 'rouge', 'gregregz', 15),
(44, 'gregerger', 12, 'M', 'fezfef', 'fezfeez', 122),
(45, 'gregre', 321321, 'M', 'gregreger', 'gregergre', 1223),
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
(16, '$2y$10$NFoRysZmFkbpUrdd/E5YKeuejUR.JOdcHXh/3n7ky35VlKcnoyzcO', 'y@gmail.com', 'admin', '91d3f3e75ae98df925f4ecf5bee033ddd79dd5834313de7b1ed3da1cf8022e7b'),
(17, '$2y$10$HDbCm4hwaUxAf3TDY7UoHuuHozLGwPg0CWo5eqZyvpZkxhZuNSZ.G', 'user@gmail.com', 'utilisateurs', '9b7fc24c00428517c2d6534b2dbfa210e9e852fa14499d6431a76f6a5ae7e15f'),
(18, '$2y$10$Y4NUtWGZyV.xVvG1vgYtzu1fvE/PgfgFF/iFf92MBJVFneq0sGBQO', 'a@gmail.com', 'utilisateurs', '36f15e37f02214572f506af991e074400ef9f0a04d838434c305b62bbddc7841'),
(19, '$2y$10$HyVgLyf5nvuMQEtxasqeduub.3NhENwwhC9F/HCb3/XdMmSsZ1dky', 'usebr@gmail.com', 'utilisateurs', NULL),
(20, '$2y$10$YR8pSKFMYZjEfih.w6wnS.gTOTqHyJbXDdL9zWvN1/rhFpanG26lC', 'c@gmail.com', 'utilisateurs', '177e100c7b9a2bd14d4ef115bd1de44309fc055310ca81cdc8461bbec000f0fc'),
(21, '$2y$10$lQw40snUlMWCvHf/t6o1Oe.9GwS/w8Ehh2SNU2mfTtGOALsTORbLa', 'jean.dupont@example.com', 'utilisateurs', '4db9f4ab8e211ddd6400370a13483b6e925475d0041544d68e155a0aed29514d'),
(22, '$2y$13$dDMj74n14Qf/GLSmSipHIesee0gdfjl1cvlaRJtRVxmc9aKXZ0Nmm', 'jean.dupdont@example.com', 'utilisateurs', '7ac3d9f34ada652dbb48982174b88b9c'),
(23, '$2y$13$xWRJmQwSah9t/XTOwGx.LOnR8/NLoeCGdgEpz337H.lMJ5I7wyqVC', 'qr@gmail.com', 'utilisateurs', '97ed2223af3f81b988fad82837a5e448'),
(24, '$2y$13$HZPprWimIelYSHPktZOFXO5ne3OhX15GgH8xCfUANrrZRM3XGO1Ie', 'uadddaser@gmail.com', 'utilisateurs', '6e1bf93b016131308124bddadaddc477'),
(25, '$2y$13$a76r0diJtB11vOcVHTXY4.jvXGJIiLwsGFM5WuUMnlnwqB89vKt1W', 'sasdad@gre.com', 'utilisateurs', 'e19fb584fd86cf11b2cc6a8105486596'),
(26, '$2y$13$ge6piXRnhOI8l8c.MHM9LOs.eDSD6dkM73BLSXklw0EejFhOkW0HC', 'youu@gmail.com', 'utilisateurs', '16f475d4ae99ebdbba1dd6617a5f0abb');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `doctrine_migration_versions`
--
ALTER TABLE `doctrine_migration_versions`
  ADD PRIMARY KEY (`version`);

--
-- Index pour la table `joueurs`
--
ALTER TABLE `joueurs`
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
-- AUTO_INCREMENT pour la table `joueurs`
--
ALTER TABLE `joueurs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT pour la table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT pour la table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
