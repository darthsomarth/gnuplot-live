# gnuplot-live
## What is it?
A simple bash script that takes in data from stdin and plots them out using `gnuplot`.

## How does it work?
The script creates a named pipe and a file in a temporary directory.
The named pipe is connected to gnuplot so that the latter is waiting for commands.
Whenever there's some data in standard input, it first writes the data to the file, it then issues plot command to gnuplot to plot   last few lines from the data file.

## How to use it?
Assuming you have a program named `get-data` that prints a column of data to standard output,
```
0
1
2
3
4
```
then you would run
```
$ ./get-data | ./gnuplot-live 100
```
to see the last 100 data points. 
The argument is optional and the default is 10.
If you have a program that prints multiple columns of space-separated data and you only want a few of them to be plotted,
```
1 2 0 4 0 0 0 0
2 3 0 5 0 0 0 0
3 4 0 6 0 0 0 0
```
then you could run
```
$ ./get-data | tee >(stdbuf -oL cut -d ' ' -f 1,2 | ./gnuplot-live) >(stdbuf -oL cut -d ' ' -f 4 | ./gnuplot-live)
```
to plot the first and the second columns on one plot and the fourth column on a second plot. 
Here the `stdbuf` allows `cut` output to be flushed to `gnuplot-live`.
Terminate the script by pressing `Ctrl-C` on the terminal.

## Prerequisites
You will need `gnuplot`. I have been using this on `gnuplot` version 5.

## Miscellaneous

The gnuplot terminal used needs to have **noraise** option. Here I'm using qt terminal with noraise option. Else the script will keep bringing up the plot into focus making the program difficult to be terminated!
