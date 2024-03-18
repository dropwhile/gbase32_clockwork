import gleeunit
import gleeunit/should
import gbase32.{decode, encode}
import gbase32/clockwork

pub fn main() {
  gleeunit.main()
}

pub fn encode_test() {
  let codebook = clockwork.new([])

  encode(codebook, "")
  |> should.equal(Ok(""))

  encode(codebook, "f")
  |> should.equal(Ok("CR"))

  encode(codebook, "fo")
  |> should.equal(Ok("CSQG"))

  encode(codebook, "foo")
  |> should.equal(Ok("CSQPY"))

  encode(codebook, "foob")
  |> should.equal(Ok("CSQPYRG"))

  encode(codebook, "fooba")
  |> should.equal(Ok("CSQPYRK1"))

  encode(codebook, "foobar")
  |> should.equal(Ok("CSQPYRK1E8"))

  encode(codebook, "Wow, it works!")
  |> should.equal(Ok("AXQQEB10D5T20XVFE9NQ688"))
}

pub fn decode_test() {
  let codebook = clockwork.new([])

  decode(codebook, "")
  |> should.equal(Ok(""))

  decode(codebook, "CR")
  |> should.equal(Ok("f"))

  decode(codebook, "CSQG")
  |> should.equal(Ok("fo"))

  decode(codebook, "CSQPY")
  |> should.equal(Ok("foo"))

  decode(codebook, "CSQPYRG")
  |> should.equal(Ok("foob"))

  decode(codebook, "CSQPYRK1")
  |> should.equal(Ok("fooba"))

  decode(codebook, "CSQPYRK1E8")
  |> should.equal(Ok("foobar"))

  decode(codebook, " CSQPYRK1E8  ")
  |> should.equal(Ok("foobar"))

  decode(codebook, "CSQPYRK1E8====")
  |> should.equal(Ok("foobar"))

  decode(codebook, " CSQPYRK1E8==== ")
  |> should.equal(Ok("foobar"))

  decode(codebook, "AXQQEB10D5T20XVFE9NQ688")
  |> should.equal(Ok("Wow, it works!"))

  decode(codebook, "cSqPy")
  |> should.equal(Ok("foo"))

  decode(codebook, "C-SQPY")
  |> should.equal(Error("Encoding outside range"))
}
