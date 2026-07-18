# Quaternions — Project Documentation

Interactive 3D visualisation of paths on a unit sphere, built with Three.js and dat.GUI. Two lat/long coordinates are mapped to points on the sphere surface and connected by the shorter arc, interpolated in angular space.

---

## Project Structure

```
quaternions/
├── index.html          # Entry point — wires up the scene, GUI, and render loop
├── main.css            # Minimal page styles
├── package.json        # Node dependencies (three, mathjs, dat.gui)
├── docs/               # This folder
│   └── README.md
├── lib/                # Vendored third-party libraries (not modified)
│   ├── three.module.js     # Three.js ES module build
│   ├── OrbitControls.js    # Three.js orbit camera addon
│   ├── math.min.js         # mathjs (global `math` object)
│   └── dat.gui.min.js      # dat.GUI for the parameter panel
├── modules/            # Application source modules
│   ├── colors.js       # Colour palettes
│   ├── mathtools.js    # Vector arithmetic helpers
│   ├── threetools.js   # Three.js scene/object helpers
│   ├── plotutils.js    # Plotly-oriented data helpers (unused in index.html)
│   ├── primes.js       # Prime utilities (not imported by index.html)
│   └── zeta.js         # Riemann zeta utilities (not imported by index.html)
└── textures/
    └── sprites/disc.png
```

---

## Modules

### [modules/colors.js](../modules/colors.js)

Exports named colour palette arrays (hex strings). All palettes are indexed by integer.

| Export | Description |
|--------|-------------|
| `colorsA` | 30-colour green-to-purple gradient |
| `colorsB` | 30-colour warm pastel grid |
| `colorsGrey` | 7-step greyscale from `#202020` to `#d0d0d0` |
| `rainbow` | 60-colour spectral rainbow used for directional lines |
| `primary` | `[red, green, blue]` — used for the XYZ axis lines |

---

### [modules/mathtools.js](../modules/mathtools.js)

Pure vector arithmetic over `THREE.Vector3`. Depends on `mathjs` (loaded globally) and `three.module.js`.

| Export | Signature | Description |
|--------|-----------|-------------|
| `roundTo` | `(real, radix)` | Round `real` to `radix` decimal places |
| `polarCos` | `(degrees, radius, offset)` | `cos(deg) * radius + offset` |
| `polarSin` | `(degrees, radius, offset)` | `sin(deg) * radius + offset` |
| `square` | `(n)` | `n * n` |
| `getDistance` | `(v1, v2)` | Euclidean distance in XY |
| `addVectors` | `(v1, v2)` | Returns new `Vector3(v1 + v2)` |
| `subVectors` | `(v1, v2)` | Returns new `Vector3(v1 - v2)` |
| `subVectorsXY` | `(v1, v2)` | Subtracts XY only; preserves `v1.z` |
| `scaleVectors` | `(array, xR, yR, zR)` | Mutates each vector in-place by ratio |
| `moveVectors` | `(array, x, y, z)` | Translates each vector in-place |
| `addVectorArray` | `(a1, a2)` | Pairwise addition; returns new array |
| `subtractVectorArray` | `(a1, a2, onlyXY?)` | Pairwise subtraction; `onlyXY=true` preserves z from `a1` |

---

### [modules/threetools.js](../modules/threetools.js)

Scene construction and geometry helpers. Depends on `mathtools.js`, `three.module.js`, `OrbitControls.js`, and `colors.js`.

#### Scene

| Export | Signature | Description |
|--------|-----------|-------------|
| `buildScene` | `(el, w, h, scale, bg, light, camera?)` | Creates renderer, scene, group, lighting, and OrbitControls. Returns a `sceneInfo` object. |
| `getPerspectiveCamera` | `(w, h)` | `PerspectiveCamera` at z=50, FOV 32 |
| `getOrthoCamera` | `(w, h)` | `OrthographicCamera` centred at origin, z=50 |
| `resize` | `(renderer, camera, w, h)` | Updates renderer size and perspective camera aspect ratio |

**`sceneInfo` object** (returned by `buildScene`):

| Property / Method | Description |
|-------------------|-------------|
| `renderer` | `WebGLRenderer` |
| `camera` | Active camera |
| `scene` | `THREE.Scene` |
| `group` | `THREE.Group` — all application objects go here |
| `objects` | Array of tracked curve objects |
| `hasChanged` | Dirty flag for scale updates |
| `animationLoopId` | `requestAnimationFrame` handle |
| `scale(size)` | Sets uniform group scale |
| `addObject(obj)` | Pushes `obj` and adds `obj.mesh` to group |
| `addObjectToScene(obj)` | Adds directly to scene |
| `addObjectToGroup(obj3d)` | Adds raw `Object3D` to group |
| `clear()` | Removes all children from group; empties `objects` |
| `render()` | Calls `renderer.render(scene, camera)` |
| `redo()` | Removes all children from scene |

