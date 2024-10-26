import gbase32_clockwork/gbase32
import gleam/result
import gleam/string
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn encode_uppercase_test() {
  let encode = gbase32.new_encoder()

  encode("")
  |> should.equal(Ok(""))

  encode("f")
  |> result.map(string.uppercase)
  |> should.equal(Ok("CR"))

  encode("fo")
  |> result.map(string.uppercase)
  |> should.equal(Ok("CSQG"))

  encode("foo")
  |> result.map(string.uppercase)
  |> should.equal(Ok("CSQPY"))

  encode("foob")
  |> result.map(string.uppercase)
  |> should.equal(Ok("CSQPYRG"))

  encode("fooba")
  |> result.map(string.uppercase)
  |> should.equal(Ok("CSQPYRK1"))

  encode("foobar")
  |> result.map(string.uppercase)
  |> should.equal(Ok("CSQPYRK1E8"))

  encode("Wow, it works!")
  |> result.map(string.uppercase)
  |> should.equal(Ok("AXQQEB10D5T20XVFE9NQ688"))
}

pub fn encode_lowercase_test() {
  let encode = gbase32.new_encoder()

  encode("")
  |> should.equal(Ok(""))

  encode("f")
  |> should.equal(Ok("cr"))

  encode("fo")
  |> should.equal(Ok("csqg"))

  encode("foo")
  |> should.equal(Ok("csqpy"))

  encode("foob")
  |> should.equal(Ok("csqpyrg"))

  encode("fooba")
  |> should.equal(Ok("csqpyrk1"))

  encode("foobar")
  |> should.equal(Ok("csqpyrk1e8"))

  encode("Wow, it works!")
  |> should.equal(Ok("axqqeb10d5t20xvfe9nq688"))
}

pub fn decode_test() {
  let decode = gbase32.new_decoder()

  decode("")
  |> should.equal(Ok(""))

  decode("CR")
  |> should.equal(Ok("f"))

  decode("CSQG")
  |> should.equal(Ok("fo"))

  decode("CSQPY")
  |> should.equal(Ok("foo"))

  decode("CSQPYRG")
  |> should.equal(Ok("foob"))

  decode("CSQPYRK1")
  |> should.equal(Ok("fooba"))

  decode("CSQPYRK1E8")
  |> should.equal(Ok("foobar"))

  decode(" CSQPYRK1E8  ")
  |> should.equal(Ok("foobar"))

  decode("CSQPYRK1E8====")
  |> should.equal(Ok("foobar"))

  decode(" CSQPYRK1E8==== ")
  |> should.equal(Ok("foobar"))

  decode("AXQQEB10D5T20XVFE9NQ688")
  |> should.equal(Ok("Wow, it works!"))

  decode("cSqPy")
  |> should.equal(Ok("foo"))

  decode("CSQPYRKi")
  |> should.equal(Ok("fooba"))

  decode("csqpyrk1e8")
  |> should.equal(Ok("foobar"))

  decode("C-SQPY")
  |> should.equal(Error("Encoding outside range"))
}
