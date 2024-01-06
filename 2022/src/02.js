import { readFileSync } from 'fs'

const file = readFileSync(process.argv[2], 'utf8')
const lines = file.split('\n').slice(0, -1)

let result_1 = 0
const scores_1 = {
  'A X': 3+1,
  'A Y': 6+2,
  'A Z': 0+3,
  'B X': 0+1,
  'B Y': 3+2,
  'B Z': 6+3,
  'C X': 6+1,
  'C Y': 0+2,
  'C Z': 3+3,
}

let result_2 = 0
const scores_2 = {
  'A X': 0+3,
  'A Y': 3+1,
  'A Z': 6+2,
  'B X': 0+1,
  'B Y': 3+2,
  'B Z': 6+3,
  'C X': 0+2,
  'C Y': 3+3,
  'C Z': 6+1,
}

lines.forEach(line => result_1 += scores_1[line])
lines.forEach(line => result_2 += scores_2[line])

console.log(result_1)
console.log(result_2)
