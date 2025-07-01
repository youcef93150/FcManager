<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity]
#[ORM\Table(name: "entrainements")]
class Entrainements
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column(type: "integer")]
    private $id;

    #[ORM\Column(type: "string", length: 200)]
    #[Assert\NotBlank]
    private $titre;

    #[ORM\Column(type: "text", nullable: true)]
    private $description;

    #[ORM\Column(name: "date_entrainement", type: "datetime")]
    #[Assert\NotNull]
    private $dateEntrainement;

    #[ORM\Column(type: "string", length: 150)]
    #[Assert\NotBlank]
    private $lieu;

    #[ORM\Column(name: "duree_minutes", type: "integer")]
    private $dureeMinutes = 120;

    #[ORM\Column(name: "type_entrainement", type: "string", length: 50)]
    #[Assert\NotBlank]
    private $typeEntrainement;

    #[ORM\Column(name: "joueurs_convoques", type: "json", nullable: true)]
    private $joueursConvoques = null;

    #[ORM\Column(name: "created_at", type: "datetime")]
    private $createdAt;

    #[ORM\Column(type: "string", length: 20)]
    private $statut = 'programme';

    #[ORM\Column(name: "updated_at", type: "datetime")]
    private $updatedAt;

    public function __construct()
    {
        $this->createdAt = new \DateTime();
        $this->updatedAt = new \DateTime();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getTitre(): ?string
    {
        return $this->titre;
    }

    public function setTitre(string $titre): self
    {
        $this->titre = $titre;
        return $this;
    }

    public function getDescription(): ?string
    {
        return $this->description;
    }

    public function setDescription(?string $description): self
    {
        $this->description = $description;
        return $this;
    }

    public function getDateEntrainement(): ?\DateTime
    {
        return $this->dateEntrainement;
    }

    public function setDateEntrainement(\DateTime $dateEntrainement): self
    {
        $this->dateEntrainement = $dateEntrainement;
        return $this;
    }

    public function getLieu(): ?string
    {
        return $this->lieu;
    }

    public function setLieu(string $lieu): self
    {
        $this->lieu = $lieu;
        return $this;
    }

    public function getDureeMinutes(): ?int
    {
        return $this->dureeMinutes;
    }

    public function setDureeMinutes(int $dureeMinutes): self
    {
        $this->dureeMinutes = $dureeMinutes;
        return $this;
    }

    public function getTypeEntrainement(): ?string
    {
        return $this->typeEntrainement;
    }

    public function setTypeEntrainement(string $typeEntrainement): self
    {
        $this->typeEntrainement = $typeEntrainement;
        return $this;
    }

    public function getJoueursConvoques()
    {
        return $this->joueursConvoques;
    }

    public function setJoueursConvoques($joueursConvoques): self
    {
        $this->joueursConvoques = $joueursConvoques;
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

    public function getStatut(): ?string
    {
        return $this->statut;
    }

    public function setStatut(string $statut): self
    {
        $this->statut = $statut;
        return $this;
    }

    public function getUpdatedAt(): ?\DateTime
    {
        return $this->updatedAt;
    }

    public function setUpdatedAt(\DateTime $updatedAt): self
    {
        $this->updatedAt = $updatedAt;
        return $this;
    }
}