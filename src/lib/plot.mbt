///|
pub fn plot(
  f : (Double) -> Double,
  x_range : (Double, Double),
  y_range : (Double, Double),
  wid : Int,
  axis : Bool
) -> Unit {
  let x_min = x_range.0
  let x_max = x_range.1
  let y_min = y_range.0
  let y_max = y_range.1
  let x_step = x_max - x_min
  let y_step = y_max - y_min
  let hei = (wid.to_double() * y_step / x_step / 2.0).to_int()
  let y_zero = hei + (y_min / y_step * hei.to_double() - 0.5).to_int()
  let x_zero = wid - (x_max / x_step * wid.to_double() + 0.5).to_int()
  for i in 0..<hei {
    let mut t = ""
    let labels : Array[(Int, String)] = []
    // let mut axis_fragment = ""
    for j in 0..<wid {
      let x = x_min + (j.to_double() + 0.0) * x_step / wid.to_double()
      let x_ = x_min + (j.to_double() + 1.0) * x_step / wid.to_double()
      let y_ = y_max - (i.to_double() + 0.0) * y_step / hei.to_double()
      let y = y_max - (i.to_double() + 1.0) * y_step / hei.to_double()
      if axis && j == x_zero {
        if i != 0 {
          t += "┃"
        } else {
          t += "⇑"
        }
      } else if axis && i == y_zero {
        if j != wid - 1 {
          t += "—"
        } else {
          t += "→"
        }
      } else if func_cross_box(f, (x, y), (x_, y_)) {
        t += braille_from_pos(func_box_pos(f, (x, y), (x_, y_)))
      } else {
        t += " "
      }
      // set labels
      if func_cross_box(f, (x, y), (x_, y_)) {
        if j == x_zero || j == wid - 1 || i == y_zero || i == 0 {
          let sign = j
          let x = x_min + (j.to_double() + 0.5) * x_step / wid.to_double()
          let label = "(\{x},\{f(x)})"
          labels.push((sign, label))
        }
      }
    }
    for l in labels {
      // labels测试
      // t = back_print(t, wid, l.1, l.0, wid)
    }
    println(t)
  }
}

///|
pub fn draw(
  fs : Array[((Double) -> Double, Array[Box])], // set(fn, f_ranges)
  range : Box,
  // func_range:[(Double, Double)],
  w : Int,
  h : Int,
  labels : Array[(Double, Double, String)]
) -> Unit {
  // let mut count = 0
  let x_min = range.x_min
  let x_max = range.x_max
  let y_min = range.y_min
  let y_max = range.y_max
  let x_step = x_max - x_min
  let y_step = y_max - y_min
  let wid = min(w.to_double(), h.to_double() * 2.0 / y_step * x_step).to_int()
  let hei = min(h.to_double(), w.to_double() / 2.0 / x_step * y_step).to_int()
  let offset_x = (w - wid) / 2
  let offset_y = (h - hei) / 2
  if offset_y > 0 {
    println(mul_str(offset_y - 1, "\n"))
  }
  // let hei = (wid.to_double() * y_step / x_step / 2.0).to_int()
  let y_zero = hei + (y_min / y_step * hei.to_double() - 0.5).to_int()
  let x_zero = wid - (x_max / x_step * wid.to_double() + 0.5).to_int()
  for i in 0..<hei {
    let mut t = mul_str(offset_x, " ")
    for j in 0..<wid {
      let x = x_min + (j.to_double() + 0.0) * x_step / wid.to_double()
      let x_ = x_min + (j.to_double() + 1.0) * x_step / wid.to_double()
      let y_ = y_max - (i.to_double() + 0.0) * y_step / hei.to_double()
      let y = y_max - (i.to_double() + 1.0) * y_step / hei.to_double()
      let mut temp : Array[(Int, Int)] = []
      for item in fs {
        let f = item.0
        let f_ranges = item.1
        let mut is_in_range = true
        for range in f_ranges {
          // Low accuracy now
          if (
              between(x, (range.x_min, range.x_max), 0.0) != true ||
              between(x_, (range.x_min, range.x_max), 0.0) != true
            ) &&
            (
              between(y, (range.y_min, range.y_max), 0.0) != true ||
              between(y_, (range.y_min, range.y_max), 0.0) != true
            ) {
            is_in_range = false
          }
        }
        if func_cross_box(f, (x, y), (x_, y_)) && is_in_range {
          temp = union(temp, func_box_pos(f, (x, y), (x_, y_)))
          // [..temp, ..func_box_pos(f, (x, y), (x_, y_))]
        }
      }
      if temp.length() == 0 {
        t += " "
      } else {
        t += braille_from_pos(temp)
      }
    }
    // same-line labels
    let temp_labels = []
    // sieve the labels
    for l in labels {
      // vertical pos
      let pos_i = ((y_max - l.1) / y_step * hei.to_double()).to_int()
      if i == pos_i {
        // horizontal pos
        let pos_j = ((l.0 - x_min) / x_step * wid.to_double()).to_int()
        temp_labels.push((pos_j, l.2))
      }
    }
    // sort the labels
    for l in temp_labels {
      for i in 0..<temp_labels.length() {
        for j in (i + 1)..<temp_labels.length() {
          if temp_labels[i].0 < temp_labels[j].0 {
            let temp = temp_labels[i]
            temp_labels[i] = temp_labels[j]
            temp_labels[j] = temp
          }
        }
      }
    }
    // insert the labels
    for l in temp_labels {
      let pos_j = l.0
      let label = l.1
      t = back_print(t, wid, label, pos_j + offset_x, wid)
    }
    println(t)
  }
  // hei
}

