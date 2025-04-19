///|
pub fn line(
  p1 : (Double, Double),
  p2 : (Double, Double)
) -> ((Double) -> Double, Array[Box]) {
  let y1 = p1.1
  let y2 = p2.1
  let mut x1 = p1.0
  let mut x2 = p2.0
  let cen_x = (x1 + x2) / 2
  let d_y = y1 - y2
  let mut k = 0.0
  if x1 == x2 {
    x1 -= 0.0000001 * cen_x
    x2 += 0.0000001 * cen_x
    k = 10000.0 * (d_y * d_y + 100)
  } else {
    k = (y2 - y1) / (x2 - x1)
  }
  let b = y1 - k * x1
  (fn(x : Double) -> Double { k * x + b }, [set_box((x1, x2), (y1, y2))])
}

///|
pub fn lines(
  points : Array[(Double, Double)]
) -> Array[((Double) -> Double, Array[Box])] {
  let res = []
  for i in 0..<points.length() {
    let mut i_ = 0
    if i + 1 == points.length() {
      i_ = i
    } else {
      i_ = i + 1
    }
    res.push(line(points[i], points[i_]))
  }
  res
}

///|
pub fn polygon(
  points : Array[(Double, Double)]
) -> Array[((Double) -> Double, Array[Box])] {
  let poi = points
  if points.length() == 0 {
    return []
  }
  poi.push(points[0])
  lines(poi)
}

///|
pub fn convex_pois_filter(
  points : Array[(Double, Double)]
) -> Array[(Double, Double)] {
  if points.length() == 0 {
    return []
  }
  let start_poi : (Double, Double) = {
    let mut t = points[0]
    for i in 1..<points.length() {
      if points[i].0 < t.0 || points[i].1 < t.1 {
        t = points[i]
      }
    }
    t
  }
  let res = [start_poi]
  let mut now_poi = start_poi
  let mut now_vec = (0.0, -1.0)
  let angle_proj = fn(v1 : (Double, Double), v2 : (Double, Double)) -> Double {
    (v1.0 * v2.0 + v1.1 * v2.1) /
    @math.sqrt(v1.0 * v1.0 + v1.1 * v1.1) /
    @math.sqrt(v2.0 * v2.0 + v2.1 * v2.1)
  }
  let choose_min_angle = fn(
    now_p : (Double, Double),
    now_v : (Double, Double),
    points : Array[(Double, Double)]
  ) -> (Double, Double) {
    let mut res = points[0]
    let angles = []
    for p in points {
      if p != now_p {
        let p2p = (p.0 - now_p.0, p.1 - now_p.1)
        let angle = angle_proj(now_v, p2p)
        if angles.length() == 0 {
          angles.push(angle)
          res = p
        } else if angle > angles[angles.length() - 1] {
          angles.push(angle)
          res = p
        }
      }
    }
    now_vec = (res.0 - now_p.0, res.1 - now_p.1)
    res
  }
  while res.length() > 1 && res[0] != res[res.length() - 1] {
    res.push(choose_min_angle(now_poi, now_vec, points))
    now_poi = res[res.length() - 1]
  }
  res
}

///| upwards
pub fn oval_arc(
  cen : (Double, Double),
  r : Double,
  k : Double,
  range : Array[Box]
) -> ((Double) -> Double, Array[Box]) {
  let f_arc = fn(x : Double) -> Double {
    let y = cen.1 + k * @math.sqrt(r * r - (x - cen.0) * (x - cen.0))
    // let y = 1.0
    y
  }
  (f_arc, range)
}

///|
pub fn make_oval(
  cen : (Double, Double),
  a : Double,
  b : Double,
  range : Array[Box]
) -> Array[((Double) -> Double, Array[Box])] {
  let f_arc = fn(x : Double) -> Double {
    let y = cen.1 +
      @math.sqrt(b * b * (1.0 - (x - cen.0) * (x - cen.0) / (a * a)))
    // let y = 1.0
    y
  }
  let _f_arc = fn(x : Double) -> Double {
    let y = cen.1 -
      @math.sqrt(b * b * (1.0 - (x - cen.0) * (x - cen.0) / (a * a)))
    // let y = 1.0
    y
  }
  [(f_arc, range), (_f_arc, range)]
}
