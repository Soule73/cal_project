-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : ven. 29 nov. 2024 à 19:01
-- Version du serveur : 8.0.30
-- Version de PHP : 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `cal_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `courses`
--

CREATE TABLE `courses` (
  `id` int NOT NULL,
  `language_id` int NOT NULL,
  `level_id` int NOT NULL,
  `room_id` int NOT NULL,
  `subscription_id` int NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `specific_equipment` text,
  `type_of_course` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `courses`
--

INSERT INTO `courses` (`id`, `language_id`, `level_id`, `room_id`, `subscription_id`, `identifier`, `name`, `description`, `specific_equipment`, `type_of_course`) VALUES
(1, 1, 1, 1, 1, 'ENG-A1-101', 'English A1 - Beginner', 'Basic English course for beginners', 'Interactive whiteboard', 'group'),
(2, 2, 3, 2, 2, 'FRE-B1-102', 'French B1 - Intermediate', 'Intermediate French course', 'Projector', 'group'),
(3, 3, 5, 3, 3, 'SPA-C1-103', 'Spanish C1 - Advanced', 'Advanced Spanish course', 'Computers', 'individual'),
(10, 1, 5, 2, 2, 'ENG-C1-101', 'Advanced English course', '', '', 'group'),
(12, 1, 6, 1, 2, 'ENG-C-101', 'Advanced English course', '', '', 'group'),
(13, 1, 2, 1, 2, 'ENG-A2-102', 'English A2 - Beginner	', 'Basic English course for beginners', '', 'group'),
(15, 1, 3, 2, 1, 'ENG-B1-102', 'Intermedaite English course	', '', '', 'group'),
(20, 1, 4, 1, 2, 'ENG-B2-202', 'Intermedaite English course', '', '', 'group');

-- --------------------------------------------------------

--
-- Structure de la table `languages`
--

CREATE TABLE `languages` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `languages`
--

INSERT INTO `languages` (`id`, `name`) VALUES
(1, 'English'),
(2, 'French'),
(3, 'Spanish');

-- --------------------------------------------------------

--
-- Structure de la table `learners`
--

CREATE TABLE `learners` (
  `id` int NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `learners`
--

INSERT INTO `learners` (`id`, `firstname`, `lastname`, `email`, `created_at`) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '2024-01-15'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '2024-02-20'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com', '2024-03-10'),
(7, 'SDS', 'ghjkl', 'sdsqq@example.com', '2024-11-27');

-- --------------------------------------------------------

--
-- Structure de la table `learner_language`
--

CREATE TABLE `learner_language` (
  `learner_id` int NOT NULL,
  `language_id` int NOT NULL,
  `level_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `learner_language`
--

INSERT INTO `learner_language` (`learner_id`, `language_id`, `level_id`) VALUES
(1, 1, 1),
(2, 2, 3),
(3, 3, 5);

-- --------------------------------------------------------

--
-- Structure de la table `learner_subscription`
--

