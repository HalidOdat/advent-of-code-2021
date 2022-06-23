INPUTS=sample.txt input.txt

run: main
	./main $(INPUTS)

main: main.d
	ldmd2 -of main main.d

clean:
	rm -rf *.o main
