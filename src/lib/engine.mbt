///|
struct Line {
  p1 : (Double, Double)
  p2 : (Double, Double)
  color : (Int, Int, Int)
  draw : ((Double) -> Double, Array[(Box, Bool)], Int)
}
