# gbase32_clockwork

## About

I wanted to try implementing base32_clockwork in Gleam.  
Inspired by [shiguredo/base32_clockwork][1] and [this gist][2].

[1]: https://github.com/shiguredo/base32_clockwork
[2]: https://gist.github.com/szktty/228f85794e4187882a77734c89c384a8

## Usage

[![Package Version](https://img.shields.io/hexpm/v/gbase32_clockwork)](https://hex.pm/packages/gbase32_clockwork)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gbase32_clockwork/)

```sh
gleam add gbase32_clockwork
```
```gleam
import gbase32_clockwork/gbase32
import gleam/result
import gleam/string
import gleeunit/should

pub fn main() {
  // create a reusable encoder
  let encode = gbase32.new_encoder()
  
  // by default, lowercase is emitted
  encode("foobar")
  |> should.equal(Ok("csqpyrk1e8"))

  // to emit as uppercase, simply uppercase the output string
  encode("foobar")
  |> result.map(string.uppercase)
  |> should.equal(Ok("CSQPYRK1E8"))

  // create a reusable encoder
  let decode = gbase32.new_encoder()

  // a decoder will decode both upper and lowercase
  decode("CSQPYRG")
  |> should.equal(Ok("foob"))
}
```

Further documentation can be found at <https://hexdocs.pm/gbase32_clockwork>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