#### Geometry

| Export | Signature | Description |
|--------|-----------|-------------|
| `newVec` | `(x, y, z)` | Shorthand for `new THREE.Vector3(x, y, z)` |
| `getMaterial` | `(palette, colorN, opacity?)` | Returns a `LineBasicMaterial`; transparent when `opacity > 0` |
| `drawAxis` | `(parent, size, material?)` | Draws X/Y/Z axis lines of given half-length into `parent` |
| `makeSimpleCurve` | `(points, material, xO?, yO?, res?)` | Wraps points in a curve object without computing the curve |
| `makeCurve` | `(pivot, a, b, r, ngon, rot, mat, points?, res?)` | Full curve object; calls `addMesh` |
| `makeCircle` | `(pivot, a, b, r, ngon, rot, mat)` | Generates circle points then calls `makeCurve` |
| `getCirclePoints` | `(pivot, a, b, r, ngon?, rot?)` | Returns array of `Vector3` on a circle |

---

### [modules/plotutils.js](../modules/plotutils.js)

Data-generation helpers originally intended for Plotly charts. Not imported by `index.html`.

| Export | Description |
|--------|-------------|
| `repeatXFx(limit, inc, fnx)` | Builds `{x, y}` scatter data by sampling `fnx(n, k, limit)` |
| `repeatReIm(limit, inc, fnx)` | Builds `{x, y}` from real/imaginary parts of `fnx` |
| `repeatReImN(maxX, limit, inc, fnx)` | Variant of above with separate x bound |
| `getLayout(rangemode, mode, showline, zeroline)` | Returns a Plotly axis layout config |
| `animate(limit, inc, repeater, fx, layout)` | Calls `Plotly.animate` on `#div1` |
| `animateData(data, layout)` | Calls `Plotly.animate` on `#div1` with prebuilt data |
| `unitCircle2SineX / Y` | Parametric complex-plane sampling functions |
| `fxLine / fxLine2` | Experimental complex-valued line functions |

---

## Entry Point — index.html

The page renders a unit sphere with two directional lines (one per lat/long pair) and a yellow arc connecting them. All controls are in the dat.GUI panel on the right.

---

### GUI Parameters — how each control feeds into the code

Every parameter change triggers `drawChoice()` → `drawArches()` → `makeSphere()`, which rebuilds all scene objects from scratch.

#### Scale (0 – 10, step 0.05, default 5)

Scale does **not** call `drawArches`. Instead it sets a dirty flag:

```javascript
// popGui
gui.controllers.ctrlScale = datGui.add(gui.parameters, 'Scale', 0, 10, 0.05)
    .onChange(hasChanged);       // sets sceneInfo.hasChanged = true

// updateObjects — called every animation frame
if (sceneInfo.hasChanged) {
    sceneInfo.scale(gui.controllers.ctrlScale.getValue());  // group.scale.set(v, v, v)
    sceneInfo.hasChanged = false;
}
```

The scale is applied to the `THREE.Group` that contains all objects, so geometry is never rebuilt — only the group transform changes.

#### X, Y, Z (0 – 360°, step 1, defaults 0 / 0 / 0)

Read inside `makeSphere` and applied as Euler rotations to **every object** in the scene tree individually — sphere mesh, edge lines, both radius lines, and the flight arc all receive identical rotations:

```javascript
const x = gui.controllers.ctrlX.getValue();
const y = gui.controllers.ctrlY.getValue();
const z = gui.controllers.ctrlZ.getValue();

objTree.forEach((obj) => {
    obj.rotateX(x * math.pi / 180);
    obj.rotateY(y * math.pi / 180);
    obj.rotateZ(z * math.pi / 180);
});
```

Rotation is applied in X → Y → Z order (intrinsic Euler). Because the entire `objTree` is rotated together the sphere, lines, and arc move as a rigid body. This lets the viewer inspect the geometry from any angle without changing the camera.

#### Latitude1 / Longitude1 (0 – 360°, step 1, defaults 0 / 0)

