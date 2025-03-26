///|
pub fn central_print(width : Int, str : String, p : Int, q : Int) -> String {
  let real_len = real_len(str)
  let offset = width * p / q - real_len / 2
  "\r" + mul_str(offset, " ") + str
}

///|
pub fn back_print(
  background : String,
  width : Int,
  str : String,
  p : Int,
  q : Int
) -> String {
  let mut res = ""
  let l = real_len(str)
  let front_str = central_print(
    width,
    {
      let mut res = ""
      for s in str {
        if s != '\n' {
          res = res + "\{s}"
        }
      }
      res
    },
    p,
    q,
  )
  // old-version
  res = background +
    front_str +
    "\r" +
    str_len_slice(
      background,
      0,
      // count_trim(front_str) * 2,
      width * 2 * p / q - l,
      //  130,
    )
  // let offset = width * p / q - l / 2
  // res = background + mul_str(offset, "\b") + str
  res
}

///|
pub fn count_trim(str : String) -> Int {
  let mut res = 0
  for i in str {
    match i {
      '\t' => res = (res / 8 + 1) * 8 // 制表符对齐到下一个8的倍数
      '\b' => res = if res > 0 { res - 1 } else { 0 } // 处理退格，防止负数
      ' ' => res = res + 1 // 普通空格
      _ => break // 遇到非空白字符停止
    }
  }
  res
}

///|
pub fn str_slice(str : String, start : Int, end : Int) -> String {
  let mut res = ""
  for i in start..<end {
    res = res + "\{str[i]}"
  }
  res
}

///|
pub fn str_len_slice(str : String, start : Int, len : Int) -> String {
  let mut res = ""
  let mut i = start
  while real_len(res) < len {
    res = res + "\{str[i]}"
    i = i + 1
  }
  res
}

///|
pub fn real_len(str : String) -> Int {
  let mut real_len = 0
  for i in str {
    let code = i.to_int()
    if 0xFF01 <= code ||
      code <= 0xFF5E ||
      0x4E00 <= code ||
      code <= 0x9FFF ||
      0x3000 <= code ||
      code <= 0x303F {
      real_len = real_len + 2
    } else {
      real_len = real_len + 1
    }
  }
  real_len
}

///|
pub fn mul_str(times : Int, str : String) -> String {
  let mut res = ""
  for i = times; i > 0; i = i - 1 {
    res = res + str
  }
  res
}
