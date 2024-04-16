import gbase32_clockwork/options.{type Options}
import gleam/dict.{type Dict}

pub type EncodeBook =
  Dict(Int, String)

pub type DecodeBook =
  Dict(String, Int)

pub type EncodeFn =
  fn(String) -> Result(String, String)

pub type DecodeFn =
  fn(String) -> Result(String, String)

pub type CodeBook {
  CodeBook(encode: EncodeFn, decode: DecodeFn, options: List(Options))
}
