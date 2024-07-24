#include <iostream>
#include <vector>

int sum_positive(std::vector<int> input) {
    int acc = 0;
    for (int num: input) {
        if (num > 0) {
            acc += num;
        }
    }

    return acc;
}

int main() {
    
    std::vector<int> input = {1,-4,7,12};

    std::cout << "Input: ";
    for (int num: input) {
        std::cout << num << ' ';
    }

    int output = sum_positive(input);
    std::cout << "Output: " << output;
}