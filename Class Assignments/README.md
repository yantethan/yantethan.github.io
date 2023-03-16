# Class Assignments
Completed class assignments will be shown below.  Most, if not all, do not have code available due to Academic Integrity reasons.  Code can be provided upon request by employer by contacting me though the email shown on the first page.

## Classes
### Data Structures and Algorithms with C++ 
#### Final Project - Sorting Algorithm Comparison

For this project, I was assigned to make a program to compare the efficiency of the different sorting algorithms we learned throughout class. The algorithms we compared are: Bubble Sort, Insertion Sort, Merge Sort, Quick Sort, and Heap Sort.  This was performed by generating a set of ten randomized test cases of 2000 values each. Each test case was run on each algorithm five times and their times were averaged. Once completed, the program would print out the each test time for each algorithm in a table, and then the Max, Min, and Average for each test number. The test numbers correspond to the different algorithms in the same order as introduced above.

##### Example Output
-------------------------------- Results ---------------------------------  
Case #| Selection | Bubble | Insertion | Merge | Quick | Heap  
  1      1842us     6277us    1763us     338us   129us   239us  
  2      6030us     7105us    2131us     484us   168us   291us  
  3      4290us     8497us    2068us     482us   172us   287us  
  4      3846us     7184us    1120us     318us   145us   229us  
  5      1963us     5952us    1895us     316us   133us   260us  
  6      1953us     5793us    2394us     491us   182us   303us  
  7      3286us     8222us    1994us     332us   129us   208us  
  8      2117us     6257us    1186us     316us   121us   245us  
  9      1967us     6789us    1391us     521us   184us   294us  
  10     2901us     8169us    1671us     315us   120us   246us

Average Across all Test Cases  
Test Number #1:  
- Max: 6030  
- Min: 1842  
- Avg: 3019  
Test Number #2:  
- Max: 8497  
- Min: 5793  
- Avg: 7024  
Test Number #3:  
- Max: 2394  
- Min: 1120  
- Avg: 1761  
Test Number #4:  
- Max: 521  
- Min: 315  
- Avg: 391  
Test Number #5:  
- Max: 184  
- Min: 120  
- Avg: 148  
Test Number #6:  
- Max: 303  
- Min: 208  
- Avg: 260

#### Train Car Ordering
This program finds whether or not a set of train cars coming into a station can be arranged in a specified way. The program reads from a text file that includes the train length and requested order of the cars, determines if the order is possible, and outputs to a file if possible or not.  Available here at [Project #1](https://replit.com/@ecy5045/proj1#proj1.cpp)

#### Parenthesis
This program generates and prints out the set of balanced parenthesis using n open and n close brackets.  'n' is inputted by the user.  Available here at [Project #2](https://replit.com/@ecy5045/CMPSC-465-Project-2-Parenthesis#proj2.cpp)

#### X and O's
This program takes and input file that defines a 2D board size and a board of X's and O's and captures (replaces with X's) all O's that are surrounded by X's and outputs to a text file.  Available here at [Project #3](https://replit.com/@ecy5045/Project-3#proj3.cpp).

#### Knights Move
The program then finds the smallest number of "Knight" moves it takes to get to ending position from the starting position.  Available here at [Project #4](https://replit.com/@ecy5045/Project4#proj4.cpp)

#### Inverstions Assignment
This program reads a text file to obtain sequences of integers values and finds the number of inversions from a sorted array and outputs the number. Available here at [Project #5](https://replit.com/@ecy5045/Project-5#proj5.cpp).

#### Dynamic Programming
This program reads a text file to obtain a board of 1's and 0's and finds the area of the largest square of 1's inside that board. Available here at [Project #6](https://replit.com/@ecy5045/Project-6-Dynamic-Programming#proj6.cpp).

### Intro to Operating Systems with C
#### IPC Communication 
This assignment required developing a program that could safely pass data between different threads and another process.  The starting process takes a user input which would be a celcius value to be converted to fahrenheit.  One thread would read the input and add it to a processing queue.  Another thread would pull from the processing queue, convert from celsius to fahrenheit, and then add the converted value into a Sending Queue (for sending to memory).  The last thread removes nodes from the Sending Queue to store the data in a shared memory location.  From there, the second program can access the values from the shared memory and display it to console.  Code available upon *request*. 
#### Basic Exam
This assignment implemented a very simple test that the user had to answer.  The goal of this assignment was to use signals to implement the timer for the test.  Every minute due to the alarm signal, the console prints out a message stating the number of minutes passed and how many are left.  After ten minutes, the text would be ended and total points printed.  Code available upon request. 

### Embedded System Design or Microcontroller with C or Assembly

### Object Oriented Programming with Java
