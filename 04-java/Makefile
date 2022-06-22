INPUT_FILES=sample.txt input.txt

run: main
	java main $(INPUT_FILES)

main: main.java
	javac -Xlint:unchecked main.java

clean:
	rm -rf *.class