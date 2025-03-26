///|
pub fn max(a : Double, b : Double) -> Double {
  if a > b {
    a
  } else {
    b
  }
}

///|
pub fn min(a : Double, b : Double) -> Double {
  if a < b {
    a
  } else {
    b
  }
}

///|
pub fn between(
  t : Double,
  range : (Double, Double),
  tolerance : Double
) -> Bool {
  // t < up && t > down
  let mut up = 0.0
  let mut down = 0.0
  if range.0 < range.1 {
    up = range.1
    down = range.0
  } else {
    up = range.0
    down = range.1
  }
  return t < up + tolerance && t > down - tolerance
}

///|
pub fn func_cross_box(
  f : (Double) -> Double,
  p1 : (Double, Double),
  p2 : (Double, Double)
) -> Bool {
  let x_min = min(p1.0, p2.0)
  let x_max = max(p1.0, p2.0)
  let y_min = min(p1.1, p2.1)
  let y_max = max(p1.1, p2.1)
  let dx = x_max - x_min
  let cen1 = x_min + dx / 5.0
  let cen2 = x_min + dx * 2.0 / 5.0
  let cen3 = x_min + dx * 3.0 / 5.0
  let cen4 = x_min + dx * 4.0 / 5.0
  let tolerance = 0.0
  if between(f(cen1), (y_min, y_max), tolerance) ||
    between(f(cen2), (y_min, y_max), tolerance) ||
    between(f(cen3), (y_min, y_max), tolerance) ||
    between(f(cen4), (y_min, y_max), tolerance) ||
    between(f(x_min), (y_min, y_max), tolerance) ||
    between(f(x_max), (y_min, y_max), tolerance) ||
    (y_min - f(x_min)) * (f(x_max) - y_max) > 0 {
    return true
  } else {
    return false
  }
}

///|
pub fn func_box_pos(
  f : (Double) -> Double,
  p1 : (Double, Double),
  p2 : (Double, Double)
) -> Array[(Int, Int)] {
  let res : Array[(Int, Int)] = []
  let x_min = min(p1.0, p2.0)
  let x_max = max(p1.0, p2.0)
  let y_min = min(p1.1, p2.1)
  let y_max = max(p1.1, p2.1)
  let x_step = (x_max - x_min) / 2.0
  let y_step = (y_max - y_min) / 4.0
  for i in 1..<3 {
    let l = x_min + x_step * (i - 1).to_double()
    let r = x_min + x_step * i.to_double()
    for j in 1..<5 {
      let u = y_max - y_step * (j - 1).to_double()
      let d = y_max - y_step * j.to_double()
      if func_cross_box(f, (l, d), (r, u)) {
        res.push((i, j))
      }
    }
  }
  res
}

///| arr1 ∪ arr2
pub fn union(
  arr1 : Array[(Int, Int)],
  arr2 : Array[(Int, Int)]
) -> Array[(Int, Int)] {
  let result = arr1
  for item in arr2 {
    if result.contains(item) != true {
      result.push(item)
    }
  }
  result
}

///| arr1 ∩ arr2
pub fn intersection(
  arr1 : Array[(Int, Int)],
  arr2 : Array[(Int, Int)]
) -> Array[(Int, Int)] {
  let result = []
  for item in arr1 {
    if arr2.contains(item) {
      result.push(item)
    }
  }
  result
}

///| arr1 - arr2
pub fn difference(
  arr1 : Array[(Int, Int)],
  arr2 : Array[(Int, Int)]
) -> Array[(Int, Int)] {
  let result = []
  for item in arr1 {
    if arr2.contains(item) != true {
      result.push(item)
    }
  }
  result
}
