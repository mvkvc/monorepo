#include <bitset>
#include <iostream>

unsigned int countBits(unsigned long long n){
  return static_cast<unsigned int>(std::bitset<64>(n).count());
}

int main()
{
    unsigned int input = 392902058;

    std::cout << "Input: " << input << "\n";
    std::cout << "Output: " << countBits(input) << "\n";

    return 0;
}
