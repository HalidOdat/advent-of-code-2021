import sys

def partOne(lines):
  switcher = {
    ')': ('(', 3),
    ']': ('[', 57),
    '}': ('{', 1197),
    '>': ('<', 25137),
  }

  score = 0
  for line in lines:
    stack = []
    for c in line:
      if   c == '(' or c == '[' or c == '{' or c == '<':
        stack.append(c)
      elif c == ')' or c == ']' or c == '}' or c == '>':
        (openingChar, points) = switcher.get(c);
        if stack.pop() != openingChar:
          score += points;
          break

  return score

def partTwo(lines):
  scores = []

  for line in lines:
    stack = []
    
    for c in line:
      if   c == '(' or c == '[' or c == '{' or c == '<':
        stack.append(c)
      elif c == ')' or c == ']' or c == '}' or c == '>':
        switcher = {
          ')': '(',
          ']': '[',
          '}': '{',
          '>': '<',
        }
        if stack.pop() != switcher.get(c):
          stack = []
          break
    
    if len(stack) != 0:
      switcher = {
        '(': 1,
        '[': 2,
        '{': 3,
        '<': 4,
      }
      score = 0;
      while stack:
        score = score * 5 + switcher.get(stack.pop())
      scores.append(score)

  scores.sort()
  return scores[len(scores) // 2]


for filename in sys.argv[1:]:
  try:
    with open(filename) as file:
      lines = file.read().splitlines()

      print(f'{filename}: Part one: {partOne(lines)}')
      print(f'{filename}: Part two: {partTwo(lines)}')

  except Exception as error:
    print(f'Could not open file \'{filename}\' with error message \'{error}\'')
