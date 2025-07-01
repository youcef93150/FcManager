<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity]
#[ORM\Table(name: "matchs")]
class Matchs
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column(type: "integer")]
    private $id;

    #[ORM\Column(type: "string", length: 100)]
    #[Assert\NotBlank]
    private $equipe_domicile;

    #[ORM\Column(type: "string", length: 100)]
    #[Assert\NotBlank]
    private $equipe_exterieur;

    #[ORM\Column(name: "date_match", type: "datetime")]
    #[Assert\NotNull]
    private $dateMatch;

    #[ORM\Column(type: "string", length: 100)]
    #[Assert\NotBlank]
    private $competition;

    #[ORM\Column(type: "string", length: 150)]
    #[Assert\NotBlank]
    private $stade;

    #[ORM\Column(name: "score_domicile", type: "integer", nullable: true)]
    private $scoreDomicile = null;

    #[ORM\Column(name: "score_exterieur", type: "integer", nullable: true)]
    private $scoreExterieur = null;

    #[ORM\Column(type: "string", length: 20)]
    private $statut = 'programme';

    #[ORM\Column(name: "created_at", type: "datetime")]
    private $createdAt;

    #[ORM\Column(name: "updated_at", type: "datetime", nullable: true)]
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

    public function getEquipeDomicile(): ?string
    {
        return $this->equipe_domicile;
    }

    public function setEquipeDomicile(string $equipe_domicile): self
    {
        $this->equipe_domicile = $equipe_domicile;
        return $this;
    }

    public function getEquipeExterieure(): ?string
    {
        return $this->equipe_exterieur;
    }

    public function setEquipeExterieure(string $equipe_exterieur): self
    {
        $this->equipe_exterieur = $equipe_exterieur;
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
        $this->updateStatut();
        return $this;
    }

    public function getScoreExterieure(): ?int
    {
        return $this->scoreExterieur;
    }

    public function setScoreExterieure(?int $scoreExterieur): self
    {
        $this->scoreExterieur = $scoreExterieur;
        $this->updateStatut();
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

    public function getUpdatedAt(): ?\DateTime
    {
        return $this->updatedAt;
    }

    public function setUpdatedAt(\DateTime $updatedAt): self
    {
        $this->updatedAt = $updatedAt;
        return $this;
    }

    // ===== MÉTHODES ADDITIONNELLES POUR LA COMPATIBILITÉ =====

    public function getEquipeAdverse(): ?string
    {
        return $this->isPsgDomicile() ? $this->equipe_exterieur : $this->equipe_domicile;
    }

    public function setEquipeAdverse(string $equipe_adverse): self
    {
        if ($this->isPsgDomicile()) {
            $this->equipe_exterieur = $equipe_adverse;
        } else {
            $this->equipe_domicile = $equipe_adverse;
        }
        return $this;
    }

    public function getLieu(): ?string
    {
        return $this->isPsgDomicile() ? 'Domicile' : 'Extérieur';
    }

    public function setLieu(string $lieu): self
    {
        $is_psg_domicile = ($lieu === 'Domicile');
        
        // Si le lieu change et que l'équipe adverse est définie, mise à jour des équipes
        if ($is_psg_domicile !== $this->isPsgDomicile()) {
            $equipe_adverse = $this->getEquipeAdverse();
            
            if ($is_psg_domicile) {
                $this->equipe_domicile = 'PSG';
                $this->equipe_exterieur = $equipe_adverse;
            } else {
                $this->equipe_domicile = $equipe_adverse;
                $this->equipe_exterieur = 'PSG';
            }
        }
        
        return $this;
    }

    public function getScorePsg(): ?int
    {
        return $this->isPsgDomicile() ? $this->scoreDomicile : $this->scoreExterieur;
    }

    public function setScorePsg(?int $score_psg): self
    {
        if ($this->isPsgDomicile()) {
            $this->scoreDomicile = $score_psg;
        } else {
            $this->scoreExterieur = $score_psg;
        }
        $this->updateStatut();
        return $this;
    }

    public function getScoreAdverse(): ?int
    {
        return $this->isPsgDomicile() ? $this->scoreExterieur : $this->scoreDomicile;
    }

    public function setScoreAdverse(?int $score_adverse): self
    {
        if ($this->isPsgDomicile()) {
            $this->scoreExterieur = $score_adverse;
        } else {
            $this->scoreDomicile = $score_adverse;
        }
        $this->updateStatut();
        return $this;
    }

    public function isPsgDomicile(): ?bool
    {
        return $this->equipe_domicile === 'PSG';
    }

    public function setIsPsgDomicile(bool $is_psg_domicile): self
    {
        // Si on change le statut domicile/extérieur
        if ($is_psg_domicile !== $this->isPsgDomicile()) {
            $equipe_adverse = $this->getEquipeAdverse();
            $score_psg = $this->getScorePsg();
            $score_adverse = $this->getScoreAdverse();
            
            if ($is_psg_domicile) {
                $this->equipe_domicile = 'PSG';
                $this->equipe_exterieur = $equipe_adverse;
                $this->scoreDomicile = $score_psg;
                $this->scoreExterieur = $score_adverse;
            } else {
                $this->equipe_domicile = $equipe_adverse;
                $this->equipe_exterieur = 'PSG';
                $this->scoreDomicile = $score_adverse;
                $this->scoreExterieur = $score_psg;
            }
        }
        
        return $this;
    }
    
    /**
     * Met à jour le statut du match en fonction des scores
     */
    private function updateStatut(): void
    {
        if ($this->scoreDomicile !== null && $this->scoreExterieur !== null) {
            $this->statut = 'termine';
        }
        
        // Mettre à jour la date de modification
        $this->updatedAt = new \DateTime();
    }
}