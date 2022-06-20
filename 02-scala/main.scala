import scala.collection.mutable.ArrayBuffer
import scala.io.Source
import java.io.{FileNotFoundException, IOException}

object Main {
    private def part_one(values: ArrayBuffer[(String, Int)]): Int = {
        var horizontal = 0
        var depth      = 0

        for ((command, operand) <- values) {
            command match {
                case "forward" => horizontal += operand
                case "up"      => depth -= operand
                case "down"    => depth += operand
                case _         => assert(false, "Unknown command '" + command + "' found")
            }
        }

        return horizontal * depth
    }

    private def part_two(values: ArrayBuffer[(String, Int)]): Int = {
        var horizontal = 0
        var depth      = 0
        var aim        = 0

        for ((command, operand) <- values) {
            command match {
                case "forward" => {
                    horizontal += operand
                    depth      += aim * operand
                }
                case "up"      => aim -= operand
                case "down"    => aim += operand
                case _         => assert(false, "Unknown command '" + command + "' found")
            }
        }

        return horizontal * depth
    }

    def main(args: Array[String]) = {
        for (filepath <- args) {
            try {
                var values = ArrayBuffer[(String, Int)]()
                for (line <- Source.fromFile(filepath).getLines) {
                    val parts = line.split(" ")
                    val value = (parts(0), parts(1).toInt)
                    values += value
                }

                println(s"$filepath: Part one: ${ Main.part_one(values) }")
                println(s"$filepath: Part two: ${ Main.part_two(values) }")
            } catch {
                case e: FileNotFoundException => println("Couldn't find that file.")
                case e: IOException => println("Got an IOException!")
            }
        }
    }
}