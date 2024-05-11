;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Domaine : Hanoi     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du domaine Hanoi
(define (domain hanoi)

	(:requirements :strips :typing)

	; Types : object, stack
	(:types object stack)

	; Prédicats : Fonctions qui décrivent notre domaine
	(:predicates
		
		; L'object "x" est sur l'object "y"
		(on ?x - object ?y - object)

		; On empile l'object "x" sur la pile "p"
		(onstack ?x - object ?p - stack)

		; Il n'y a pas d'object au dessus de l'object "x"
		(clear ?x - object)

		; Le bras est vide
		(handempty)

		; L'object "x" est tenu par le bras
		(holding ?x - object)

		; L'object "x" est plus petit que l'object "y"
		(smaller ?x - object ?y - object)
	)

	; Action : Prendre un objet sur la pile
	(:action pick-up
		
		; Paramètres : L'object "x" et la pile "p"
		:parameters (?x - object ?p - stack)

		; Préconditions de l'action : Prendre un object sur la pile
		:precondition

			; Ensemble des préconditions de cette action
			(and
				
				; Il n'y a pas d'object au dessus de l'object "x"
				(clear ?x)
				
				; L'object "x" est sur la pile "p"
				(onstack ?x ?p)

				; Le bras est vide
				(handempty)
			)

		; Effets de l'action : Prendre un object
		:effect

			; Ensemble des effets de cette action
			(and
				
				; L'object "x" est tenu par le bras
				(holding ?x)

				; Il n'y a pas d'object au dessus de l'object "p"
				(clear ?p)

				; Il y a un object au dessus de l'object "x"
				(not (clear ?x))

				; Le bras n'est plus vide
				(not (handempty))

				; L'object "x" n'est plus sur la pile "p"
				(not (onstack ?x ?p))
			)
	)

	; Action : Poser un objet sur le pile
	(:action put-down
		
		; Paramètres : L'object "x" et la pile "p"
		:parameters (?x - object ?p - stack)

		; Préconditions de l'action : Poser un object sur le pile
		:precondition
		
			; Ensemble des préconditions de cette action
			(and
				
				; L'object "x" est tenu par le bras
				(holding ?x)

				; Il n'y a pas d'object au dessus de l'object "p"
				(clear ?p)
			)

		; Effets de l'action : Poser un object sur le pile
		:effect
		
			; Ensemble des effets de cette action
			(and
				
				; L'object "x" n'est plus tenu par le bras
				(not (holding ?x))

				; Il y a un object au dessus de l'object "p"
				(not (clear ?p))

				; Il n'y a pas d'object au dessus de l'object "x"
				(clear ?x)

				; Le bras est vide
				(handempty)

				; L'object "x" est sur la pile "p"
				(onstack ?x ?p)
			)
	)

	; Action : Empiler un objet sur un autre objet
	(:action stack
		
		; Paramètres : L'object "x" et l'object "y"
		:parameters (?x - object ?y - object)

		; Préconditions de l'action : Empiler un objet sur un autre objet
		:precondition

			; Ensemble des préconditions de cette action
			(and
				
				; L'object "x" est tenu par le bras
				(holding ?x)

				; Il n'y a pas d'object au dessus de l'object "y"
				(clear ?y)

				; L'object "x" est plus petit que l'object "y"
				(smaller ?x ?y)
			)

		; Effets de l'action : Empiler un objet sur un autre objet
		:effect
		
			; Ensemble des effets de cette action
			(and
				
				; L'object "x" n'est plus tenu par le bras
				(not (holding ?x))

				; Il y a un object au dessus de l'object "y"
				(not (clear ?y))

				; Il n'y a pas d'object au dessus de l'object "x"
				(clear ?x)

				; Le bras est vide
				(handempty)

				; L'object "x" est sur l'object "y"
				(on ?x ?y)
			)
	)

	; Action : Dépiler un objet depuis un autre objet
	(:action unstack
		
		; Paramètres : L'object "x" et l'object "y"
		:parameters (?x - object ?y - object)

		; Préconditions de l'action : Dépiler un objet depuis un autre objet
		:precondition
			
			; Ensemble des préconditions de cette action
			(and
				
				; Il n'y a pas d'object au dessus de l'object "x"
				(clear ?x)

				; L'object "x" est sur l'object "y"
				(on ?x ?y)

				; Le bras est vide
				(handempty)
			)

		; Effets de l'action : Dépiler un objet depuis un autre objet
		:effect
			
			; Ensemble des effets de cette action
			(and
				
				; L'object "x" n'est plus sur l'object "y"
				(not (on ?x ?y))

				; Il y a un object au dessus de l'object "x"
				(not (clear ?x))

				; Le bras n'est plus vide
				(not (handempty))

				; L'object "x" est tenu par le bras
				(holding ?x)

				; Il n'y a pas d'object au dessus de l'object "y"
				(clear ?y)
			)
	)
)