///|
pub fn draw_(
  fs : Array[((Double) -> Double, Array[Box])], // set(fn, f_ranges)
  range : Box,
  // func_range:[(Double, Double)],
  w : Int,
  h : Int,
  labels : Array[(Double, Double, String)]
) -> (String, Int) {
  let mut res = ""
  let x_min = range.x_min
  let x_max = range.x_max
  let y_min = range.y_min
  let y_max = range.y_max
  let x_step = x_max - x_min
  let y_step = y_max - y_min
  let wid = min(w.to_double(), h.to_double() * 2.0 / y_step * x_step).to_int()
  let hei = min(h.to_double(), w.to_double() / 2.0 / x_step * y_step).to_int()
  let offset_x = (w - wid) / 2
  let offset_y = (h - hei) / 2
  // if offset_y > 1 {
  // println(mul_str(offset_y - 1, "\n"))
  // "\x1b[\{offset_y}B"
  res = if offset_y > 0 { "\x1b[\{offset_y}B" } else { "" }
  // mul_str(offset_y, "\n")
  // }
  // let hei = (wid.to_double() * y_step / x_step / 2.0).to_int()
  let y_zero = hei + (y_min / y_step * hei.to_double() - 0.5).to_int()
  let x_zero = wid - (x_max / x_step * wid.to_double() + 0.5).to_int()
  for i in 0..<hei {
    // "\r\x1b[\{offset_x}C"
    let mut t = if offset_x > 0 { "\r\x1b[\{offset_x}C" } else { "\r" }
    // mul_str(offset_x, " ")
    for j in 0..<wid {
      let x = x_min + (j.to_double() + 0.0) * x_step / wid.to_double()
      let x_ = x_min + (j.to_double() + 1.0) * x_step / wid.to_double()
      let y_ = y_max - (i.to_double() + 0.0) * y_step / hei.to_double()
      let y = y_max - (i.to_double() + 1.0) * y_step / hei.to_double()
      let mut temp : Array[(Int, Int)] = []
      for item in fs {
        let f = item.0
        let f_ranges = item.1
        let mut is_in_range = true
        for range in f_ranges {
          // Low accuracy now
          if (
              between(x, (range.x_min, range.x_max), 0.0) != true ||
              between(x_, (range.x_min, range.x_max), 0.0) != true
            ) &&
            (
              between(y, (range.y_min, range.y_max), 0.0) != true ||
              between(y_, (range.y_min, range.y_max), 0.0) != true
            ) {
            is_in_range = false
          }
        }
        if func_cross_box(f, (x, y), (x_, y_)) && is_in_range {
          temp = union(temp, func_box_pos(f, (x, y), (x_, y_)))
          // [..temp, ..func_box_pos(f, (x, y), (x_, y_))]
        }
      }
      if temp.length() == 0 {
        t += "\x1b[1m" + " " + "\x1b[0m"
      } else {
        t += "\x1b[1;\{i%7+31}m" + braille_from_pos(temp) + "\x1b[0m"
      }
    }
    for l in labels {
      // vertical pos
      let pos_i = ((y_max - l.1) / y_step * hei.to_double()).to_int()
      if i == pos_i {
        // horizontal pos
        let pos_j = ((l.0 - x_min) / x_step * wid.to_double()).to_int()
        // temp_labels.push((pos_j, l.2))
        t = back_print(t, wid, l.2, pos_j + offset_x, wid)
      }
    }
    res = res + t + "\n"
  }
  (res, hei + 1 + offset_y)
}

///|
pub fn cover_draw(view_frame : String, h : Int) -> Unit {
  println(view_frame + "\x1b[\{h}A")
  // println(delay(10))
  // println("\x1b[\{h+1}A")
}
