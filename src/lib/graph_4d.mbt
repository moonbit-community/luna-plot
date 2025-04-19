///|
pub fn make_2layer_4d(
  s1 : Array[(Double, Double, Double, Double)],
  s1_ : Array[(Double, Double, Double, Double)],
  s2 : Array[(Double, Double, Double, Double)],
  s2_ : Array[(Double, Double, Double, Double)],
  l_w : Double,
  view_box : Box,
  view_dis : Double
) -> Array[((Double) -> Double, Array[Box])] {
  let mut res = []
  // ..s1, ..s1_, ..s2, ..s2_
  let cen_poi = count_cenpoi([..s1, ..s1_, ..s2, ..s2_])
  let _2d_s1 = pois_3to2(pois_4to3(s1, cen_poi, l_w), view_box, view_dis)
  let _2d_s1_ = pois_3to2(pois_4to3(s1_, cen_poi, l_w), view_box, view_dis)
  let _2d_s2 = pois_3to2(pois_4to3(s2, cen_poi, l_w), view_box, view_dis)
  let _2d_s2_ = pois_3to2(pois_4to3(s2_, cen_poi, l_w), view_box, view_dis)
  // waiting for visible-judge
  let generatrix_make = fn(
    u1 : Array[(Double, Double)],
    u2 : Array[(Double, Double)]
  ) -> Unit {
    for i in 0..<max_(u1.length(), u2.length()) {
      if min_(u1.length(), u2.length()) != 0 {
        res.push(
          // make generatrix
          line(u1[i % max_(u1.length(), 1)], u2[i % max_(u2.length(), 1)]),
        )
      }
    }
  }
  generatrix_make(_2d_s1, _2d_s1_)
  generatrix_make(_2d_s2, _2d_s2_)
  generatrix_make(_2d_s1, _2d_s2)
  generatrix_make(_2d_s1_, _2d_s2_)
  // add 2surfaces
  res = [
      ..res,
      ..polygon(_2d_s1),
      ..polygon(_2d_s2),
      ..polygon(_2d_s1_),
      ..polygon(_2d_s2_),
    ]
  res
}

///|
pub fn make_cube4_pois(
  cen_poi : (Double, Double, Double, Double),
  size : Double
  // direct : Rotation // 待实现
) -> Array[Array[(Double, Double, Double, Double)]] {
  // let mut res = []
  let x = cen_poi.0
  let y = cen_poi.1
  let z = cen_poi.2
  let w = cen_poi.3
  let offset = size / 2.0
  let s1 = [
    (x - offset, y + offset, z - offset, w - offset),
    (x - offset, y + offset, z + offset, w - offset),
    (x + offset, y + offset, z + offset, w - offset),
    (x + offset, y + offset, z - offset, w - offset),
  ]
  let s1_ = [
    (x - offset, y + offset, z - offset, w + offset),
    (x - offset, y + offset, z + offset, w + offset),
    (x + offset, y + offset, z + offset, w + offset),
    (x + offset, y + offset, z - offset, w + offset),
  ]
  let s2 = [
    (x - offset, y - offset, z - offset, w - offset),
    (x - offset, y - offset, z + offset, w - offset),
    (x + offset, y - offset, z + offset, w - offset),
    (x + offset, y - offset, z - offset, w - offset),
  ]
  let s2_ = [
    (x - offset, y - offset, z - offset, w + offset),
    (x - offset, y - offset, z + offset, w + offset),
    (x + offset, y - offset, z + offset, w + offset),
    (x + offset, y - offset, z - offset, w + offset),
  ]
  // for i in 0..<2 {
  //   let x_offset = (i * 2 - 1).to_double() * offset
  //   for j in 0..<2 {
  //     let z_offset = -(j * 2 - 1).to_double() * offset * x_offset
  //     s1.push((x + x_offset, y + offset, z + z_offset, w - offset))
  //     s1_.push((x + x_offset, y + offset, z + z_offset, w + offset))
  //     s2.push((x + x_offset, y - offset, z + z_offset, w - offset))
  //     s2_.push((x + x_offset, y - offset, z + z_offset, w + offset))
  //   }
  // }
  // waiting for direct
  [s1, s1_, s2, s2_]
}

///|
pub fn make_cube4(
  cen_poi : (Double, Double, Double, Double),
  size : Double,
  l_w : Double,
  view_box : Box,
  view_dis : Double
  // direct : Rotation
) -> Array[((Double) -> Double, Array[Box])] {
  let surfaces = make_cube4_pois(cen_poi, size)
  make_2layer_4d(
    surfaces[0],
    surfaces[1],
    surfaces[2],
    surfaces[3],
    l_w,
    view_box,
    view_dis,
  )
}

///|
pub fn count_cenpoi(
  pois : Array[(Double, Double, Double, Double)]
) -> (Double, Double, Double) {
  let mut x_max = pois[0].0
  let mut y_max = pois[0].1
  let mut z_max = pois[0].2
  let mut x_min = pois[0].0
  let mut y_min = pois[0].1
  let mut z_min = pois[0].2
  for i in 0..<pois.length() {
    if pois[i].0 > x_max {
      x_max = pois[i].0
    }
    if pois[i].1 > y_max {
      y_max = pois[i].1
    }
    if pois[i].2 > z_max {
      z_max = pois[i].2
    }
    if pois[i].0 < x_min {
      x_min = pois[i].0
    }
    if pois[i].1 < y_min {
      y_min = pois[i].1
    }
    if pois[i].2 < z_min {
      z_min = pois[i].2
    }
  }
  ((x_max + x_min) / 2.0, (y_max + y_min) / 2.0, (z_max + z_min) / 2.0)
}
