<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity]
#[ORM\Table(name: "entrainements")]
class Entrainement
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column(type: "integer")]
    private $id;

    #[ORM\Column(name: "titre", type: "string", length: 200)]
    private $titre;

    #[ORM\Column(name: "description", type: "text", nullable: true)]
    private $description;

    #[ORM\Column(name: "date_entrainement", type: "datetime")]
    private $dateEntrainement;

    #[ORM\Column(name: "lieu", type: "string", length: 200)]
    private $lieu;

    #[ORM\Column(name: "duree_minutes", type: "integer")]
    private $dureeMinutes = 120;

    #[ORM\Column(name: "type_entrainement", type: "string", length: 50)]
    private $typeEntrainement;

    #[ORM\Column(name: "created_at", type: "datetime")]
    private $createdAt;

    public function __construct()
    {
        $this->createdAt = new \DateTime();
        $this->dureeMinutes = 120;
    }

    // Getters et Setters
    public function getId(): ?int { return $this->id; }

    public function getTitre(): ?string { return $this->titre; }
    public function setTitre(string $titre): self { $this->titre = $titre; return $this; }

    public function getDescription(): ?string { return $this->description; }
    public function setDescription(?string $description): self { $this->description = $description; return $this; }

    public function getDateEntrainement(): ?\DateTime { return $this->dateEntrainement; }
    public function setDateEntrainement(\DateTime $dateEntrainement): self { $this->dateEntrainement = $dateEntrainement; return $this; }

    public function getLieu(): ?string { return $this->lieu; }
    public function setLieu(string $lieu): self { $this->lieu = $lieu; return $this; }

    public function getDureeMinutes(): ?int { return $this->dureeMinutes; }
    public function setDureeMinutes(int $dureeMinutes): self { $this->dureeMinutes = $dureeMinutes; return $this; }

    public function getTypeEntrainement(): ?string { return $this->typeEntrainement; }
    public function setTypeEntrainement(string $typeEntrainement): self { $this->typeEntrainement = $typeEntrainement; return $this; }

    public function getCreatedAt(): ?\DateTime { return $this->createdAt; }
    public function setCreatedAt(\DateTime $createdAt): self { $this->createdAt = $createdAt; return $this; }
}