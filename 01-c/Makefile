CFLAGS=-Wall -Wextra -Wpedantic
INPUT_FILES=sample.txt input.txt

run: main
	./main $(INPUT_FILES)

main: main.c
	$(CC) $(CFLAGS) -o main main.c
