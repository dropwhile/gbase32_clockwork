import gleeunit
import gleeunit/should
import gbase32_clockwork/options.{Lowercase}
import gbase32_clockwork

pub fn main() {
  gleeunit.main()
}

pub fn encode_uppercase_test() {
  let codebook = gbase32_clockwork.new([])

  codebook.encode("")
  |> should.equal(Ok(""))

  codebook.encode("f")
  |> should.equal(Ok("CR"))

  codebook.encode("fo")
  |> should.equal(Ok("CSQG"))

  codebook.encode("foo")
  |> should.equal(Ok("CSQPY"))

  codebook.encode("foob")
  |> should.equal(Ok("CSQPYRG"))

  codebook.encode("fooba")
  |> should.equal(Ok("CSQPYRK1"))

  codebook.encode("foobar")
  |> should.equal(Ok("CSQPYRK1E8"))

  codebook.encode("Wow, it works!")
  |> should.equal(Ok("AXQQEB10D5T20XVFE9NQ688"))
}

pub fn encode_lowercase_test() {
  let codebook = gbase32_clockwork.new([Lowercase])

  codebook.encode("")
  |> should.equal(Ok(""))

  codebook.encode("f")
  |> should.equal(Ok("cr"))

  codebook.encode("fo")
  |> should.equal(Ok("csqg"))

  codebook.encode("foo")
  |> should.equal(Ok("csqpy"))

  codebook.encode("foob")
  |> should.equal(Ok("csqpyrg"))

  codebook.encode("fooba")
  |> should.equal(Ok("csqpyrk1"))

  codebook.encode("foobar")
  |> should.equal(Ok("csqpyrk1e8"))

  codebook.encode("Wow, it works!")
  |> should.equal(Ok("axqqeb10d5t20xvfe9nq688"))
}

pub fn decode_test() {
  let codebook = gbase32_clockwork.new([])

  codebook.decode("")
  |> should.equal(Ok(""))

  codebook.decode("CR")
  |> should.equal(Ok("f"))

  codebook.decode("CSQG")
  |> should.equal(Ok("fo"))

  codebook.decode("CSQPY")
  |> should.equal(Ok("foo"))

  codebook.decode("CSQPYRG")
  |> should.equal(Ok("foob"))

  codebook.decode("CSQPYRK1")
  |> should.equal(Ok("fooba"))

  codebook.decode("CSQPYRK1E8")
  |> should.equal(Ok("foobar"))

  codebook.decode(" CSQPYRK1E8  ")
  |> should.equal(Ok("foobar"))

  codebook.decode("CSQPYRK1E8====")
  |> should.equal(Ok("foobar"))

  codebook.decode(" CSQPYRK1E8==== ")
  |> should.equal(Ok("foobar"))

  codebook.decode("AXQQEB10D5T20XVFE9NQ688")
  |> should.equal(Ok("Wow, it works!"))

  codebook.decode("cSqPy")
  |> should.equal(Ok("foo"))

  codebook.decode("CSQPYRKi")
  |> should.equal(Ok("fooba"))

  codebook.decode("csqpyrk1e8")
  |> should.equal(Ok("foobar"))

  codebook.decode("C-SQPY")
  |> should.equal(Error("Encoding outside range"))
}
