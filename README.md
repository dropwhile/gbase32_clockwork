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
import gbase32_clockwork
import gbase32_clockwork/options.{Lowercase}

pub fn main() {
  let codebook = gbase32_clockwork.new([])

  codebook.encode("foobar")
  |> should.equal(Ok("CSQPYRK1E8"))

  // to emit as lowercase
  let codebook_lc = gbase32_clockwork.new([Lowercase])
  
  codebook.encode("foobar")
  |> should.equal(Ok("csqpyrk1e8"))
}
```

Further documentation can be found at <https://hexdocs.pm/gbase32_clockwork>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
