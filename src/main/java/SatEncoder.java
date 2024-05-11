import fr.uga.pddl4j.heuristics.state.FastForward;
import fr.uga.pddl4j.parser.DefaultParsedProblem;
import fr.uga.pddl4j.parser.RequireKey;
import fr.uga.pddl4j.plan.Plan;
import fr.uga.pddl4j.plan.SequentialPlan;
import fr.uga.pddl4j.planners.AbstractPlanner;
import fr.uga.pddl4j.problem.DefaultProblem;
import fr.uga.pddl4j.problem.Fluent;
import fr.uga.pddl4j.problem.Problem;
import fr.uga.pddl4j.problem.State;
import fr.uga.pddl4j.problem.operator.Action;
import fr.uga.pddl4j.util.BitVector;
import org.sat4j.core.VecInt;
import org.sat4j.minisat.SolverFactory;
import org.sat4j.specs.ContradictionException;
import org.sat4j.specs.ISolver;
import org.sat4j.specs.TimeoutException;
import picocli.CommandLine;
import java.util.ArrayList;
import java.util.Arrays;

import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

/**
 * The class is a SAT planner. Solves a pddl problem using a SAT solver
 */
@CommandLine.Command(name = "SatEncoder",
        version = "SAT 1.0",
        description = "Solves a specified planning problem using a SAT Solver.",
        sortOptions = false,
        mixinStandardHelpOptions = true,
        headerHeading = "Usage:%n",
        synopsisHeading = "%n",
        descriptionHeading = "%nDescription:%n%n",
        parameterListHeading = "%nParameters:%n",
        optionListHeading = "%nOptions:%n")
public class SatEncoder extends AbstractPlanner {

    private static final Logger LOGGER = LogManager.getLogger(SatEncoder.class.getName());

    private final int VAR_COUNT = 100000;

    private final int CLAUSE_COUNT = 100000;

    private final long MAX_TIMER = 10 * 60 * 1000; // 10 minutes in milliseconds

    /**
     * Instantiates the planning problem from a parsed problem.
     *
     * @param problem the problem to instantiate.
     * @return the instantiated planning problem or null if the problem cannot be
     *         instantiated.
     */
    @Override
    public Problem instantiate(DefaultParsedProblem problem) {
        final Problem pb = new DefaultProblem(problem);
        pb.instantiate();
        return pb;
    }

    /**
     * Transform the propositions and actions to SAT variables, mapping them to unique integers.
     * Each proposition has a unique integer associated with its time step.
     * For example: Move(A,B,0) = 1, Move(A,B,1) = 5, etc.
     *
     * @param fluents       List of fluents representing initial states. (Liste des perdicats)
     * @param actions       List of actions available.
     * @param timeStep     Number of time steps.
     * @param existingVariables   List of previously created SAT variables.
     */
    private void createSATVariables(ArrayList<Fluent> fluents, ArrayList<Action> actions, int timeStep,
                                    ArrayList<SatVariable> existingVariables) {
        // Determine the starting variable name based on existing variables
        int variableName = existingVariables.isEmpty() ? 1 : existingVariables.size() + 1;
        int previousStep = existingVariables.isEmpty() ? 0 : timeStep - 1;
        int numFluents = fluents.size();
        int numActions = actions.size();

        // Iterate over the time steps
        for (int step = previousStep; step < timeStep; step++) {
            // Array to store the indices of fluents relative to the current time step
            int[] fluentVarIndices = new int[numFluents];

            // Transform propositions to SATVariables
            for (int i = 0; i < numFluents; i++) {
                SatVariable propositionVariable = new SatVariable(step, variableName, true);
                fluentVarIndices[i] = variableName++;

                // Add the new variable to existingVariables if it doesn't already exist
                if (!existingVariables.contains(propositionVariable)) {
                    existingVariables.add(propositionVariable);
                }
            }

            // Transform actions to SATVariables
            for (Action action : actions) {
                SatVariable actionVariable = new SatVariable(step, variableName, false);
                BitVector positiveEffects = action.getUnconditionalEffect().getPositiveFluents();
                BitVector negativeEffects = action.getUnconditionalEffect().getNegativeFluents();
                BitVector positivePreconditions = action.getPrecondition().getPositiveFluents();

                // Add positive effects to actions
                for (int i = 0; i < positiveEffects.length(); i++) {
                    if (positiveEffects.get(i)) {
                        actionVariable.addPositiveEffect(fluentVarIndices[i] + (numFluents + numActions));
                    }
                }

                // Add negative effects to actions
                for (int i = 0; i < negativeEffects.length(); i++) {
                    if (negativeEffects.get(i)) {
                        actionVariable.addNegativeEffect(fluentVarIndices[i] + (numFluents + numActions));
                    }
                }

                // Add positive preconditions to actions
                for (int i = 0; i < positivePreconditions.length(); i++) {
                    if (positivePreconditions.get(i)) {
                        actionVariable.addPrecondition(fluentVarIndices[i]);
                    }
                }

                // Increment variable name for the next SATVariable
                variableName++;

                // Add the new action variable to existingVariables if it doesn't already exist
                if (!existingVariables.contains(actionVariable)) {
                    existingVariables.add(actionVariable);
                }
            }
        }
    }

