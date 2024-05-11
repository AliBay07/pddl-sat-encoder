;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      Domaine : SatSolver     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Définition du domaine SatSolver
(define (domain SatSolver)

	(:requirements :strips :typing)

	; Types : clause, variable
	(:types clause variable)

	; Prédicats : Fonctions qui décrivent notre domaine
	(:predicates 
		
		; La variable "x" est vraie dans la clause "y"
		(isTrueInClause ?x - variable ?y - clause)

		; La variable "x" est fausse dans la clause "y"
		(isFalseInClause ?x - variable ?y - clause)

		; La variable "x" est vraie
		(isTrueVariable ?x - variable)

		; La variable "x" est fausse
		(isFalseVariable ?x - variable)

		; La clause "x" est résolue
		(isClauseSolved ?x - clause)

		; La variable "x" n'a pas de valeur
		(hasNoValue ?x - variable)
	)

	; Actions : Mettre une variable à vrai
	(:action putVariableToTrue
		
		; Paramètres : La variable "v"
		:parameters (?v - variable)

		; Préconditions de l'action : Mettre une variable à vrai
		:precondition

			; Ensemble des préconditions de cette action
			(and
				
				; La variable "v" n'a pas de valeur
				(hasNoValue ?v) 
			)

		; Effet de l'action : Mettre une variable à vrai
		:effect
		
			; Ensemble des effets de cette action
			(and 
				
				; La variable "v" a une valeur
				(not (hasNoValue ?v))

				; La variable "v" est vraie
				(isTrueVariable ?v)
			)
	)

	; Actions : Mettre une variable à faux
	(:action putVariableToFalse
		
		; Paramètres : La variable "v"
		:parameters (?v - variable)

		; Préconditions de l'action : Mettre une variable à faux
		:precondition
			
			; Ensemble des préconditions de cette action
			(and
				
				; La variable "v" n'a pas de valeur
				(hasNoValue ?v) 
			)

		; Effet de l'action : Mettre une variable à faux
		:effect
		
			; Ensemble des effets de cette action
			(and 
				
				; La variable "v" a une valeur
				(not (hasNoValue ?v))

				; La variable "v" est fausse
				(isFalseVariable ?v)
			)
	)

	; Actions : Résoudre une clause par une variable vraie
	(:action solveClauseByTrue
		
		; Paramètres : La clause "c" et la variable "v"
		:parameters (?c - clause ?v - variable)

		; Préconditions de l'action : Résoudre une clause par une variable vraie
		:precondition
		
			; Ensemble des préconditions de cette action
			(and 
				
				; La variable "v" est vraie dans la clause "c"
				(isTrueInClause ?v ?c)

				; La variable "v" est vraie
				(isTrueVariable ?v)
			)

		; Effet de l'action : Résoudre une clause par une variable vraie
		:effect
		
			; Ensemble des effets de cette action
			(and 
				
				; La clause "c" est résolue
				(isClauseSolved ?c)
			)
	)

	; Actions : Résoudre une clause par une variable fausse
	(:action solveClauseByFalse
		
		; Paramètres : La clause "c" et la variable "v"
		:parameters (?c - clause ?v - variable)

		; Préconditions de l'action : Résoudre une clause par une variable fausse
		:precondition
		
			; Ensemble des préconditions de cette action
			(and 
				
				; La variable "v" est fausse
				(isFalseVariable ?v)

				; La variable "v" est fausse dans la clause "c"
				(isFalseInClause ?v ?c)
			)

		; Effet de l'action : Résoudre une clause par une variable fausse
		:effect
		
			; Ensemble des effets de cette action
			(and 
				
				; La clause "c" est résolue
				(isClauseSolved ?c)
			)
	)
)