import gleam/bit_array
import gleam/bytes_builder.{type BytesBuilder}
import gleam/dict
import gleam/int.{bitwise_shift_left}
import gleam/list
import gleam/result
import gleam/string
import gbase32/codebook.{type CodeBook}

fn to_symbol(c: Int, codebook: CodeBook) -> Result(String, String) {
  dict.get(codebook.encoder, c)
  |> result.map_error(fn(_) { "Encoding outside range" })
}

fn from_symbol(sym: String, codebook: CodeBook) -> Result(Int, String) {
  sym
  |> dict.get(codebook.decoder, _)
  |> result.map_error(fn(_) { "Encoding outside range" })
}

fn encode_rec(
  codebook: CodeBook,
  input: BitArray,
  acc: Result(BytesBuilder, String),
) -> Result(BytesBuilder, String) {
  case input, acc {
    <<>>, Ok(_) -> acc
    <<c:5, rest:bits>>, Ok(bb) -> {
      use sym <- result.try(to_symbol(c, codebook))
      let newbb = bytes_builder.append_string(bb, sym)
      encode_rec(codebook, rest, Ok(newbb))
    }
    <<c:4, rest:bits>>, Ok(bb) -> {
      use sym <- result.try({
        c
        |> bitwise_shift_left(1)
        |> to_symbol(codebook)
      })
      let newbb = bytes_builder.append_string(bb, sym)
      encode_rec(codebook, rest, Ok(newbb))
    }
    <<c:3, rest:bits>>, Ok(bb) -> {
      use sym <- result.try({
        c
        |> bitwise_shift_left(2)
        |> to_symbol(codebook)
      })
      let newbb = bytes_builder.append_string(bb, sym)
      encode_rec(codebook, rest, Ok(newbb))
    }
    <<c:2, rest:bits>>, Ok(bb) -> {
      use sym <- result.try({
        c
        |> bitwise_shift_left(3)
        |> to_symbol(codebook)
      })
      let newbb = bytes_builder.append_string(bb, sym)
      encode_rec(codebook, rest, Ok(newbb))
    }
    <<c:1, rest:bits>>, Ok(bb) -> {
      use sym <- result.try({
        c
        |> bitwise_shift_left(4)
        |> to_symbol(codebook)
      })
      let newbb = bytes_builder.append_string(bb, sym)
      encode_rec(codebook, rest, Ok(newbb))
    }
    _, err -> err
  }
}

fn decode_rec(
  codebook: CodeBook,
  input: List(String),
  counter: Int,
  acc: Result(BytesBuilder, String),
) -> Result(BytesBuilder, String) {
  let next_ctr = counter + 5
  case input, acc {
    [], Ok(_) -> acc
    [sym], Ok(bb) -> {
      let pad_len = next_ctr % 8
      case pad_len {
        0 -> {
          use c <- result.try(from_symbol(sym, codebook))
          let newbb = bytes_builder.append(bb, <<c:5>>)
          decode_rec(codebook, [], next_ctr, Ok(newbb))
        }
        _ -> {
          let need_bits = 5 - pad_len
          use c <- result.try(from_symbol(sym, codebook))
          let x = int.bitwise_shift_right(c, pad_len)
          let newbb = bytes_builder.append(bb, <<x:size(need_bits)>>)
          decode_rec(codebook, [], next_ctr, Ok(newbb))
        }
      }
    }
    [sym, ..rest], Ok(bb) -> {
      use c <- result.try(from_symbol(sym, codebook))
      let newbb = bytes_builder.append(bb, <<c:5>>)
      decode_rec(codebook, rest, next_ctr, Ok(newbb))
    }
    _, err -> err
  }
}

pub fn encode(codebook: CodeBook, input: String) -> Result(String, String) {
  let encoded =
    input
    |> bit_array.from_string()
    |> encode_rec(codebook, _, Ok(bytes_builder.new()))

  case encoded {
    Ok(a) -> {
      a
      |> bytes_builder.to_bit_array()
      |> bit_array.to_string()
      |> result.map_error(fn(_) { "Failed to encode" })
    }
    Error(b) -> Error(b)
  }
}

pub fn decode(codebook: CodeBook, input: String) -> Result(String, String) {
  let decoded =
    input
    |> string.trim()
    |> string.to_graphemes()
    |> list.filter(fn(x) { x != "=" })
    |> decode_rec(codebook, _, 0, Ok(bytes_builder.new()))

  case decoded {
    Ok(a) -> {
      a
      |> bytes_builder.to_bit_array()
      |> bit_array.to_string()
      |> result.map_error(fn(_) { "Failed to decode" })
    }
    Error(b) -> Error(b)
  }
}
