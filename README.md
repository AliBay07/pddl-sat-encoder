# pddl-sat-encoder

## Overview

pddl-sat-encoder is a project designed to solve planning problems specified in PDDL (Planning Domain Definition Language). It converts PDDL domain and problem files into a SAT (Satisfiability) problem representation, which is then solved using SAT4J. If a plan is found, the results are decoded to generate the sequence of actions needed to solve the problem in PDDL format.

## Compile and Test

To compile and execute the SAT Planning tool, navigate to the `pddl-sat-encoder` directory.

```bash
cd pddl-sat-encoder
```

Then, run the make.sh script, replacing `<domain_file.pddl>` with the name of the PDDL domain file and `<problem_file.pddl>` with the name of the PDDL problem file.

```bash
bash make.sh <domain_file.pddl> <problem_file.pddl>
```

Some example domains and problems can be found in the `pddl-sat-encoder/pddl` directory.







