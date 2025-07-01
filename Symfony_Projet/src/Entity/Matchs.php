<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity]
#[ORM\Table(name: "matchs")]
class Matchs
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column(type: "integer")]
    private $id;

    #[ORM\Column(name: "equipe_domicile", type: "string", length: 100)]
    private $equipeDomicile;

    #[ORM\Column(name: "equipe_exterieur", type: "string", length: 100)]
    private $equipeExterieur;

    #[ORM\Column(name: "date_match", type: "datetime")]
    private $dateMatch;

    #[ORM\Column(name: "competition", type: "string", length: 100)]
    private $competition;

    #[ORM\Column(name: "stade", type: "string", length: 150)]
    private $stade;

    #[ORM\Column(name: "score_domicile", type: "integer", nullable: true)]
    private $scoreDomicile;

    #[ORM\Column(name: "score_exterieur", type: "integer", nullable: true)]
    private $scoreExterieur;

    #[ORM\Column(name: "statut", type: "string", length: 20)]
    private $statut = 'programme';

    #[ORM\Column(name: "created_at", type: "datetime")]
    private $createdAt;

    public function __construct()
    {
        $this->createdAt = new \DateTime();
        $this->statut = 'programme';
    }

    // Getters et Setters de base
    public function getId(): ?int
    {
        return $this->id;
    }

    public function getEquipeDomicile(): ?string
    {
        return $this->equipeDomicile;
    }

    public function setEquipeDomicile(string $equipeDomicile): self
    {
        $this->equipeDomicile = $equipeDomicile;
        return $this;
    }

    public function getEquipeExterieur(): ?string
    {
        return $this->equipeExterieur;
    }

    public function setEquipeExterieur(string $equipeExterieur): self
    {
        $this->equipeExterieur = $equipeExterieur;
        return $this;
    }

    public function getDateMatch(): ?\DateTime
    {
        return $this->dateMatch;
    }

    public function setDateMatch(\DateTime $dateMatch): self
    {
        $this->dateMatch = $dateMatch;
        return $this;
    }

    public function getCompetition(): ?string
    {
        return $this->competition;
    }

    public function setCompetition(string $competition): self
    {
        $this->competition = $competition;
        return $this;
    }

    public function getStade(): ?string
    {
        return $this->stade;
    }

    public function setStade(string $stade): self
    {
        $this->stade = $stade;
        return $this;
    }

    public function getScoreDomicile(): ?int
    {
        return $this->scoreDomicile;
    }

    public function setScoreDomicile(?int $scoreDomicile): self
    {
        $this->scoreDomicile = $scoreDomicile;
        return $this;
    }

    public function getScoreExterieur(): ?int
    {
        return $this->scoreExterieur;
    }

    public function setScoreExterieur(?int $scoreExterieur): self
    {
        $this->scoreExterieur = $scoreExterieur;
        return $this;
    }

    public function getStatut(): ?string
    {
        return $this->statut;
    }

    public function setStatut(string $statut): self
    {
        $this->statut = $statut;
        return $this;
    }

    public function getCreatedAt(): ?\DateTime
    {
        return $this->createdAt;
    }

    public function setCreatedAt(\DateTime $createdAt): self
    {
        $this->createdAt = $createdAt;
        return $this;
    }

    // Méthodes calculées pour la compatibilité Vue.js
    public function getLieu(): ?string 
    { 
        if ($this->equipeDomicile === 'PSG') {
            return 'Domicile';
        } else if ($this->equipeExterieur === 'PSG') {
            return 'Extérieur';
        }
        return 'Neutre';
    }

    public function getEquipeAdverse(): ?string 
    { 
        if ($this->equipeDomicile === 'PSG') {
            return $this->equipeExterieur;
        } else if ($this->equipeExterieur === 'PSG') {
            return $this->equipeDomicile;
        }
        return null;
    }

    public function getScorePsg(): ?int 
    { 
        if ($this->equipeDomicile === 'PSG') {
            return $this->scoreDomicile;
        } else if ($this->equipeExterieur === 'PSG') {
            return $this->scoreExterieur;
        }
        return null;
    }

    public function getScoreAdverse(): ?int 
    { 
        if ($this->equipeDomicile === 'PSG') {
            return $this->scoreExterieur;
        } else if ($this->equipeExterieur === 'PSG') {
            return $this->scoreDomicile;
        }
        return null;
    }
}