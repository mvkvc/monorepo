#include "./add.h"
#include <iostream>

int main() {
  int x{1};
  int y{2};

  std::cout << "The sum of " << x << " and " << y << " is " << add(x, y)
            << "\n";

  return 0;
}
