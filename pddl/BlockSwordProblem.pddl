;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     Exercice 1 : Blocksworld     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du problème Blocksworld
(define (problem blocks_probleme)

    ; Définition du domaine utilisé : "blocks"
    (:domain blocks)

    ; Définition des objets utilisés
    (:objects
        ; a, b, c et d sont de type "block"
        a b c d - block
    )

    ; Initialisation du problème Blocksworld
    ;  
    ;           | 
    ;           |
    ;       +---+---+
    ;      /         \
    ;      \         /
    ;   
    ;       +-------+
    ;       |   a   |
    ;       +-------+
    ;       |   b   |
    ;       +-------+
    ;       |   c   |
    ;       +-------+
    ;       |   d   |
    ;       +-------------------+
    ;       |       TABLE       |
    ;       +-------------------+
    ;
    (:init
        
        ; Le block "a" est attrapable par le bras
        (clear a)

        ; Le bloc "a" est sur le bloc "b"
        (on a b)

        ; Le bloc "b" est sur le bloc "c"
        (on b c)

        ; Le bloc "c" est sur le bloc "d"
        (on c d)

        ; Le bloc "d" est sur la table
        (ontable d)

        ; Le bras est vide
        (handempty)
    )

    ; But Final du problème Blocksworld
    ;  
    ;           | 
    ;           |
    ;       +---+---+
    ;      /         \
    ;      \         /
    ;   
    ;       +-------+
    ;       |   a   |
    ;       +-------+
    ;       |   d   |
    ;       +-------+
    ;       |   c   |
    ;       +-------+
    ;       |   b   |
    ;       +-------------------+
    ;       |       TABLE       |
    ;       +-------------------+
    ;
    (:goal
        ; Ensemble des conditions à satisfaire pour atteindre le but final
        (and
            ; Le bloc "a" est sur le bloc "d"
            (on a d)
            
            ; Le bloc "d" est sur le bloc "c"
            (on d c)
            
            ; Le bloc "c" est sur le bloc "b"
            (on c b)
        )
    )
)