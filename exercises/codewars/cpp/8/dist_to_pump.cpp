#include <iostream>

bool zero_fuel(uint32_t distance_to_pump, uint32_t mpg, uint32_t fuel_left)
{
    bool result = false;
    if (mpg != 0) {
        result = distance_to_pump/mpg < fuel_left;
    }
  
  return result;
}

int main()
{
    uint32_t input_dist = 100;
    uint32_t input_mpg = 50;
    uint32_t input_fuel = 1;

    std::cout << "Input: ";
    std::cout << "dist - " << input_dist << " ";
    std::cout << "mpg - " << input_mpg << " ";
    std::cout << "fuel - " << input_fuel << "\n";

    bool result = zero_fuel(input_dist, input_mpg, input_fuel);

    std::cout << "Result: " << result << "\n";

    return 0;
}
