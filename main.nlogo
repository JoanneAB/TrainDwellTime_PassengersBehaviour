;   - on platform : direction of closest door
;                   . stay in line if japanese-person
;                   . get close to door is gaijin-person
;   - on train : . to seat if seating passenger
;                . close to door if stays close to exit
;                . to middle, standing is stanging-person or if all seats taken if seated-person

; Waiting to board passengers : check if people want to alight and if yes, clear the door.
;    good  behaviour : always stay in line and always clear the doors
;    mixed behaviour : user-defined number of people beeing a good or bad citizen
;    bad   behaviour : stay as close as possible as the doors

;                               -> Check the cells in front of the door and if empty for few seconds, move inside

; Train does not leave if people inside the cells in front of the doors

; --------------------------------------------------------------------------------------------------------
__includes["platform_config.nls" "train_config.nls" "passengers_config.nls" "moves.nls" "globals.nls"]

; --------------------------------------------------------------------------------------------------------
breed [people-boarding p-boarding]
breed [people-alighting p-alighting]

people-boarding-own [ behaviour finished? inside? ] ;standing? ]
people-alighting-own [ finished? outside? ]

patches-own [ waiting-line-distribution waiting-distance-distribution elevation train? ]

; --------------------------------------------------------------------------------------------------------
to setup
  clear-all

  setup-counter-globals
  setup-train-globals
  setup-platform-globals
  setup-passengers-globals

  setup-patches
  setup-people
  reset-ticks ; reset the tick counter
end

; --------------------------------------------------------------------------------------------------------
to go
  move-alighting
  move-boarding

  if ( all? people-alighting [ finished? ] ) and ( all? people-boarding [ finished? ] )
    [
;    if ( count people-boarding > 0 )  [ print ( word "boarding : " ( 100 * ( count people-boarding with [ inside? ] ) / count people-boarding ) " %" ) ]
;    if ( count people-alighting > 0 ) [ print ( word "alighting : " ( 100 * ( count people-alighting with [ outside? ] ) / count people-alighting ) " %" ) ]
;    show "--- FINISHED ---"
    stop
    ]
  if ticks > 100 ; small problem here, sometimes one or two passenger get stuck in the door.
    [ stop ]
  tick
end

; --------------------------------------------------------------------------------------------------------
to setup-counter-globals
  set counter-boarding-inside    0
  set counter-boarding-finished  0
  set counter-alighting-outside  0
  set counter-alighting-finished 0
end

; --------------------------------------------------------------------------------------------------------
to setup-patches
  create-platform
  create-train
end

; --------------------------------------------------------------------------------------------------------
to setup-people
  create-passengers
end

; --------------------------------------------------------------------------------------------------------
; Create reporters to display on the interface :
to-report ticks-boarding-inside
  report counter-boarding-inside
end

to-report ticks-boarding-finished
  report counter-boarding-finished
end

to-report ticks-alighting-outside
  report counter-alighting-outside
end

to-report ticks-alighting-finished
  report counter-alighting-finished
end

; --------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------
; Used to run a large number of simulations to test the impact of each parameter:
to do-many
  set filename ( word "parameters_exploration/output_" train-seats "_" number-passengers "_" partition-boarding "_" boarding-in-lines "_" boarding-behaviour ".txt" )

  file-open filename
  file-print "train-seats number-passengers partition-boarding boarding-in-lines boarding-behaviour"
  file-write train-seats
  file-write number-passengers
  file-write partition-boarding
  file-write boarding-in-lines
  file-write boarding-behaviour
  file-print " "
  file-print "counter-boarding-inside counter-boarding-finished counter-alighting-outside counter-alighting-finished ticks"
  file-close

  set i-run 1
  while [ i-run <= n-run ]
    [
    show i-run

     clear-ticks
     clear-turtles
     clear-patches
     clear-drawing
     clear-all-plots
     clear-output

    setup-patches
    setup-people
     reset-ticks ; reset the tick counter

    while [ not ( ( all? people-alighting [ finished? ] ) and ( all? people-boarding [ finished? ] ) ) ]
      [
      move-alighting
      move-boarding
      tick
      if ticks > 1000
        [ stop ]
      ]

    if ( all? people-alighting [ finished? ] ) and ( all? people-boarding [ finished? ] )
      [
      file-open filename
      file-write counter-boarding-inside
      file-write counter-boarding-finished
      file-write counter-alighting-outside
      file-write counter-alighting-finished
      file-write ticks
      file-print " "
      file-close
      ]



    set i-run ( i-run + 1 )
    ]

    stop
