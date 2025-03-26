///|
fn main {
  // terminal-info output
  let wid = @lib.str_to_int(@sys.get_cli_args()[1])
  let str = "欢迎,终端宽度是\{wid}"
  println(
    @lib.central_print(wid, str, 3, 4) + @lib.central_print(wid, str, 1, 4),
  )
  // plot x² with axis
  @lib.plot(f1, (-10.0, 13.1415926), (-3, 10.0), wid, true)
  // multi-func draw:for future view engine
  @lib.draw(
    [f1, f2, fn(x) { x }, fn(x) { @math.exp(x) }, fn(x) { @math.log(x) }],
    (-10.0, 13.1415926), //corner point 1
    (-3, 10.0),//corner point 2
    wid,
    [
      (2.718, 1.0, "lnx"),
      (-2.0, 4.0, "x²"),
      (1, 2.718, "e\{Char::from_int(0x02E3)}"),
      (4.0, 2.0, "√x"),
    ],//labels
    // [],
  )
}

///|
fn f1(n : Double) -> Double {
  return n * n
  // @math.sqrt(n)
  // @math.exp(n)
  // @math.log(n)
}

///|
fn f2(n : Double) -> Double {
  return @math.sqrt(n)
}
///|
