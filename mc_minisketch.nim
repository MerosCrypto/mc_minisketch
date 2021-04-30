#Get the Minisketch path.
const sketchFolder = currentSourcePath().substr(0, currentSourcePath().len - "/mc_minisketch.nim".len) & "minisketch/"

#Add the Minisketch include folder to the include folders.
{.passC: "-I " & sketchFolder & "include/".}

#Link with the static library.
{.passL: sketchFolder & ".libs/libminisketch.a".}

#Link with the C++ standard library.
{.passL: "-lstdc++".}

{.push, header: "minisketch.h".}

#Sketch data types.
type Sketch* {.importc: "minisketch*".} = object

#Highest implementation number available.
proc implementationMax*(): uint32 {.importc: "minisketch_implementation_max".}

#Constructor.
proc newSketch*(
  bits: uint32,
  impl: uint32,
  capacity: csize_t
): Sketch {.importc: "minisketch_create".}

#Capacity.
proc capacity*(
  sketch: Sketch
): csize_t {.importc: "minisketch_capacity".}

#Add an element.
proc add*(
  sketch: Sketch,
  elem: uint64
) {.importc: "minisketch_add_uint64".}

#Serialization.
proc serializedSize(
  sketch: Sketch
): csize_t {.importc: "minisketch_serialized_size".}

proc serialize(
  sketch: Sketch,
  output: cstring
) {.importc: "minisketch_serialize".}

#Parse a Sketch.
proc parse(
  sketch: Sketch,
  input: cstring
) {.importc: "minisketch_deserialize".}

#Return the differences from merged sketches.
proc decode(
  sketch: Sketch,
  max: csize_t,
  output: ptr uint64
): cint {.importc: "minisketch_decode".}

#Destroy a sketch.
proc destroy*(
  sketch: Sketch
) {.importc: "minisketch_destroy".}

{.pop.}

#Serialize a sketch.
proc serialize*(
  sketch: Sketch
): string =
  result = newString(sketch.serializedSize())
  sketch.serialize(addr result[0])

#Merge a sketch.
#Doesn't use parse and then the Minisketch provided merge.
#That requires parsing a second sketch and merging with that.
#This xors the serializations and parses back into the passed in sketch.
proc merge*(
  sketch: Sketch,
  otherStr: string
) =
  var difference: string = sketch.serialize()
  for c in 0 ..< difference.len:
    difference[c] = char(uint8(difference[c]) xor uint8(otherStr[c]))
  sketch.parse(addr difference[0])

#Return the differences from merged sketches.
proc decode*(
  sketch: Sketch
): seq[uint64] =
  result = newSeq[uint64](sketch.capacity)
  var differences: cint = sketch.decode(sketch.capacity, addr result[0])
  if differences == -1:
    raise newException(ValueError, "The amount of differences is greater than the capacity.")
  while differences != result.len:
    result.del(result.len - 1)
