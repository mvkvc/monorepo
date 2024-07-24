#include <iostream>
#include <string>

int string_to_number(const std::string &s)
{
    return std::stoi(s);
}

int main()
{
    std::string input = "100";
    std::cout << "Input: "  << input << "\n";
    std::cout << "Output: " << string_to_number(input) << "\n";
}