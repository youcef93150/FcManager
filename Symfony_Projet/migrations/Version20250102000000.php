<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20250102000000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add failed login attempts tracking to user table';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE user ADD failed_login_attempts INT DEFAULT 0 NOT NULL');
        $this->addSql('ALTER TABLE user ADD last_failed_login_at DATETIME DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE user DROP failed_login_attempts');
        $this->addSql('ALTER TABLE user DROP last_failed_login_at');
    }
}
