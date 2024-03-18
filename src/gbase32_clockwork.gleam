import gleam/string
import gleam/iterator.{Next}
import gleam/list
import gleam/dict
import gbase32_clockwork/encoder.{decode, encode}
import gbase32_clockwork/options.{type Options, Lowercase}
import gbase32_clockwork/codebook.{
  type CodeBook, type DecodeBook, type DecodeFn, type EncodeBook, type EncodeFn,
  CodeBook,
}

const clockwork_codebook = "0123456789abcdefghjkmnpqrstvwxyz"

pub fn new(options options: List(Options)) -> CodeBook {
  let clockwork_case = case list.contains(options, Lowercase) {
    True ->
      clockwork_codebook
      |> string.lowercase
    False ->
      clockwork_codebook
      |> string.uppercase
  }

  let encodebook: EncodeBook =
    clockwork_case
    |> string.to_graphemes()
    |> iterator.from_list()
    |> iterator.transform(0, fn(i, el) { Next(#(i, el), i + 1) })
    |> iterator.to_list()
    |> dict.from_list()

  let decodebook_lower: DecodeBook =
    clockwork_case
    |> string.lowercase()
    |> string.to_graphemes()
    |> iterator.from_list()
    |> iterator.index()
    |> iterator.to_list()
    |> dict.from_list()

  let decodebook_upper: DecodeBook =
    clockwork_codebook
    |> string.uppercase()
    |> string.to_graphemes()
    |> iterator.from_list()
    |> iterator.index()
    |> iterator.to_list()
    |> dict.from_list()

  // add aliases
  let decodebook_updates =
    dict.from_list([
      #("O", 0),
      #("o", 0),
      #("I", 1),
      #("i", 1),
      #("L", 1),
      #("l", 1),
    ])

  let decodebook =
    decodebook_lower
    |> dict.merge(decodebook_upper)
    |> dict.merge(decodebook_updates)

  let encode_fn: EncodeFn = encode(encodebook, _)
  let decode_fn: DecodeFn = decode(decodebook, _)

  CodeBook(encode: encode_fn, decode: decode_fn, options: options)
}
