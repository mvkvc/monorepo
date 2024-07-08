#include <iostream>

int main() 
{
    std::cout << "Enter an integer: ";
    int v1{};

    std::cin >> v1;

    std::cout << "Double that number is: " << v1 * 2 << "\n";
    std::cout << "Triple that number is: " << v1 * 3 << "\n";

    return 0;
}