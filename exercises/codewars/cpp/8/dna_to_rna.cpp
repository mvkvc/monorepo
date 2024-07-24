#include <iostream>
#include <string>

std::string replace(std::string subject, std::string target, std::string replacement)
{
    size_t pos = 0;
    while ((pos = subject.find(target, pos)) != std::string::npos)
    {
        subject.replace(pos, target.length(), replacement);
        pos += replacement.length();
    }

    return subject;
}

int main()
{
    std::string input = "GCAT";
    std::string result = replace(input, "T", "U");

    std::cout << "Result: ";
    std::cout << result;

    return 0;
}
