#include <iostream>
#include <vector>

// Function to calculate factorial
int factorial(int n) {
    if (n <= 1) {
        return 1;
    }
    return n * factorial(n - 1);
}

// Function to display vector elements
void printVector(const std::vector<int>& vec) {
    for (int num : vec) {
        std::cout << num << " ";
    }
    std::cout << std::endl;
}

int main() {
    int num = 5;
    std::cout << "Factorial of " << num << " is " << factorial(num) << std::endl;

    std::vector<int> numbers = {1, 2, 3, 4, 5};
    printVector(numbers);

    return 0;
}

