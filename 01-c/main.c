#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int* parse_file(const char* filepath, int* n) {
	FILE* file = fopen(filepath, "r");
	if (!file) {
		fprintf(stderr, "Could not load file: %s\n", filepath);
		return false;
	}

	int* values = NULL;
	int  length = 0;

	int x;
	while (fscanf(file, "%d", &x) == 1) {
		values = realloc(values, sizeof(int) * (length + 1));
		values[length++] = x;
	}

	fclose(file);

	*n = length;
	return values;
}

int part_one(const int* values, const int n) {
	int result = 0;
	for (int i = 1; i < n; ++i) {
		if (values[i - 1] < values[i]) {
			result++;
		}
	}
	return result;
}

int part_two(const int* values, const int n) {
	int result = 0;

	for (int i = 0; i < n - 3; ++i) {
		int w1 = values[i + 0] + values[i + 1] + values[i + 2];
		int w2 = values[i + 1] + values[i + 2] + values[i + 3];

		if (w1 < w2) {
			result++;
		}
	}
	return result;
}

void solve(const char* filepath) {
	int  length;
	int* values = parse_file(filepath, &length);
	if (!values) {
		return;
	}

	printf("%s: Part one: %d\n", filepath, part_one(values, length));
	printf("%s: Part two: %d\n", filepath, part_two(values, length));
}

int main(int argc, char const *argv[]) {
	for (int i = 1; i < argc; ++i) {
		solve(argv[i]);
	}

	return 0;
}