end
@#$#@#$#@
GRAPHICS-WINDOW
310
10
933
580
-1
-1
18.1
1
10
1
1
1
0
0
0
1
0
33
0
30
0
0
1
ticks
30.0

BUTTON
12
24
86
57
Setup
Setup
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
101
24
164
57
Run
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
21
246
226
279
number-passengers
number-passengers
0
200
117.0
1
1
NIL
HORIZONTAL

CHOOSER
19
119
157
164
train-seats
train-seats
"lines" "doubles"
1

SLIDER
20
292
226
325
partition-boarding
partition-boarding
0
number-passengers
166.0
1
1
NIL
HORIZONTAL

SLIDER
17
337
229
370
boarding-in-lines
boarding-in-lines
0
1
0.5
0.5
1
NIL
HORIZONTAL

TEXTBOX
7
213
274
240
Passengers configuration :
18
0.0
1

TEXTBOX
7
88
207
132
Train configuration :
18
0.0
1

TEXTBOX
7
421
215
446
Run configuration :
18
0.0
1

CHOOSER
23
452
226
497
boarding-behaviour
boarding-behaviour
"good" "mixed" "bad"
1

SWITCH
962
55
1126
88
show-elevation
show-elevation
1
1
-1000

TEXTBOX
948
19
1098
41
Display options :
18
0.0
1

PLOT
945
170
1341
392
Count of passengers
Ticks
# Passengers [%]
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"Alighting finished" 1.0 1 -12087248 true "" "plot 100 * ( count people-alighting with [ finished? ] ) / count people-alighting"
"Boarding finished" 1.0 1 -11033397 true "" "plot 100 * ( count people-boarding with [ finished? ] ) / count people-boarding"
"Alighting" 1.0 0 -14439633 true "" "plot 100 * ( count people-alighting with [ outside? ] ) / count people-alighting"
"Boarding" 1.0 0 -11033397 true "" "plot 100 * ( count people-boarding with [ inside? ] ) / count people-boarding"

SWITCH
959
96
1127
129
show-pen
show-pen
1
1
-1000

