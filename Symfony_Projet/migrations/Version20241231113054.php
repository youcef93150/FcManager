<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20241231113054 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE product (id INT AUTO_INCREMENT NOT NULL, nom VARCHAR(255) NOT NULL, prix NUMERIC(10, 2) NOT NULL, taille VARCHAR(10) NOT NULL, couleur VARCHAR(50) NOT NULL, description LONGTEXT NOT NULL, stock INT NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('ALTER TABLE joueurs DROP buts_marques, DROP passes_decisives, DROP cartons_jaunes, DROP cartons_rouges, DROP valeur_marche, DROP date_creation');
        $this->addSql('ALTER TABLE user DROP nom, DROP prenom, CHANGE email email VARCHAR(180) NOT NULL, CHANGE role role VARCHAR(50) NOT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('DROP TABLE product');
        $this->addSql('ALTER TABLE joueurs ADD buts_marques INT DEFAULT 0, ADD passes_decisives INT DEFAULT 0, ADD cartons_jaunes INT DEFAULT 0, ADD cartons_rouges INT DEFAULT 0, ADD valeur_marche NUMERIC(15, 2) DEFAULT NULL, ADD date_creation DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL');
        $this->addSql('ALTER TABLE user ADD nom VARCHAR(255) NOT NULL, ADD prenom VARCHAR(255) NOT NULL, CHANGE email email VARCHAR(255) NOT NULL, CHANGE role role VARCHAR(255) DEFAULT \'utilisateurs\' NOT NULL');
    }
}
