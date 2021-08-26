#  Project Breakdown

## Input Files
/Users/temevan/Library/Containers/com.evantempleton.MacTextFileSorter/Data/Documents/input_files/

## Output Files
/Users/temevan/Library/Containers/com.evantempleton.MacTextFileSorter/Data/Documents/

## ViewController
- Calls `FilesManager.parseFiles()` method on load

## FilesManager
- Searches `input_files` for text files
- Loops through each file, creates an array from each line, filters out whitespace
- Sorts the array, writes each line to `output.txt`

## TODO/Issues
1. Doesn't handle infinite file length
    - Solution 1: loop through input files one line at a time and delete each line after reading
    - Solution 2: store pointer's position for each file

2. Bug
    - Figure out why the program keeps running if `output.txt` already exists
