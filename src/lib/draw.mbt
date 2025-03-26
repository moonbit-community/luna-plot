///|
pub fn braille_from_pos(pos : Array[(Int, Int)]) -> String {
  let places = pos
    .map(fn {
      (1, 4) => 7
      (2, 4) => 8
      (1, n) => n
      (2, n) => n + 3
      _ => abort("invalid position")
    })
    .map(fn { n => 1 << (n - 1) })
  "\{Char::from_int(0x2800 + places.fold(init=0, Int::op_add))}"
}

///|
test {
  inspect!(braille_from_pos([(1, 1)]), content="⠁")
  inspect!(braille_from_pos([(1, 1), (1, 2)]), content="⠃")
  inspect!(braille_from_pos([(1, 1), (1, 2), (1, 3)]), content="⠇")
  inspect!(braille_from_pos([(1, 1), (1, 2), (1, 3), (1, 4)]), content="⡇")
  inspect!(braille_from_pos([(2, 1)]), content="⠈")
  inspect!(
    braille_from_pos([(1, 1), (1, 2), (1, 3), (1, 4), (2, 1)]),
    content="⡏",
  )
  inspect!(
    braille_from_pos([(1, 1), (1, 3), (1, 4), (2, 1), (2, 2)]),
    content="⡝",
  )
  inspect!(
    braille_from_pos([(1, 1), (1, 2), (1, 3), (1, 4), (2, 1), (2, 2)]),
    content="⡟",
  )
}