    /**
     * Creates a clause for state changes.
     *
     * @param fluentName         Name of the fluent.
     * @param fluentNext         Name of the next fluent.
     * @param actionList         List of actions affecting the fluent.
     * @return Clause for state changes.
     */
    private int[] createClause(int fluentName, int fluentNext, ArrayList<Integer> actionList) {
        // Initialize an array to store the clause
        int[] clause = new int[actionList.size() + 2];

        // Set the first two elements of the clause to represent the fluent and its negation in the next time step
        clause[0] = fluentName;
        clause[1] = -fluentNext;

        // Populate the clause with the indices of actions affecting the fluent
        for (int i = 0; i < actionList.size(); i++) {
            clause[i + 2] = actionList.get(i);
        }

        // Return the created clause
        return clause;
    }

    /**
     * Handles the generation of action implications for a given time step.
     *
     * @param satVariables List of SAT variables.
     * @param prevClauses  Previous list of clauses.
     * @param timeStep     The current time step.
     */
    private void handleActionImplications(ArrayList<SatVariable> satVariables, ArrayList<int[]> prevClauses, int timeStep) {
        for (SatVariable action : satVariables) {
            if (!action.isFluent() && action.getStep() == timeStep) {
                for (int precondition : action.getPreconditions()) {
                    prevClauses.add(new int[]{-action.getName(), precondition});
                }

                for (int positiveEffect : action.getPositiveEffects()) {
                    prevClauses.add(new int[]{-action.getName(), positiveEffect});
                }

                for (int negativeEffect : action.getNegativeEffects()) {
                    prevClauses.add(new int[]{-action.getName(), -negativeEffect});
                }
            }
        }
    }


    /**
     * Handles the generation of state transitions for a given time step.
     *
     * @param satVariables    List of SAT variables.
     * @param prevClauses     Previous list of clauses.
     * @param timeStep        The current time step.
     * @param varPerTimeStep Number of variables per time step.
     */
    private void handleStateTransition(ArrayList<SatVariable> satVariables, ArrayList<int[]> prevClauses, int timeStep, int varPerTimeStep) {
        for (SatVariable fluent : satVariables) {
            if (fluent.isFluent() && fluent.getStep() == timeStep) {
                int fluentNext = fluent.getName() + varPerTimeStep;
                ArrayList<Integer> actionWithPosEffect = new ArrayList<>();
                ArrayList<Integer> actionWithNegEffect = new ArrayList<>();


                // Find actions affecting the fluent in the next time step
                for (SatVariable action : satVariables) {
                    if (action.getStep() == timeStep && !action.isFluent()) {
                        for (int affectedF : action.getPositiveEffects()) {
                            if (affectedF == fluentNext) {
                                actionWithPosEffect.add(action.getName());
                                break;
                            }
                        }

                        for (int affectedF : action.getNegativeEffects()) {
                            if (affectedF == fluentNext) {
                                actionWithNegEffect.add(action.getName());
                                break;
                            }
                        }
                    }
                }

                // Add clauses representing state changes
                prevClauses.add(createClause(fluent.getName(), fluentNext, actionWithPosEffect));
                prevClauses.add(createClause(-fluent.getName(), -fluentNext, actionWithNegEffect));
            }
        }
    }

    /**
     * Handles the generation of action disjunction for a given time step.
     *
     * @param satVariables List of SAT variables.
     * @param prevClauses  Previous list of clauses.
     * @param timeStep     The current time step.
     */
    private void handleActionDisjunction(ArrayList<SatVariable> satVariables, ArrayList<int[]> prevClauses, int timeStep) {
        ArrayList<Integer> handledActions = new ArrayList<>();
        for (SatVariable action : satVariables) {
            if (!action.isFluent() && action.getStep() == timeStep && !handledActions.contains(action.getName())) {
                for (SatVariable otherAction : satVariables) {
                    if (!otherAction.isFluent() && otherAction.getStep() == timeStep && action.getName() != otherAction.getName()) {
                        prevClauses.add(new int[]{-action.getName(), -otherAction.getName()});
                    }
                }
                handledActions.add(action.getName());
            }
        }
    }