CREATE TABLE `learner_subscription` (
  `learner_id` int NOT NULL,
  `subscription_id` int NOT NULL,
  `start_at` date NOT NULL,
  `end_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `learner_subscription`
--

INSERT INTO `learner_subscription` (`learner_id`, `subscription_id`, `start_at`, `end_at`) VALUES
(1, 1, '2024-01-15', '2024-02-15'),
(2, 2, '2024-02-20', '2024-03-20'),
(3, 3, '2024-03-10', '2024-04-10');

-- --------------------------------------------------------

--
-- Structure de la table `levels`
--

CREATE TABLE `levels` (
  `id` int NOT NULL,
  `name` varchar(10) NOT NULL,
  `status` enum('active','inactive') NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `levels`
--

INSERT INTO `levels` (`id`, `name`, `status`, `description`) VALUES
(1, 'A1', 'active', 'Beginner level'),
(2, 'A2', 'active', 'Elementary level'),
(3, 'B1', 'active', 'Intermediate level'),
(4, 'B2', 'active', 'Upper intermediate level'),
(5, 'C1', 'active', 'Advanced level'),
(6, 'C2', 'active', 'Proficiency level');

-- --------------------------------------------------------

--
-- Structure de la table `messages`
--

CREATE TABLE `messages` (
  `id` int NOT NULL,
  `content` text NOT NULL,
  `created_at` date NOT NULL,
  `learner_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `messages`
--

INSERT INTO `messages` (`id`, `content`, `created_at`, `learner_id`) VALUES
(1, 'Looking for a conversation partner for French.', '2024-04-01', 1),
(2, 'Anyone interested in a Spanish study group?', '2024-04-02', 2),
(3, 'Tips for improving English pronunciation?', '2024-04-03', 3);

-- --------------------------------------------------------

--
-- Structure de la table `rooms`
--

CREATE TABLE `rooms` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `equipment` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `rooms`
--

INSERT INTO `rooms` (`id`, `name`, `equipment`) VALUES
(1, 'Room 101', 'Interactive whiteboard, Headsets, Manuals'),
(2, 'Room 102', 'Projector, Whiteboard, Speakers'),
(3, 'Room 103', 'Computers, Headsets, Manuals');

-- --------------------------------------------------------

--
-- Structure de la table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `data` blob,
  `last_accessed` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `sessions`
--

INSERT INTO `sessions` (`id`, `data`, `last_accessed`) VALUES
('682d434e-4167-4ca6-9ff1-0220bb38dffe', 0xaced0005737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f400000000000007708000000100000000078, '2024-11-25 22:26:50');

-- --------------------------------------------------------

--
-- Structure de la table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `access_conditions` text,
  `type` varchar(50) NOT NULL,
  `status` enum('active','inactive') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `subscriptions`
--

INSERT INTO `subscriptions` (`id`, `name`, `price`, `description`, `access_conditions`, `type`, `status`) VALUES
(1, 'Basic Plan', 99.99, 'Access to all beginner courses', 'Beginner level only', 'monthly', 'active'),
(2, 'Premium Plan', 199.99, 'Access to all courses', 'All levels', 'monthly', 'active'),
(3, 'Conversation Plan', 49.99, 'Access to conversation sessions', 'All levels', 'monthly', 'active');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` bigint NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`) VALUES
(1, 'Admin', 'admin@cal.com', '$2a$10$mN1Iw261E4U5xsEqnhi.CuyMlInRKUiYQilyJvjBxvFx/rQMKNVM2');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `identifier` (`identifier`),
  ADD KEY `idx_courses_language_id` (`language_id`),
  ADD KEY `idx_courses_level_id` (`level_id`),
  ADD KEY `idx_courses_room_id` (`room_id`),
  ADD KEY `idx_courses_subscription_id` (`subscription_id`);

--
-- Index pour la table `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `idx_languages_name` (`name`);

--
-- Index pour la table `learners`
--
ALTER TABLE `learners`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_learners_email` (`email`);

--
-- Index pour la table `learner_language`
--
ALTER TABLE `learner_language`
  ADD PRIMARY KEY (`learner_id`,`language_id`,`level_id`),
  ADD KEY `idx_learner_language_learner_id` (`learner_id`),
  ADD KEY `idx_learner_language_language_id` (`language_id`),
  ADD KEY `idx_learner_language_level_id` (`level_id`);

--
-- Index pour la table `learner_subscription`
--
ALTER TABLE `learner_subscription`
  ADD PRIMARY KEY (`learner_id`,`subscription_id`),
  ADD KEY `idx_learner_subscription_learner_id` (`learner_id`),
  ADD KEY `idx_learner_subscription_subscription_id` (`subscription_id`);

--
-- Index pour la table `levels`
--
ALTER TABLE `levels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `idx_levels_name` (`name`);

--
-- Index pour la table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_messages_learner_id` (`learner_id`);

--
-- Index pour la table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `idx_rooms_name` (`name`);

--
-- Index pour la table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `idx_subscriptions_name` (`name`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT pour la table `languages`
--
ALTER TABLE `languages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `learners`
--
ALTER TABLE `learners`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT pour la table `levels`
--
ALTER TABLE `levels`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `fk_courses_language_id` FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_courses_level_id` FOREIGN KEY (`level_id`) REFERENCES `levels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_courses_room_id` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_courses_subscription_id` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `learner_language`
--
ALTER TABLE `learner_language`
  ADD CONSTRAINT `fk_learner_language_language_id` FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_learner_language_learner_id` FOREIGN KEY (`learner_id`) REFERENCES `learners` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_learner_language_level_id` FOREIGN KEY (`level_id`) REFERENCES `levels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `learner_subscription`
--
ALTER TABLE `learner_subscription`
  ADD CONSTRAINT `fk_learner_subscription_learner_id` FOREIGN KEY (`learner_id`) REFERENCES `learners` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_learner_subscription_subscription_id` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `fk_messages_learner_id` FOREIGN KEY (`learner_id`) REFERENCES `learners` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
