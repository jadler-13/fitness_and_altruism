# Fitness and Altruism
To explore the model, simply install [NetLogo](https://ccl.northwestern.edu/netlogo/download.shtml), then download and run *fitness_and_altruism.nlogo*.

## PURPOSE OF THE MODEL

This model simulates the impact of altruistic behaviour on individual fitness. It is based on the idea of *stakeholder altruism* presented by Gilbert Roberts in his 2005 publication "Cooperation through interdependence" (Animal Behaviour 70.4 (2005): 901-908.).

## HOW IT WORKS

There are three types of agents: *altruists*, *egoists*, and *predators*. The first two will also be referred to as *harmless agents* for brevity's sake. Each agent has a lifespan (after which it disappears) and a reproduction time (after which it clones itself). When an altruist "touches" another harmless agent, it decreases its own lifespan by a *cost* value and increases the lifespan of the other agent by a *benefit* value.

Example: if *cost = 1* and *benefit = 2*, a meeting of two altruists will cause both their lifespans to increase by 1. A meeting between an altruist and an egoist will decrease the altruist's lifespan by 1, while increasing the egoist's lifespan by 2.

Predators only exist to create selection pressure. When a predator touches a harmless agent, it checks the number of nearby harmless agents against the number of nearby predators. If the former outnumber the latter by more than 1, the predator disappears (this simulates defensive cooperation or *safety in numbers*). If not, the harmless agent disappears and the predator increases its lifespan and decreases its reproduction time (this "reward" is arbitrarily chosen and only serves to ensure a stable predator population with the default parameters).

Since altruistic behaviour (as defined above) increases the chance of having other harmless agents nearby, which increases the chance of "surviving" encounters with predators, it increases individual fitness. At the same time, altruistic behaviour comes with a fitness loss that correlates with egoist population size, since encounters with egoists decrease the lifespan of altruists. Because of this, long-term coexistence of altruists and egoists is unlikely in the model, and one is usually selected over the other within a short period of time.

## HOW TO USE IT

Playing around with the given parameters can illustrate their impact on population dynamics. It is however important to keep in mind that the simulated agents and their dynamics are extremely simple and no direct inferences can be made to real-world ecosystems.

**population**: The number of agents of a certain type at the beginning of the experiment.

**lifespan**: The number of ticks after which an agent disappears.

**reproduction time**: The number of ticks after which an agents clones itself.

**capacity**: When an agent population exceeds this number, a random fraction of it disappears. This simulates the carrying capacity of an ecosystem.

**benefit**: The number by which an altruist increases the lifespan of other harmless agents when touching them.

**cost**: The number by which an altruist increases its own lifespan when touching another harmless agent.

**maximum ticks**: The number of ticks after which the experiment ends.

**setup**: Creates a number (determined by *population* parameters) of agents and randomly places them on the board. (= sets up experimental starting conditions)

**go**: Starts the experiment.

**cycles**: Runs multiple experiments in a row and records the survival rate of different agent populations.

## STAKE-VALUES

From the abstract of **Cooperation through interdependence**:

*"I formalize the degree of interdependence by defining an individual’s ‘stake’ in another as the dependence of its fitness on that of the other."*

What is called "neutral stake value" in the model is defined by **s** in: 

**s*b - c = 0**

in which **b** and **c** are the benefit and cost as defined in the section above.

This should be interpreted as the degree of interdepence at which the cost and benefit of altruism are balanced, leading to zero impact on individual fitness. Altruistic behaviour is expected to be selected for if the stake value exceeds this *neutral value* **s**. The actual interdependence for a set of parameters is estimated by the *approximate stake value* reported at the end of an experiment cycle.

## THINGS TO TRY

1) Increase *harmless_reproduction_time* by 1, while leaving other parameters unchanged and observe the change in altruist fitness.

2) From **Cooperation through interdependence**:

*„As group size increases, reciprocal altruism declines markedly (Boyd & Richerson 1988). Further work will be required to test whether cooperation through interdependence is any less susceptible to increasing group size.“*

--> This could be examined by modifying *population* and *capacity* parameters.

## EXTENDING THE MODEL

One could make agent behaviours more complex, or replace the random *capacity* mechanism with something else (perhaps add a finite food source for harmless agents) to make the model more realistic. It is however important to keep in mind that the model will never be as complex as a real ecosystem and it is therefore best used to examine very simple questions, which might be exacerbated by added complexity.

## CREDITS

This model was created for a project by Melike Kaplan with help from Jonathan Adler.

2022