- Drive the **first radius line**: `drawLine(ctrlLongitude, ctrlLatitude, 36)` — drawn with `rainbow[36]` (a warm orange-red).
- Drive the **start point** of the yellow arc in `drawFlight()`:
  ```javascript
  const lat1  = gui.controllers.ctrlLatitude.getValue();
  const long1 = gui.controllers.ctrlLongitude.getValue();
  ```
- Default (0°, 0°) resolves to the 3D point `(1, 0, 0)` — the intersection of the sphere with the positive X axis.

#### Latitude2 / Longitude2 (0 – 360°, step 1, defaults 0 / 13)

- Drive the **second radius line**: `drawLine(ctrlLongitude2, ctrlLatitude2, 16)` — drawn with `rainbow[16]` (a warm peach).
- Drive the **end point** of the yellow arc in `drawFlight()`.
- Default (0°, 13°) resolves to `(cos 13°, sin 13°, 0)` ≈ `(0.974, 0.225, 0)` — a small step along the equator.

---

### Coordinate system — `outerPoint`

`outerPoint(latDeg, longDeg)` converts a (latitude, longitude) pair in degrees to a unit-vector on the sphere:

```javascript
function outerPoint(latDeg, longDeg) {
    const lineYC = sin(longDeg);                    // y = sin(long)
    let   lineZC = -sin(latDeg) * cos(longDeg);    // z = -sin(lat) * cos(long)
    let   lineXC =  cos(latDeg) * cos(longDeg);    // x =  cos(lat) * cos(long)
    return newVec(lineXC, lineYC, lineZC);
}
```

Written as a formula:

```
P(lat, long) = ( cos(lat)·cos(long),  sin(long),  −sin(lat)·cos(long) )
```

**Geometric meaning of each axis:**

| long=0, vary lat | traces the XZ-plane circle (a meridian through X) |
|---|---|
| lat=0, vary long | traces the XY-plane circle (the equator) |
| Positive Y | "north" of the equator in longitude (long → 90°) |
| Negative Z | corresponds to positive latitude elevation |

This is standard spherical coordinates with Y as the "longitude up" axis:
- **Longitude** is the azimuthal angle in the XY plane, measured from +X toward +Y.
- **Latitude** tilts the point toward the −Z pole.

**Degenerate cases:** when `long = 90°` or `long = 270°`, `cos(long) = 0`, so the `lat` terms vanish. Any latitude value at those longitudes maps to the same point `(0, ±1, 0)`. Latitude has no geometric effect at those two longitudes.

---

### The yellow arc — how `drawFlight` works

`drawFlight()` builds 65 points (n = 0 … 64) on the sphere surface, connecting the two lat/long coordinates with a smooth arc coloured `0xffff00` (yellow).

#### Step 1 — find the shorter angular span for longitude

```javascript
let lessLong = Math.min(long1, long2);
let bigLong  = Math.max(long1, long2);
let diffLong = bigLong - lessLong;                  // direct arc

if (360 - bigLong + lessLong < diffLong) {          // wrap-around is shorter
    diffLong = 360 - bigLong + lessLong;
    flipLong = true;                                // travel past 360° instead
}
```

`diffLong` is always the **smaller** of the two possible arcs between the two longitudes on the circle. `flipLong` records which direction is shorter.

Example — long1 = 350°, long2 = 10°:
- Direct arc: 350 − 10 = 340°
- Wrap-around: 360 − 350 + 10 = 20° ← shorter
- Result: `diffLong = 20`, `flipLong = true`

#### Step 2 — find the shorter angular span for latitude (same logic)

```javascript
let lessLat = Math.min(lat1, lat2);
let bigLat  = Math.max(lat1, lat2);
let diffLat = bigLat - lessLat;

if (360 - bigLat + lessLat < diffLat) {
    diffLat = 360 - bigLat + lessLat;
    flipLat = true;
}
```

#### Step 3 — choose the start point based on flip flags

| `flipLat` | `flipLong` | lat starts at | long starts at |
|-----------|-----------|---------------|----------------|
| false     | false     | `lessLat`     | `lessLong`     |
| false     | true      | `lessLat`     | `bigLong`      |
| true      | false     | `bigLat`      | `lessLong`     |
| true      | true      | `bigLat`      | `bigLong`      |

When a flip is active the start is the larger value; adding `diffLong * n/64` drives the longitude past 360°, which is fine because `sin` and `cos` are periodic — `sin(370°) = sin(10°)`.

#### Step 4 — interpolate 65 points

```javascript
for (let n = 0; n <= 64; n++) {
    const lat  = startLat  + diffLat  * n / 64;
    const long = startLong + diffLong * n / 64;
    points.push(outerPoint(lat, long));
}
```

