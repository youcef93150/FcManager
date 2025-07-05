<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Migration pour ajouter les colonnes nom et prenom à la table user
 */
final class Version20250705120000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajouter les colonnes nom et prenom à la table user';
    }

    public function up(Schema $schema): void
    {
        // Ajouter les colonnes nom et prenom à la table user
        $this->addSql('ALTER TABLE user ADD nom VARCHAR(100) NOT NULL DEFAULT ""');
        $this->addSql('ALTER TABLE user ADD prenom VARCHAR(100) NOT NULL DEFAULT ""');
    }

    public function down(Schema $schema): void
    {
        // Supprimer les colonnes nom et prenom de la table user
        $this->addSql('ALTER TABLE user DROP COLUMN nom');
        $this->addSql('ALTER TABLE user DROP COLUMN prenom');
    }
}
