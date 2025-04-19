///|
pub fn max(a : Double, b : Double) -> Double {
  if a > b {
    a
  } else {
    b
  }
}

///|
pub fn max_(a : Int, b : Int) -> Int {
  if a > b {
    a
  } else {
    b
  }
}

///|
pub fn max_arr(arr : Array[Double]) -> Double {
  let mut res = 0.0
  for item in arr {
    if item > res {
      res = item
    }
  }
  res
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
pub fn min_(a : Int, b : Int) -> Int {
  if a < b {
    a
  } else {
    b
  }
}

///|
pub fn min_arr(arr : Array[Double]) -> Double {
  let mut res = 0.0
  for item in arr {
    if item < res {
      res = item
    }
  }
  res
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

///| Principles of perspective
pub fn poi_3to2(
  poi : (Double, Double, Double),
  view_box : Box,
  view_dis : Double
) -> (Double, Double) {
  let cen_x = view_box.x_min + (view_box.x_max - view_box.x_min) / 2.0
  let cen_y = view_box.y_min + (view_box.y_max - view_box.y_min) / 2.0
  let cen = (cen_x, cen_y)
  let scale = view_dis / (view_dis + poi.2)
  poi_add(scale, (poi.0, poi.1), 1.0 - scale, cen)
}

///|
pub fn pois_3to2(
  pois : Array[(Double, Double, Double)],
  view_box : Box,
  view_dis : Double
) -> Array[(Double, Double)] {
  let res = []
  for poi in pois {
    res.push(poi_3to2(poi, view_box, view_dis))
  }
  res
}

///|
pub fn poi_4to3(
  poi : (Double, Double, Double, Double),
  cen_poi : (Double, Double, Double),
  l_w : Double
) -> (Double, Double, Double) {
  // let coe = 1.0/@math.sqrt(3.0)
  let x = poi.0
  let y = poi.1
  let z = poi.2
  let w = poi.3
  let coe = 1.0 / @math.sqrt(3.0) / 2.0
  let proj_scale = l_w / (l_w + w)
  // let set_p = (x + w * coe, y + w * coe, z + w * coe)
  let set_p = (x, y, z)
  poi_add_3(proj_scale, set_p, 1.0 - proj_scale, cen_poi)
}

///|
pub fn pois_4to3(
  pois : Array[(Double, Double, Double, Double)],
  cen_poi : (Double, Double, Double),
  l_w : Double
) -> Array[(Double, Double, Double)] {
  let res = []
  for poi in pois {
    res.push(poi_4to3(poi, cen_poi, l_w))
  }
  res
}

///| poi and vector
pub fn poi_add(
  k1 : Double,
  p1 : (Double, Double),
  k2 : Double,
  p2 : (Double, Double)
) -> (Double, Double) {
  let x = p1.0 * k1 + p2.0 * k2
  let y = p1.1 * k1 + p2.1 * k2
  (x, y)
}

///|
pub fn poi_add_3(
  k1 : Double,
  p1 : (Double, Double, Double),
  k2 : Double,
  p2 : (Double, Double, Double)
) -> (Double, Double, Double) {
  let x = p1.0 * k1 + p2.0 * k2
  let y = p1.1 * k1 + p2.1 * k2
  let z = p1.2 * k1 + p2.2 * k2
  (x, y, z)
}

// v proj to v1-direction
///|
pub fn vec_proj_3(
  v : (Double, Double, Double),
  v1 : (Double, Double, Double)
) -> (Double, Double, Double) {
  // v·v1
  let mul = v.0 * v1.0 + v.1 * v1.1 + v.2 * v1.2
  // v·v1/v1^2
  let scale = mul / (v1.0 * v1.0 + v1.1 * v1.1 + v1.2 * v1.2)
  (v1.0 * scale, v1.1 * scale, v1.2 * scale)
}

///|
pub fn move_x(
  pois : Array[(Double, Double, Double)],
  x : Double
) -> Array[(Double, Double, Double)] {
  let res = []
  for poi in pois {
    res.push((poi.0 + x, poi.1, poi.2))
  }
  res
}

///|
pub fn move_y(
  pois : Array[(Double, Double, Double)],
  y : Double
) -> Array[(Double, Double, Double)] {
  let res = []
  for poi in pois {
    res.push((poi.0, poi.1 + y, poi.2))
  }
  res
}

///|
pub fn move_z(
  pois : Array[(Double, Double, Double)],
  z : Double
) -> Array[(Double, Double, Double)] {
  let res = []
  for poi in pois {
    res.push((poi.0, poi.1, poi.2 + z))
  }
  res
}

///|
pub fn move_(
  pois : Array[(Double, Double, Double)],
  x : Double,
  y : Double,
  z : Double
) -> Array[(Double, Double, Double)] {
  let res = []
  for poi in pois {
    res.push((poi.0 + x, poi.1 + y, poi.2 + z))
  }
  res
}

///|
pub fn poi3_dis(
  p1 : (Double, Double, Double),
  p2 : (Double, Double, Double)
) -> Double {
  let dx = p1.0 - p2.0
  let dy = p1.1 - p2.1
  let dz = p1.2 - p2.2
  @math.sqrt(dx * dx + dy * dy + dz * dz)
}

///|
pub fn poi2_dis(p1 : (Double, Double), p2 : (Double, Double)) -> Double {
  let dx = p1.0 - p2.0
  let dy = p1.1 - p2.1
  @math.sqrt(dx * dx + dy * dy)
}

///|
pub fn v2_len(p : (Double, Double)) -> Double {
  @math.sqrt(p.0 * p.0 + p.1 * p.1)
}

///|
pub fn v3_len(p : (Double, Double, Double)) -> Double {
  @math.sqrt(p.0 * p.0 + p.1 * p.1 + p.2 * p.2)
}

///|
pub fn p_mul_3(
  p : (Double, Double, Double),
  p1 : (Double, Double, Double)
) -> Double {
  // (p.0*k,p.1*k,p.2*k)
  p.0 * p1.0 + p.1 * p1.1 + p.2 * p1.2
}

///|
pub fn f_mul_3(
  p : (Double, Double, Double),
  p1 : (Double, Double, Double)
) -> (Double, Double, Double) {
  let x = p.1 * p1.2 - p.2 * p1.1
  let y = p.2 * p1.0 - p.0 * p1.2
  let z = p.0 * p1.1 - p.1 * p1.0
  (x, y, z)
}

///|
pub fn generatrix(
  u1 : Array[(Double, Double)],
  u2 : Array[(Double, Double)]
) -> Array[((Double) -> Double, Array[Box])] {
  let res = []
  for i in 0..<max_(u1.length(), u2.length()) {
    if min_(u1.length(), u2.length()) != 0 {
      res.push(
        // make generatrix
        line(u1[i % max_(u1.length(), 1)], u2[i % max_(u2.length(), 1)]),
      )
    }
  }
  res
}

///| 四元数
struct Quaternion {
  vector : (Double, Double, Double)
  theta : Double
} derive(Show)

///|
pub fn set_quaternion(v : (Double, Double, Double), t : Double) -> Quaternion {
  let vector = v
  let theta = t
  let q = Quaternion::{ vector, theta }
  q
}

///| 旋转体
struct Rotation {
  q : Quaternion
  p_ref : (Double, Double, Double)
} derive(Show)

///|
pub fn set_rotation(
  v : (Double, Double, Double),
  t : Double,
  p_ref : (Double, Double, Double)
) -> Rotation {
  let q = set_quaternion(v, t)
  let r = Rotation::{ q, p_ref }
  r
}

///|
pub fn p2l_len(p : (Double, Double, Double), rotate : Rotation) -> Double {
  // coefficients
  let q = rotate.q
  let p_ref = rotate.p_ref
  let v = q.vector
  let t = q.theta
  let p2p = poi_add_3(-1, p, 1, p_ref)
  v3_len(f_mul_3(p2p, v)) / v3_len(v)
}

///|
pub fn p_rotate(
  p : (Double, Double, Double),
  rotate : Rotation
) -> (Double, Double, Double) {
  // coefficients
  let q = rotate.q
  let p_ref = rotate.p_ref
  // rotate-axis
  let v = q.vector
  let t = q.theta
  // Rodriges
  let p2p = poi_add_3(-1, p_ref, 1, p)
  let v2p = f_mul_3(p2p, v)
  let p_proj = vec_proj_3(p2p, v)
  let to_rotate_face = poi_add_3(@math.cos(t), p2p, 1.0 - @math.cos(t), p_proj)
  let face_to_side = poi_add_3(@math.sin(t) / v3_len(v), v2p, 1, to_rotate_face)
  poi_add_3(1, p_ref, 1, face_to_side)
}

///|
pub fn v_rotate(
  p : (Double, Double, Double),
  rotate : Rotation
) -> (Double, Double, Double) {
  let p_ref = rotate.p_ref
  let p_ = p_rotate(p, rotate)
  poi_add_3(-1, p_ref, 1, p_)
}

///|
pub fn pois_rotate(
  pois : Array[(Double, Double, Double)],
  rotate : Rotation
) -> Array[(Double, Double, Double)] {
  let res = []
  for poi in pois {
    res.push(p_rotate(poi, rotate))
  }
  res
}

///|
struct Box {
  x_min : Double
  y_min : Double
  x_max : Double
  y_max : Double
} derive(Show)

///|
pub fn set_box(x_range : (Double, Double), y_range : (Double, Double)) -> Box {
  let x_min = min(x_range.0, x_range.1)
  let x_max = max(x_range.0, x_range.1)
  let y_min = min(y_range.0, y_range.1)
  let y_max = max(y_range.0, y_range.1)
  let box = Box::{ x_min, y_min, x_max, y_max }
  box
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
