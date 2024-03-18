import gleam/dict.{type Dict}

pub type EncodeBook =
  Dict(Int, String)

pub type DecodeBook =
  Dict(String, Int)

pub type Options {
  WithPadding
  Lowercase
}

pub type CodeBook {
  CodeBook(encoder: EncodeBook, decoder: DecodeBook, options: List(Options))
}
