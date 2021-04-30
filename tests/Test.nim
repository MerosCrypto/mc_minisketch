import ../mc_minisketch

import algorithm

var sketchA: Sketch = newSketch(12, 0, 4)
for i in 3000 ..< 3010:
  sketchA.add(uint64(i))

var serialized: string = sketchA.serialize()
assert(serialized.len == 12 * 4 div 8)

var sketchB: Sketch = newSketch(12, 0, 4)
for i in 3002 ..< 3012:
  sketchB.add(uint64(i))

sketchB.merge(serialized)

var differences: seq[uint64] = sketchB.decode()
assert(differences.len == 4)
assert(differences.sorted() == @[3000'u64, 3001'u64, 3010'u64, 3011'u64].sorted())
