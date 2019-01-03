# Space Gravity Simulator
Hi! This is a simple 2D gravity simulator. Scenarios are loaded from the data folder. The scenarios are in .json format. Controls:
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
This is an example of a scenario with a planet and a moon:
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
Explanation:
* Location: The location in pixels. The window will be loaded at the resolution of your screen.
* Width/Height: In pixels.
* Mass: A measure of the mass of an object.
* Is Static: If an object is static, it doesn't move and is not effected by gravity.
* Velocity: Velocity in pixels per frame.
* Use orbital velocity to: If an object is specified, the application will calculate the velocity of the object to have a stable orbit.
* Orbit is clockwise: If 'use_orbital_velocity_to' is specified, the calculated orbit will be in the clockwise direction.
* Trace path: The path of a moving object will be drawn.
* Max_nr_path: The path consists of a number of lines drawn between points. This is the number of lines drawn.
* Gravity influence from: Specify the objects the object is effected by gravitationaly.
* Draw all vectors:
  - Do: Do draw all vectors.
  - k_v: Velocity vector scaling factor.
  - k_g: Gravitational vector scaling factor.
  - g_vectors_from: The gravitational vectors are drawn towards these objects.
  - draw_physics_data: Display numerical data about the object on the side of the screen.
* G: Gravitational constant.
* FPS: The application will try to render at this framerate.

## Phsyics
The application uses the following formulas to calculate orbits and the effects of gravity:
### Gravity
![Acceleration due to gravity](https://latex.codecogs.com/gif.latex?\newline&space;F&space;=&space;\frac{m*M}{r^2}\newline&space;ma&space;=&space;\frac{m*M}{r^2}\newline&space;a&space;=&space;\frac{m*M}{r^2}\div&space;m\newline&space;g&space;=&space;\frac{m*M}{r^2}\div&space;m)

* m and M:  in mass (no unit defined)
* G:        gravitational constant (in (pix^3/frame^2)/mass)
* r:        in pixels
* g:        in pixels/frame/frame
### Orbital velocity
![Orbital velocity](https://latex.codecogs.com/gif.latex?\newline&space;v&space;=&space;\sqrt{G*\frac{M}{r}})

* v:        in pixels/frame
* G:        gravitational constant (in (pix^3/frame^2)/mass)
* M:        in mass (no unit defined)
* r:        in pixels
