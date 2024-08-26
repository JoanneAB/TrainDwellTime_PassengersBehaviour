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
  echo | gmt psxy -R -J -X$dX -Y$dY -O -K >> $out 
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

  minmax=`awk -v s=$seats -v p=$pass '{if ($3 == p && $4 == s) print $NF}' tmp.txt | gmt gmtinfo -C` 
  minC=`echo $minmax | awk '{print $1}'`
  maxC=`echo $minmax | awk '{print $2}'`

  gmt makecpt -Cmy_color.cpt -T$minC/$maxC > g.cpt

  awk -v p=$pass -v s=$seats '{if ($3 == p && $4 == s) print $1,$2,$NF}' tmp.txt | gmt psxy -R -J -Ss1.8 -W0.2p,0 -Cg.cpt -O -K >> $out 
  echo 0.6 3.2 $text | gmt pstext -R -J -F+jBL -W0.4p,0 -G255 -O -K >> $out

  # -------------------------------------------
  # Plot the colorbar:
  gmt psscale -Cg.cpt -Dx4.3/0+w4/0.25+jBC -Bxa2f+l"Average number of ticks" -O -K >> $out
  }

# -----------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------
out="parameters_explorations_boarding.eps"

echo | gmt psxy -R0.5/3.5/0.5/3.5 -JX4 -K -Y13 -P > $out
if [ -e tmp.txt ]; then rm tmp.txt; fi


for seats in "lines" "doubles"; do
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
        echo $x $y $n_passengers $seats $b_i >> tmp.txt
      done
    done
  done
done

# -------------------------------------------
# -------------------------------------------
# Plot the data:
dX=0;  dY=0; text="50 passengers";   pass=50;  seats="lines"; do_map
dX=0; dY=-5; text="100 passengers";  pass=100; seats="lines"; do_map
dX=0; dY=-5; text="200 passengers";  pass=200; seats="lines"; do_map

dX=7; dY=10; text="50 passengers";   pass=50;  seats="doubles"; do_map
dX=0; dY=-5; text="100 passengers";  pass=100; seats="doubles"; do_map
dX=0; dY=-5; text="200 passengers";  pass=200; seats="doubles"; do_map

# Write the Legend:
echo 0.6 3.2 DISTRIBUTION OF THE BOARDING PASSENGERS | gmt pstext -R0/10/0/10 -JX10 -F+jBL -W0.4p,0 -G255 -Y-4.2 -X-5 -O -K >> $out
echo 0.6 3.2 BEHAVIOUR OF THE BOARDING PASSENGERS | gmt pstext -R -JX -F+jBL+a90 -W0.4p,0 -G255 -X-3.8 -Y4.7 -O -K >> $out

echo 0.6 3.2 SEATS IN LINES   | gmt pstext -R -JX -F+jBL -W0.4p,0 -G255 -X2 -Y11 -O -K >> $out
echo 0.6 3.2 SEATS IN DOUBLES | gmt pstext -R -JX -F+jBL -W0.4p,0 -G255 -X6.8      -O -K >> $out

fin



