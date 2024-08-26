#!/bin/bash

# -----------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------
fin ()
  {
  echo | gmt psxy -R -J -O >> $out
  gmt psconvert -A -Tf $out
  rm gmt.history g.cpt $out
  if [ -e tmp.txt ]; then rm tmp.txt; fi
  }

do_map ()
  {
  gmt psbasemap -R -J -B -X$dX -Y$dY -O -K >> $out 
  gmt pstext -R -J -F+f7,Helvetica,+jBC -Y-1 -O -K << END >> $out
  1.0 1.0 Random
  2.0 1.0 Mixed
  3.0 1.0 In lines
END
  gmt pstext -R -J -F+f7,Helvetica,+jBC+a90 -Y1 -X-1 -O -K << END >> $out
  1.1 1.0 Bad
  1.1 2.0 Mixed
  1.1 3.0 Good
END

  echo | gmt psxy -R -J -X1 -O -K >> $out
  awk -v c=$col '{print $1,$2,$c}' tmp.txt | gmt psxy -R -J -Ss1.8 -W0.2p,0 -Cg.cpt -O -K >> $out 
  echo 0.6 3.2 $text | gmt pstext -R -J -F+jBL -W0.4p,0 -G255 -O -K >> $out
  }


# -----------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------
gmt makecpt -Cno_green.cpt -T0/21 > g.cpt


seats="lines"
for passenger in "50" "100" "200"; do
  if [ $passenger = "50" ]; then
    n_passengers=50
    n_boarding=25
  fi
  if [ $passenger = "100" ]; then
    n_passengers=100
    n_boarding=50
  fi
  if [ $passenger = "200" ]; then
    n_passengers=200
    n_boarding=101
  fi

  if [ -e tmp.txt ]; then rm tmp.txt; fi

  out="parameters_explorations_"$n_passengers".eps"
  echo | gmt psxy -R0.5/3.5/0.5/3.5 -JX4 -B1a/1ansew -K -Y10 -P > $out

  for waiting in "0" "0.5" "1"; do
    if [ $waiting = "0"   ]; then x=1.0; fi
    if [ $waiting = "0.5" ]; then x=2.0; fi
    if [ $waiting = "1"   ]; then x=3.0; fi

    for behaviour in "good" "mixed" "bad"; do
      if [ $behaviour = "good"  ]; then y=3.0; fi
      if [ $behaviour = "mixed" ]; then y=2.0; fi
      if [ $behaviour = "bad"   ]; then y=1.0; fi

      file="../output_"$seats"_"$n_passengers"_"$n_boarding"_"$waiting"_"$behaviour".txt"
 
      # All boarding passengers are inside :
      b_i=`sed -n 4,103p $file | awk '{s+=$1} END {print s/100}'` # all boarding inside
      b_f=`sed -n 4,103p $file | awk '{s+=$2} END {print s/100}'` # all boarding finished
      a_o=`sed -n 4,103p $file | awk '{s+=$3} END {print s/100}'` # all alighting outside
      a_f=`sed -n 4,103p $file | awk '{s+=$4} END {print s/100}'` # all alighting finished

      echo $x $y $b_i $b_f $a_o $a_f >> tmp.txt
    done
  done

  # -------------------------------------------
  minmax=`awk '{print $3,$4,$5,$6}' tmp.txt | xargs -n1 | gmt gmtinfo -C` 
  minC=`echo $minmax | awk '{print $1}'`
  maxC=`echo $minmax | awk '{print $2}'`

  gmt makecpt -Cno_green.cpt -T$minC/$maxC > g.cpt

  # -------------------------------------------
  # Plot the data:
  dX=0;  dY=0;  text="All boarded";        col=3; do_map
  dX=5;  dY=0;  text="Boarding finished";  col=4; do_map
  dX=-5; dY=-5; text="All alighted";       col=5; do_map
  dX=5;  dY=0;  text="Alighting finished"; col=6; do_map

  # -------------------------------------------
  # Plot the colorbar:
  gmt psscale -Cg.cpt -Dx5/6.5+w4/0.3+jTC -Bxa2f+l"Average number of ticks" -O -K >> $out

  # Write the Legend:
  echo 0.6 3.2 DISTRIBUTION OF THE BOARDING PASSENGERS | gmt pstext -R0/10/0/10 -JX10 -F+jBL -W0.4p,0 -G255 -Y-4.2 -X-4.5 -O -K >> $out
  echo 0.6 3.2 BEHAVIOUR OF THE BOARDING PASSENGERS | gmt pstext -R -JX -F+jBL+a90 -W0.4p,0 -G255 -X-2 -Y2.5 -O -K >> $out

  fin
done



