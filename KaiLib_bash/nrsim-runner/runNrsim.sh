#!/bin/bash

# For convenience, add the following line to .bashrc file
# alias rnrsim='bash /your/path/to/this/script/runNrsim.sh'

usage="shortcut program to run NRSim on different purposes.

Usage: rnrsim ($(basename $0)) [-v nrsim_version] [-g gdb_setting_file] [-a autorun_file] [-l gdb_logging_file] [-b | -c | -d | -e [expsim module] | -h | -m f,s,e | -r ]

where:
-a\t specify a autorun file in the working directory (NRSim version). The searching directory is /path/to/the/nrsim/version/Scn/autoRuns/.
-b\t build NRSim in debug mode
-c\t build NRSim in release mode
-d\t run NRSim debug mode for debugging with GDB setting file `launch_debug.gdb`.
-e\t run NRSim debug mode for EXPSim.
  \t \t - An GDB setting file is needed (default 'launch_expsim.gdb').
  \t \t - An autorun file needs to be specified explicitly.
  \t Example: $ rnrsim -e -g ChannelEstimatorCRS -a lteStandardRegTest_autoRun_24
-g\t specify a GDB setting file. The GDB setting file name has a format: 'launch_[debug|expsim]_<gdbSettingFile>.gdb'. The string specified here is used to match <gdbSettingFile>.
-h\t show help text
-l\t specify a logging file in the working directory (NRSim version)
-m\t run NRSim release mode with specified autorun file (f) with subfix starting at (s) and ending at (e). Ex: rnrsim -m lteStandardRegTest,1,4
-r\t run NRSim release mode
-v\t specify a NRSim version as a working directory. The default one is nrsim-dl. This feature enables existence of multiple NRSim executables, say, from different branches
default run gdb with launch.gdb"

# Get the current directory name
currDictory=$(basename "$PWD")

# Check if the directory name starts with "nrsim"
if [[ $currDictory == nrsim* ]]; then
    nrsimVersion="$currDictory"
else
    nrsimVersion="nrsim-dl"
fi

gdbLogFile="gdb.log.$(date '+%Y%m%d%H%M%S').txt"
gdbSettingFile=""
autorunFile=""
runMode=""

errMsg="Error: options -b, -c, -d, -e, -h, -m, -r are mutually exclusive."
while getopts ":a:bcd:eg:hl:m:rv:" opt; do
    case $opt in
        a)
            autorunFile="$OPTARG"
            ;;
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
            ;;
        e)
            if [ -n "$runMode" ]; then
                echo "$errMsg" 
                exit 1
            fi
            runMode="e"
            ;;
        g)
            gdbSettingFile="$OPTARG"
            ;;
        h)
            if [ -n "$runMode" ]; then
                echo "$errMsg" 
                exit 1
            fi
            runMode="h"
            ;;
        l)
            gdbLogFile="$OPTARG";
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

workspacePath="/nfs/home/<user.name>/workspace/$nrsimVersion"
if [ ! -d "$workspacePath" ]; then
    echo "$worksapcePath does not exist."
    exit 1
fi
cd "$workspacePath"
pwd

currentGitBranch="\nCurrent branch: $(git symbolic-ref --short HEAD)"

if [ "$runMode" == "h" ]; then  # display help text
    echo -e "$usage";
elif [ "$runMode" == "d" ]; then  # debug NRSim by specifying gdb setting file (searching only inside this directory)
    if [ "$gdbSettingFile" == "" ] || [ "$gdbSettingFile" == " " ]; then
        gdbSettingFileFullPath="/nfs/home/<user.name>/opt/runNrsim/launch_debug.gdb"
    else
        gdbSettingFileFullPath="/nfs/home/<user.name>/opt/runNrsim/launch_debug_${gdbSettingFile}.gdb"
        if [ ! -f "$gdbSettingFileFullPath" ]; then
            echo "Error: GDB setting file does not exist!"
            exit 1;
        fi
    fi
    gdb -ex "file $workspacePath/nrsim_dbg" -x "gdbSettingFileFullPath"

elif [ "$runMode" == "e" ]; then  # Extract Data for EXPSim
    if [ "$gdbSettingFile" == "" ] || [ "$gdbSettingFile" == " " ]; then
        gdbSettingFileFullPath="/nfs/home/<user.name>/opt/runNrsim/launch_expsim.gdb"
    else
        gdbSettingFileFullPath="/nfs/home/<user.name>/opt/runNrsim/launch_expsim_${gdbSettingFile}.gdb"
        if [ ! -f "$gdbSettingFileFullPath" ]; then
            echo "Error: GDB setting file ${gdbSettingFileFullPath} does not exist!"
            exit 1;
        fi
    fi
    autorunFileFullPath="${workspacePath}/Scn/autoRuns/${autorunFile}"
    if [ ! -f "$autorunFileFullPath" ]; then
        echo "Error: Autorun file ${autorunFileFullPath} does not exist!"
        exit 1;
    fi
    sed -i.bak "s|<executable-file>|${workspacePath}/nrsim_dbg|g;s|<autorun-file>|${autorunFileFullPath}|g" "${gdbSettingFileFullPath}"
    echo "Replace settings in ${gdbSettingFileFullPath}."
    echo "Execute command: gdb -ex 'set logging file ${gdbLogFile}' -x '${gdbSettingFileFullPath}'."
    gdb -ex "set logging file ${gdbLogFile}" -x "${gdbSettingFileFullPath}"
    mv "${gdbSettingFileFullPath}.bak" "${gdbSettingFileFullPath}"
    echo "Restore to GDB setting file."
    echo $currentGitBranch >> "$gdbLogFile"
elif [ "$runMode" == "r" ]; then # run release
    ./nrsim
elif [ "$runMode" == "b" ]; then # build debug mode
    cmake -S $workspacePath -B $workspacePath/build-debug -DCMAKE_BUILD_TYPE=Debug -DSQN_TARGET=native -DSQN_BBIC=1 -DUSE_CEVA_SHARED_LIBS=1 && cmake --build $workspacePath/build-debug --target all -j 32
elif [ "$runMode" == "c" ]; then # build release mode
    cmake -S $workspacePath -B $workspacePath/build-release -DCMAKE_BUILD_TYPE=Release -DSQN_TARGET=native -DSQN_BBIC=1 -DUSE_CEVA_SHARED_LIBS=1 && cmake --build $workspacePath/build-release --target all -j 32
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
    gdb -ex "file $workspacePath/nrsim_dbg" -ex "set logging file $gdbLogFile" -x ~/opt/runNrsim/launch_debug.gdb
fi

