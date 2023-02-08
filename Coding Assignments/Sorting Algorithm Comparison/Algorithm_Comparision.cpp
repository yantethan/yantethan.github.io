// Algorithm_Comparision.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <chrono>
//#include <dos.h>
#include <math.h>
#include "SortAlg.h"


using namespace std;
using namespace std::chrono;


/*Variable Definitions*/
#define NUM_OF_VALUES 2000
#define NUM_OF_CASES 10
#define TESTS_PER_CASE 5


/*Function Definitions*/
void generateValues(int inputCase[]);
void printCase(int inputCase[]);
void printResults(int totalTimes[NUM_OF_CASES][6]);

void performTests(int Arr[], int caseNum, int totalTimes[NUM_OF_CASES][6]);
void tempArrReset(int Arr[], int ArrTmp[]);



/*Code Begining*/
int main()
{
    int totalTimes[NUM_OF_CASES][6];            //Array for storing results
    int userInput = 0;

    /*Define and Generate Test Cases*/
    srand(time(0));
    int* testCase1 = new int[NUM_OF_VALUES];
    generateValues(testCase1);
    int* testCase2 = new int[NUM_OF_VALUES];
    generateValues(testCase2);
    int* testCase3 = new int[NUM_OF_VALUES];
    generateValues(testCase3);
    int* testCase4 = new int[NUM_OF_VALUES];
    generateValues(testCase4);
    int* testCase5 = new int[NUM_OF_VALUES];
    generateValues(testCase5);
    int* testCase6 = new int[NUM_OF_VALUES];
    generateValues(testCase6);
    int* testCase7 = new int[NUM_OF_VALUES];
    generateValues(testCase7);
    int* testCase8 = new int[NUM_OF_VALUES];
    generateValues(testCase8);
    int* testCase9 = new int[NUM_OF_VALUES];
    generateValues(testCase9);
    int* testCase10 = new int[NUM_OF_VALUES];
    generateValues(testCase10);

    /*Perform Tests*/
    performTests(testCase1, 0, totalTimes);
    performTests(testCase2, 1, totalTimes);
    performTests(testCase3, 2, totalTimes);
    performTests(testCase4, 3, totalTimes);
    performTests(testCase5, 4, totalTimes);
    performTests(testCase6, 5, totalTimes);
    performTests(testCase7, 6, totalTimes);
    performTests(testCase8, 7, totalTimes);
    performTests(testCase9, 8, totalTimes);
    performTests(testCase10, 9, totalTimes);

    /*Print Final Results*/
    printResults(totalTimes);

    exit(1);
}


