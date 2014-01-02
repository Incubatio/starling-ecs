{
  screen:
    size: [1024, 800]
  map:
    url: "assets/data/rpg/example.json"
    tilesheet: "tilesheet.png"
  prefixs:
    image: "assets/images/rpg/"
    sfx: "assets/sfx/"
  systems: ["Movement", "Collision", "Rendering"]
  sfx: []
  sprites:
    Pad:
      Visible:
#        size: [5, 40]
#color: 0x000000
#        shape: "rect"
#Visible2:
        frameSize: [64, 64]
        frameset: { down: [56, 59],  left: [8, 11], right: [8, 11], up: [34, 39], pause: [64, 65] }
        image: "firefox"
        options: { xflip: { left: true } }
      Collidable:
        type: "image"
      Mobile:
        speed: [0, 2, 0]
    Ball:
      Visible:
        radius: 10
#color: 0x000000
#shape: "circle"
        image: "tennis_ball"
      Visble2:
        frameSize: [32, 32]
        frameset:
          wave: [0, 3]
          pause: [0]
        image: "frameset/octocat.png"
        options: { start: "wave" }
      Mobile:
        speed: [1, 1, 0]
        dir: [1, 1, 0]
      Collidable:
        type: "image"
  scene:
    actors: [
      ["Pad", [100, 400]]
      ["Pad", [900, 400]]
      ["Ball", [400, 400]]
    ]
  decors: [
    ["text", "Hello World", [200, 250]]
    ["image", "stargate.png", [250, 1]]
  ]
}
