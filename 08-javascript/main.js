const fs = require('fs');


function partOne(entries) {
  let count = 0;
  for (let { patterns, outputs } of entries) {
    for (let output of outputs) {
      switch (output.length) {
        case 2: // Number 1
        case 4: // Number 4
        case 3: // Number 7
        case 7: // number 8
          count++;
          break;
        default:
          // do nothing...
      }
    }
  }

  return count;
}

const A    = 1 << 0;
const B    = 1 << 1;
const C    = 1 << 2;
const D    = 1 << 3;
const E    = 1 << 4;
const F    = 1 << 5;
const G    = 1 << 6;
const NONE = 0;
const ALL  = A
           | B
           | C
           | D
           | E
           | F
           | G;

function stringToMask(s) {
  let mask = NONE;
  for (let c of s) {
    switch (c) {
      case 'a': mask |= A; break;
      case 'b': mask |= B; break;
      case 'c': mask |= C; break;
      case 'd': mask |= D; break;
      case 'e': mask |= E; break;
      case 'f': mask |= F; break;
      case 'g': mask |= G; break;
      default:
        throw new RangeError('Invalid char ' + c);
    }
  }
  return mask;
}

function decode(masks, string) {
  let output = stringToMask(string);
  switch (string.length) {
    case 2: return 1;
    case 3: return 7;
    case 4: return 4;
    case 5: {
      let two   = masks[0] | masks[2] | masks[3] | masks[4] | masks[6];
      let three = masks[0] | masks[2] | masks[3] | masks[5] | masks[6];
      let five  = masks[0] | masks[1] | masks[3] | masks[5] | masks[6];

      if (output == two) {
        return 2;
      } else if (output == three) {
        return 3;
      } else if (output == five) {
        return 5;
      } else {
        throw new Error();
      }
    }
    case 6: {
      let zero = masks[0] | masks[1] | masks[2] | masks[4] | masks[5] | masks[6];
      let six  = masks[0] | masks[1] | masks[3] | masks[4] | masks[5] | masks[6];
      let nine = masks[0] | masks[1] | masks[2] | masks[3] | masks[5] | masks[6];

      if (output == zero) {
        return 0;
      } else if (output == six) {
        return 6;
      } else if (output == nine) {
        return 9;
      } else {
        throw new Error();
      }
    }
    case 7: return 8;
  }
}

function partTwo(entries) {
  let result = 0;
  for (let { patterns, outputs } of entries) {
    patterns = patterns.sort((x, y) => x.length - y.length).map(stringToMask);
    let masks = [ALL, ALL, ALL, ALL, ALL, ALL, ALL];

    masks[0] = patterns[0] ^ patterns[1];
    masks[2] = patterns[0];
    masks[5] = patterns[0];

    masks[5] ^= masks[0];

    masks[1] = patterns[2] ^ (patterns[1] ^ masks[0]);
    masks[3] = patterns[2] ^ (patterns[1] ^ masks[0]);
    masks[4] ^= masks[1] | masks[2];
    masks[6] ^= masks[1] | masks[2];

    let three = patterns.slice(3, 6).filter(x => (x & patterns[0]) == patterns[0])[0];
    masks[3] &= three & ~patterns[0] ^ masks[0];
    masks[1] ^= masks[3];
    masks[6] &= three & ~patterns[0] ^ masks[0];
    masks[4] ^= masks[6];

    let two = patterns.slice(3, 6).filter(x => (x & (masks[3] | masks[4])) == (masks[3] | masks[4]))[0];
    masks[5] &= ~two;
    masks[2] ^= masks[5];

    result += outputs.reduce((acc, output) => acc * 10 + decode(masks, output), 0);
  }
  return result;
}

for (let filename of process.argv.slice(2)) {
  let entries = [];
  fs.readFileSync(filename, 'utf-8').split(/\r?\n/).forEach(line =>  {
    let parts = line.split(' | ').map(x => x.split(' '));
    entries.push({ patterns: parts[0], outputs: parts[1] });
  });

  console.log(`${filename}: Part one: ${ partOne(entries) }`);
  // console.log(entries);
  console.log(`${filename}: Part two: ${ partTwo(entries) }`);
  // console.log(entries.map(x => x.patterns));
}