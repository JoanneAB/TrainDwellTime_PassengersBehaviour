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
