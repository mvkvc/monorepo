#include <iostream>
#include <vector>

int count_sheep(std::vector<bool> arr)
{
    int count = 0;
    for (std::vector<bool>::const_iterator it = arr.begin(); it != arr.end(); it++)
    {
        if (*it)
        {
            count++;
        }
    }

    return count;
}

int main()
{
    std::vector<bool> input = {true, true, true, false,
                               true, true, true, true,
                               true, false, true, false,
                               true, false, false, true,
                               true, true, true, true,
                               false, false, true, true};

    // std::cout << "Input: " << input << "\n";
    std::cout << "Output: " << count_sheep(input) << "\n";

    return 0;
}
