<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity]
class Joueurs
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column(type: 'integer')]
    private $id;

    #[ORM\Column(type: 'string', length: 100)]
    private $nom;

    #[ORM\Column(type: 'string', length: 100)]
    private $prenom;

    #[ORM\Column(type: 'string', length: 50)]
    private $poste;

    #[ORM\Column(type: 'string', length: 100)]
    private $equipe;

    #[ORM\Column(type: 'integer')]
    private $age;

    #[ORM\Column(type: 'integer')]
    private $taille_cm;

    #[ORM\Column(type: 'decimal', precision: 5, scale: 2)]
    private $poids_kg;

    #[ORM\Column(type: 'integer')]
    private $numero_maillot;

    #[ORM\Column(type: 'string', length: 100)]
    private $pays_origine;

    // Getters et setters...

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getNom(): ?string
    {
        return $this->nom;
    }

    public function setNom(string $nom): self
    {
        $this->nom = $nom;

        return $this;
    }

    public function getPrenom(): ?string
    {
        return $this->prenom;
    }

    public function setPrenom(string $prenom): self
    {
        $this->prenom = $prenom;

        return $this;
    }

    public function getPoste(): ?string
    {
        return $this->poste;
    }

    public function setPoste(string $poste): self
    {
        $this->poste = $poste;

        return $this;
    }

    public function getEquipe(): ?string
    {
        return $this->equipe;
    }

    public function setEquipe(string $equipe): self
    {
        $this->equipe = $equipe;

        return $this;
    }

    public function getAge(): ?int
    {
        return $this->age;
    }

    public function setAge(int $age): self
    {
        $this->age = $age;

        return $this;
    }

    public function getTailleCm(): ?int
    {
        return $this->taille_cm;
    }

    public function setTailleCm(int $taille_cm): self
    {
        $this->taille_cm = $taille_cm;

        return $this;
    }

    public function getPoidsKg(): ?string
    {
        return $this->poids_kg;
    }

    public function setPoidsKg(string $poids_kg): self
    {
        $this->poids_kg = $poids_kg;

        return $this;
    }

    public function getNumeroMaillot(): ?int
    {
        return $this->numero_maillot;
    }

    public function setNumeroMaillot(int $numero_maillot): self
    {
        $this->numero_maillot = $numero_maillot;

        return $this;
    }
    
    
    public function getPaysOrigine(): ?string
    {
        return $this->pays_origine;
    }

    public function setPaysOrigine(string $pays_origine): self
    {
        $this->pays_origine = $pays_origine;

        return $this;
}
}
