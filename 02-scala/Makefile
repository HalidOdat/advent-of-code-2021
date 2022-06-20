INPUT_FILES=sample.txt input.txt

run: main
	scala Main $(INPUT_FILES)

main: main.scala
	scalac main.scala

clean:
	rm -rf *.class