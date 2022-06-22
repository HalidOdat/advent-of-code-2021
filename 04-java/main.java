import java.util.stream.*;
import java.util.*;
import java.io.*;

public class main {
  private static class Board {
    public static int ROWS    = 5;
    public static int COLUMNS = 5;

    public static class Element {
      public int     value;
      public boolean marked;

      public Element(int value) {
        this.value  = value;
        this.marked = false;
      }
    }

    private Element[][] matrix;
    private int lastMove = -1;

    public Board(Element[][] matrix) {
      this.matrix = matrix;
    }

    public int getLastMove() {
      return lastMove;
    }

    public void applyMove(int move) {
      this.lastMove = move;

      for (int i = 0; i < Board.ROWS; ++i) {
        for (int j = 0; j < Board.COLUMNS; j++) {
          if (this.matrix[i][j].value == move) {
            this.matrix[i][j].marked = true;
          }
        }
      }
    }

    public boolean hasWon() {
      // Check board horizontals
      for (int i = 0; i < Board.ROWS; ++i) {
        boolean hasMarked = true;
        for (int j = 0; j < Board.COLUMNS; ++j) {
          if (!this.matrix[i][j].marked) {
            hasMarked = false;
            break;
          }
        }

        if (hasMarked) {
          return true;
        }
      }
  
      // Check board verticals
      for (int i = 0; i < Board.COLUMNS; ++i) {
        boolean hasMarked = true;
        for (int j = 0; j < Board.ROWS; ++j) {
          if (!this.matrix[j][i].marked) {
            hasMarked = false;
            break;
          }
        }

        if (hasMarked) {
          return true;
        }
      }

      return false;
    }

    public int getScore() {
      return this.getLastMove() * Arrays
        .stream(this.matrix)
        .flatMap(x -> Arrays.stream(x))
        .filter(x -> !x.marked)
        .mapToInt(x -> x.value)
        .sum();
    }
  }

  private static List<Board> solve(List<Integer> moves, List<Board> boards) {
    ArrayList<Board> solved = new ArrayList<>();

    for (int move : moves) {
      for (int i = 0; i < boards.size(); ++i) {
        boards.get(i).applyMove(move);

        if (boards.get(i).hasWon()) {
          solved.add(boards.get(i));
          boards.remove(i);
          i--;
        }
      }
    }

    return solved;
  }

  public static void main(String[] args) {
    for (String filename : args) {
      List<String> lines;

      try {
        BufferedReader reader = new BufferedReader(new FileReader(filename));
        lines = reader.lines().collect(Collectors.toList());
        reader.close();
      } catch (Exception e) {
        e.printStackTrace();
        continue;
      }

      List<Integer> moves = Arrays
        .stream(lines.get(0).split(","))
        .map(x -> Integer.parseInt(x))
        .collect(Collectors.toList());

      ArrayList<Board> boards = new ArrayList<>();
      for (int i = 2; i < lines.size(); i += 6) {
        Board.Element[][] matrix = new Board.Element[5][5];
        for (int j = 0; j < 5; j++) {
          String[] row = lines.get(i + j).trim().split("\\s+");
          for (int k = 0; k < row.length; k++) {
            matrix[j][k] = new Board.Element(Integer.parseInt(row[k]));
          }
        }
        boards.add(new Board(matrix));
      }


      List<Board> solved = solve(moves, boards);
      System.out.printf("%s: Part one: %d\n", filename, solved.get(0).getScore());
      System.out.printf("%s: Part two: %d\n", filename, solved.get(solved.size() - 1).getScore());
    }
  }
}