#include <iostream>

std::string reverseString(std::string str)
{
    size_t len = str.length() - 1;
    size_t i = (len - 1) / 2;
    size_t pos = 0;
    while (pos <= i)
    {
        std::swap(str[pos], str[len-pos]);
        pos++;
    }

    return str;
}

int main()
{
    std::string input = "Hello";

    std::cout << "Input: " << input << "\n";
    std::cout << "Result: " << reverseString(input) << "\n";

    return 0;
}
