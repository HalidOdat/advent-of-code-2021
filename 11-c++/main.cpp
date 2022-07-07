#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <cstdint>

const auto FLASHED = UINT8_MAX;

std::pair<size_t, size_t> solve(std::vector<std::vector<uint8_t>>& matrix) {
  const auto STEPS   = 100;

  const auto rows    = matrix.size();
  const auto columns = matrix[0].size();

  const auto increment_non_flashed = [&](const auto i, const auto j) {
    // Out of bounds
    if ((i < 0 || i >= rows) || (j < 0 || j >= columns)) {
      return;
    }
    
    // already flashed to nothing
    if (matrix[i][j] == FLASHED) {
      return;
    }

    matrix[i][j]++;
  };

  const auto flash = [&](const auto i, const auto j) -> bool {
    // Out of bounds
    if ((i < 0 || i >= rows) || (j < 0 || j >= columns)) {
      return false;
    }
    
    // already flashed to nothing
    if (matrix.at(i).at(j) == FLASHED) {
      return false;
    }

    if (matrix[i][j] > 9) {
      matrix[i][j] = FLASHED;
      return true;
    }

    return false;
  };
  
  bool part_one_done = false;
  bool part_two_done = false;

  size_t part_one_result = 0;
  size_t part_two_result = 0;

  size_t step = 0;
  while (!(part_one_done && part_two_done)) {

    // 1. First, the energy level of each octopus increases by 1.
    for (auto i = 0; i < rows; ++i) {
      for (auto j = 0; j < columns; ++j) {
        matrix[i][j]++;
      }
    }

    // 2. Then, any octopus with an energy level greater than 9 flashes.
    //    This increases the energy level of all adjacent octopuses by 1,
    //    including octopuses that are diagonally adjacent.
    // 
    // If this causes an octopus to have an energy level greater than 9,
    //    it also flashes. This process continues as long as new octopuses keep
    //    having their energy level increased beyond 9.
    //    (An octopus can only flash at most once per step.)
    bool flashed;
    do {
      flashed = false;

      for (auto i = 0; i < rows; ++i) {
        for (auto j = 0; j < columns; ++j) {
          if (flash(i, j)) {
            increment_non_flashed(i + 1, j - 1);
            increment_non_flashed(i + 1, j    );
            increment_non_flashed(i + 1, j + 1);
            increment_non_flashed(i    , j - 1);
            increment_non_flashed(i    , j + 1);
            increment_non_flashed(i - 1, j - 1);
            increment_non_flashed(i - 1, j    );
            increment_non_flashed(i - 1, j + 1);
            flashed = true;
          }
        }
      }
    } while (flashed);

    // 3. Finally, any octopus that flashed during this step has its energy level set to 0, as it used all of its energy to flash.
    size_t count = 0;
    for (auto i = 0; i < rows; ++i) {
      for (auto j = 0; j < columns; ++j) {
        if (matrix[i][j] == FLASHED) {
          matrix[i][j] = 0;
          count++;
        }
      }
    }

    if (step < STEPS) {
      part_one_result += count;
    } else {
      part_one_done = true;
    }

    if (count == rows * columns) {
      part_two_result = step + 1;
      part_two_done = true;
    }

    step++;
  }
  
  return { part_one_result, part_two_result };
}

int main(int argc, char const *argv[]) {
  for (int i = 1; i < argc; ++i) { // skip over argv[0]
    const char* filename = argv[i];

    std::vector<std::vector<uint8_t>> matrix; 

    std::ifstream file(filename);
    if (file.is_open()) {
        std::string line;

        while (std::getline(file, line)) {
            std::vector<uint8_t> row;
            for (const auto c : line) {
              row.push_back(c - '0');
            }
            matrix.push_back(row);
        }
        file.close();
    } else {
      std::cerr << "Couldn't open file '" << filename << "'" << std::endl;
      continue;
    }

    const auto solution = solve(matrix);
    std::cout << filename << ": Part one: " << solution.first  << std::endl;
    std::cout << filename << ": Part two: " << solution.second << std::endl;
  }
}