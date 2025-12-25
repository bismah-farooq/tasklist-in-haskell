# Task List Program (Haskell)

## Name
Bismah Farooq

## Description
This program implements a simple task list manager written in Haskell. It reads tasks from a text file and processes them using functional programming concepts. The program demonstrates file input/output, list processing, and basic Haskell syntax, making it suitable for introductory functional programming coursework.

## Features
- Reads tasks from an input file
- Processes task data using lists
- Uses functional programming principles
- Simple console-based output
- Demonstrates file handling in Haskell

## How the Program Works
The program opens a file named `tasklist.txt`, reads tasks line by line, stores them in a list, processes the list, and displays the tasks to the user.

## Input File
The program expects a file named `tasklist.txt` located in the same directory as `tasklist.hs`.

Example contents:
```text
Finish homework
Buy groceries
Study for exam
```

## Sample Output
```text
Task List:
1. Finish homework
2. Buy groceries
3. Study for exam
```

## How to Run the Program
compile and run:
```text
ghc tasklist.hs
./tasklist
```

## Notes
The program assumes the input file exists. File reading is handled using standard Haskell I/O functions. 
