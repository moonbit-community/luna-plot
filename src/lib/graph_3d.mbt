///|
pub fn make_2layer(
  s1 : Array[(Double, Double, Double)],
  s2 : Array[(Double, Double, Double)],
  view_box : Box,
  view_dis : Double
) -> Array[((Double) -> Double, Array[Box])] {
  let mut res = []
  // convex_pois_filter(
  let s1_ = pois_3to2(s1, view_box, view_dis)
  // )
  // convex_pois_filter(
  let s2_ = pois_3to2(s2, view_box, view_dis)
  // )
  // waiting for visible-judge
  for i in 0..<max_(s1_.length(), s2_.length()) {
    if min_(s1_.length(), s2_.length()) != 0 {
      res.push(
        // make generatrix
        line(s1_[i % max_(s1_.length(), 1)], s2_[i % max_(s2_.length(), 1)]),
      )
    }
  }
  // add 2surfaces
  res = [..res, ..polygon(s1_), ..polygon(s2_)]
  res
}

///|
pub fn make_nlayer(
  surfaces : Array[Array[(Double, Double, Double)]],
  view_box : Box,
  view_dis : Double
) -> Array[((Double) -> Double, Array[Box])] {
  let mut res = []
  let surfaces_ = []
  for s in surfaces {
    // convex_pois_filter(
    let s_ = pois_3to2(s, view_box, view_dis)
    // )
    surfaces_.push(s_)
    res = [..res, ..polygon(s_)]
  }
  // 首尾相接
  surfaces_.push(surfaces_[0])
  for i in 0..<surfaces.length() {
    let s1_ = surfaces_[i]
    let s2_ = surfaces_[i + 1]
    res = [..res, ..generatrix(s1_, s2_)]
  }
  res
}

///|
pub fn make_nline(
  line_set : Array[Array[(Double, Double, Double)]],
  view_box : Box,
  view_dis : Double
) -> Array[((Double) -> Double, Array[Box])] {
  let mut res = []
  for l in line_set {
    let l_ = pois_3to2(l, view_box, view_dis)
    res = [..res, ..lines(l_)]
  }
  // ..polygon(l_),
  res
}

///|
pub fn make_cube_pois(
  cen_poi : (Double, Double, Double),
  size : Double,
  direct : Rotation
) -> (Array[(Double, Double, Double)], Array[(Double, Double, Double)]) {
  let offset = size / 2.0
  let x = cen_poi.0
  let y = cen_poi.1
  let z = cen_poi.2
  let s1 = [
    (x - offset, y - offset, z - offset),
    (x + offset, y - offset, z - offset),
    (x + offset, y - offset, z + offset),
    (x - offset, y - offset, z + offset),
  ]
  let s2 = [
    (x - offset, y + offset, z - offset),
    (x + offset, y + offset, z - offset),
    (x + offset, y + offset, z + offset),
    (x - offset, y + offset, z + offset),
  ]
  let s1_ = pois_rotate(s1, direct)
  let s2_ = pois_rotate(s2, direct)
  (s1_, s2_)
}

///|
pub fn make_ball_pois(
  cen_poi : (Double, Double, Double),
  r : Double,
  segment_num : Int,
  direct : Rotation
) -> Array[Array[(Double, Double, Double)]] {
  let start_poi = (cen_poi.0, cen_poi.1 + r, cen_poi.2)
  let xoy = {
    let temp = []
    for i in 0..<segment_num {
      let rot_z = set_rotation(
        (0.0, 0.0, 1.0),
        3.1415926 * 2.0 * i.to_double() / segment_num.to_double(),
        cen_poi,
      )
      temp.push(p_rotate(start_poi, rot_z))
    }
    temp
  }
  let xoz = {
    let temp = []
    for i in 0..<segment_num {
      let rot_y = set_rotation(
        (0.0, 1.0, 0.0),
        3.1415926 * 2.0 * i.to_double() / segment_num.to_double(),
        cen_poi,
      )
      temp.push(pois_rotate(pois_rotate(xoy, rot_y), direct))
    }
    temp
  }
  xoz
}

///|
pub fn make_grid_plat(
  cell_num : Int,
  cen_poi : (Double, Double, Double),
  interval : Double,
  direct : Rotation
) -> Array[Array[(Double, Double, Double)]] {
  let res = []
  let offset = interval * cell_num.to_double() / 2.0
  let x = cen_poi.0
  let y = cen_poi.1
  let z = cen_poi.2
  // default-surface is xoz
  for i in 0..<cell_num {
    let temp = []
    for j in 0..<cell_num {
      let x_ = x + i.to_double() * interval - offset
      let z_ = z + j.to_double() * interval - offset
      temp.push(p_rotate((x_, y, z_), direct))
    }
    res.push(temp)
  }
  res
}
