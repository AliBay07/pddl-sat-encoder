;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Exercice 1 : SatSolver     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du problème SatSolver
(define (problem p01)

    ; Definition du domaine utilisé : "SatSolver"
    (:domain SatSolver)

    ; Définition des objets utilisés
    (:objects
        
        ; c1, c2 et c3 sont des clauses
        c1 c2 c3 - clause

        ; x1, x2, x3 et x4 sont des variables
        x1 x2 x3 x4  - variable
    )

    ; Initialisation du problème SatSolver
    ;
    ;
    ;   Les variables sont définies comme suit :
    ;
    ;       x1 : pas de valeur
    ;       x2 : pas de valeur
    ;       x3 : pas de valeur
    ;       x4 : pas de valeur
    ;
    ;
    ;   Les clauses sont définies comme suit :
    ;                      __
    ;       c1 : x1 v x3 v x4
    ;
    ;       c2 : x4
    ;                 __
    ;       c3 : x2 v x3
    ;
    ;
    (:init
        
        ; La variable "x1" n'a pas de valeur
        (hasNoValue x1)

        ; La variable "x2" n'a pas de valeur
        (hasNoValue x2)

        ; La variable "x3" n'a pas de valeur
        (hasNoValue x3)

        ; La variable "x4" n'a pas de valeur
        (hasNoValue x4)

        ; La variable "x1" est vraie dans la clause "c1"
        (isTrueInClause x1 c1)

        ; La variable "x3" est vraie dans la clause "c1"
        (isTrueInClause x3 c1)

        ; La variable "x4" est fausse dans la clause "c1"
        (isFalseInClause x4 c1)

        ; La variable "x4" est vraie dans la clause "c2"
        (isTrueInClause x4 c2)

        ; La variable "x2" est vraie dans la clause "c3"
        (isTrueInClause x2 c3)

        ; La variable "x3" est fausse dans la clause "c3"
        (isFalseInClause x3 c3)
    )

    ; But Final du problème SatSolver
    ;
    ;
    ;   Les variables sont définies comme suit :
    ;
    ;       x1 : est vraie
    ;       x2 : est vraie
    ;       x3 : pas de valeur
    ;       x4 : est vraie
    ;
    ;
    ;   Les clauses sont définies comme suit :
    ;                      __
    ;       c1 : x1 v x3 v x4   ->    True v ? v Not(True)   ->   True v ? v False   ->   True
    ;
    ;       c2 : x4             ->    True
    ;                 __
    ;       c3 : x2 v x3        ->    True v ?               ->   True
    ;
    ;
    (:goal
        
        ; Ensemble des conditions à satisfaire pour atteindre le but final
        (and
            
            ; La clause "c1" est résolue
            (isClauseSolved c1)

            ; La clause "c2" est résolue
            (isClauseSolved c2)

            ; La clause "c3" est résolue
            (isClauseSolved c3)
        )
    )
)