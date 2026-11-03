// Isometric SVG piece — no build step: serve the folder (or open index.html) and it runs.

// —— Determinism: every random draw goes through rand(); the global RNG is off-limits ——
const SEED = 20260923;
function mulberry32(a) {
  return function () {
    a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
const rand = mulberry32(SEED);

// —— Unified isometric projection: P(x,y,z) = ( (√3/2)(x−y), 0.5(x+y) − z ) ——
//    A ground circle of radius r projects to an axis-aligned ellipse: rx = 1.2247r, ry = 0.7071r.
//    Use disc() for every disc / wheel / contact shadow — never eyeball an ellipse.
const ISO_KX = Math.sqrt(3) / 2;  // 0.86603
const DISC_RX = 1.2247;
const DISC_RY = 0.7071;
const UNIT = 46;                  // world unit -> px
const ORIGIN = { x: 800, y: 560 };// projection origin inside the 1600x1000 viewBox

const SVG_NS = 'http://www.w3.org/2000/svg';
const world = document.getElementById('world');
const hud = document.getElementById('hud');

function iso(x, y, z = 0) {
  return {
    x: ORIGIN.x + UNIT * (ISO_KX * (x - y)),
    y: ORIGIN.y + UNIT * (0.5 * (x + y) - z),
  };
}
const fmt = (n) => (Math.round(n * 100) / 100).toString();
function poly(points, attrs, parent = world) {
  return el('polygon', { points: points.map((p) => { const q = iso(p[0], p[1], p[2] || 0); return `${fmt(q.x)},${fmt(q.y)}`; }).join(' '), ...attrs }, parent);
}
function el(name, attrs = {}, parent = world) {
  const n = document.createElementNS(SVG_NS, name);
  for (const k in attrs) n.setAttribute(k, attrs[k]);
  parent.appendChild(n);
  return n;
}
// Ground disc at (x,y,z=0) with world radius r -> the one correct ellipse
function disc(x, y, r, attrs = {}, parent = world) {
  const c = iso(x, y, 0);
  return el('ellipse', { cx: fmt(c.x), cy: fmt(c.y), rx: fmt(DISC_RX * r * UNIT), ry: fmt(DISC_RY * r * UNIT), ...attrs }, parent);
}
// Painter's order: draw ascending by depth(); nothing else fixes overlap in SVG
const depth = (x, y, z = 0) => x + y + z;
// Axis-aligned box: three visible faces share one light direction (top brightest, right darkest)
function box(x, y, sx, sy, sz, hue, parent = world) {
  const g = el('g', {}, parent);
  poly([[x, y, sz], [x + sx, y, sz], [x + sx, y + sy, sz], [x, y + sy, sz]], { fill: `hsl(${hue} 28% 62%)` }, g);
  poly([[x, y + sy, sz], [x + sx, y + sy, sz], [x + sx, y + sy, 0], [x, y + sy, 0]], { fill: `hsl(${hue} 26% 44%)` }, g);
  poly([[x + sx, y, sz], [x + sx, y + sy, sz], [x + sx, y + sy, 0], [x + sx, y, 0]], { fill: `hsl(${hue} 24% 31%)` }, g);
  return g;
}

// —— Scene: built once, then sample(t) drives every animated attribute ——
disc(0, 0, 5.2, { fill: 'url(#pool)' });
const blocks = [];
for (let i = 0; i < 9; i++) {
  const gx = (i % 3) - 1, gy = Math.floor(i / 3) - 1;
  const h = 0.6 + rand() * 1.8;
  blocks.push({ node: box(gx * 1.4, gy * 1.4, 1, 1, h, 210 + rand() * 40), d: depth(gx * 1.4, gy * 1.4, h) });
}
blocks.sort((a, b) => a.d - b.d).forEach((b) => world.appendChild(b.node)); // painter's order
const marker = disc(0, 0, 0.34, { fill: '#8df0c1', opacity: '0.92' });

// —— Time model: the piece is a pure function of t; t=0 and t=DURATION must match ——
const DURATION = 12; // seconds per loop
function sample(t) {
  const a = (t / DURATION) * Math.PI * 2;
  const c = iso(Math.cos(a) * 3.2, Math.sin(a) * 3.2, 0);
  marker.setAttribute('cx', fmt(c.x));
  marker.setAttribute('cy', fmt(c.y));
}

window.__SCENE_READY__ = false;
window.__SCENE_ERROR__ = null;
const params = new URLSearchParams(location.search);
const CAPTURE_MODE = params.get('capture') === '1';
window.__CAPTURE_MODE__ = CAPTURE_MODE;
const T_PARAM = params.get('t');
let simT = 0, paused = CAPTURE_MODE || T_PARAM !== null, last = 0, frameId = 0, captureState = null;
// —— HUD: live instrumentation, deliberately not part of the picture. A frame frozen
//    by __seek(t) has to be a pure function of t, and a clock reading is not — so the
//    HUD leaves the frame while the piece is parked and comes back on __play().
//    Readouts belong here and never in the artwork: then two seeks a whole loop
//    apart stay pixel-identical no matter what the HUD grows to show. ——
function drawHud() {
  hud.style.display = paused ? 'none' : '';
  if (!paused) hud.textContent = `t ${simT.toFixed(2)}s · nodes ${world.getElementsByTagName('*').length}`;
}

// Jump to an arbitrary moment; pauses so the frame holds still for a screenshot.
window.__seek = (t) => {
  window.__SCENE_READY__ = false;
  const v = Number(t);
  paused = true;
  cancelAnimationFrame(frameId);
  simT = Number.isFinite(v) && v > 0 ? v : 0;
  sample(simT);
  drawHud();
  window.__SCENE_READY__ = true;
};
window.__play = () => {
  if (CAPTURE_MODE) return;
  cancelAnimationFrame(frameId);
  paused = false; last = 0; drawHud();
  frameId = requestAnimationFrame(frame);
};
window.__capture = (t = simT) => {
  if (captureState) throw new Error('Capture already active');
  captureState = { simT, paused };
  window.__seek(t);
};
window.__restore = () => {
  if (!captureState) return;
  const state = captureState;
  captureState = null;
  window.__seek(state.simT);
  if (!state.paused) window.__play();
};
function frame(now) {
  if (!paused) {
    const dt = last ? Math.min((now - last) / 1000, 0.1) : 0;
    last = now; simT += dt;
    sample(simT);
    drawHud();
  }
  if (!paused) frameId = requestAnimationFrame(frame);
}
sample(simT);
drawHud();
if (paused) window.__seek(T_PARAM ?? 0);
else frameId = requestAnimationFrame(frame);
window.__SCENE_READY__ = true; // ready signal: for screenshot/self-check scripts to wait on
