///|
fn main {
  // terminal-info output
  let wid = @lib.str_to_int(@sys.get_cli_args()[1])
  let hei = @lib.str_to_int(@sys.get_cli_args()[2])
  // let s_hat = Char::from_int(0x0305)
  // Unicode Welcome
  let s1 = Char::from_int(0x0304)
  let s = Char::from_int(0x0323)
  let s2 = Char::from_int(0x030A)
  let pattern = "҈"
  let str = "Ω\{s1}\{s2}\{s}" + "欢迎,终端宽度是\{wid}\{pattern}"
  println(
    @lib.central_print(wid, str, 3, 4) + @lib.central_print(wid, str, 1, 4),
  )
  // Terminal-rain_effects output
  println(@lib.rain_effects(1))
  // Basic-func plot
  // plot x² with axis
  @lib.plot(fn(x) { x * x }, (-10.0, 13.1415926), (-3, 10.0), wid, true)
  // // multi-func draw:for future view engine
  let (func_view, func_h) = @lib.draw_(
    [
      (fn(x) { x * x }, []),
      (f2, []),
      (
        fn(x) { x },
        [
          @lib.set_box((0.0, 1.0), (0.0, 1.0)),
          @lib.set_box((2.0, 4.0), (2.0, 4.0)),
        ],
      ),
      (fn(x) { @math.exp(x) }, []),
      (fn(x) { @math.log(x) }, []),
      @lib.line((2.718, 1.0), (0, 2.718)),
    ],
    @lib.set_box((-4.0, 6.0), (-2.0, 6.0)),
    wid,
    hei,
    [
      (0.0, 2.718, "一条斜杠"),
      (2.718, 1.0, "lnx"),
      (-2.0, 4.0, "x²"),
      (1, 2.718, "e\{Char::from_int(0x02E3)}"),
      (2.0, 2.718, "一张func图"),
      (4.0, 2.0, "√x"),
    ], //labels
  )
  @lib.cover_draw(
    func_view,
    // 0,
    func_h / 3,
  )

  // 3D draw
  let view_dis = 5.0
  // let eye_dis = view_dis / 10.0
  let view_box = @lib.set_box((-5.0, 16.0), (-1.0, 7.0))
  // let mut view_frames = ""
  for j in 0..<100 {
    view(view_box, view_dis, wid * 3 / 2, hei / 4, j)
  }
  // println(@lib.spine_effects(wid, 10))
}

///|
fn f2(n : Double) -> Double {
  return @math.sqrt(n)
}

///|
fn view(
  view_box : @lib.Box,
  view_dis : Double,
  wid : Int,
  hei : Int,
  // eye_dis : Double,
  frame_num : Int
) -> Unit {
  // for j in 0..<frame_num {
  let j = frame_num
  let j_vec = (0.0, 1.0, 0.0)
  let j_theta = j.to_double() / 20.0 * 3.1415926
  // 方块序列
  let mut cube_array = []
  // println("\x1b[2J\x1b[H")
  let cube_count = 5
  for i in 0..<cube_count {
    let cube_cen = (
      i.to_double() * 5.0 + 5.0,
      i.to_double() - 2.0,
      10.0 + i.to_double() * 2.0,
    )
    let direction = @lib.set_rotation(
      (1.0, 1.0, 1.0),
      3.1415926 * i.to_double() / 5.0,
      // 0.0,
      cube_cen,
    )
    let j_rot = @lib.set_rotation(j_vec, j_theta, cube_cen)
    let cube_arr_pois = @lib.make_cube_pois(cube_cen, 2.0, direction)
    let s1 = @lib.pois_rotate(cube_arr_pois.0, j_rot)
    let s2 = @lib.pois_rotate(cube_arr_pois.1, j_rot)
    cube_array = [..cube_array, ..@lib.make_2layer(s1, s2, view_box, view_dis)]
  }
  let j_rot_cube = @lib.set_rotation(j_vec, j_theta, (16.0, 16.0, 16.0))
  let cube_pois = @lib.make_cube_pois(
    (6.0, 16.0, 10.0),
    8.0,
    @lib.set_rotation(
      (1.0, 1.0, 1.0),
      3.1415926 * 1.0 / 2.0,
      // 0.0,
      (6.0, 16.0, 10.0),
      // cube_cen
    ),
  )
  let s1 = @lib.pois_rotate(cube_pois.0, j_rot_cube)
  let s2 = @lib.pois_rotate(cube_pois.1, j_rot_cube)
  // 球
  let ball_pois = @lib.make_ball_pois(
    (1.0, 7.0, 10.0),
    5.0,
    10,
    @lib.set_rotation(
      (1.0, 1.0, 1.0),
      3.1415926 * 1.0 / 3.0,
      // 0.0,
      (1.0, 7.0, 10.0),
    ),
  )
  let j_rot_ball = @lib.set_rotation(j_vec, j_theta, (1.0, 7.0, 10.0))
  let ball_pois_ = ball_pois.map(fn { n => @lib.pois_rotate(n, j_rot_ball) })
  // println(@lib.mul_str(100, "\x1b[A") + "\x1b[H")
  // let view_frame = 
  let j_ = j.to_double() / 5.0
  let (view_frame, h) = @lib.draw_(
    [
      // ..@lib.make_column((5.0, 0.0, 0.0), 0.5, 0.2, view_dis),
      (f2, [@lib.set_box((0.0, 4.0), (0.0, 4.0))]),
      ..@lib.make_oval((0.0, 0.0), 0.5, 0.2, []),
      ..@lib.make_2layer(s1, s2, view_box, view_dis),
      ..@lib.make_cube4(
        (
          10.0 + j_ * @math.sqrt(@math.sin(j_)),
          5.0 + j_,
          5.0 + j_ * @math.sqrt(@math.sin(j_)),
          5.0 + j_ * @math.sqrt(@math.sin(j_)),
        ),
        8.0,
        view_dis,
        view_box,
        view_dis,
      ),
      ..@lib.make_nlayer(ball_pois_, view_box, view_dis),
      ..cube_array,
    ],
    view_box,
    wid,
    hei,
    [
      (0.0, 0.0, "(0,0)"),
      (0.0, 4.0, "(0,4)"),
      (2.0, 2.0, "(2.0,2.0)"),
      (4.0, 4.0, "(4,4)"),
      (4.0, 0.0, "(4,0)"),
    ],
  )
  println(view_frame + "\x1b[\{h}A\r")
  // println(delay(10))
  // println("\x1b[\{h+1}A\r")
  // println("\x1b[H\x1b[\{h}B")
  // }
}
