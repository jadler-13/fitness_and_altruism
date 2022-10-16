; first, the different agent types are defined
breed [altruists altruist]
breed [egoists egoist]
breed [predators predator]

turtles-own [lifespan reproduction_time]
globals [predator_survival altruist_survival egoist_survival nc]

; this sets up the starting conditions for the experiment
to setup
  clear-all-plots
  clear-turtles
  clear-output
  clear-ticks
  create-altruists altruist_population [
    set color green
    setxy random-xcor random-ycor  ; chooses random start location
    set lifespan harmless_lifespan
    set reproduction_time harmless_reproduction_time
  ]
  create-egoists egoist_population [
    set color blue
    setxy random-xcor random-ycor  ; chooses random start location
    set lifespan harmless_lifespan
    set reproduction_time harmless_reproduction_time
  ]
  create-predators predator_population [
    set color red
    setxy random-xcor random-ycor  ; chooses random start location
    set lifespan 10
    set reproduction_time 4
  ]
  reset-ticks
end

; runs the experiment once
to go
  while [(count predators >= 0) and (count altruists >= 0) and (count egoists >= 0)] [
    if ticks > maximum_ticks [  ; prevents the simulation from running too long if no agent type goes extinct
;      output-print word "altruist population: "  count altruists
;      output-print word "egoist population: " count egoists
;      output-print word "predator population: " count predators
      if count altruists > 0 [ set altruist_survival altruist_survival + 1 ]
      if count egoists > 0 [ set egoist_survival egoist_survival + 1 ]
      if count predators > 0 [ set predator_survival predator_survival + 1 ]
      stop
    ]
    ask turtles [ move ]
    ask predators [ hunt ]
    ask egoists [ survive ]
    ask altruists [
      survive
      help ]
    ask turtles [
      starvation
      infighting
      reproduce
      death
      ]
    tick
  ]
end

; runs multiple experiments and reports the survival count of each agent type in the output window
to cycle
  set nc number_of_cycles
  set predator_survival 0
  set altruist_survival 0
  set egoist_survival 0
  while [ nc > 0 ] [
    setup
    output-print (word nc " cycles left...")
    go
    set nc nc - 1
  ]
  clear-output
  output-print (word "predators survived " predator_survival " times")
  output-print (word "altruists survived " altruist_survival " times")
  output-print (word "egoists survived " egoist_survival " times")
  output-print (word "approximate stake value: " (altruist_survival / number_of_cycles / 0.5 * cost / benefit))
end

to move
  rt random 30 - random 30  ; agents turn in random directions
  fd 1  ; agents move forward
  set lifespan lifespan - 1  ; agents "age" as they move
end

; if a predator touches a harmless agent, it checks the number of nearby predators and harmless agents
; if the harmless agents outnumber the predators by more than 1, the "attacking" predator dies
; if not, the predator gets rewarded with an increase in lifespan and decrease in reproduction time
to hunt
  if (count altruists-here > 0) or (count egoists-here > 0) [
    ifelse count altruists-on neighbors + count egoists-on neighbors - count predators-on neighbors > 1 [
    die ]
    [ set lifespan lifespan + 5
    set reproduction_time reproduction_time - 5
    ]
  ]
end

; harmless agents are killed by predators or helped by altruists
to survive
  if count predators-here > 0 [die]
  ifelse is-altruist? self [
    if count altruists-here > 1 [
      set lifespan lifespan + benefit
    ]
  ]
  [ if count altruists-here > 0 [
      set lifespan lifespan + benefit
    ]
  ]
end

; altruists pay a cost for helping, decreasing their own lifespan
to help
  if count altruists-here + count egoists-here > 1 [
    set lifespan lifespan - cost
  ]
end

; agents create clones of themselves when their reproduction time hits zero
to reproduce
  set reproduction_time reproduction_time - 1
  if reproduction_time < 1 [
    ifelse is-predator? self [
      set reproduction_time predator_reproduction_time
      hatch 1 [
        set lifespan predator_lifespan
        fd 1 ]
      ]
      [ set reproduction_time harmless_reproduction_time
      hatch 1 [
        set lifespan harmless_lifespan
        fd 1 ]
      ]
    ]
end

; agents die of old age
to death
  if lifespan < 1 [ die ]
end

; kills a percentage of harmless agents when their numbers exceed carrying capacity
to starvation
  let num-harmless count altruists + count egoists
  if num-harmless <= harmless_capacity
    [ stop ]
  let chance-to-die (num-harmless - harmless_capacity) / num-harmless
  ask altruists
  [
    if random-float 1.0 < chance-to-die
      [ die ]
  ]
  ask egoists
  [
    if random-float 1.0 < chance-to-die
      [ die ]
  ]
end

; kills a percentage of predators when their numbers exceed carrying capacity;
to infighting
  let num-predators count predators
  if num-predators <= predator_capacity
    [ stop ]
  let chance-to-die (num-predators - predator_capacity) / num-predators
  ask predators
  [
    if random-float 1.0 < chance-to-die
      [ die ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
628
429
-1
-1
10.0
1
10
1
1
1
0
1
1
1
-20
20
-20
20
0
0
1
ticks
30.0

BUTTON
23
10
78
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
82
10
137
43
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
22
210
194
243
predator_population
predator_population
0
300
150.0
1
1
NIL
HORIZONTAL

SLIDER
23
125
195
158
altruist_population
altruist_population
0
300
75.0
1
1
NIL
HORIZONTAL

SLIDER
22
168
194
201
egoist_population
egoist_population
0
300
75.0
1
1
NIL
HORIZONTAL

SLIDER
22
406
194
439
harmless_capacity
harmless_capacity
20
1000
150.0
10
1
NIL
HORIZONTAL

SLIDER
22
288
194
321
harmless_lifespan
harmless_lifespan
1
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
22
329
194
362
predator_lifespan
predator_lifespan
1
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
209
447
414
480
harmless_reproduction_time
harmless_reproduction_time
1
20
4.0
1
1
NIL
HORIZONTAL

SLIDER
424
447
629
480
predator_reproduction_time
predator_reproduction_time
1
20
10.0
1
1
NIL
HORIZONTAL

PLOT
676
10
1123
222
population growth over time
ticks
population size
0.0
300.0
0.0
221.0
true
false
"" ""
PENS
"default" 1.0 0 -14439633 true "" "plot count altruists"
"pen-1" 1.0 0 -13345367 true "" "plot count egoists"
"pen-2" 1.0 0 -2674135 true "" "plot count predators"

MONITOR
676
226
784
271
altruist population
count altruists
3
1
11

MONITOR
798
226
906
271
egoist population
count egoists
3
1
11

MONITOR
920
226
1029
271
predator population
count predators
3
1
11

CHOOSER
677
283
815
328
benefit
benefit
0 1 2 3 4 5
2

CHOOSER
677
340
815
385
cost
cost
1 2 3 4 5
0

SLIDER
22
447
194
480
predator_capacity
predator_capacity
20
1000
200.0
10
1
NIL
HORIZONTAL

SLIDER
677
397
816
430
maximum_ticks
maximum_ticks
1
3000
1500.0
1
1
NIL
HORIZONTAL

MONITOR
836
283
960
328
neutral stake value:
cost / benefit
7
1
11

OUTPUT
837
350
1070
431
11

BUTTON
141
10
196
43
NIL
cycle
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
23
58
196
103
number_of_cycles
number_of_cycles
5 50 100 500 1000
1

@#$#@#$#@
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

This model was created for a project by Melike Kaplan with the help of Jonathan Adler.

2022
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
