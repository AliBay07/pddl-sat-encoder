;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Exercice 1 : PursuitEvasion     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du problème PursuitEvasion
(define (problem p001)

    ; Definition du domaine utilisé : "PursuitEvasion"
    (:domain PursuitEvasion)

    ; Définition des objets utilisés
    (:objects
        
        ; n1, n2, n3, n4 et n5 sont des noeuds
        n1 n2 n3 n4 n5 - node

        ; arc1_2, arc2_5, arc2_3, arc2_4 et arc3_4 sont des arcs
        arc1_2 arc2_5 arc2_3 arc2_4 arc3_4 - arc

        ; a1 et a2 sont des agents
        a1 a2 - agent
    )

    ; Initialisation du problème PursuitEvasion
    ;
    ;
    ;   Noeud couvert : n1 (********)
    ;   Noeud non couvert : n2, n3, n4 et n5 (-------)
    ;
    ;   Arc couvert : X (*********)
    ;   Arc non couvert : arc1_2, arc2_5, arc2_3, arc2_4 et arc3_4 (-------)
    ;
    ;
    ;                                n5
    ;                            +-------+
    ;                            |       |
    ;                            |       |
    ;                            |       |
    ;                            +---+---+ 
    ;                                |   
    ;                                |
    ;                              arc2_5
    ;                                |
    ;                                |                         n4
    ;   *********                +---+---+                +-------+
    ;   |   a1  |                |       |                |       |
    ;   |       +---- arc1_2 ----+       +---- arc2_4 ----+       |
    ;   |   a2  |                |       |\               |       |
    ;   *********                +-------+  \             +---+---+
    ;       n1                       n2       \               |
    ;                                           \             |                                
    ;                                          arc2_3       arc3_4
    ;                                              \          |
    ;                                                \        |
    ;                                                  \  +---+---+
    ;                                                    \|       |
    ;                                                     +       |
    ;                                                     |       |
    ;                                                     +-------+
    ;                                                         n3      
    ;
    (:init
        
        ; L'agent "a1" est sur le noeud "n1"
        (isOnNode n1 a1)

        ; L'agent "a2" est sur le noeud "n1"
        (isOnNode n1 a2)

        ; Le noeud "n1" est couvert
        (isCovered n1)

        ; L'agent "a1" est différent de l'agent "a2"
        (isDifferentAgent a1 a2)

        ; L'agent "a2" est différent de l'agent "a1"
        (isDifferentAgent a2 a1)

        ; Le noeud "n1" est connecté au noeud "n2"
        (isConnected n1 n2)

        ; Le noeud "n1" est connecté au noeud "n2" par l'arc "arc1_2"
        (isConnectedArc n1 n2 arc1_2)

        ; Le noeud "n2" est connecté au noeud "n1"
        (isConnected n2 n1)

        ; Le noeud "n2" est connecté au noeud "n1" par l'arc "arc1_2"
        (isConnectedArc n2 n1 arc1_2)

        ; Le noeud "n2" est connecté au noeud "n4"
        (isConnected n2 n4)

        ; Le noeud "n2" est connecté au noeud "n4" par l'arc "arc2_4"
        (isConnectedArc n2 n4 arc2_4)

        ; Le noeud "n4" est connecté au noeud "n2"
        (isConnected n4 n2)

        ; Le noeud "n4" est connecté au noeud "n2" par l'arc "arc2_4"
        (isConnectedArc n4 n2 arc2_4)

        ; Le noeud "n2" est connecté au noeud "n3"
        (isConnected n2 n3)

        ; Le noeud "n2" est connecté au noeud "n3" par l'arc "arc2_3"
        (isConnectedArc n2 n3 arc2_3)

        ; Le noeud "n3" est connecté au noeud "n2"
        (isConnected n3 n2)

        ; Le noeud "n3" est connecté au noeud "n2" par l'arc "arc2_3"
        (isConnectedArc n3 n2 arc2_3)

        ; Le noeud "n2" est connecté au noeud "n5"
        (isConnected n2 n5)

        ; Le noeud "n2" est connecté au noeud "n5" par l'arc "arc2_5"
        (isConnectedArc n2 n5 arc2_5)

        ; Le noeud "n5" est connecté au noeud "n2"
        (isConnected n5 n2)

        ; Le noeud "n5" est connecté au noeud "n2" par l'arc "arc2_5"
        (isConnectedArc n5 n2 arc2_5)

        ; Le noeud "n3" est connecté au noeud "n4"
        (isConnected n3 n4)

        ; Le noeud "n3" est connecté au noeud "n4" par l'arc "arc3_4"
        (isConnectedArc n3 n4 arc3_4)

        ; Le noeud "n4" est connecté au noeud "n3"
        (isConnected n4 n3)

        ; Le noeud "n4" est connecté au noeud "n3" par l'arc "arc3_4"
        (isConnectedArc n4 n3 arc3_4)

        ; Le noeud "n1" a une seule connexion
        (singleConnection n1)

        ; Le noeud "n1" n'a pas plusieurs connexions
        (notMultipleConnection n1)

        ; Le noeud "n2" a plusieurs connexions
        (multipleConnection n2)

        ; Le noeud "n3" a deux connexions
        (doubleConnection n3)

        ; Le noeud "n4" a deux connexions
        (doubleConnection n4)

        ; Le noeud "n3" n'a pas plusieurs connexions
        (notMultipleConnection n3)

        ; Le noeud "n4" n'a pas plusieurs connexions
        (notMultipleConnection n4)

        ; Le noeud "n5" a une seule connexion
        (singleConnection n5)

        ; Le noeud "n5" n'a pas plusieurs connexions
        (notMultipleConnection n5)
    )

    ; But Final du problème PursuitEvasion
    ;
    ;
    ;   Noeud couvert : n1, n2, n3, n4 et n5 (********)
    ;   Noeud non couvert : X (-------)
    ;
    ;   Arc couvert : arc1_2, arc2_5, arc2_3, arc2_4 et arc3_4 (*********)
    ;   Arc non couvert : X (-------)
    ;
    ;
    ;                                n5
    ;                            *********
    ;                            |       |
    ;                            |       |
    ;                            |       |
    ;                            ********* 
    ;                                *   
    ;                                *
    ;                              arc2_5
    ;                                *
    ;                                *                         n4
    ;   *********                *********                *********
    ;   |       |                |   a1  |                |       |
    ;   |       +**** arc1_2 ****+       +**** arc2_4 ****+       |
    ;   |       |                |   a2  |*               |       |
    ;   *********                *********  *             *********
    ;       n1                       n2       *               *
    ;                                           *             *                                
    ;                                          arc2_3       arc3_4
    ;                                              *          *
    ;                                                *        *
    ;                                                  *  *********
    ;                                                    *|       |
    ;                                                     +       |
    ;                                                     |       |
    ;                                                     *********
    ;                                                         n3      
    ;
    (:goal
        
        ; Ensemble des conditions à satisfaire pour atteindre le but final
        (and
            
            ; Le noeud "n1" est couvert
            (isCovered n1)

            ; Le noeud "n2" est couvert
            (isCovered n2)

            ; Le noeud "n3" est couvert
            (isCovered n3)

            ; Le noeud "n4" est couvert
            (isCovered n4)

            ; Le noeud "n5" est couvert
            (isCovered n5)

            ; L'arc "arc1_2" est couvert
            (isCoveredArc arc1_2)

            ; L'arc "arc2_5" est couvert
            (isCoveredArc arc2_5)

            ; L'arc "arc2_3" est couvert
            (isCoveredArc arc2_3)

            ; L'arc "arc2_4" est couvert
            (isCoveredArc arc2_4)

            ; L'arc "arc3_4" est couvert
            (isCoveredArc arc3_4)
        )
    )
)