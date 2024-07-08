// Write the following program: The user is asked to enter 2 floating point numbers (use doubles). The user is then asked to enter one of the following mathematical symbols: +, -, *, or /. The program computes the answer on the two numbers the user entered and prints the results. If the user enters an invalid symbol, the program should print nothing.

// Example of program:

// Enter a double value: 6.2
// Enter a double value: 5
// Enter +, -, *, or /: *
// 6.2 * 5 is 31

#include <iostream>

double getDouble() {
    std::cout << "Enter a double: ";
    double x;
    std::cin >> x;

    return x;
}

char getOperator() {
    std::cout << "Enter +, -, *, or /: ";
    char op;
    std::cin >> op;

    return op;
}

int handleResult(double x, double y, char op) {
    double result;

    if (op == '+')
    {
        result = x + y;
    }
    else if (op == '-')
    {
        result = x - y;
    }
    else if (op == '*')
    {
        result = x * y;
    }
    else if (op == '/')
    {
        result = x / y;
    }
    else
    {
        std::cout << "Invalid operator: " << op << "\n";
        return 1;
    }

    std::cout << x << " " << op << " " << y << " is " << result << "\n";
    return 0;
}

int main_()
{
    double x{ getDouble() }; 
    double y{ getDouble() }; 
    char op{ getOperator() };

    int out{ handleResult(x, y, op) };

    return out;
}