BUTTON
180
25
265
58
Run once
go ; once
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
945
457
1137
502
All boarding inside [# of ticks]
ticks-boarding-inside
17
1
11

MONITOR
945
405
1135
450
All alighting outside [# of ticks]
ticks-alighting-outside
17
1
11

MONITOR
947
509
1343
554
Total number of ticks
ticks
17
1
11

MONITOR
1146
405
1339
450
All alighting finished [# of ticks]
counter-alighting-finished
17
1
11

MONITOR
1147
456
1342
501
All boarding finished [# of ticks]
counter-boarding-finished
17
1
11

BUTTON
136
688
226
746
NIL
do-many
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
15
686
122
746
n-run
100.0
1
0
Number

TEXTBOX
17
654
272
676
Parameters exploration :
18
0.0
1

@#$#@#$#@
## WHAT IS IT?

This model simulates the movement of passengers alighting and boarding a train in order to estimate the train dwell time (amount of time a train waits at a station while passengers are alighting and boarding). 

While alighting passengers are directly exiting the train, the boarding passengers may have a more complex behaviour. Firstly, they might either board the train as soon as the train doors open or either wait for all the alighting passengers to get out of the train before boarding. A second boarding behaviour is how the passengers are waiting for the train on the platform would either be in waiting lines or standing close to the train. These complex behaviours of the boarding passengers might lead to increased or decreased train dwell time. The goal of this model is to show whether the manners of the boarding passengers help reduce the train dwell time.

This project is inspired by my journey in Tokyo. I moved to Japan one year ago, and I am still stunned to see how Japanese people are well-behaved while waiting for the train, in two perfect lines even if the platform is very crowded. It is such different from what could happen on French's trains platforms. I wondered whether this behaviour could explain why Japan's trains are never late and has the most reliable train network in the world.


## HOW IT WORKS

The rule of this model is simple : the passengers on the platform want to go on the train and the passengers on the train want to go on the platform. 

Two passengers can not stand on the same patch. The passengers can not cross the train edges. A variable is assigned to every patch of the model and is designed such that to guide every passenger to find the nearest train door to get in or out of the train.
 
The simulation ends when all aligthing passengers are outside of the train and all boarding passengers are inside the train. The user can however continue the simulation (if desired) to let all the boarding passengers find a suitable space on the train and all alighting passengers go far from the train.

## HOW TO USE IT

### The model

The model is divided into one platform (represented by gray patches) and one train car.

The train contour (forbidden patches for the passengers) is designed with black patches and doors with dark gray patches. Inside the train, the light green patches represent the train and dark green represents the seats (see following figure). The distribution of the seats in the train can either be in lines along the edges of the train or in sets of double seats to simulate the possible configuration of the trains in the Tokyo subway lines. Use the **`train-seats`** chooser to set the configuration of the train.

![Legend of the train configuration](file:figures/legend_train.png)

### The passengers

The total number of passengers is selected using the **`number-passengers`** slider. Among all the passengers, the number of passengers that are located on the platform and will board the train is selected using the **`partition-boarding`** slider.

At the setup of the model, the alighting passengers are randomly located in the train and assigned to a green color. 

The boarding passengers are located on the platform and assigned with either a blue or purple color to describe their good or bad behaviour at boarding, respectively (see following figure). The behaviour at boarding is selected using the chooser **`boarding-behaviour`** and the following options :

 - **`good`** : all boarding passengers wait for all alighting passengers to get out of the train before moving.
 - **`mixed`** : random distribution of passengers with good or bad behaviour. Half of passengers will have good behaviour and the other half bad behaviour.
 - **`bad`** : no passengers wait for alighting passengers to get off the train before boarding. They start moving as soon as the simulation starts.

![Legend of the passengers](file:figures/legend_passengers.png)

The location of the boarding passengers is affected by the **`boarding-in-lines`** switch which could either be 0.0, 0.5 or 1.0 :

 - 0.0 : randomly distribution of the boarding passengers in front of the train.
 - 0.5 : randomly distribution of the boarding passengers in front of the doors
 - 1.0 : distribution of the boarding passengers in two lines in front of each door.

The **`show-pen`** switch ables to draw the path of each passenger during the run.

### The elevation 

Each patch of the model is assigned with an elevation parameter which will be used by the passengers to choose the best direction to go (see figure). Alighting passengers follow a path with decreasing elevation, while boarding passengers follow a path with increasing elevation.

![Legend of the elevation](file:figures/legend_elevation.png)

The elevation map can be displayed on the monitor (and during the simulation) using the **`show-elevation`** switch.

### Graphic

The graph **`Count of passengers`** shows the evolution of passengers' percentage that moved to its destination _i.e._ in or out of the train for boarding (in blue) and alighting (in green) passengers respectively. The graph also shows a histogram of the evolution of the number of passengers that arrive at their final destination _i.e._ far from the train for the alighting passengers and a place on the train where they can not move anymore for the boarding passengers.


## THINGS TO NOTICE

The main purpose of this model is to estimate the influence of the boarding passenger's attitude on the dwell time of the train. 

I performed 100 simulations for each particular set of the parameters : 

 - distribution of the boarding passengers on the platform (_i.e._ **boarding-in-lines** chooser),
 - behaviour of the boarding passengers (_i.e_ **boarding-behaviour** chooser),
 - configuration of the train (_i.e._ **train-seats** chooser),
 - total number of passengers (_i.e._ **number-passengers** slider). 

For each run, the number of boarding passengers is half the total number of passengers.

Results are presented in the following figures.

![Impact of varying the parameters on the boarding time](file:figures/parameters_explorations_boarding.png)

First of all, we notice that having bad behaviour (_i.e._ boarding the train as soon as the simulation starts) helps to have a short train dwell time. Waiting for an empty train does not seem to improve the dwell time.

Secondly, it is preferable to wait close to the doors (_i.e._ mixed distribution) than standing randomly on the platform (_i.e._ random distribution) or standing in two lines in front of the doors (_i.e._ in waiting lines).

Finally, the total number of passengers or train configuration does not seem to have a significant impact on the train dwell time. Indeed, the conclusions remain the same whether we set 50, 100 or 200 passengers or change the configuration of the seats in the train.

## THINGS TO TRY

Try varying the distribution and the behaviour of the boarding passengers on the platform using the **boarding-in-lines** and **boarding-behaviour** sliders to see how they are distributed and when they start moving during the simulation.

Try a simulation with only alighting passengers (_i.e._ **partition-boarding** = 0) and change the configuration of the train (**train-seats**) to see how the alighting passengers are going off of the train depending on the disposition of the seats.

It is suggested to start with a simulation with a small number of passengers (less than 200). Especially if the boarding passengers are forming waiting lines on the platform (_i.e._ **boarding-in-lines** = 1.0). The time for the setup of the simulation might take long if there are lots of people in the waiting lines.

The passengers are moving fast. You might want to reduce the speed of the simulation (using the speed slide at the top center of the interface) after setting up the simulation to see the passengers moving.

Use the **show-pen** and **show-elevation** on a small number of passengers (50-100) and see how they follow the elevation on the platform and the train.


## EXTENDING THE MODEL

The behaviour of the boarding passengers can be improved with the following features :

 - The passengers with good behaviour wait on the platform for all the alighting passengers to get off the train while other boarding passengers start to board the train. At the moment, they do not move until all alighting passengers are on the platform. They could, however, go closer to the train as some passengers board the train and leave some free space close to the train.
 - As they enter the train, should the passengers look for a seat? stay close to the door? or go as far as they could from the doors ? 

To increase the complexity of the simulation, some passengers could be assigned to several patches attached to each other to simulate a passenger with a large luggage or pushchair. These passengers take more space on the train and platform and should move slower than the other passengers.

One small problem remains is to find the correct time to stop the simulation. When using a large number of passengers, a few boarding passengers might get stuck very close to the door patches. As the passengers are moving slowly away from the doors because of the crowd, no neighbor patch is available, and the passenger assumes that its displacement is finished and blocks the way to other passengers. As passengers continue to move in front of it and release some free space, these passengers are not moving anymore and continue to block the way to others. (see the results of such an event in the following figure, red circle).

![entryway blocked by one passenger](file:figures/boarding_problem.png) 


## NETLOGO FEATURES

- The initial location of the boarding passengers follows a normal distribution to have a high probability of being close to the train and a low probability of being far from the train. This distribution of the passengers on the platform had to be written as, to my knowledge, no such feature exists in NetLogo.

- The uphill/downhill NetLogo features are very useful in letting passengers follow a user-defined path. However, for the boarding passengers, a stop criterion was necessary to prevent passengers overlapping and telling them to stop if there is no more space on the train.


## CREDITS AND REFERENCES

This model has been developed as part of a project for the "Agent-Based Modeling" class for Data Science Master's course in Data ScienceTech Institute (DSTI, France). Source codes and supplementary files are available at https://github.com/JoanneAB/TrainDwellTime_PassengersBehaviour.


The design of the elevation is inspired from the paper of : 

Han Namgoong, 2022. Train Dwell Time Modeling Using Netlogo and Comparison of Boarding Strategies. SSRN Electronic Journal, https://api.semanticscholar.org/CorpusID:248235141

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, please include the citations below.

For the model itself:

 - Adam, J.M.-C. (2024). NetLogo model to estimate the dwell time of a train depending on the behaviour of the boarding passengers. Master's project at DSTI, France. https://github.com/JoanneAB/TrainDwellTime_PassengersBehaviour

Please cite the NetLogo software as:

 - Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## LICENCE

This work is under a GNU General Public License.
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
NetLogo 6.4.0
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
