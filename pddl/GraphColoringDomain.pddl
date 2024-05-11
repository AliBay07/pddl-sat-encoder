;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Domaine : GraphColoring     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du domaine GraphColoring
(define (domain graph)

    (:requirements :strips :typing)

    ; Types : noeud, couleur, arc
    (:types node color arc)

    ; Prédicats : Fonctions qui décrivent notre domaine
    (:predicates
        
        ; Le noeud "x" est connecté au noeud "y" par l'arc "z"
        (isConnected ?x - node ?y - node ?z - arc)
        
        ; Le noeud "x" est coloré
        (isColored ?x - node)

        ; Le noeud "x" n'est pas coloré
        (isNotColored ?x - node)

        ; La couleur "x" est différente de la couleur "y"
        (isDifferentColor ?x - color ?y - color)

        ; Le noeud "x" a la couleur "y"
        (hasColor ?x - node ?y - color)

        ; L'arc "x" est marqué
        (isMarked ?x - arc)

        ; L'arc "x" n'est pas marqué
        (isNotMarked ?x - arc)
    )

    ; Action : Colorier deux noeuds
    (:action colorTwoNodes
        
        ; Paramètres : Les noeuds "x" et "y", l'arc "z", les couleurs "c" et "c2"
        :parameters (?x - node ?y - node ?z - arc ?c - color ?c2 - color)
        
        ; Préconditions de l'action : Colorier deux noeuds
        :precondition

            ; Ensemble des préconditions de cette action
            (and
                ; Les noeuds "x" et "y" sont connectés par l'arc "z"
                (isConnected ?x ?y ?z)
                
                ; Le noeud "x" n'est pas coloré
                (isNotColored ?x)
                
                ; Le noeud "y" n'est pas coloré
                (isNotColored ?y)
                
                ; L'arc "z" n'est pas marqué
                (isNotMarked ?z)
                
                ; La couleur "c" est différente de la couleur "c2"
                (isDifferentColor ?c ?c2)
            )

        ; Effets de l'action : Colorier deux noeuds
        :effect
        
            ; Ensemble des effets de cette action
            (and
                
                ; Le noeud "x" est coloré
                (isColored ?x)
                
                ; Le noeud "y" est coloré
                (isColored ?y)
                
                ; Le noeud "x" n'est pas, pas coloré
                (not (isNotColored ?x))
                
                ; Le noeud "y" n'est pas, pas coloré
                (not (isNotColored ?y))
                
                ; Le noeud "x" a la couleur "c"
                (hasColor ?x ?c)
                
                ; Le noeud "y" a la couleur "c2"
                (hasColor ?y ?c2)
                
                ; L'arc "z" est marqué
                (isMarked ?z)
                
                ; L'arc "z" n'est pas, pas marqué
                (not (isNotMarked ?z))
            )
    )

    ; Action : Colorier un noeud
    (:action colorNode
        
        ; Paramètres : Les noeuds "x" et "y", l'arc "z", les couleurs "c" et "c2"
        :parameters (?x - node ?y - node ?z - arc ?c - color ?c2 - color)
        
        ; Préconditions de l'action : Colorier un noeud
        :precondition
        
            ; Ensemble des préconditions de cette action
            (and
                
                ; Les noeuds "x" et "y" sont connectés par l'arc "z"
                (isConnected ?x ?y ?z)
                
                ; Le noeud "x" n'est pas coloré
                (isNotColored ?x)
                
                ; Le noeud "z" n'est pas marqué
                (isNotMarked ?z)
                
                ; Le noeud "y" a la couleur "c2"
                (hasColor ?y ?c2)
                
                ; La couleur "c" est différente de la couleur "c2"
                (isDifferentColor ?c ?c2)
            )
        
        ; Effets de l'action : Colorier un noeud
        :effect
            
            ; Ensemble des effets de cette action
            (and
                
                ; Le noeud "x" est coloré
                (isColored ?x)

                ; Le noeud "x" n'est pas, pas coloré
                (not (isNotColored ?x))

                ; Le noeud "x" a la couleur "c"
                (hasColor ?x ?c)

                ; L'arc "z" est marqué
                (isMarked ?z)

                ; L'arc "z" n'est pas, pas marqué
                (not (isNotMarked ?z))
            )
    )

    ; Action : Marquer les noeuds colorés
    (:action markColoredNodes
        
        ; Paramètres : Les noeuds "x" et "y", l'arc "z", les couleurs "c" et "c2"
        :parameters (?x - node ?y - node ?z - arc ?c - color ?c2 - color)
        
        ; Préconditions de l'action : Marquer les noeuds colorés
        :precondition
        
            ; Ensemble des préconditions de cette action
            (and
                
                ; Les noeuds "x" et "y" sont connectés par l'arc "z"
                (isConnected ?x ?y ?z)
                
                ; Le noeud "x" est coloré
                (isColored ?x)
                
                ; Le noeud "y" est coloré
                (isColored ?y)
                
                ; Le noeud "x" a la couleur "c"
                (hasColor ?x ?c)
                
                ; Le noeud "y" a la couleur "c2"
                (hasColor ?y ?c2)
                
                ; L'arc "z" n'est pas marqué
                (isNotMarked ?z)
                
                ; La couleur "c" est différente de la couleur "c2"
                (isDifferentColor ?c ?c2)
            )

        ; Effets de l'action : Marquer les noeuds colorés
        :effect
            
            ; Ensemble des effets de cette action
            (and
                
                (isMarked ?z)
                
                (not (isNotMarked ?z))
            )
    )
)