    /**
     * Generates transition clauses for a SAT problem.
     *
     * @param satVariables     List of SAT variables.
     * @param prevClauses      Previous list of clauses.
     * @param lastStep         Last step of transition.
     * @param varPerTimeStep  Number of variables per time step.
     */
    private void generateTransitionClauses(ArrayList<SatVariable> satVariables,
                                           ArrayList<int[]> prevClauses,
                                           int lastStep, int varPerTimeStep) {
        // Determine the starting time step based on whether previous clauses exist
        int startTime = (prevClauses.isEmpty()) ? 0 : lastStep - 1;

        // Iterate over each time step
        for (int timeStep = startTime; timeStep < lastStep; timeStep++) {
            handleActionImplications(satVariables, prevClauses, timeStep);
            handleStateTransition(satVariables, prevClauses, timeStep, varPerTimeStep);
            handleActionDisjunction(satVariables, prevClauses, timeStep);
        }
    }

    /**
     * Encodes goal state clauses for the SAT problem.
     *
     * @param fluents     List of fluents.
     * @param goalState   Goal state.
     * @param variableSize Size of variables per time step.
     * @param stepCount   Total number of time steps.
     * @return List of goal state clauses.
     */
    private ArrayList<int[]> encodeGoalState(ArrayList<Fluent> fluents, BitVector goalState, int variableSize, int stepCount) {
        // Initialize the list to store goal clauses
        ArrayList<int[]> goalClauses = new ArrayList<>();

        // Iterate over each fluent
        for (int i = 1; i <= fluents.size(); i++) {
            // Calculate the index of the fluent in the last step
            int fluentIndex = i + (variableSize * (stepCount));

            // If the fluent is present in the goal state, add it to the clause
            if (goalState.get(i - 1)) {
                int[] clause = {fluentIndex};
                goalClauses.add(clause);
            }
        }

        // Return the list of goal clauses
        return goalClauses;
    }

    /**
     * Adds clauses to the SAT solver.
     *
     * @param solver      The SAT solver instance.
     * @param clauses     List of clauses to add.
     */
    private boolean addClauses(ISolver solver, ArrayList<int[]> clauses) {
        // Iterate over each clause
        for (int[] clause : clauses) {
            try {
                // Check if the clause is non-empty
                if (clause.length > 0) {
                    // Add the clause to the solver
                    solver.addClause(new VecInt(clause));
                } else {
                    // Log a message if the clause has an invalid format
                    LOGGER.info("Clause with invalid format!");
                }
            } catch (ContradictionException e) {
                return false;
            }
        }
        return true;
    }

    /**
     * Retrieves the initial clauses based on the given problem and list of sat variables.
     *
     * @param problem    The problem instance containing initial state information.
     * @return           A list of initial clauses represented as arrays of integers.
     */
    private ArrayList<int[]> getInitClauses(Problem problem, ArrayList<SatVariable> variables) {
        // Initialize the list to store initial clauses
        ArrayList<int[]> initClauses = new ArrayList<>();

        // Get the positive fluents of the initial state
        BitVector initState = problem.getInitialState().getPositiveFluents();

        // Iterate over each SAT variable
        for (SatVariable v : variables) {
            // Check if the variable is at step 0 and is a fluent
            if (v.getStep() == 0 && v.isFluent()) {
                int varName = v.getName();
                // Create a clause based on whether the variable is true or false in the initial state
                int[] clause = { initState.get(varName - 1) ? varName : -varName };
                // Add the clause to the list of initial clauses
                initClauses.add(clause);
            }
        }
        // Return the list of initial clauses
        return initClauses;
    }

    /**
     * Calculates the estimation of the minimum number of steps required to reach the goal state from the initial state.
     *
     * @param problem The problem instance for which the estimation is calculated.
     * @return An estimation of the minimum number of steps required to reach the goal state from the initial state.
     */
    int calculateEstimation(Problem problem) {
        FastForward ff = new FastForward(problem);
        State init = new State(problem.getInitialState());
        return ff.estimate(init, problem.getGoal());
    }

