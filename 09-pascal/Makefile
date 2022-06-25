INPUTS=sample.txt input.txt

run: main
	./main $(INPUTS)

main: main.pas
	fpc main.pas

clean:
	rm -rf main main.o