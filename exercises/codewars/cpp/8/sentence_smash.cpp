#include <iostream>
#include <vector>

std::string smash(const std::vector<std::string> &words)
{
    std::string result;
    for (std::vector<std::string>::const_iterator it = words.begin(); it != words.end(); it++)
    {
        result += *it;
        if (it != words.end() - 1)
        {
            result += ' ';
        }
    }

    return result;
}

int main()
{
    std::vector<std::string> input = {"this", "is", "a", "really", "long", "sentence"};

    // std::cout << "Input: " << input << "\n";
    std::cout << "START" << smash(input) << "END\n";

    return 0;
}
