;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;       Domaine : Blocksworld      ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du domaine Blocksworld
(define (domain blocks)

	(:requirements :strips :typing)

	; Types : Les blocs sont de type "block"
	(:types block)

	; Prédicats : Fonctions qui décrivent notre domaine
	(:predicates
		
  		; Le bloc "x" est sur le bloc "y"
  		(on ?x - block ?y - block)
  		
  		; Le bloc "x" est sur la table
  		(ontable ?x - block)
  		
  		; Le bloc "x" est attrapable par le bras
  		(clear ?x - block)
  		
  		; Le bras est vide
  		(handempty)
  		
  		; Le bras tient le bloc "x"
  		(holding ?x - block)
	)

	; Action : Prendre un bloc
	(:action pick-up
		
		; Paramètres : Le bloc "x"
		:parameters (?x - block)

		; Préconditions de l'action : Prendre un bloc
		:precondition

			; Ensemble des préconditions de cette action
			(and 
				; Le bloc "x" est attrapable
				(clear ?x)

				; Le bloc "x" est sur la table
				(ontable ?x)

				; Le bras est vide
				(handempty)
			)

		; Effets de l'action : Prendre un bloc
		:effect

			; Ensemble des effets de cette action
			(and
				; Le bloc "x" n'est plus sur la table
				(not (ontable ?x))
	        
				; Le bloc "x" n'est plus attrapable (le bloc "x" est attrapé)
				(not (clear ?x))

				; Le bras n'est plus vide (il tient le bloc "x")
				(not (handempty))

				; Le bras tient le bloc "x"
				(holding ?x)
			)
	)

	; Action : Poser un bloc
	(:action put-down
		
		; Paramètres : Le bloc "x"
		:parameters (?x - block)

		; Préconditions de l'action : Poser un bloc
		:precondition 

			; Le bras tient le bloc "x"
			(holding ?x)

		; Effets de l'action : Poser un bloc
		:effect

			; Ensemble des effets de cette action
			(and
				; Le bras ne tient plus le bloc "x"
				(not (holding ?x))
	        
				; Le bloc "x" est sur la table
				(ontable ?x)

				; Le bras est vide
				(handempty)

				; Le bloc "x" est attrapable
				(clear ?x)
			)
	)

	; Action : Empiler un bloc sur un autre bloc
	(:action stack
		
		; Paramètres : Les blocs "x" et "y"
		:parameters (?x - block ?y - block)

		; Préconditions de l'action : Empiler un bloc sur un autre bloc
		:precondition

			; Ensemble des préconditions de cette action
			(and 
				; Le bras tient le bloc "x"
				(holding ?x)

				; Le bloc "y" est attrapable
				(clear ?y)
			)

		; Effets de l'action : Empiler un bloc sur un autre bloc
		:effect

			; Ensemble des effets de cette action
			(and
				; Le bras ne tient plus le bloc "x"
				(not (holding ?x))
	        
				; Le bloc "y" n'est plus attrapable (le bloc "x" est au dessus du bloc "y")
				(not (clear ?y))

				; Le bloc "x" est attrapable
				(clear ?x)

				; Le bras est vide
				(handempty)

				; Le bloc "x" est sur le bloc "y"
				(on ?x ?y)
			)
	)

	; Action : Dépiler un bloc d'un autre bloc
	(:action unstack
		
		; Paramètres : Les blocs "x" et "y"
		:parameters (?x - block ?y - block)

		; Préconditions de l'action : Dépiler un bloc d'un autre bloc
		:precondition

			; Ensemble des préconditions de cette action
			(and 
				; Le bloc "x" est sur le bloc "y"
				(on ?x ?y)

				; Le bloc "x" est attrapable
				(clear ?x)

				; Le bras est vide
				(handempty)
			)

		; Effets de l'action : Dépiler un bloc d'un autre bloc
		:effect

			; Ensemble des effets de cette action
			(and
				; Le bras tient le bloc "x"
				(holding ?x)
	        
				; Le bloc "y" est attrapable
				(clear ?y)

				; Le bloc "x" n'est plus sur le bloc "y"
				(not (on ?x ?y))

				; Le bras n'est plus vide (il tient le bloc "x")
				(not (handempty))

				; Le bloc "x" n'est plus attrapable (le bloc "x" est attrapé)
				(not (clear ?x))
			)
	)
)