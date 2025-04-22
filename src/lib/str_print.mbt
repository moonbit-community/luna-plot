///|
pub fn central_print(width : Int, str : String, p : Int, q : Int) -> String {
  let _str = {
    let mut res = ""
    for s in str {
      if s != '\n' {
        res = res + "\{s}"
      }
      if s == '\r' {
        res = ""
      }
    }
    res
  }
  let real_len = real_len(_str)
  let offset = width * p / q - real_len / 2
  "\r\x1b[\{offset}C" + _str
}

///|
pub fn back_print(
  background : String,
  width : Int,
  str : String,
  p : Int,
  q : Int
) -> String {
  let _str = {
    let mut res = ""
    for s in str {
      if s != '\n' {
        res = res + "\{s}"
      }
      if s == '\r' {
        res = ""
      }
    }
    res
  }
  let l = real_len(_str)
  let offset = width / q * p - l / 2
  background + "\r\x1b[\{offset}C" + _str
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
// pub fn real_len(str : String) -> Int {
pub fn real_len(str : String) -> Int {
  let mut real_len = 0
  for i in str {
    let code = i.to_int()
    if (0xFF01 <= code && code <= 0xFF5E) || // 全角ASCII字符
      (0x4E00 <= code && code <= 0x9FFF) || // CJK统一汉字
      (0x3000 <= code && code <= 0x303F) { // CJK符号和标点
      real_len = real_len + 2
    } else {
      real_len = real_len + 1
    }
  }
  real_len
}
//   real_len
// }

///|
pub fn mul_str(times : Int, str : String) -> String {
  let mut res = ""
  for i = times; i > 0; i = i - 1 {
    res = res + str
  }
  res
}
