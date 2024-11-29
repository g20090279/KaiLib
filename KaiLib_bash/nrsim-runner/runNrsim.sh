#!/bin/bash

# Place holders to change
# 1. <your-username>: change this to the name of your home folder
# 2. <the-library>: the specific external library used in our product, four upper-case letters XXXX


usage="Usage: rnrsim ($(basename $0)) [-h] [-v V] [-d f] [-e] [-r] [-b] [-c] [-m f,s,e] - shortcut program to run NRSim on different purposes.

where:
    -b   build debug mode
    -c   build release mode
    -d   debug mode (a gdb setting file must be specified)
    -e   run gdb with setting specified to EXPSim
    -h   show help text
    -l   set logging file
    -m   run NRSim release mode with specified autorun file (f) with subfix starting at (s) and ending at (e). Ex: rnrsim -m lteStandardRegTest,1,4
    -r   run NRSim release mode
    -v   specify a NRSim version
    default run gdb with launch.gdb"

nrsimVersion="nrsim-dl"
logFile="log-gdb/gdb.log.$(date '+%Y%m%d%H%M%S').txt"
runMode=""

errMsg="Error: options -b, -c, -d, -e, -h, -m, -r are mutually exclusive."
while getopts ":bcd:ehm:rv:" opt; do
  case $opt in
    b)
      if [ -n "$runMode" ]; then
        echo "$errMsg" 
	exit 1
      fi
      runMode="b"
      ;;
    c)
      if [ -n "$runMode" ]; then
        echo "$errMsg" 
	exit 1
      fi
      runMode="c"
      ;;
    d)
      if [ -n "$runMode" ]; then
        echo "$errMsg" 
	exit 1
      fi
      runMode="d"
      dVal="$OPTARG"
      ;;
    e)
      if [ -n "$runMode" ]; then
        echo "$errMsg" 
	exit 1
      fi
      runMode="e"
      ;;
    h)
      if [ -n "$runMode" ]; then
        echo "$errMsg" 
	exit 1
      fi
      runMode="h"
      ;;
    l)
      logFile="$OPTARG";
      ;;
    m)
      if [ -n "$runMode" ]; then
        echo "$errMsg" 
	exit 1
      fi
      runMode="m"
      IFS=',' read -r -a mVal <<< "$OPTARG"
      ;;
     r)
      if [ -n "$runMode" ]; then
        echo "$errMsg" 
	exit 1
      fi
      runMode="r"
      ;;
     v)
       nrsimVersion="$OPTARG"
       ;;
     *)
      if [ -n "$runMode" ]; then
        echo "$errMsg" 
	exit 1
      fi
      runMode="z"
      ;;
  esac
done

workspacePath="/nfs/home/<your-username>/workspace/$nrsimVersion"
if [ ! -d "$workspacePath" ]; then
  echo "$worksapcePath does not exist."
  exit 1
fi
cd "$workspacePath"
pwd

makeFile="/nfs/home/<your-username>/workspace/nrsim-dl/CMakeLists.txt"

if [ "$runMode" == "h" ]; then  # display help text
  echo "$usage";
elif [ "$runMode" == "d" ]; then  # debug NRSim by specifying gdb setting file (searching only inside this directory)
  if [ -z "$dVal" ]; then
    echo "Error: Need to specify a gdb setting for debugging! Example: $ rnrsim -d launch.gdb"
  else
    gdbFile="$dVal"
    gdb -ex "file $workspacePath/nrsim_dbg" -x ~/opt/runNrsim/"$gdbFile"
  fi
elif [ "$runMode" == "e" ]; then  # Grap Data for EXPSim
  gdb -ex "file $workspacePath/nrsim_dbg" -ex "set logging file $logFile" -x ~/opt/runNrsim/launch_expsim_data.gdb
elif [ "$runMode" == "r" ]; then # run release
  ./nrsim
elif [ "$runMode" == "b" ]; then # build debug mode
    if [ ! -f "$makeFile" ]; then
        echo "Error: CMakeLists does not exist!"
        exit 1
    fi
    if [[ "$workspacePath" != "/nfs/home/<your-username>/worksapce/nrsim-dl" ]]; then
        sed -i.bak "s|\(set(CMAKE_RUNTIME_OUTPUT_DIRECTORY \)\${CMAKE_CURRENT_SOURCE_DIR})|\1"$workspacePath")|g" "$makeFile"
    fi
    cmake -S /nfs/home/<your-username>/workspace/nrsim-dl -B $workspacePath/build-debug -DCMAKE_BUILD_TYPE=Debug -DSQN_TARGET=native -DSQN_BBIC=1 -DUSE_<the-library>_SHARED_LIBS=1 && cmake --build $workspacePath/build-debug --target all -j 32
    mv "$makeFile.bak" "$makeFile"
elif [ "$runMode" == "c" ]; then # build release mode
    if [ ! -f "$makeFile" ]; then
        echo "Error: CMakeLists does not exist!"
        exit 1
    fi
    if [[ "$workspacePath" != "/nfs/home/<your-username>/worksapce/nrsim-dl" ]]; then
        sed -i.bak "s|\(set(CMAKE_RUNTIME_OUTPUT_DIRECTORY \)\${CMAKE_CURRENT_SOURCE_DIR})|\1"$workspacePath")|g" "$makeFile"
    fi
    cmake -S /nfs/home/<your-username>/workspace/nrsim-dl -B $workspacePath/build-release -DCMAKE_BUILD_TYPE=Release -DSQN_TARGET=native -DSQN_BBIC=1 -DUSE_<the-library>_SHARED_LIBS=1 && cmake --build $workspacePath/build-release --target all -j 32
    mv "$makeFile.bak" "$makeFile"
elif [ "$runMode" == "m" ]; then # run multiple autorun file
  index=0
  if [ -n "${mVal[*]}" ]; then  
    autorunFile=""
    indStart=""
    indEnd=""
    for value in "${mVal[@]}"; do
      case $index in
	0) autorunFile="$value" ;;
	1) indStart="$value"  ;;
	2) indEnd="$value" ;;
      esac
      ((index++))
    done
  fi
  if [ "$index" -ne 3 ]; then
    echo "Error: not enough input arguments."
    exit 1
  fi
  for i in $(seq "$indStart" "$indEnd");
  do
    echo "["$(date -d "-6 hours" +"%T")"] Running TC#" "$i" "......"
    ./nrsim ./Scn/autoRuns/"${autorunFile}"_autoRun_"$i" "$i" | tee ./log-nrsim/log_"${autorunFile}"_"$i".txt
  done
else # debug NRSim with default gdb setting file (launch.gdb)
    gdb -ex "file $workspacePath/nrsim_dbg" -ex "set logging file $logFile" -x ~/opt/runNrsim/launch.gdb
fi

