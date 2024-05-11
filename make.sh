#!/bin/bash

export CP=.:jars/pddl4j-4.0.0.jar:jars/commons-cli-1.1.jar:jars/org.sat4j.core-2.3.1-tests.jar:jars/org.sat4j.core-2.3.1.jar:jars/org.sat4j.maxsat-2.3.1.jar:jars/org.sat4j.pb-2.3.1.jar

javac -cp "$CP" -d classes src/main/java/*.java

if [ "$#" -eq 0 ]; then
    DOMAIN_FILE="pddl/HanoiDomain.pddl"
    PROBLEM_FILE="pddl/HanoiProblem.pddl"
elif [ "$#" -eq 1 ]; then
    DOMAIN_FILE="pddl/HanoiDomain.pddl"
    PROBLEM_FILE="pddl/HanoiProblem.pddl"
else
    DOMAIN_FILE="pddl/$1"
    PROBLEM_FILE="pddl/$2"
fi

java -cp "$CP:classes" -server -Xms4096m -Xmx4096m SatEncoder "$DOMAIN_FILE" "$PROBLEM_FILE"

