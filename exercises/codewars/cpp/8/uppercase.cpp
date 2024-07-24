#include <iostream>

std::string makeUpperCase (const std::string& input_str)
{
    std::string output = input_str;
    for (char& c: output) {
        c = static_cast<char>(std::toupper(static_cast<unsigned char>(c)));
    }
    return output;
}

int main() {
    
    std::string input = "hello";
    std::cout << "Input: " << input << "\n";

    std::string output = makeUpperCase(input);
    std::cout << "Output: " << output << "\n";
}