    /**
     * Search a solution plan to a specified domain and problem using SAT.
     *
     * @param problem the problem to solve.
     * @return the plan found or null if no plan was found.
     */
    @Override
    public Plan solve(final Problem problem) {
        // Log the start of the SAT search
        LOGGER.info("* Starting SAT search \n");

        problem.instantiate();

        // Initialize variables
        int stepCount = calculateEstimation(problem);
        ArrayList<Fluent> fluents = new ArrayList<>(problem.getFluents());
        ArrayList<Action> actions = new ArrayList<>(problem.getActions());
        ArrayList<int[]> transitionClauses = new ArrayList<>();
        ArrayList<SatVariable> variables = new ArrayList<>();

        int variableSize = fluents.size() + actions.size();

        BitVector goalState = problem.getGoal().getPositiveFluents();

        ArrayList<int[]> initClauses =  new ArrayList<>();
        ArrayList<int[]> goalClauses;

        // Start the search timer
        long searchTimeStart = System.currentTimeMillis();

        boolean firstIt = true;
        // Continue the search until the time limit is reached
        while (System.currentTimeMillis() - searchTimeStart <= MAX_TIMER) {

            System.out.println("Starting step " + stepCount);

            // Create a new solver instance
            ISolver solver = SolverFactory.newDefault();
            solver.newVar(VAR_COUNT);
            solver.setExpectedNumberOfClauses(CLAUSE_COUNT);

            // Generate SAT clauses
            createSATVariables(fluents, actions, stepCount, variables);
            if (firstIt) {
                firstIt = false;
                initClauses = getInitClauses(problem, variables);
            }
            generateTransitionClauses(variables, transitionClauses, stepCount, variableSize);
            goalClauses = encodeGoalState(fluents, goalState, variableSize, stepCount);

            boolean initClausesAdded = addClauses(solver, initClauses);
            boolean transitionClausesAdded = addClauses(solver, transitionClauses);
            boolean goalClausesAdded = addClauses(solver, goalClauses);

            if (!initClausesAdded || !transitionClausesAdded || !goalClausesAdded) {
                stepCount++;
                continue;
            }

            try {
                // Check if the solver found a satisfying assignment
                if (solver.isSatisfiable()) {
                    Plan plan = new SequentialPlan();
                    int[] solution = solver.findModel();

                    // Reconstruct the plan from the solution
                    Action action;
                    for (int s : solution) {
                        for (SatVariable v : variables) {
                            if (!v.isFluent() && v.getName() == s) {
                                int index = (v.getName() % variableSize == 0) ?
                                        actions.size() - 1 :
                                        (v.getName() % variableSize) - fluents.size() - 1;

                                action = actions.get(index);
                                plan.add(v.getStep(), action);
                                break;
                            }
                        }
                    }

                    LOGGER.info("\nPlan found in {} seconds\n", ((float) (System.currentTimeMillis() - searchTimeStart) / 600));
                    return plan;
                }

                stepCount++; // Increment step count for next iteration
            } catch (TimeoutException e) {
                throw new RuntimeException(e);
            }
        }

        // Log a message if the search timeout is exceeded
        LOGGER.info("Search timeout: " + (MAX_TIMER / 60000) + " minutes exceeded");
        return null;
    }

    /**
     * Returns if a specified problem is supported by the planner. Just ADL problem can be solved by this planner.
     *
     * @param problem the problem to test.
     * @return <code>true</code> if the problem is supported <code>false</code> otherwise.
     */
    @Override
    public boolean isSupported(Problem problem) {
        return !problem.getRequirements().contains(RequireKey.ACTION_COSTS)
                && !problem.getRequirements().contains(RequireKey.CONSTRAINTS)
                && !problem.getRequirements().contains(RequireKey.CONTINOUS_EFFECTS)
                && !problem.getRequirements().contains(RequireKey.DERIVED_PREDICATES)
                && !problem.getRequirements().contains(RequireKey.DURATIVE_ACTIONS)
                && !problem.getRequirements().contains(RequireKey.DURATION_INEQUALITIES)
                && !problem.getRequirements().contains(RequireKey.FLUENTS)
                && !problem.getRequirements().contains(RequireKey.GOAL_UTILITIES)
                && !problem.getRequirements().contains(RequireKey.METHOD_CONSTRAINTS)
                && !problem.getRequirements().contains(RequireKey.NUMERIC_FLUENTS)
                && !problem.getRequirements().contains(RequireKey.OBJECT_FLUENTS)
                && !problem.getRequirements().contains(RequireKey.PREFERENCES)
                && !problem.getRequirements().contains(RequireKey.TIMED_INITIAL_LITERALS)
                && !problem.getRequirements().contains(RequireKey.HIERARCHY);
    }

    /**
     * The main method of the <code>SAT</code> planner.
     *
     * @param args the arguments of the command line.
     */
    public static void main(String[] args) {
        try {
            final SatEncoder encoder = new SatEncoder();
            CommandLine cmd = new CommandLine(encoder);
            cmd.execute(args);
        } catch (IllegalArgumentException e) {
            LOGGER.fatal(e.getMessage());
        }
    }
}

