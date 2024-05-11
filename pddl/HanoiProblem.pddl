;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Exercice 1 : Hanoi     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du problème Hanoi
(define (problem hanoi_probleme)

    ; Definition du domaine utilisé : "hanoi"
    (:domain hanoi)

    ; Définition des objets utilisés
    (:objects
        
        ; bleu, blanc et rouge sont des objets
        bleu blanc rouge - object

        ; left, middle et right sont des piles
        left middle right - stack
    )

    ; Initialisation du problème Hanoi
    ;
    ;          | 
    ;          |
    ;   +------+-----+
    ;  /              \
    ;  \              /
    ;
    ;
    ;
    ;   +------------+
    ;   |    bleu    |
    ;   +------------+
    ;   |   blanc    |
    ;   +------------+
    ;   |   rouge    |
    ;   +------------+  +------------+  +------------+                   
    ;   |    left    |  |   middle   |  |   right    |
    ;   +------------+  +------------+  +------------+
    ;
    (:init
        
        ; L'object "bleu" est plus petit que l'object "blanc"
        (smaller bleu blanc)

        ; L'object "bleu" est plus petit que l'object "rouge"
        (smaller bleu rouge)

        ; L'object "blanc" est plus petit que l'object "rouge"
        (smaller blanc rouge)

        ; On empile l'object "rouge" sur la pile "left"
        (onstack rouge left)

        ; L'object "blanc" est sur l'object "rouge"
        (on blanc rouge)

        ; L'object "bleu" est sur l'object "blanc"
        (on bleu blanc)

        ; Il n'y a pas d'object sur l'object "bleu"
        (clear bleu)

        ; Il n'y a pas d'object sur la pile "middle"
        (clear middle)

        ; Il n'y a pas d'object sur la pile "right"
        (clear right)

        ; Le bras est vide
        (handempty)
    )

    ; But Final du problème Hanoi
    ;
    ;          | 
    ;          |
    ;   +------+-----+
    ;  /              \
    ;  \              /
    ;
    ;
    ;
    ;                                   +------------+
    ;                                   |    bleu    |
    ;                                   +------------+
    ;                                   |   blanc    |
    ;                                   +------------+
    ;                                   |   rouge    |
    ;   +------------+  +------------+  +------------+                   
    ;   |    left    |  |   middle   |  |   right    |
    ;   +------------+  +------------+  +------------+
    (:goal
        
        ; Ensemble des conditions à satisfaire pour atteindre le but final
        (and
            
            ; L'object "rouge" est sur la pile "right"
            (onstack rouge right)

            ; L'object "blanc" est sur l'object "rouge"
            (on blanc rouge)

            ; L'object "bleu" est sur l'object "blanc"
            (on bleu blanc)
        )
    )
)