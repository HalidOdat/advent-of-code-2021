program main;

uses
  SysUtils;

type
  TElement = Record
    value: byte;
    marked: boolean;
  end;
  Input    = Array of Array of TElement;
  TPoint   = Record
    x: Integer;
    y: Integer;
  end;

const
  NEWLINE       = #10;
  MATRIX_WIDTH  = 1000;
  MATRIX_HEIGHT = 1000;

function PartOne(matrix: Input; rows: Integer; columns: Integer) : Integer;
var
   i: Integer;
   j: Integer;

begin
  PartOne := 0;
  for i := 0 to rows - 1 do
  begin
    for j := 0 to columns - 1 do
    begin
      // Check if up adjacent element is greater, if so skip element.
      if (i <> 0) and (matrix[i][j].value >= matrix[i - 1][j].value) then
        continue;
 
      // Check if down adjacent element is greater, if so skip element.
      if (i <> rows - 1) and (matrix[i][j].value >= matrix[i + 1][j].value) then
        continue;

      // Check if left adjacent element is greater, if so skip element.
      if (j <> 0) and (matrix[i][j].value >= matrix[i][j - 1].value) then
        continue;
 
      // Check if right adjacent element is greater, if so skip element.
      if (j <> columns - 1) and (matrix[i][j].value >= matrix[i][j + 1].value) then
        continue;

      PartOne += matrix[i][j].value + 1;
    end;
  end;
end;

function PartTwo(matrix: Input; rows: Integer; columns: Integer) : Int32;
var
   i: Integer;
   j: Integer;
   k: Integer;

   count: Integer;

   points: Array[0 .. 1000] of TPoint;
   points_size: Integer = 0;

   stack: Array[0 .. 1000] of TPoint;
   stack_size: Integer = 0;

   point: TPoint;

   top_counts: Array[0 .. 3] of Integer;

begin
  for i := 0 to rows - 1 do
  begin
    for j := 0 to columns - 1 do
    begin
      // Check if up adjacent element is greater, if so skip element.
      if (i <> 0) and (matrix[i][j].value >= matrix[i - 1][j].value) then
        continue;
 
      // Check if down adjacent element is greater, if so skip element.
      if (i <> rows - 1) and (matrix[i][j].value >= matrix[i + 1][j].value) then
        continue;

      // Check if left adjacent element is greater, if so skip element.
      if (j <> 0) and (matrix[i][j].value >= matrix[i][j - 1].value) then
        continue;
 
      // Check if right adjacent element is greater, if so skip element.
      if (j <> columns - 1) and (matrix[i][j].value >= matrix[i][j + 1].value) then
        continue;

      // Writeln('Mark(', i, ', ', j, ') = ', matrix[i][j].value);
      matrix[i][j].marked := True;

      point.x := i;
      point.y := j;
      points[points_size] := point;
      points_size += 1;
    end;
  end;
  
  for i := 0 to 3 do
    top_counts[i] := -1;

  for i := 0 to points_size - 1 do
  begin
    stack_size := 0;

    stack[stack_size] := points[i];
    stack_size += 1;
    
    count := 0;
    while stack_size <> 0 do
    begin
      stack_size -= 1;
      point := stack[stack_size];

      count += 1;

      // If there is such an element and it is not marked and it is greater than the current point and it not a 9, then
      // push to stack and mark it

      if (point.x <> 0)
        and not matrix[point.x - 1][point.y].marked
        and    (matrix[point.x - 1][point.y].value <> 9)
        and    (matrix[point.x - 1][point.y].value > matrix[point.x][point.y].value) then
      begin
        // Writeln('Point(', point.x - 1, ', ', point.y, ') = ', matrix[point.x - 1][point.y].value);
        matrix[point.x - 1][point.y].marked := True;
        
        stack[stack_size].x := point.x - 1;
        stack[stack_size].y := point.y;
        stack_size += 1;
      end;
 
      if (point.x <> rows - 1)
        and not matrix[point.x + 1][point.y].marked
        and    (matrix[point.x + 1][point.y].value <> 9)
        and    (matrix[point.x + 1][point.y].value > matrix[point.x][point.y].value) then
      begin
        // Writeln('Point(', point.x + 1, ', ', point.y, ') = ', matrix[point.x + 1][point.y].value);
        matrix[point.x + 1][point.y].marked := True;

        stack[stack_size].x := point.x + 1;
        stack[stack_size].y := point.y;
        stack_size += 1;
      end;

      if (point.y <> 0)
        and not matrix[point.x][point.y - 1].marked
        and    (matrix[point.x][point.y - 1].value <> 9)
        and    (matrix[point.x][point.y - 1].value > matrix[point.x][point.y].value) then
      begin
        // Writeln('Point(', point.x, ', ', point.y - 1, ') = ', matrix[point.x][point.y - 1].value);
        matrix[point.x][point.y - 1].marked := True;
        
        stack[stack_size].x := point.x;
        stack[stack_size].y := point.y - 1;
        stack_size += 1;
      end;
 
      if (point.y <> columns - 1)
        and not matrix[point.x][point.y + 1].marked
        and    (matrix[point.x][point.y + 1].value <> 9)
        and    (matrix[point.x][point.y + 1].value > matrix[point.x][point.y].value) then
      begin
        // Writeln('Point(', point.x, ', ', point.y + 1, ') = ', matrix[point.x][point.y + 1].value);
        matrix[point.x][point.y + 1].marked := True;

        stack[stack_size].x := point.x;
        stack[stack_size].y := point.y + 1;
        stack_size += 1;
      end;
    end;
    
    // Writeln('Count = ', count);

    j := 0;
    for k := 0 to 2 do
    begin
      if top_counts[k] < top_counts[j] then
        j := k;
    end;
    if top_counts[j] < count then
      top_counts[j] := count;
  end;

  PartTwo := 1;
  for i := 0 to 2 do
  begin
    // Writeln('Top count #', i + 1, ' = ', top_counts[i]);
    PartTwo *= top_counts[i];
  end;
end;

var
  f:       File of Char;
  c:       Char;
  i:       Integer;
  j:       Integer;
  k:       Integer;
  rows:    Integer;
  columns: Integer;
  matrix:  Input;

begin
  // Preallocate more than enough space for the input
  setLength(matrix, MATRIX_WIDTH, MATRIX_HEIGHT);
  
  for i := 1 to ParamCount do
  begin
    Assign(f, ParamStr(i));
    Reset(f);

    c := '?';

    rows := 0;
    while not Eof(f) do
    begin
      columns := 0;
      while not Eof(f) do
      begin
        Read(f, c);

        if c = NEWLINE then
          break;

        matrix[rows][columns].value  := Ord(c) - Ord('0');
        matrix[rows][columns].marked := False;
        columns += 1;
      end;
      rows += 1;
    end;

    Close(f);

    Writeln(ParamStr(i), ': Part one: ', PartOne(matrix, rows, columns));
    Writeln(ParamStr(i), ': Part two: ', PartTwo(matrix, rows, columns));

    // for j := 0 to rows - 1 do
    // begin
    //   for k := 0 to columns - 1 do
    //   begin
    //     if (matrix[j][k].marked) then
    //       Write('[', matrix[j][k].value, ']');
    // 
    //     if not (matrix[j][k].marked) then
    //       Write(' ', matrix[j][k].value, ' ');
    //   end;
    //   Writeln();
    // end;
  end;
end.