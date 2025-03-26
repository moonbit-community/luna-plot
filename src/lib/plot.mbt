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
  fs : Array[(Double) -> Double],
  x_range : (Double, Double),
  y_range : (Double, Double),
  wid : Int,
  labels : Array[(Double, Double, String)]
) -> Unit {
  let x_min = min(x_range.0, x_range.1)
  let x_max = max(x_range.0, x_range.1)
  let y_min = min(y_range.0, y_range.1)
  let y_max = max(y_range.0, y_range.1)
  let x_step = x_max - x_min
  let y_step = y_max - y_min
  let hei = (wid.to_double() * y_step / x_step / 2.0).to_int()
  let y_zero = hei + (y_min / y_step * hei.to_double() - 0.5).to_int()
  let x_zero = wid - (x_max / x_step * wid.to_double() + 0.5).to_int()
  for i in 0..<hei {
    let mut t = ""
    for j in 0..<wid {
      let x = x_min + (j.to_double() + 0.0) * x_step / wid.to_double()
      let x_ = x_min + (j.to_double() + 1.0) * x_step / wid.to_double()
      let y_ = y_max - (i.to_double() + 0.0) * y_step / hei.to_double()
      let y = y_max - (i.to_double() + 1.0) * y_step / hei.to_double()
      let mut temp : Array[(Int, Int)] = []
      for f in fs {
        if func_cross_box(f, (x, y), (x_, y_)) {
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
    for l in labels {
      // horizontal pos
      let pos_j = ((l.0 - x_min) / x_step * wid.to_double()).to_int()
      // vertical pos
      let pos_i = ((y_max - l.1) / y_step * hei.to_double()).to_int()
      if i == pos_i {
        t = back_print(t, wid, l.2, pos_j, wid)
      }
    }
    println(t)
  }
}
