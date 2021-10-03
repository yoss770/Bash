#!/bin/bash

function unpack() {
  # Limit scope of variables
  local 'recursive' 'verbose' 'sources'

# Default values
  totalDecompressed=0
  recursive=false
  verbose=false
  sources=()

  # Arguments handling
  while (( ${#} > 0 )); do
    case "${1}" in
      ( '-r'* ) recursive=true ;;               # Handles --opt1
      ( '-v'* ) verbose=true ;;                  # Handles --opt2
      ( '--' ) sources+=( "${@:2}" ); break ;;   # End of options 
      ( '-'?* ) ;;                               # Discard non-valid options
      ( * ) sources+=( "${1}" )                 # Handles operands
    esac
    shift
  done
   
  for source in ${sources[*]}
  do
    __decompressor $source $PWD $recursive $verbose
    local successDecompress=$?
    totalDecompressed=$(($totalDecompressed + $successDecompress))
    
  done

  if [ "$verbose" = true ]; then
    echo "decompressor ${totalDecompressed} archive(s)"
  fi
}

#​gunzip ​, ​bunzip2 ​, ​unzip ​, ​uncompress
function __decompressor(){
    local "source" "dest" "recursice" "verbose" "successDecompress"
    
    source=$1
    dest=$2
    recursive=$3
    verbose=$4
    successDecompress=0  

    case $source in
      *.gzip| *.gz)
        successDecompress=1
        if [ "$verbose" = true ]; then echo "Unpacking ${source}" 
        fi
        gzip -fd $source
      ;;
      *.z | *.Z)
        successDecompress=1
        if [ "$verbose" = true ]; then echo "Unpacking ${source}" 
        fi
        uncompress $source
      ;;
      *.bz2)
        successDecompress=1
        if [ "$verbose" = true ]; then echo "Unpacking ${source}" 
        fi
        bzip2 -dk $source
      ;;
      *.zip)
        successDecompress=1
        if [ "$verbose" = true ]; then echo "Unpacking ${source}" 
        fi
        unzip -o -qq $source 
      ;;
      *)
      successDecompress=0
      if [[ -f $source ]]; then
        if [ "$verbose" = true ]; then echo "Ignoring ${source}" 
        fi
      elif [ "$recursive" = true ]; then
          for file in `cd ${source} && ls -1 && cd ..`
          do    
            __decompressor $source/$file $dest $recursive $verbose
            local res=$?
            
            successDecompress=$(($successDecompress + $res))
          done
       fi
      ;;
    esac
    
    return $successDecompress
}
# run example source ./unpack.sh && unpack2 -v *
