#pragma once

#include <iostream>
using namespace std;


#define NUM_OF_VALUES 2000


/*Function Definitioins*/
void selectionSort(int Arr[], int n);

void bubbleSort(int Arr[], int n);

void insertionSort(int Arr[], int n);

void mergeSort(int array[], int const begin, int const end);
void merge(int array[], int const left, int const mid, int const right);

void quickSort(int Arr[], int low, int high);
int partitionArr(int Arr[], int low, int high);

void heapSort(int Arr[], int n);
void heapify(int Arr[], int n, int i);

void swap(int* a, int* b);


void sortAlgCheck(int Arr[]);		//Debug function




/*Selection Sort*/
//https://www.geeksforgeeks.org/selection-sort/
void selectionSort(int Arr[], int n) {
    int min;

    for (int i = 0; i < n - 1; i++) {
        min = i;

        for (int j = i + 1; j < n; j++) {
            if (Arr[j] < Arr[min])
                min = j;
        }

        swap(&Arr[min], &Arr[i]);
    }
}


/*Bubble Sort*/
//https://www.geeksforgeeks.org/bubble-sort/
void bubbleSort(int Arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (Arr[j] > Arr[j + 1])
                swap(&Arr[j], &Arr[j + 1]);
        }
    }
}


/*Insertion Sort*/
//https://www.geeksforgeeks.org/insertion-sort/?ref=leftbar-rightbar
void insertionSort(int Arr[], int n) {
    int j, key;

    for (int i = 1; i < n; i++) {
        key = Arr[i];
        j = i - 1;

        while (j >= 0 && Arr[j] > key) {
            Arr[j + 1] = Arr[j];
            j = j - 1;
        }

        Arr[j + 1] = key;
    }
}


/*Merge Sort (Directly Copied)*/
//https://www.geeksforgeeks.org/merge-sort/?ref=lbp
void mergeSort(int array[], int const begin, int const end)
{
    if (begin >= end)
        return; // Returns recursively

    auto mid = begin + (end - begin) / 2;
    mergeSort(array, begin, mid);
    mergeSort(array, mid + 1, end);
    merge(array, begin, mid, end);
}

void merge(int array[], int const left, int const mid, int const right)
{
    auto const subArrayOne = mid - left + 1;
    auto const subArrayTwo = right - mid;

    // Create temp arrays
    auto* leftArray = new int[subArrayOne],
            * rightArray = new int[subArrayTwo];

    // Copy data to temp arrays leftArray[] and rightArray[]
    for (auto i = 0; i < subArrayOne; i++)
        leftArray[i] = array[left + i];
    for (auto j = 0; j < subArrayTwo; j++)
        rightArray[j] = array[mid + 1 + j];

    auto indexOfSubArrayOne = 0, // Initial index of first sub-array
    indexOfSubArrayTwo = 0; // Initial index of second sub-array
    int indexOfMergedArray = left; // Initial index of merged array

    // Merge the temp arrays back into array[left..right]
    while (indexOfSubArrayOne < subArrayOne && indexOfSubArrayTwo < subArrayTwo) {
        if (leftArray[indexOfSubArrayOne] <= rightArray[indexOfSubArrayTwo]) {
            array[indexOfMergedArray] = leftArray[indexOfSubArrayOne];
            indexOfSubArrayOne++;
        }
        else {
            array[indexOfMergedArray] = rightArray[indexOfSubArrayTwo];
            indexOfSubArrayTwo++;
        }
        indexOfMergedArray++;
    }
    // Copy the remaining elements of
    // left[], if there are any
    while (indexOfSubArrayOne < subArrayOne) {
        array[indexOfMergedArray] = leftArray[indexOfSubArrayOne];
        indexOfSubArrayOne++;
        indexOfMergedArray++;
    }
    // Copy the remaining elements of
    // right[], if there are any
    while (indexOfSubArrayTwo < subArrayTwo) {
        array[indexOfMergedArray] = rightArray[indexOfSubArrayTwo];
        indexOfSubArrayTwo++;
        indexOfMergedArray++;
    }
}


/*Quick Sort*/
//https://www.geeksforgeeks.org/quick-sort/?ref=lbp
void quickSort(int Arr[], int low, int high) {
    if (low < high) {
        int index = partitionArr(Arr, low, high);

        quickSort(Arr, low, index - 1);
        quickSort(Arr, index + 1, high);
    }
}

int partitionArr(int Arr[], int low, int high) {
    int pivotPt = Arr[high], i = low - 1;

    for (int j = low; j < high; j++) {
        if (Arr[j] < pivotPt) {
            i++;
            swap(&Arr[i], &Arr[j]);
        }
    }
    swap(&Arr[i + 1], &Arr[high]);
    return (i + 1);
}


/*Heap Sort*/
//https://www.geeksforgeeks.org/heap-sort/?ref=lbp
void heapSort(int Arr[], int n) {
    for (int i = n / 2 - 1; i >= 0; i--) {
        heapify(Arr, n, i);
    }

    for (int j = n - 1; j > 0; j--) {
        swap(&Arr[0], &Arr[j]);
        heapify(Arr, j, 0);
    }
}

void heapify(int Arr[], int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n && Arr[left] > Arr[largest])
        largest = left;

    if (right < n && Arr[right] > Arr[largest])
        largest = right;

    if (largest != i) {
        swap(&Arr[i], &Arr[largest]);
        heapify(Arr, n, largest);
    }
}


//Array value swap function
void swap(int* a, int* b) {
    int temp = *a;

    *a = *b;
    *b = temp;
}


//Brute-Force debug function to manually check that all algorithms are giving the same output
void sortAlgCheck(int Arr[]) {
    int arrTemp[NUM_OF_VALUES];
    for (int i = 0; i < NUM_OF_VALUES; i++) {
        arrTemp[i] = Arr[i];
    }
    int* ArrSelection = new int[NUM_OF_VALUES];
    selectionSort(Arr, NUM_OF_VALUES);
    for (int i = 0; i < NUM_OF_VALUES; i++) {
        ArrSelection[i] = Arr[i];
    }

    bubbleSort(Arr, NUM_OF_VALUES);
    for (int i = 0; i < NUM_OF_VALUES; i++) {
        if (ArrSelection[i] != Arr[i]) {
            cout << "Mis-match when comparing Selection to Bubble on index: " << i << endl;
        }
    }
    insertionSort(Arr, NUM_OF_VALUES);
    for (int i = 0; i < NUM_OF_VALUES; i++) {
        if (ArrSelection[i] != Arr[i]) {
            cout << "Mis-match when comparing Selection to Insertion on index: " << i << endl;
        }
    }
    mergeSort(Arr, 0, NUM_OF_VALUES - 1);
    for (int i = 0; i < NUM_OF_VALUES; i++) {
        if (ArrSelection[i] != Arr[i]) {
            cout << "Mis-match when comparing Selection to Merge on index: " << i << endl;
        }
    }
    quickSort(Arr, 0, NUM_OF_VALUES - 1);
    for (int i = 0; i < NUM_OF_VALUES; i++) {
        if (ArrSelection[i] != Arr[i]) {
            cout << "Mis-match when comparing Selection to Quick on index: " << i << endl;
        }
    }
    heapSort(Arr, NUM_OF_VALUES);
    for (int i = 0; i < NUM_OF_VALUES; i++) {
        if (ArrSelection[i] != Arr[i]) {
            cout << "Mis-match when comparing Selection to Heap on index: " << i << endl;
        }
    }

    cout << "All algorithms are equal otherwise.";
}