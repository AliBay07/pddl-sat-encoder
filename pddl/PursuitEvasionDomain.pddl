;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Domaine : PursuitEvasion     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du domaine PursuitEvasion
(define (domain PursuitEvasion)

    (:requirements :strips :typing)
    
    ; Types : noeud, arc, agent
    (:types node arc agent)

    ; Prédicats : Fonctions qui décrivent notre domaine
    (:predicates
            
        ; L'agent "x" est différent de l'agent "y"
		(isDifferentAgent ?x ?y - agent)
	
        ; Le noeud "x" est connecté au noeud "y"
        (isConnected ?x ?y - node)

        ; Le noeud "x" est connecté au noeud "y" par l'arc "z"
        (isConnectedArc ?x ?y - node ?z - arc)

        ; L'agent "y" est sur le noeud "x"
        (isOnNode ?x - node ?y - agent)

        ; Le noeud "x" est couvert
        (isCovered ?x - node)

        ; L'arc "x" est couvert
        (isCoveredArc ?x - arc)

        ; Le noeud "x" a une seule connexion
        (singleConnection ?x - node)

        ; Le noeud "x" a deux connexions
        (doubleConnection ?x - node)

        ; Le noeud "x" a plusieurs connexions
        (multipleConnection ?x - node)

        ; Le noeud "x" n'a pas plusieurs connexions
        (notMultipleConnection ?x - node)
	)

    ; Actions : Couverture d'une connexion simple
    (:action coverSingleConnection
    	
    	; Paramètres : Le noeud "n1", le noeud "n2", l'agent "a" et l'arc "arc1"
    	:parameters (?n1 - node ?n2 - node ?a - agent ?arc1 - arc)
    	
    	; Préconditions de l'action : Couverture d'une connexion simple
        :precondition
    	
			; Ensemble des préconditions de cette action
    		(and
                
				; L'agent "a" est sur le noeud "n1"
    			(isOnNode ?n1 ?a)
    			
				; Le noeud "n1" est connecté au noeud "n2"
                (isConnected ?n1 ?n2)
                
                ; Le noeud "n1" a une seule connexion
                (singleConnection ?n1)
                
                ; Le noeud "n1" est connecté au noeud "n2" par l'arc "arc1"
                (isConnectedArc ?n1 ?n2 ?arc1)
            )
    	
    	; Effet de l'action : Couverture d'une connexion simple
        :effect
    	
			; Ensemble des effets de cette action
    		(and 
                
				; L'agent "a" n'est plus sur le noeud "n1"
    			(not (isOnNode ?n1 ?a))
                
				; L'agent "a" est sur le noeud "n2"
    			(isOnNode ?n2 ?a)
                
				; Le noeud "n2" est couvert
    			(isCovered ?n2)
                
				; L'arc "arc1" est couvert
    			(isCoveredArc ?arc1)
            )
    )

    ; Actions : Couverture d'une connexion double
    (:action coverDoubleConnection
    	
    	; Paramètres : Le noeud "n1", le noeud "n2", le noeud "n3", l'agent "a" et les arcs "arc12" et "arc23"
        :parameters (?n1 - node ?n2 - node ?n3 - node ?a - agent ?arc12 - arc ?arc23 - arc)
        
        ; Préconditions de l'action : Couverture d'une connexion double
        :precondition
    	
			; Ensemble des préconditions de cette action
    		(and
    			
				; Le noeud "n3" est couvert
                (isCovered ?n3)
                
				; L'agent "a" est sur le noeud "n1"
                (isOnNode ?n1 ?a)
                
				; Le noeud "n1" est connecté au noeud "n2"
                (isConnected ?n1 ?n2)
                
				; Le noeud "n2" est connecté au noeud "n3"
                (isConnected ?n2 ?n3)
                
				; Le noeud "n1" a deux connexions
                (doubleConnection ?n1)
                
				; Le noeud "n1" est connecté au noeud "n2" par l'arc "arc12"
                (isConnectedArc ?n1 ?n2 ?arc12)
                
				; Le noeud "n2" est connecté au noeud "n3" par l'arc "arc23"
                (isConnectedArc ?n2 ?n3 ?arc23)
            )
    		
    	; Effet de l'action : Couverture d'une connexion double
        :effect
    	
			; Ensemble des effets de cette action
    		(and 
                
				; L'agent "a" n'est plus sur le noeud "n1"
    			(not (isOnNode ?n1 ?a))
                
				; L'agent "a" est sur le noeud "n2"
    			(isOnNode ?n2 ?a)
                
				; Le noeud "n2" est couvert
    			(isCovered ?n2)
                
				; L'arc "arc12" est couvert
    			(isCoveredArc ?arc12)
            )
    )
    
    ; Actions : Couverture d'une connexion multiple
    (:action coverMultipleNodes
    	
    	; Paramètres : Le noeud "n1", le noeud "n2", l'agent "a1", l'agent "a2" et l'arc "arc12"
        :parameters (?n1 - node ?n2 - node ?a1 - agent ?a2 - agent ?arc12 - arc)
        
        ; Préconditions de l'action : Couverture d'une connexion multiple
        :precondition
    	
			; Ensemble des préconditions de cette action
    		(and 
                
				; Les agents "a1" et "a2" sont différents
    			(isDifferentAgent ?a1 ?a2)
                
				; L'agent "a1" est sur le noeud "n1"
    			(isOnNode ?n1 ?a1)
                
				; L'agent "a2" est sur le noeud "n1"
    			(isOnNode ?n1 ?a2)
                
				; Le noeud "n1" est connecté au noeud "n2"
    			(isConnected ?n1 ?n2)
                
    			; Le noeud "n1" est connecté au noeud "n2" par l'arc "arc12"
    			(isConnectedArc ?n1 ?n2 ?arc12)
                
				; Le noeud "n1" a plusieurs connexions
                (multipleConnection ?n1)
            )
    	
		; Effet de l'action : Couverture d'une connexion multiple
        :effect
    	
			; Ensemble des effets de cette action
    		(and 
                
				; L'agent "a1" n'est plus sur le noeud "n1"
    			(not (isOnNode ?n1 ?a1))
                
				; L'agent "a1" est sur le noeud "n2"
    			(isOnNode ?n2 ?a1)
                
				; Le noeud "n2" est couvert
    			(isCovered ?n2)
                
				; L'arc "arc12" est couvert
                (isCoveredArc ?arc12)
            )
    )

    ; Actions : Déplacement de l'agent
    (:action moveAgent
    	
    	; Paramètres : Le noeud "n1", le noeud "n2", l'agent "a" et l'arc "arc"
        :parameters (?n1 - node ?n2 - node ?a - agent ?arc - arc)
        
        ; Préconditions de l'action : Déplacement de l'agent
        :precondition
    	
			; Ensemble des préconditions de cette action
    		(and 
                
				; L'agent "a" est sur le noeud "n1"
    			(isOnNode ?n1 ?a)
    			
				; Le noeud "n1" est connecté au noeud "n2"
                (isConnected ?n1 ?n2)
                
				; Le noeud "n1" est connecté au noeud "n2" par l'arc "arc"
                (isConnectedArc ?n1 ?n2 ?arc)
                
				; Le noeud "n1" n'a pas plusieurs connexions
                (notMultipleConnection ?n1)
            )
    		
    	; Effet de l'action : Déplacement de l'agent
        :effect
    	
			; Ensemble des effets de cette action
    		(and 
                
				; L'agent "a" n'est plus sur le noeud "n1"
    			(not (isOnNode ?n1 ?a))
    			
				; Le noeud "n1" n'est plus couvert
                (not (isCovered ?n1))
                
				; L'agent "a" est sur le noeud "n2"
                (isOnNode ?n2 ?a)
                
				; Le noeud "n2" est couvert
                (isCovered ?n2)
                
				; L'arc "arc" n'est plus couvert
                (not (isCoveredArc ?arc))
            )
    )
)