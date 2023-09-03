# Chirp Detection Algorithm
This is a repository for chirp detection algorithm development.

## Matlab Libraries
This is the initial MATLAB code that is used to prototype the initial algorithm. The find_chirps function is the main detection function that is used within the algorithm. There are a number of different functions that support this main function. Those functions are shown below in the following dependency tree.
![Alt text](image.png)

## Julia Libraries
This is the Julia version of the code that is going to be used moving forward. The Julia version is a more unpolished version and therefore may have more custom functions in comparison to the MATLAB version of the build. The Julia version will use a function-module setup where the functions will be declared from specific files and then all compiled into a single module.