/*Function to Perform all Tests on Selected Test Case*/
/*Runs each algorithm the specified number times and averages the values for each algorithm*/
void performTests(int Arr[], int caseNum, int totalTimes[NUM_OF_CASES][6]) {
    auto startTime = high_resolution_clock::now();                      //Initialize Time Start Capture Variable
    auto stopTime = high_resolution_clock::now();                       //Initialize Time Stop Capure Variable
    auto duration = duration_cast<microseconds>(stopTime - startTime);  //Initialize Time Duration Calculation Variable
    int timestoAvg[TESTS_PER_CASE], tempArr[NUM_OF_VALUES], avg = 0, i = 1;
    tempArrReset(Arr, tempArr);

    //Selection Sort
    for (i = 0; i < TESTS_PER_CASE; i++) {                              //Repeat for defined number of tests per case to average
        startTime = high_resolution_clock::now();                       //Capture Start Clock Time
        selectionSort(tempArr, NUM_OF_VALUES);                          //Run Algorithm
        stopTime = high_resolution_clock::now();                        //Capture Stop Clock Time

        duration = duration_cast<microseconds>(stopTime - startTime);   //Find time difference in microseconds
        avg+= duration.count();                                         //Add time to average variable

        tempArrReset(Arr, tempArr);                                     //Clear tempArr to perform test again
    }
    avg = avg / TESTS_PER_CASE;
    totalTimes[caseNum][0] = avg;
    avg = 0;

    //Bubble
    for (i = 0; i < TESTS_PER_CASE; i++) {                              //Same as above...
        startTime = high_resolution_clock::now();
        bubbleSort(tempArr, NUM_OF_VALUES);
        stopTime = high_resolution_clock::now();

        duration = duration_cast<microseconds>(stopTime - startTime);
        avg += duration.count();

        tempArrReset(Arr, tempArr);
    }
    avg = avg / TESTS_PER_CASE;
    totalTimes[caseNum][1] = avg;
    avg = 0;

    //Insertion
    for (i = 0; i < TESTS_PER_CASE; i++) {
        startTime = high_resolution_clock::now();
        insertionSort(tempArr, NUM_OF_VALUES);
        stopTime = high_resolution_clock::now();

        duration = duration_cast<microseconds>(stopTime - startTime);
        avg += duration.count();

        tempArrReset(Arr, tempArr);
    }
    avg = avg / TESTS_PER_CASE;
    totalTimes[caseNum][2] = avg;
    avg = 0;

    //Merge
    for (i = 0; i < TESTS_PER_CASE; i++) {
        startTime = high_resolution_clock::now();
        mergeSort(tempArr, 0, NUM_OF_VALUES - 1);
        stopTime = high_resolution_clock::now();

        duration = duration_cast<microseconds>(stopTime - startTime);
        avg += duration.count();

        tempArrReset(Arr, tempArr);
    }
    avg = avg / TESTS_PER_CASE;
    totalTimes[caseNum][3] = avg;
    avg = 0;

    //Quick
    for (i = 0; i < TESTS_PER_CASE; i++) {
        startTime = high_resolution_clock::now();
        quickSort(tempArr, 0, NUM_OF_VALUES - 1);
        stopTime = high_resolution_clock::now();

        duration = duration_cast<microseconds>(stopTime - startTime);
        avg += duration.count();

        tempArrReset(Arr, tempArr);
    }
    avg = avg / TESTS_PER_CASE;
    totalTimes[caseNum][4] = avg;
    avg = 0;

    //Heap
    for (i = 0; i < TESTS_PER_CASE; i++) {
        startTime = high_resolution_clock::now();
        heapSort(tempArr, NUM_OF_VALUES);
        stopTime = high_resolution_clock::now();

        duration = duration_cast<microseconds>(stopTime - startTime);
        avg += duration.count();

        tempArrReset(Arr, tempArr);
    }
    avg = avg / TESTS_PER_CASE;
    totalTimes[caseNum][5] = avg;
}


//Function for generating random values in the array
void generateValues(int inputCase[]) {
    for (int i = 0; i < NUM_OF_VALUES; i++) {
        inputCase[i] = rand() % 2000;
    }
}

//Function for reseting temp array back to the original test case array
void tempArrReset(int Arr[], int ArrTmp[]) {
    for (int i = 0; i < NUM_OF_VALUES; i++) {
        ArrTmp[i] = Arr[i];
    }
}


//Function to format and print out the time duration
void printResults(int totalTimes[NUM_OF_CASES][6]) {
    int max, min, avg;
    cout << "-------------------------------- Results ---------------------------------\n";
    cout << "Case #| Selection |  Bubble   | Insertion |   Merge   |   Quick   |    Heap\n";

    //Below is a mix of formating code to print the results out neatly
    for (int x = 0; x < NUM_OF_CASES; x++) {
        if (x == 9)
            cout << "  " << x + 1 << "     ";
        else
            cout << "  " << x + 1 << "      ";


        for (int y = 0; y < 6; y++) {
            if ((totalTimes[x][y] / 1000) >= 10)
                cout << totalTimes[x][y] << "us     ";
            else if ((totalTimes[x][y] / 1000) >= 1)
                cout << totalTimes[x][y] << "us      ";
            else
                cout << " " << totalTimes[x][y] << "us      ";
        }
        cout << endl;
    }

    cout << "\nAverage Across all Test Cases\n";
    for (int i = 0; i < 6; i++) {
        avg = 0;
        min = totalTimes[0][i];
        max = 0;

        cout << "Test Number #" << i + 1 << ":\n";
        for (int j = 0; j < NUM_OF_CASES; j++) {
            avg += totalTimes[j][i];
            if (totalTimes[j][i] > max)
                max = totalTimes[j][i];
            if (totalTimes[j][i] < min)
                min = totalTimes[j][i];
        }
        cout << "\t- Max: " << max << "\n\t- Min: " << min << "\n\t- Avg: " << avg / NUM_OF_CASES << endl;
    }
}

//Print Case Debug Function
void printCase(int inputCase[]) {
    for (int i = 0; i < NUM_OF_VALUES; i++) {
        if ((i % 20) == 0)
            cout << endl;
        cout << inputCase[i] << " ";
    }
    cout << endl << endl;
}