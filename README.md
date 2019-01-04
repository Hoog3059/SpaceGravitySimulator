# Space Gravity Simulator
Hi! This is a simple 2D gravity simulator. Scenarios are loaded from the data folder. The scenarios are in .json format. 
## Downloading
You can download the program for Windows (32/64 bit) and Linux (32/64 bit/arm64/armv6hf). The program requires Java to run. One of the releases (Windows 64 Java included) has Java included.
### Building
To build the program, clone this repo:
```bash
> git clone https://github.com/Hoog3059/SpaceGravitySimulator.git
```
Install Processing 3.x by downloading it [here](https://processing.org/download/).
Open the sketch in Processing. Go to File > Export Application > Export.
## Using
Controls when a scene is active:
```
UP      : Move camera up
DOWN    : Move camera down
LEFT    : Move camera left
RIGHT   : Move camera right
+       : Zoom in
-       : Zoom out
a       : Scroll text up
z       : Scroll text down
c       : Reset camera
.       : Speed up (increase framerate)
,       : Slow down (decrease framerate)
r       : Restart scene (doesn't reset camera)
BACKSPACE       : Stop scene, open new scene.
ESC     : Exit
```
Scenes are placed in the data folder and are in JSON format. This is an example of a scenario with a planet and a moon:
```json
{
    "Objects": [
        {
            "name": "Planet",
            "location.x": 840.0,
            "location.y": 525.0,
            "width": 50.0,
            "height": 50.0,
            "mass": 0.1,
            "is_static": true,
            "velocity.x": 0.0,
            "velocity.y": 0.0,
            "use_orbital_velocity_to": "",
            "orbit_is_clockwise": false,
            "trace_path": false,
            "max_nr_path": 0,
            "gravity_influence_from": [],
            "draw_all_vectors": {
                "do": true,
                "k_v": 5,
                "k_g": 1000,
                "g_vectors_from": [
                    "Moon"
                ]
            },
            "draw_physics_data": true
        },
        {
            "name": "Moon",
            "location.x": 840.0,
            "location.y": 125.0,
            "width": 10.0,
            "height": 10.0,
            "mass": 0.012,
            "is_static": false,
            "velocity.x": 0.0,
            "velocity.y": 0.0,
            "use_orbital_velocity_to": "Planet",
            "orbit_is_clockwise": false,
            "trace_path": true,
            "max_nr_path": 500,
            "gravity_influence_from": [
                "Planet"
            ],
            "draw_all_vectors": {
                "do": true,
                "k_v": 5,
                "k_g": 500,
                "g_vectors_from": [
                    "Planet"
                ]
            },
            "draw_physics_data": true
        }
    ],
    "G": 160000.0,
    "FPS": 60
}
```
![Planet and moon](https://hoog3059.pythonanywhere.com/static/img/img_compressed/gravity_simulation.jpg)
Explanation:
* location.x and location.y: The location in pixels. The window will be loaded at the resolution of your screen.
* width and height: In pixels.
* mass: A measure of the mass of an object.
* is_static: If an object is static, it doesn't move and is not affected by gravity.
* velocity.x and velocity.y: Velocity in pixels per frame.
* use_orbital_velocity_to: If an object is specified, the application will calculate the velocity of the object to have a stable orbit.
* orbit_is_clockwise: If 'use_orbital_velocity_to' is specified, the calculated orbit will be in the clockwise direction.
* trace_path: The path of a moving object will be drawn.
* max_nr_path: The path consists of a number of lines drawn between points. This is the number of lines drawn.
* gravity_influence_from: Specify the objects the object is effected by gravitationally.
* draw_all_vectors:
  - do: Do draw all vectors.
  - k_v: Velocity vector scaling factor.
  - k_g: Gravitational vector scaling factor.
  - g_vectors_from: The gravitational vectors are drawn towards these objects.
  - draw_physics_data: Display numerical data about the object on the side of the screen.
* G: Gravitational constant.
* FPS: The application will try to render at this framerate.

## Physics
The application uses the following formulas to calculate orbits and the effects of gravity:
### Acceleration due to gravity
This formula calculates the acceleration an object receives. It is run once every frame on every object that is set to be affected by gravity.

![Acceleration due to gravity](https://latex.codecogs.com/gif.latex?\newline&space;F&space;=&space;\frac{m*M}{r^2}\newline&space;ma&space;=&space;\frac{m*M}{r^2}\newline&space;a&space;=&space;\frac{m*M}{r^2}\div&space;m\newline&space;g&space;=&space;\frac{m*M}{r^2}\div&space;m)

* m and M:  Mass (no unit defined)
* G:        Gravitational Constant (in (pix^3/frame^2)/mass)
* r:        Distance (in pixels)
* g:        Acceleration due to gravity (in pixels/frame^2)
### Orbital velocity
This formula calculates the velocity an object needs to be in a stable orbit around another object. It is run at load time for those objects that are set to be at orbital velocity.

![Orbital velocity](https://latex.codecogs.com/gif.latex?\newline&space;v&space;=&space;\sqrt{G*\frac{M}{r}})

* v:        Velocity (in pixels/frame)
* G:        Gravitational Constant (in (pix^3/frame^2)/mass)
* M:        Mass (no unit defined)
* r:        Distance (in pixels)