At `n = 0` the point is on one coordinate; at `n = 64` it is on the other. Each intermediate point sits on the unit sphere because `outerPoint` always returns a unit vector.

---

### Shortest flight path — what the algorithm computes and its limits

#### What the code does

The algorithm minimises the angular distance for **latitude and longitude independently** and then linearly interpolates both angles together. This is an angular-space interpolation, not a 3D Cartesian interpolation.

The arc on the sphere produced by this approach is **not a great-circle route**. A great circle is the intersection of the sphere with any plane that passes through its centre — it is always the geometrically shortest path between two points on a sphere.

What this algorithm traces is closer to the shape you get by "dragging" a point along latitude and longitude at a constant rate simultaneously. The path stays on the sphere surface but curves away from the great-circle route when the two points differ in both dimensions.

#### When it does equal a great circle

| Condition | Reason |
|-----------|--------|
| Both points share the same longitude | Latitude alone varies → traces a meridian, which is a great circle |
| Both points sit on the equator (lat = 0) | Longitude alone varies at lat = 0 → traces the equatorial great circle |
| The two points are antipodal | Every arc between antipodal points is a semicircle of a great circle |

For all other combinations the path deviates from the great-circle route, with the deviation growing as the angular distance between the points increases.

#### Why it still finds the "shorter" arc

The flip logic ensures that the interpolation always travels the short way around the sphere in each angular dimension independently. Without the flip check, moving from long = 10° to long = 350° would traverse 340° the "long way"; the flip redirects to 20° the short way. The same applies to latitude. So the arc is the shorter of the two possible angular-interpolation paths between the coordinates, even if it is not the geodesically shortest path.

#### What a true great-circle route would require

A true great-circle interpolation (SLERP — Spherical Linear Interpolation) works in 3D:

```
P1 = outerPoint(lat1, long1)     // unit vector
P2 = outerPoint(lat2, long2)     // unit vector
θ  = arccos(P1 · P2)             // angle between them

SLERP(t) = sin((1−t)θ) / sin(θ) · P1  +  sin(t·θ) / sin(θ) · P2
```

Every point on the SLERP path lies on the great circle defined by P1 and P2. The current implementation has no equivalent of this formula; the angular interpolation is a simpler approximation that is visually useful for small angular separations but diverges from the great-circle route at larger separations.

---

### Key Functions

| Function | Description |
|----------|-------------|
| `outerPoint(lat, long)` | Converts lat/long degrees to a unit-sphere `Vector3` using the formula above |
| `drawLine(ctrlLong, ctrlLat, colorNum)` | Draws a `THREE.Line` from origin `(0,0,0)` to the sphere surface point |
| `drawFlight()` | Builds the yellow arc — 65-point angular interpolation with wrap-around detection |
| `makeSphere()` | Assembles sphere mesh, wireframe edges, two radius lines, flight arc; applies X/Y/Z rotation to all |
| `drawArches()` | Calls `sceneInfo.clear()` then `makeSphere()` — full rebuild on any parameter change |
| `updateObjects()` | Per-frame: flushes the `hasChanged` scale flag |
| `animationLoop()` | `requestAnimationFrame` loop: `updateObjects` → `sceneInfo.render()` |

#### Orphaned functions (not called in the current render flow)

These functions exist in `index.html` but are never invoked by `drawArches` or `animationLoop`. They appear to be leftover from an earlier CIRCLES mode:

| Function | Description |
|----------|-------------|
| `getEta(numerator, k, a, b)` | Evaluates one term of the Dirichlet eta series: `numerator / (k · baseFactor)^(a + bi)` using mathjs. Renders the formula to `#floatingText`. Would crash if called — references `ctrlBaseFactor`, which is never added to the GUI panel in `popGui`. |
| `setFormula(text, ...)` | Maintains a two-item rolling history of formula strings and writes them to `#floatingText` as HTML. Title hardcoded to `1/(n1...n2)^(a + bi)`. |
| `fn(r)` | Formats a real number as a signed string with 5 significant characters, e.g. `+ 1.234` or `- 0.500`. Used by `getEta` to build the displayed formula. |
| `getPoints(p1, p2)` | Empty stub — loop body is blank, `points` is never declared. |

---

## Dependencies

| Library | Version | Purpose |
|---------|---------|---------|
| three | ^0.117.1 | 3D rendering |
| mathjs | ^7.2.0 | Complex arithmetic and expression evaluation |
| dat.gui | ^0.7.7 | Parameter control panel |
