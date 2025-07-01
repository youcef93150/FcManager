<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity]
#[ORM\Table(name: "entrainement_joueurs")]
class EntrainementJoueurs
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column(type: "integer")]
    private $id;

    #[ORM\Column(type: "integer")]
    private $entrainementId;

    #[ORM\Column(type: "integer")]
    private $joueurId;

    #[ORM\Column(type: "boolean")]
    private $present = false;

    #[ORM\Column(type: "string", length: 255, nullable: true)]
    private $excuse;

    #[ORM\Column(type: "datetime")]
    private $createdAt;

    public function __construct()
    {
        $this->createdAt = new \DateTime();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getEntrainementId(): ?int
    {
        return $this->entrainementId;
    }

    public function setEntrainementId(int $entrainementId): self
    {
        $this->entrainementId = $entrainementId;
        return $this;
    }

    public function getJoueurId(): ?int
    {
        return $this->joueurId;
    }

    public function setJoueurId(int $joueurId): self
    {
        $this->joueurId = $joueurId;
        return $this;
    }

    public function getPresent(): ?bool
    {
        return $this->present;
    }

    public function setPresent(bool $present): self
    {
        $this->present = $present;
        return $this;
    }

    public function getExcuse(): ?string
    {
        return $this->excuse;
    }

    public function setExcuse(?string $excuse): self
    {
        $this->excuse = $excuse;
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
}