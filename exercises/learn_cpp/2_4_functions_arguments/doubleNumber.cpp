#include <iostream>

int doubleNumber(int n) { return n * 2; }

int main() {
  std::cout << "Enter an integer to double: ";
  int n{};
  std::cin >> n;
  std::cout << "Result: " << doubleNumber(n) << "\n";

  return 0;
}
