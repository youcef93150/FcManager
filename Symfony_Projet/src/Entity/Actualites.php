<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity]
#[ORM\Table(name: "actualites")]
class Actualites
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column(type: "integer")]
    private $id;

    #[ORM\Column(type: "string", length: 255)]
    #[Assert\NotBlank]
    private $titre;

    #[ORM\Column(type: "text")]
    #[Assert\NotBlank]
    private $contenu;

    #[ORM\Column(name: "date_publication", type: "datetime")]
    private $datePublication;

    #[ORM\Column(type: "string", length: 100)]
    private $auteur;

    #[ORM\Column(name: "image_url", type: "string", length: 500, nullable: true)]
    private $imageUrl;

    #[ORM\Column(type: "string", length: 20)]
    private $statut = 'publie';

    #[ORM\Column(type: "integer")]
    private $likes = 0;

    #[ORM\Column(type: "integer")]
    private $commentaires = 0;

    #[ORM\Column(name: "created_at", type: "datetime")]
    private $createdAt;

    #[ORM\Column(name: "updated_at", type: "datetime")]
    private $updatedAt;

    public function __construct()
    {
        $this->datePublication = new \DateTime();
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

    public function getContenu(): ?string
    {
        return $this->contenu;
    }

    public function setContenu(string $contenu): self
    {
        $this->contenu = $contenu;
        return $this;
    }

    public function getDatePublication(): ?\DateTime
    {
        return $this->datePublication;
    }

    public function setDatePublication(\DateTime $datePublication): self
    {
        $this->datePublication = $datePublication;
        return $this;
    }

    public function getAuteur(): ?string
    {
        return $this->auteur;
    }

    public function setAuteur(string $auteur): self
    {
        $this->auteur = $auteur;
        return $this;
    }

    public function getImageUrl(): ?string
    {
        return $this->imageUrl;
    }

    public function setImageUrl(?string $imageUrl): self
    {
        $this->imageUrl = $imageUrl;
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

    public function getLikes(): ?int
    {
        return $this->likes;
    }

    public function setLikes(int $likes): self
    {
        $this->likes = $likes;
        return $this;
    }

    public function getCommentaires(): ?int
    {
        return $this->commentaires;
    }

    public function setCommentaires(int $commentaires): self
    {
        $this->commentaires = $commentaires;
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