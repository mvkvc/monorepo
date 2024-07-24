#include <iostream>
#include <vector>
#include <string>

bool check(const std::vector<std::string> &seq, const std::string &elem)
{
    for (std::vector<std::string>::const_iterator it = seq.begin(); it != seq.end(); it++)
    {
        if (*it == elem)
        {
            return true;
        }
    }

    return false;
}

int main()
{

    std::vector<std::string> seq = {"a", "b", "c"};
    std::string elem = "c";

    std::cout << "Result: " << check(seq, elem) << "\n";

    return 0;
}
