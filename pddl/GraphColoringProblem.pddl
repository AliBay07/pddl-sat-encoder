;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Exercice 1 : GraphColoring     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du problème GraphColoring
(define (problem p001)

    ; Définition du domaine utilisé : "graph"
    (:domain graph)

    ; Définition des objets utilisés
    (:objects
        
        ; bleu, blanc et rouge sont de type "color"
        bleu blanc rouge - color

        ; a, b, c, d, e et f sont de type "node"
        a b c d e f - node

        ; arc1, arc2, arc3, arc4, arc5, arc6, arc7, arc8 et arc9 sont de type "arc"
        arc1 arc2 arc3 arc4 arc5 arc6 arc7 arc8 arc9 - arc
    )

    ; Initialisation du problème GraphColoring
    ;
    ;
    ;                          +---+
    ;                          | f |
    ;                          +---+
    ;                         /     \
    ;                       /         \
    ;                   'arc9'        'arc8'
    ;                   /                  \
    ;                 /                      \
    ;            +---+                        +---+
    ;            | c | - - - - 'arc7' - - - - | e |
    ;            +---+                        +---+
    ;           /  |  \                         |  
    ;          /   |    \                       |   
    ;      'arc2'  |      \                     |  
    ;        /     |        \                   |    
    ;       /      |          \                 |      
    ;  +---+       |            \               |       
    ;  | a |     'arc3'          'arc5'       'arc6'    
    ;  +---+       |                  \         |       
    ;       \      |                   \        |      
    ;        \     |                     \      |     
    ;      'arc1'  |                      \     |  
    ;          \   |                        \   |   
    ;           \  |                         \  |  
    ;            +---+                        +---+
    ;            | b | - - - - 'arc4' - - - - | d |
    ;            +---+                        +---+
    ;
    ;
    (:init
        
        ; La couleur "bleu" est différente de la couleur "blanc"
        (isDifferentColor bleu blanc)

        ; La couleur "bleu" est différente de la couleur "rouge"
        (isDifferentColor bleu rouge)

        ; La couleur "blanc" est différente de la couleur "rouge"
        (isDifferentColor blanc rouge)

        ; Le noeud "a" n'est pas coloré
        (isNotColored a)

        ; Le noeud "b" n'est pas coloré
        (isNotColored b)

        ; Le noeud "c" n'est pas coloré
        (isNotColored c)

        ; Le noeud "d" n'est pas coloré
        (isNotColored d)

        ; Le noeud "e" n'est pas coloré
        (isNotColored e)

        ; Le noeud "f" n'est pas coloré
        (isNotColored f)

        ; L'arc "arc1" relie les noeuds "a" et "b"
        (isConnected a b arc1)

        ; L'arc "arc1" relie les noeuds "b" et "a"
        (isConnected b a arc1)

        ; L'arc "arc2" relie les noeuds "a" et "c"
        (isConnected a c arc2)

        ; L'arc "arc2" relie les noeuds "c" et "a"
        (isConnected c a arc2)

        ; L'arc "arc3" relie les noeuds "b" et "c"
        (isConnected b c arc3)

        ; L'arc "arc3" relie les noeuds "c" et "b"
        (isConnected c b arc3)

        ; L'arc "arc4" relie les noeuds "b" et "d"
        (isConnected b d arc4)

        ; L'arc "arc4" relie les noeuds "d" et "b"
        (isConnected d b arc4)

        ; L'arc "arc5" relie les noeuds "c" et "d"
        (isConnected d c arc5)

        ; L'arc "arc5" relie les noeuds "d" et "c"
        (isConnected c d arc5)

        ; L'arc "arc6" relie les noeuds "d" et "e"
        (isConnected d e arc6)

        ; L'arc "arc6" relie les noeuds "e" et "d"
        (isConnected e d arc6)

        ; L'arc "arc7" relie les noeuds "c" et "e"
        (isConnected c e arc7)

        ; L'arc "arc7" relie les noeuds "e" et "c"
        (isConnected e c arc7)

        ; L'arc "arc8" relie les noeuds "e" et "f"
        (isConnected e f arc8)

        ; L'arc "arc8" relie les noeuds "f" et "e"
        (isConnected f e arc8)

        ; L'arc "arc9" relie les noeuds "c" et "f"
        (isConnected c f arc9)

        ; L'arc "arc9" relie les noeuds "f" et "c"
        (isConnected f c arc9)

        ; L'arc "arc1" n'est pas marqué
        (isNotMarked arc1)

        ; L'arc "arc2" n'est pas marqué
        (isNotMarked arc2)

        ; L'arc "arc3" n'est pas marqué
        (isNotMarked arc3)

        ; L'arc "arc4" n'est pas marqué
        (isNotMarked arc4)

        ; L'arc "arc5" n'est pas marqué
        (isNotMarked arc5)

        ; L'arc "arc6" n'est pas marqué
        (isNotMarked arc6)

        ; L'arc "arc7" n'est pas marqué
        (isNotMarked arc7)

        ; L'arc "arc8" n'est pas marqué
        (isNotMarked arc8)

        ; L'arc "arc9" n'est pas marqué
        (isNotMarked arc9)
    )

    ; But Final du problème GraphColoring
    ;
    ;
    ;                          *****
    ;                          | f |
    ;                          *****
    ;                         /     \
    ;                       /         \
    ;                   'arc9'        'arc8'
    ;                   /                  \
    ;                 /                      \
    ;            *****                        *****
    ;            | c | - - - - 'arc7' - - - - | e |
    ;            *****                        *****
    ;           /  |  \                         |  
    ;          /   |    \                       |   
    ;      'arc2'  |      \                     |  
    ;        /     |        \                   |    
    ;       /      |          \                 |      
    ;  *****       |            \               |       
    ;  | a |     'arc3'          'arc5'       'arc6'    
    ;  *****       |                  \         |       
    ;       \      |                   \        |      
    ;        \     |                     \      |     
    ;      'arc1'  |                      \     |  
    ;          \   |                        \   |   
    ;           \  |                         \  |  
    ;            *****                        *****
    ;            | b | - - - - 'arc4' - - - - | d |
    ;            *****                        *****
    ;
    ;
    (:goal
        
        ; Ensemble des conditions à satisfaire pour atteindre le but final
        (and
            ; L'arc "arc1" est marqué
            (isMarked arc1)

            ; L'arc "arc2" est marqué
            (isMarked arc2)

            ; L'arc "arc3" est marqué
            (isMarked arc3)

            ; L'arc "arc4" est marqué
            (isMarked arc4)

            ; L'arc "arc5" est marqué
            (isMarked arc5)

            ; L'arc "arc6" est marqué
            (isMarked arc6)

            ; L'arc "arc7" est marqué
            (isMarked arc7)

            ; L'arc "arc8" est marqué
            (isMarked arc8)

            ; L'arc "arc9" est marqué
            (isMarked arc9)
        )
    )
)