import gleam/string
import gleam/iterator.{Next}
import gleam/dict
import gleam/list
import gbase32/codebook.{
  type CodeBook, type DecodeBook, type EncodeBook, type Options, CodeBook,
  Lowercase,
}

pub const clockwork = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"

pub fn new(options options: List(Options)) -> CodeBook {
  let clockwork_case = case list.contains(options, Lowercase) {
    True ->
      clockwork
      |> string.lowercase
    False -> clockwork
  }

  let encoder: EncodeBook =
    clockwork_case
    |> string.to_graphemes()
    |> iterator.from_list()
    |> iterator.transform(0, fn(i, el) { Next(#(i, el), i + 1) })
    |> iterator.to_list()
    |> dict.from_list()

  let decoder_lower: DecodeBook =
    clockwork_case
    |> string.lowercase()
    |> string.to_graphemes()
    |> iterator.from_list()
    |> iterator.index()
    |> iterator.to_list()
    |> dict.from_list()

  let decoder_upper: DecodeBook =
    clockwork
    |> string.uppercase()
    |> string.to_graphemes()
    |> iterator.from_list()
    |> iterator.index()
    |> iterator.to_list()
    |> dict.from_list()

  // add aliases
  let decoder_updates =
    dict.from_list([
      #("O", 0),
      #("o", 0),
      #("I", 1),
      #("i", 1),
      #("L", 1),
      #("l", 1),
    ])

  let decoder =
    decoder_lower
    |> dict.merge(decoder_upper)
    |> dict.merge(decoder_updates)

  CodeBook(encoder: encoder, decoder: decoder, options: options)
}
