INPUT_FILES=sample.txt input.txt

run: main
	./main $(INPUT_FILES)

main: main.f90
	gfortran -o main main.f90

clean:
	rm -rf main