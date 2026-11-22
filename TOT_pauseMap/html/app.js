/* #####################################################################
 * #                                                                   #
 * #                 THIS SCRIPT IS MADE BY TOT                        #
 * #                 https://discord.gg/VnpMqz96YH                     #
 * #                                                                   #
 * ##################################################################### */
// TOT_pauseMap by TOT: minimap and pause map page
import { PauseMap3D, MinimapCamera, K0 } from './map3d.js';

const box = document.getElementById('map');
const marks = document.getElementById('marks');
const hint = document.getElementById('hint');
const post = (name, data) => fetch(`https://${GetParentResourceName()}/${name}`, { method: 'POST', body: JSON.stringify(data || {}) });

// English fallback: the active language is sent from config.lua on /ready
const EN = {
    nothing: 'Nothing on the map', nearest: 'Nearest', blip: 'Blip',
    recenter: 'RECENTER', flat: '2D VIEW', destination: 'SET DESTINATION', close: 'CLOSE MENU',
    mi: 'mi', km: 'km', m: 'm',
};
let LANG = 'en';
let STR = EN;
const t = (key) => STR[key] || EN[key] || key;
const tr = (en, ar) => (LANG === 'ar' && ar ? ar : en);
const catLabel = (cat) => tr(cat.label, cat.labelAr);

const NIGHT = {
    land: [28, 32, 82], build: [72, 86, 146], build2: [36, 40, 94],
    street: [52, 56, 112],
    road: [134, 134, 176], hwy: [160, 160, 200],
    deep: [64, 60, 142], shore: [112, 110, 196],
};

const DAY = {
    land: [208, 214, 220], build: [160, 178, 202], build2: [220, 224, 229],
    street: [226, 230, 234],
    road: [244, 244, 240], hwy: [232, 226, 196],
    deep: [36, 150, 188], shore: [104, 196, 212],
};
const LOOK = Object.assign({
    alley: null,
    streetMax: 165,
}, NIGHT);
let dayNow = -1;
const mix = (a, b, t) => [0, 1, 2].map((i) => Math.round(a[i] + (b[i] - a[i]) * Math.max(0, Math.min(1, t))));
function mapColour([r, g, b]) {
    if (b > r + 6) return mix(LOOK.deep, LOOK.shore, ((r + g + b) / 765 - 0.25) / 0.62);
    const v = (r + g + b) / 3;
    if (v <= 35) return LOOK.land;
    if (v < 82) return LOOK.build;
    if (v < 130) return LOOK.build2;
    if (v < 131) return LOOK.alley || LOOK.land;
    if (v <= LOOK.streetMax) return LOOK.street;
    if (v <= 180) return LOOK.road;
    return LOOK.hwy;
}

function dayAt(h) {
    const D = CFG.Day, f = D.fade / 2;
    const up = Math.max(0, Math.min(1, (h - (D.dawn - f)) / D.fade));
    const down = Math.max(0, Math.min(1, ((D.dusk + f) - h) / D.fade));
    return Math.min(up, down);
}
function setDay(t) {
    if (Math.abs(t - dayNow) < 0.01) return;
    dayNow = t;
    for (const k of Object.keys(NIGHT)) LOOK[k] = mix(NIGHT[k], DAY[k], t);
    if (ready) { map.setPalette(mapColour); touch(); }
    document.documentElement.classList.toggle('day', t > 0.5);
}

const CFG = {
    Route: { colour: '#5fe3c8', width: 9, miniWidth: 6 },
    Waypoint: { colour: '#5fe3c8', border: '#0b0f14', size: 3.8, miniSize: 2.8 },
    Player: { fill: '#4b4f58', border: '#15171c', arrow: '#ffffff', size: 2.6, maxSize: 3.8, grow: 0.3, miniSize: 2.2 },
    Zoom: { open: 7.8, max: 7.8, min: 5.0, mini: 2.0, ease: 320 },
    Blips: { style: 'round', background: '#ee7bb2', border: '#1a1a1a', icon: '#000000', size: 3.0, miniSize: 2.2 },
    Buildings: { fadeStart: 7.6, fadeEnd: 5.0, maxSize: 38, band: 25, ease: 400 },
    Zones: { kinds: [], countyZoom: 5.4, districtZoom: 6.6, ease: 200, border: '#ffffff', name: '#ffffff', dim: 0.5, countySize: 4.2, districtSize: 2.5, focus: 1.25, borderWidth: 4 },
    Focus: { snap: 2.4, sticky: 0.45, pull: 160, grow: 1.4, ringGrow: 1.2, units: 'mi', accent: '#ee7bb2', defaultText: '' },
    Minimap: { fps: 30, pitch: 36, height: 0.6, speedZoom: 0.8, buildingSize: 22, turn: 70 },
    Tilt: { near: 48, far: 90, nearZoom: 7.4, farZoom: 5.0 },
    Drag: { move: 70, turn: 90 },
    Day: { dawn: 6, dusk: 20, fade: 1 },
    Hud: { enabled: true, hints: true },
    Categories: [], BlipNames: {}, ZoneLabelsAr: {}, ZoneFallbackAr: 'منطقة', AlwaysShow: [],
};
const list = (t) => Array.isArray(t) ? t : Object.values(t || {});
const clean = (v) => (typeof v === 'string' ? v.trim() : '');
let CAT_OF = {}, ALWAYS = {};

const map = new PauseMap3D(box, { data: window.MAP3D_DATA });
map.paletteFn = mapColour;
let ready = false;
map.ready.then(() => { map.setPalette(mapColour); map.setMarker(null); ready = true; sizeNow(true); showRoute(); touch(); });

let mode = 'mini';
let pose = null;
let show = false;
let blips = [];
let waypoint = false;
let route = null;
let need = true;

// Frames are scheduled only when there is something to draw. The minimap runs
// at its configured 30 FPS on the render clock, and the big map animates at the
// browser's full 60 FPS. Nothing runs while the map is hidden or idle.
let rafId = 0, inFrame = false, lastFrameAt = 0;
let miniAcc = 0, miniClock = 0;
let lastMoveAt = -1e9;
const MINI_GRACE = 150;
function requestFrame(fresh) {
    if (rafId || inFrame) return;
    if (fresh) { miniAcc = 1000 / CFG.Minimap.fps; miniClock = performance.now(); }
    rafId = requestAnimationFrame(frame);
}
function touch() {
    need = true;
    if (inFrame) return;
    // A scheduled frame can be dropped when the page/compositor is suspended
    // (tab switch, game minimized). Recover by drawing once immediately rather
    // than leaving the map stuck forever behind a stale request id.
    if (rafId && performance.now() - lastFrameAt > 500) {
        cancelAnimationFrame(rafId);
        rafId = 0;
        miniAcc = 1000 / CFG.Minimap.fps;
        miniClock = performance.now();
        frame(performance.now());
        return;
    }
    requestFrame(true);
}

const MINI_BASE = { footPxPerMetre: 1.45, slowPxPerMetre: 1.15, fastPxPerMetre: 0.42 };
const cam = new MinimapCamera({ boxH: 167 });

function applyLanguage(locale, strings) {
    const l = String(locale || 'en').toLowerCase();
    LANG = l === 'ar' || l === 'arabic' ? 'ar' : 'en';
    STR = Object.assign({}, EN, (strings && strings[LANG]) || {});
    document.documentElement.lang = LANG;
    document.documentElement.dir = LANG === 'ar' ? 'rtl' : 'ltr';
}

function applyTheme(th) {
    th = th || {};
    const st = document.documentElement.style, B = CFG.Blips, W = CFG.Waypoint, P = CFG.Player;
    st.setProperty('--accent', th.accent || CFG.Focus.accent);
    st.setProperty('--panel', th.panel || '#1f1f2b'); st.setProperty('--panel2', th.panel2 || th.panel || '#1f1f2b');
    st.setProperty('--text', th.text || '#e5e9ec'); st.setProperty('--title', th.title || '#e4e6ea');
    st.setProperty('--hint', th.hint || '#ffffff'); st.setProperty('--map-bg', th.map || '#08101a');
    st.setProperty('--bl-bg', B.background); st.setProperty('--bl-border', B.border); st.setProperty('--bl-icon', B.icon);
    st.setProperty('--wp', W.colour); st.setProperty('--wp-border', W.border);
    st.setProperty('--pl-fill', P.fill); st.setProperty('--pl-border', P.border); st.setProperty('--pl-arrow', P.arrow);
    touch();
}

function hudOn() { return !CFG.Hud || CFG.Hud.enabled !== false; }
function hintsOn() { return !CFG.Hud || CFG.Hud.hints !== false; }

function applyHud(h) {
    if (h) CFG.Hud = Object.assign({ enabled: true, hints: true }, CFG.Hud, h);
    if (mode === 'mini') box.className = show && hudOn() ? 'mini' : 'mini hidden';
    hint.className = mode === 'big' && hintsOn() ? '' : 'hidden';
    touch();
}

function applyConfig(c) {
    if (c) applyLanguage(c.Locale, c.Strings);

    // Merge nested tables only: primitives such as ZoneFallbackAr are set explicitly below.
    for (const k of Object.keys(CFG)) if (c && c[k] && CFG[k] && typeof CFG[k] === 'object' && !Array.isArray(CFG[k])) Object.assign(CFG[k], c[k]);
    if (c) {
        CFG.Categories = list(c.Categories); CFG.AlwaysShow = list(c.AlwaysShow);
        if (typeof c.ZoneFallbackAr === 'string') CFG.ZoneFallbackAr = c.ZoneFallbackAr;
    }
    CAT_OF = {}; ALWAYS = {};
    for (const cat of CFG.Categories) for (const id of list(cat.sprites)) if (!CAT_OF[id]) CAT_OF[id] = cat.id;
    for (const id of CFG.AlwaysShow) ALWAYS[id] = true;
    drawRail();
    ZOOM.open = CFG.Zoom.open; ZOOM.min = CFG.Zoom.min; ZOOM.max = CFG.Zoom.max;

    const M = CFG.Minimap, k0 = MINI_BASE.footPxPerMetre * CFG.Zoom.mini;
    cam.o.footPxPerMetre = k0; cam.o.slowPxPerMetre = k0; cam.o.fastPxPerMetre = k0 * M.speedZoom;
    cam.o.footPitch = M.pitch; cam.o.vehiclePitch = M.pitch; cam.o.vehicleHeightScale = M.height; cam.o.tauYaw = M.turn;
    cam.settled = false;
    applyTheme(c && c.Theme);
    applyHud(c && c.Hud);
    // The minimap may already be visible before the config arrives; make sure
    // the WebGL canvas and the zone/blip layers get its real size instead of
    // waiting for the first big-map open/close.
    sizeNow(true);
    drawHints(); drawSide(); showRoute(); touch();
}

function drawHints() {
    const rows = [[t('recenter'), 'R'], [t('flat'), 'V'], [t('destination'), 'ENTER'], [t('close'), 'ESC']];
    hint.innerHTML = rows.map(([label, key]) => `<span>${esc(label)} <b><i>${key}</i></b></span>`).join('');
}

function showRoute() {
    if (!ready) return;
    const pts = route && route.map(([x, y, z]) => [x, y, Math.max(z ?? -1e9, map.heightAt(x, y))]);
    map.setRoute(pts, CFG.Route.colour, mode === 'big' ? CFG.Route.width : CFG.Route.miniWidth);
}
// Rebuilding the route mesh every second was wasted work whenever the waypoint
// and player were not moving; compare the points first.
function sameRoute(a, b) {
    if (!a || !b) return !a && !b;
    if (a.length !== b.length) return false;
    for (let i = 0; i < a.length; i++) {
        const p = a[i], q = b[i];
        if (p[0] !== q[0] || p[1] !== q[1] || p[2] !== q[2]) return false;
    }
    return true;
}

const ZOOM = { open: CFG.Zoom.open, min: CFG.Zoom.min, max: CFG.Zoom.max };
const TILT = CFG.Tilt;
const HEIGHT = { value: 1 };
const big = { x: 0, y: 0, zoom: ZOOM.open, target: ZOOM.open, yaw: 0, tilt: 0, flat: false, anchor: null };

function pitchNow() {
    if (big.flat) return 90;
    let t = Math.max(0, Math.min(1, (big.zoom - TILT.farZoom) / (TILT.nearZoom - TILT.farZoom)));
    t = t * t * (3 - 2 * t);
    return Math.max(25, Math.min(90, TILT.far + (TILT.near - TILT.far) * t + big.tilt));
}

function bigView() {
    return { x: big.x, y: big.y, pxPerMetre: K0 * Math.pow(2, big.zoom), offsetX: 0, offsetY: 0, yaw: big.yaw, pitch: pitchNow(), heightScale: HEIGHT.value };
}

let boxRect = { left: 0, top: 0, width: 1, height: 1 };
function sizeNow(force) {
    const r = box.getBoundingClientRect();
    boxRect = { left: r.left, top: r.top, width: r.width, height: r.height };
    if (r.width < 1) return;
    if (force || map.W !== r.width || map.H !== r.height) map.resize(r.width, r.height, 1);
    cam.o.boxH = r.height;
}

function setMode(m) {
    mode = m;
    box.className = m === 'big' ? 'big' : (show && hudOn() ? 'mini' : 'mini hidden');
    hint.className = m === 'big' && hintsOn() ? '' : 'hidden';
    if (m === 'big' && pose) { big.x = pose.x; big.y = pose.y; big.zoom = big.target = ZOOM.open; big.yaw = 0; big.tilt = 0; big.flat = false; big.anchor = null; }
    big.goal = null; big.yawGoal = undefined; big.pull = null;

    side.className = m === 'big' ? '' : 'hidden';
    menu.cat = null; menu.sub = null; menu.sel = -1;
    drawSide();
    sizeNow(true);
    showRoute();
    touch();
}

// The #map box is display:none while the HUD is hidden, so its size is 0 at
// boot and changes as soon as the first pose makes it visible. Re-measure then,
// otherwise the WebGL canvas and the zone/blip layers keep their 1x1 default
// until the player opens and closes the big map.
if (typeof ResizeObserver !== 'undefined') {
    new ResizeObserver(() => { sizeNow(); touch(); }).observe(box);
}

const zc = document.getElementById('zones'), zx = zc.getContext('2d');
const ZONES = window.MAP_ZONES || { counties: [], districts: [] };
const zAlpha = {};

for (const z of ZONES.districts) {
    z.area = 0;
    for (const r of z.rings) for (let i = 0, j = r.length - 1; i < r.length; j = i++) z.area += (r[j][0] + r[i][0]) * (r[j][1] - r[i][1]) / 2;
    z.area = Math.abs(z.area);
}
ZONES.districts.sort((a, b) => b.area - a.area);

function zoneColour(name) {
    for (const k of list(CFG.Zones.kinds)) for (const w of list(k.words)) if (name.indexOf(w) >= 0) return k.colour;
    return CFG.Zones.name;
}
function zoneText(name, upper) {
    if (LANG === 'ar') {
        const ar = CFG.ZoneLabelsAr && CFG.ZoneLabelsAr[String(name).toUpperCase()];
        return ar || CFG.ZoneFallbackAr || '';
    }
    return upper ? String(name).toUpperCase() : name;
}
function zoneSize(z) {
    const Z = CFG.Zones, t = Math.max(0, Math.min(1, (Math.sqrt(z.area) - 400) / 2600));
    return Z.districtSize * (0.8 + t * 0.6);
}
function inZone(z, x, y) {
    for (const r of z.rings) {
        let c = false;
        for (let i = 0, j = r.length - 1; i < r.length; j = i++) {
            const [xi, yi] = r[i], [xj, yj] = r[j];
            if ((yi > y) !== (yj > y) && x < ((xj - xi) * (y - yi)) / (yj - yi) + xi) c = !c;
        }
        if (c) return true;
    }
    return false;
}

function easeZones(dt) {
    const Z = CFG.Zones, big_ = mode === 'big';
    const lvCounty = big_ && big.zoom < Z.countyZoom, lvDistrict = big_ && !lvCounty && big.zoom < Z.districtZoom;
    const c = big_ ? { x: big.x, y: big.y } : null;
    const midCounty = c && ZONES.counties.find((z) => inZone(z, c.x, c.y));
    const midDistrict = c && ZONES.districts.find((z) => inZone(z, c.x, c.y));
    const k = 1 - Math.exp(-Math.min(50, dt) / Z.ease);
    let moving = false;
    const go = (key, target) => {
        const a = zAlpha[key] ?? 0, n = Math.abs(target - a) < 0.01 ? target : a + (target - a) * k;
        zAlpha[key] = n;
        if (n !== target) moving = true;
    };
    for (const z of ZONES.counties) {
        go('n:' + z.name, lvCounty ? (z === midCounty ? 1 : Z.dim) : 0);
        go('b:' + z.name, lvCounty && z === midCounty ? 1 : 0);
        go('f:' + z.name, z === midCounty ? 1 : 0);
    }
    for (const z of ZONES.districts) {
        const show = lvDistrict;
        go('n:' + z.name, show ? (z === midDistrict ? 1 : Z.dim) : 0);
        go('b:' + z.name, show && z === midDistrict ? 1 : 0);
        go('f:' + z.name, z === midDistrict ? 1 : 0);
    }
    return moving;
}
// each name is drawn once (dark outline + colour) into its own small canvas and then copied:
// drawing the text live every frame was the zoom-out lag
const labels = new Map();
document.fonts.addEventListener('loadingdone', () => labels.clear());
function label(text, font, px, colour) {
    const k = font + '|' + colour + '|' + text;
    let c = labels.get(k);
    if (!c) {
        const lw = Math.max(2, px * 0.2), pad = Math.ceil(lw);
        c = document.createElement('canvas');
        const g = c.getContext('2d');
        g.font = font;
        c.width = Math.ceil(g.measureText(text).width) + pad * 2; c.height = Math.ceil(px * 1.3) + pad * 2;
        g.font = font; g.textAlign = 'center'; g.textBaseline = 'middle';
        g.lineJoin = 'round'; g.lineWidth = lw; g.strokeStyle = 'rgba(0,0,0,0.5)';
        g.strokeText(text, c.width / 2, c.height / 2 + px * 0.06);
        g.fillStyle = colour; g.fillText(text, c.width / 2, c.height / 2);
        labels.set(k, c);
    }
    return c;
}
let zonesShown = false;
function drawZones() {
    // On the minimap there are no zone labels: clear once when leaving the big
    // map, then skip this whole canvas instead of wiping it 30 times a second.
    if (mode !== 'big' && !zonesShown) return;
    const r = boxRect, d = window.devicePixelRatio || 1;
    if (zc.width !== Math.round(r.width * d) || zc.height !== Math.round(r.height * d)) { zc.width = Math.round(r.width * d); zc.height = Math.round(r.height * d); }
    zx.setTransform(d, 0, 0, d, 0, 0);
    zx.clearRect(0, 0, r.width, r.height);
    if (mode !== 'big') { zonesShown = false; return; }
    const Z = CFG.Zones, rem = r.height / 108;
    const taken = [];
    const draw = (list, size, upper) => {
        for (const z of list) {
            const b = zAlpha['b:' + z.name] || 0, n = zAlpha['n:' + z.name] || 0;
            if (b > 0.005) {
                // the glow is two wide see-through lines under the border (canvas shadow blur cost ~25 ms a frame)
                zx.save();
                zx.lineJoin = 'round'; zx.strokeStyle = Z.border;
                const path = new Path2D();
                for (const ring of z.rings) {
                    ring.forEach(([x, y], i) => { const p = map.project(x, y); if (i) path.lineTo(p.sx, p.sy); else path.moveTo(p.sx, p.sy); });
                    path.closePath();
                }
                zx.globalAlpha = b * 0.1; zx.lineWidth = Z.borderWidth + 16; zx.stroke(path);
                zx.globalAlpha = b * 0.22; zx.lineWidth = Z.borderWidth + 7; zx.stroke(path);
                zx.globalAlpha = b; zx.lineWidth = Z.borderWidth; zx.stroke(path);
                zx.restore();
            }
            if (n > 0.005) {
                const p = map.project(z.at[0], z.at[1]), f = zAlpha['f:' + z.name] || 0;
                if (p.sx < -300 || p.sy < -100 || p.sx > r.width + 300 || p.sy > r.height + 100) continue;
                // drawn at the focused size, shrunk while not in the middle
                const full = (upper ? size : zoneSize(z)) * rem * Z.focus, s = (1 + (Z.focus - 1) * f) / Z.focus;
                const text = zoneText(z.name, upper);
                if (!text) continue;
                const img = label(text, `${upper || f > 0.5 ? 700 : 600} ${full.toFixed(1)}px BerninoNarrow, Tajawal, sans-serif`, full, upper ? Z.name : zoneColour(z.name));
                const dw = img.width * s, dh = img.height * s, w = dw / 2, h = full * s / 2 + 4;
                if (!upper && f < 0.5 && taken.some((t) => Math.abs(t[0] - p.sx) < t[2] + w && Math.abs(t[1] - p.sy) < t[3] + h)) continue;
                taken.push([p.sx, p.sy, w, h]);
                zx.globalAlpha = n;
                zx.drawImage(img, p.sx - dw / 2, p.sy - dh / 2, dw, dh);
            }
        }
    };

    const mid = ZONES.districts.filter((z) => (zAlpha['f:' + z.name] || 0) > 0.5);
    draw(mid.concat(ZONES.districts.filter((z) => mid.indexOf(z) < 0)), Z.districtSize, false);
    draw(ZONES.counties, Z.countySize, true);
    zx.globalAlpha = 1;
    zonesShown = true;
}

const at = (p) => `transform:translate(${p.sx.toFixed(1)}px,${p.sy.toFixed(1)}px)`;

let focus = null, focusAt = null;
let shownAt = [];
// blips are drawn on a canvas: moving ~280 page elements every frame was the zoom-out lag
const blipLayer = document.createElement('canvas'), bx = blipLayer.getContext('2d');
blipLayer.id = 'blipLayer';
box.insertBefore(blipLayer, marks);

const side = document.getElementById('side');
const rail = side.querySelector('.rail'), ptitle = side.querySelector('.ptitle'), prows = side.querySelector('.prows');
const menu = { cat: null, sub: null, sel: -1 };
let shownRows = [];
const sound = (name) => post('sound', { name });
const catOf = (b) => CAT_OF[b.sprite] || 'personal';
const keyOf = (b) => `${clean(b.name)}|${b.sprite}|${b.colour}`;
const distOf = (b) => pose ? Math.hypot(b.x - pose.x, b.y - pose.y) : 0;

function visible(b) {
    if (mode !== 'big' || menu.cat === null) return true;
    return catOf(b) === menu.cat || ALWAYS[b.sprite] || b.flash
        || (waypoint && Math.abs(waypoint.x - b.x) < 3 && Math.abs(waypoint.y - b.y) < 3);
}

function groupsOf(cat) {
    const g = new Map();
    for (const b of blips) {
        if (catOf(b) !== cat) continue;
        const k = keyOf(b);
        if (!g.has(k)) g.set(k, { key: k, name: clean(b.name) || `${t('blip')} ${b.sprite}`, sprite: b.sprite, colour: b.colour, blips: [] });
        g.get(k).blips.push(b);
    }
    const out = [...g.values()].sort((a, b) => a.name.localeCompare(b.name));
    for (const x of out) x.blips.sort((a, b) => distOf(a) - distOf(b));
    return out;
}

function rows() {
    if (!menu.cat) return [];
    const groups = groupsOf(menu.cat);
    if (!menu.sub) return groups.map((g) => ({ g }));
    const g = groups.find((x) => x.key === menu.sub);
    if (!g) return [];
    return [{ g, b: g.blips[0], nearest: true }, ...g.blips.map((b) => ({ g, b }))];
}

// GTA's blip pictures are a white shape with a dark outline or a black shape with a white outline: both are drawn
// once as a black shape with the details cut out, then reused (no live filters or blending)
const ICONS = {}, ICON_C = {}, RAW = {};
const EMPTY = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==';
function iconSrc(sprite) {
    if (ICONS[sprite] === undefined) {
        ICONS[sprite] = null;
        const img = new Image();
        img.onload = () => {
            const c = document.createElement('canvas'); c.width = img.width; c.height = img.height;
            const g = c.getContext('2d'); g.drawImage(img, 0, 0);
            const im = g.getImageData(0, 0, c.width, c.height), d = im.data;
            let sum = 0, n = 0;
            for (let i = 0; i < d.length; i += 4) if (d[i + 3] > 200) { sum += d[i] + d[i + 1] + d[i + 2]; n++; }
            const dark = n > 0 && sum / (n * 3) < 110;
            for (let i = 0; i < d.length; i += 4) {
                const lum = (d[i] + d[i + 1] + d[i + 2]) / 3;
                const t = Math.max(0, Math.min(1, dark ? (180 - lum) / 110 : (lum - 70) / 110));
                d[i] = d[i + 1] = d[i + 2] = 0; d[i + 3] = d[i + 3] * t;
            }
            g.putImageData(im, 0, 0);
            ICONS[sprite] = c.toDataURL();
            ICON_C[sprite] = c;
            touch(); drawSide();
        };
        img.src = `blips/${sprite}.webp`;
    }
    return ICONS[sprite] || EMPTY;
}
// one blip's look (shadow, tail, circle or box, border, icon) drawn once per sprite, colour and size
// (same shapes and sizes the old page elements had); x, y = where the blip's point sits in the image
const BAKED = new Map();
function bakedBlip(sprite, colour, sizeRem) {
    const B = CFG.Blips, rem = window.innerHeight / 108, b = sizeRem * rem;
    const plain = B.style !== 'box' && B.style !== 'round';
    const key = `${sprite}|${colour}|${b}|${B.style}|${plain ? !!RAW[sprite] : !!ICON_C[sprite]}`;
    let k = BAKED.get(key);
    if (k) return k;
    if (plain) {
        if (!RAW[sprite]) { const img = new Image(); img.onload = () => { RAW[sprite] = img; touch(); }; img.src = `blips/${sprite}.webp`; RAW[sprite] = null; }
        const c = document.createElement('canvas'); c.width = c.height = Math.ceil(b);
        if (RAW[sprite]) c.getContext('2d').drawImage(RAW[sprite], 0, 0, c.width, c.height);
        k = { c, x: b / 2, y: b / 2 };
        BAKED.set(key, k);
        return k;
    }
    iconSrc(sprite);
    const pad = Math.ceil(0.8 * rem), ax = 0.5 * b + pad, ay = 1.22 * b + pad, bw = 0.06 * b;
    const W = Math.ceil(1.12 * b + pad * 2), H = Math.ceil(1.32 * b + pad * 2);
    const shape = document.createElement('canvas'); shape.width = W; shape.height = H;
    const g = shape.getContext('2d');
    g.translate(ax, ay);
    const bg = colour || B.background;
    // the little pointer under the box, turned 45 degrees, border on its two lower sides
    g.save();
    g.translate(0.06 * b, -0.202 * b); g.rotate(Math.PI / 4);
    const t = 0.21 * b;
    g.fillStyle = bg;
    g.beginPath(); g.roundRect(-t, -t, t * 2, t * 2, [0, 0, 0.063 * b, 0]); g.fill();
    g.strokeStyle = B.border; g.lineWidth = bw;
    g.beginPath(); g.moveTo(t - bw / 2, -t); g.lineTo(t - bw / 2, t - bw / 2); g.lineTo(-t, t - bw / 2); g.stroke();
    g.restore();
    // the box itself (outer size 1.12 b, border 0.06 b)
    const L = -0.5 * b, T = -1.22 * b, O = 1.12 * b;
    g.fillStyle = bg; g.strokeStyle = B.border; g.lineWidth = bw;
    g.beginPath();
    if (B.style === 'round') g.arc(L + O / 2, T + O / 2, O / 2, 0, Math.PI * 2); else g.roundRect(L, T, O, O, O * 0.22);
    g.fill();
    g.beginPath();
    if (B.style === 'round') g.arc(L + O / 2, T + O / 2, O / 2 - bw / 2, 0, Math.PI * 2); else g.roundRect(L + bw / 2, T + bw / 2, O - bw, O - bw, O * 0.22 - bw / 2);
    g.stroke();
    const ic = ICON_C[sprite];
    if (ic) {
        const f = Math.min(0.7 * b / ic.width, 0.7 * b / ic.height), iw = ic.width * f, ih = ic.height * f;
        g.drawImage(ic, L + bw + 0.5 * b - iw / 2, T + bw + 0.5 * b - ih / 2, iw, ih);
    }
    const c = document.createElement('canvas'); c.width = W; c.height = H;
    const cg = c.getContext('2d');
    cg.shadowColor = 'rgba(0, 0, 0, 0.45)'; cg.shadowOffsetY = 0.1 * rem; cg.shadowBlur = 0.2 * rem;
    cg.drawImage(shape, 0, 0);
    k = { c, x: ax, y: ay };
    BAKED.set(key, k);
    return k;
}
const ico = (sprite, colour) => `<span class="ri" style="--bg:${colour || CFG.Blips.background}"><img src="${iconSrc(sprite)}"></span>`;

function drawRail() {
    rail.innerHTML = CFG.Categories.map((c) => `<button class="ci" data-cat="${esc(c.id)}" title="${esc(catLabel(c))}"><i style="-webkit-mask-image:url(icons/${esc(c.icon)}.svg)"></i></button>`).join('');
}

function drawSide() {
    if (mode !== 'big') return;
    side.classList.toggle('open', !!menu.cat);
    for (const el of rail.children) el.classList.toggle('on', el.dataset.cat === menu.cat);
    if (!menu.cat) { prows.innerHTML = ''; shownRows = []; return; }
    const cat = CFG.Categories.find((c) => c.id === menu.cat) || { label: '' };
    shownRows = rows();
    ptitle.textContent = menu.sub && shownRows.length ? shownRows[0].g.name : catLabel(cat);
    if (!shownRows.length) { prows.innerHTML = `<div class="empty">${esc(t('nothing'))}</div>`; return; }

    const ons = [];
    const inner = shownRows.map((r, i) => {
        const fi = focus ? r.g.blips.findIndex((b) => b.id === focus.id) : -1;
        let on = i === menu.sel, label, right = '';
        if (!r.b) {
            label = r.g.name;
            if (fi >= 0) on = true;
            if (r.g.blips.length > 1) right = fi >= 0 ? `<span class="cyc"><i class="l"></i>${fi + 1}/${r.g.blips.length}<i class="r"></i></span>` : '<i class="chev"></i>';
        } else {
            label = r.nearest ? t('nearest') : (clean(r.b.zone) || r.g.name);
            if (!r.nearest && focus && r.b.id === focus.id) on = true;
            right = `<span class="dst">${esc(distText(r.b))}</span>`;
        }
        ons[i] = on;
        return `${ico(r.g.sprite, r.g.colour)}<span class="rl">${esc(label)}</span>${right}`;
    });
    if (prows.querySelectorAll('.row').length !== inner.length) {
        prows.innerHTML = inner.map((_, i) => `<button class="row" data-i="${i}"></button>`).join('');
    }
    prows.querySelectorAll('.row').forEach((el, i) => {
        el.classList.toggle('on', ons[i]);
        if (el._html !== inner[i]) { el.innerHTML = inner[i]; el._html = inner[i]; }
    });
}

function pick(b, reveal) {
    big.pull = { x: b.x, y: b.y };
    if (reveal) {
        if (menu.cat !== catOf(b)) { menu.cat = catOf(b); menu.sub = null; }
        if (menu.sub && menu.sub !== keyOf(b)) menu.sub = null;
        menu.sel = -1;
    }
    touch();
    drawSide();
}

function openRow(i) {
    const r = shownRows[i];
    if (!r) return;
    if (r.b) { sound('nav'); pick(r.b); return; }
    if (r.g.blips.length === 1) { sound('nav'); pick(r.g.blips[0]); return; }
    sound('select');
    menu.sub = r.g.key; menu.sel = -1;
    drawSide();
}

function moveSel(d) {
    if (!shownRows.length) return;
    menu.sel = ((menu.sel < 0 ? (d > 0 ? -1 : 0) : menu.sel) + d + shownRows.length) % shownRows.length;
    sound('nav');
    const r = shownRows[menu.sel];
    pick(r.b || r.g.blips[0]);
}

function cycle(d) {
    const r = shownRows[menu.sel];
    let g = r && r.g;
    if (!g && focus && menu.cat) g = groupsOf(menu.cat).find((x) => x.blips.some((b) => b.id === focus.id));
    if (!g || g.blips.length < 2) return;
    const at = focus ? g.blips.findIndex((b) => b.id === focus.id) : -1;
    sound('side');
    pick(g.blips[(at + d + g.blips.length) % g.blips.length]);
}

function back() {
    if (menu.sub) { menu.sub = null; menu.sel = -1; sound('back'); }
    else if (menu.cat) { menu.cat = null; menu.sel = -1; sound('back'); }
    else { post('close'); return; }
    touch();
    drawSide();
}

rail.addEventListener('mousedown', (e) => {
    const el = e.button === 0 && e.target.closest('.ci');
    if (!el) return;
    if (menu.cat === el.dataset.cat) { menu.cat = null; sound('back'); }
    else { menu.cat = el.dataset.cat; sound('select'); }
    menu.sub = null; menu.sel = -1;
    touch();
    drawSide();
});
prows.addEventListener('mousedown', (e) => {
    const el = e.button === 0 && e.target.closest('.row');
    if (el) openRow(Number(el.dataset.i));
});

function blipAt(cx, cy) {
    const r = boxRect, rem = window.innerHeight / 108, R = CFG.Blips.size * 0.7 * rem;
    let best = null, bd = R;
    for (const [b, x, y] of shownAt) {
        const d = Math.hypot(cx - r.left - x, cy - r.top - y);
        if (d < bd) { bd = d; best = b; }
    }
    return best;
}
let ring = null, ringMoving = false, ringScale = 1;
const RING_SVG = '<svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="42" fill="none" stroke="rgba(0,0,0,.35)" stroke-width="8" stroke-dasharray="51.2 14.8" stroke-dashoffset="-42.6"/>'
    + '<circle cx="50" cy="50" r="42" fill="none" stroke="#fff" stroke-width="4.5" stroke-dasharray="51.2 14.8" stroke-dashoffset="-42.6"/></svg>';
const esc = (t) => String(t ?? '').replace(/[&<>"]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' })[c]);
function distText(b) {
    if (!pose) return '';
    const m = Math.hypot(b.x - pose.x, b.y - pose.y);
    return CFG.Focus.units === 'km'
        ? (m < 1000 ? `${Math.round(m)} ${t('m')}` : `${(m / 1000).toFixed(2)} ${t('km')}`)
        : `${(m / 1609.34).toFixed(2)} ${t('mi')}`;
}

const titleSize = (t) => Math.max(1.6, Math.min(2.8, 37 / (Math.max(1, t.length) * 0.62)));
function drawMarks(view) {
    let html = '';
    const B = CFG.Blips, big_ = mode === 'big', bs = big_ ? B.size : B.miniSize;
    const r = boxRect, rem = window.innerHeight / 108, cx = r.width / 2, cy = r.height / 2;
    let best = null, bd = CFG.Focus.snap * rem;
    const lift = bs * 0.6 * rem;
    const shown = [];
    shownAt = [];
    for (const b of blips) {
        if (!visible(b)) continue;
        const p = map.project(b.x, b.y);
        if (!p.visible) continue;
        shown.push([b, p]);
        if (big_) { const d = Math.hypot(p.sx - cx, p.sy - lift - cy); if (d < bd) { bd = d; best = [b, p]; } }
    }
    if ((best ? best[0].id : null) !== (focus ? focus.id : null)) { focus = best ? best[0] : null; drawSide(); }
    focus = best ? best[0] : null;
    focusAt = best ? { sx: best[1].sx, sy: best[1].sy - lift } : null;
    const d = window.devicePixelRatio || 1;
    if (blipLayer.width !== Math.round(r.width * d) || blipLayer.height !== Math.round(r.height * d)) { blipLayer.width = Math.round(r.width * d); blipLayer.height = Math.round(r.height * d); }
    bx.setTransform(d, 0, 0, d, 0, 0);
    bx.clearRect(0, 0, r.width, r.height);
    for (const [b, p] of shown) shownAt.push([b, p.sx, p.sy - lift]);
    // the focused blip is drawn last so it sits on top
    if (best) { shown.splice(shown.indexOf(best), 1); shown.push(best); }
    for (const [b, p] of shown) {
        const k = bakedBlip(b.sprite, b.colour, best && best[0] === b ? bs * CFG.Focus.grow : bs);
        bx.drawImage(k.c, Math.round(p.sx - k.x), Math.round(p.sy - k.y));
    }
    if (big_) {

        const tg = best ? { sx: best[1].sx, sy: best[1].sy - lift * CFG.Focus.grow } : { sx: cx, sy: cy };
        if (!ring) ring = { sx: tg.sx, sy: tg.sy };
        ring.sx += (tg.sx - ring.sx) * 0.35; ring.sy += (tg.sy - ring.sy) * 0.35;
        const ts = best ? CFG.Focus.ringGrow : 1;
        ringScale += (ts - ringScale) * 0.2;
        ringMoving = Math.abs(tg.sx - ring.sx) + Math.abs(tg.sy - ring.sy) > 0.5 || Math.abs(ts - ringScale) > 0.004;
        if (!ringMoving) { ring.sx = tg.sx; ring.sy = tg.sy; ringScale = ts; }
        html += `<div class="ring" style="${at(ring)} scale(${ringScale.toFixed(3)})">${RING_SVG}</div>`;
        if (best) {
            const [b, p] = best, info = b.info || {}, ar = LANG === 'ar';
            const title = (ar ? (clean(info.titleAr) || clean(b.name)) : (clean(info.title) || clean(b.name))) || `${t('blip')} ${b.sprite}`;
            const text = (ar ? clean(info.textAr) : clean(info.text)) || CFG.Focus.defaultText || '';
            html += `<div class="bdist" style="${at({ sx: p.sx, sy: p.sy })}">${esc(distText(b))}</div>`;
            html += `<div class="bcard" style="${at({ sx: p.sx, sy: p.sy })};--accent:${b.colour || CFG.Focus.accent}"><div class="bc-top"><span class="bc-ico"><img src="${iconSrc(b.sprite)}"></span>`
                + `<b style="font-size:${titleSize(title).toFixed(2)}rem">${esc(title)}</b></div>${text ? `<p>${esc(text)}</p>` : ''}</div>`;
        }
    }
    if (waypoint) {
        const p = map.project(waypoint.x, waypoint.y), s = mode === 'big' ? CFG.Waypoint.size : CFG.Waypoint.miniSize;
        if (p.visible) html += `<div class="wp" style="${at(p)};--s:${s}rem"><i></i></div>`;
    }
    if (pose) {
        const p = map.project(pose.x, pose.y, pose.z), P = CFG.Player;
        const s = mode === 'big' ? Math.min(P.maxSize, P.size + Math.max(0, ZOOM.open - big.zoom) * P.grow) : P.miniSize;
        html += `<div class="me" style="${at(p)};--s:${s.toFixed(2)}rem"><i style="transform:rotate(${(view.yaw - pose.heading).toFixed(1)}deg)"></i></div>`;
    }
    marks.innerHTML = html;
}

let lastFrame = 0;
let fade = -25;
function frame(now) {
    rafId = 0;
    inFrame = true;
    lastFrameAt = performance.now();
    const prevFrame = lastFrame;
    lastFrame = now;
    if (!ready) { inFrame = false; return; }
    if (mode === 'mini' && (!show || !hudOn())) {
        if (box.className !== 'mini hidden') box.className = 'mini hidden';
        inFrame = false;
        return;
    }
    if (mode === 'mini' && (box.className !== 'mini' || map.W < 2)) { box.className = 'mini'; sizeNow(true); need = true; }
    let view;
    let anim = false;
    if (mode === 'mini') {
        // Draw while the pose is moving (plus a short settle grace), or when
        // new data arrived. Once still, the loop stops completely.
        const moving = !cam.settled || now - lastMoveAt < MINI_GRACE;
        if (!need && !moving) { inFrame = false; return; }
        const period = 1000 / CFG.Minimap.fps;
        // Time accumulator: rAF timestamps are quantised, so counting whole
        // frames would drift (two 16.6 ms ticks must equal one 30 FPS frame).
        // The remainder carries over, keeping the average exact at 30 FPS.
        const dt = Math.max(0, Math.min(period, miniClock ? now - miniClock : period));
        miniClock = now;
        miniAcc += dt;
        if (miniAcc < period - 1) { inFrame = false; requestFrame(); return; }
        miniAcc = Math.max(0, miniAcc - period);
        view = cam.viewAt(now);
        if (!view) { inFrame = false; return; }
        anim = true;
    } else {

        if (Math.abs(big.target - big.zoom) > 0.002) {
            big.zoom += (big.target - big.zoom) * (1 - Math.exp(-Math.min(50, now - (prevFrame || now)) / CFG.Zoom.ease));
            if (Math.abs(big.target - big.zoom) <= 0.002) big.zoom = big.target;
            if (big.anchor) {
                map.setView(bigView());
                const g = groundAt(big.anchor.sx, big.anchor.sy);
                if (g) { big.x += big.anchor.x - g.x; big.y += big.anchor.y - g.y; }
            }
            need = true;
        }

        const BF = CFG.Buildings, ft = Math.max(0, Math.min(1, (BF.fadeStart - big.zoom) / (BF.fadeStart - BF.fadeEnd)));
        const fadeTarget = ft * ft * BF.maxSize + (ft > 0 ? 0 : -BF.band);
        if (Math.abs(fadeTarget - fade) > 0.05) {
            fade += (fadeTarget - fade) * (1 - Math.exp(-Math.min(50, now - (prevFrame || now)) / BF.ease));
            need = true;
        } else fade = fadeTarget;

        const dtm = Math.min(50, now - (prevFrame || now));
        if (big.goal) {
            const k = 1 - Math.exp(-dtm / CFG.Drag.move);
            big.x += (big.goal.x - big.x) * k; big.y += (big.goal.y - big.y) * k;
            if (!drag && Math.abs(big.goal.x - big.x) + Math.abs(big.goal.y - big.y) < 0.05) big.goal = null;
            need = true;
        }
        if (big.yawGoal !== undefined) {
            const k = 1 - Math.exp(-dtm / CFG.Drag.turn);
            big.yaw += (big.yawGoal - big.yaw) * k; big.tilt += (big.tiltGoal - big.tilt) * k;
            if (!drag && Math.abs(big.yawGoal - big.yaw) + Math.abs(big.tiltGoal - big.tilt) < 0.02) { big.yaw = big.yawGoal; big.tilt = big.tiltGoal; big.yawGoal = undefined; }
            need = true;
        }
        setLoop(!!(drag && drag.moved) || Math.abs(big.target - big.zoom) > 0.01);

        if (big.pull && !drag) {
            big.goal = null;
            const k = 1 - Math.exp(-Math.min(50, now - (prevFrame || now)) / CFG.Focus.pull);
            big.x += (big.pull.x - big.x) * k; big.y += (big.pull.y - big.y) * k;
            if (Math.abs(big.pull.x - big.x) + Math.abs(big.pull.y - big.y) < 0.05) big.pull = null;
            need = true;
        }
        if (ringMoving) need = true;
        if (easeZones(now - (prevFrame || now))) need = true;
        anim = need;
        if (!need) { inFrame = false; return; }
        view = bigView();
    }
    need = false;
    map.setView(view);

    map.setBuildingFade(mode === 'big' ? fade : CFG.Minimap.buildingSize, mode === 'big' ? CFG.Buildings.band : 4);
    map.render();
    drawMarks(view);
    drawZones();
    inFrame = false;

    if (mode === 'mini') {
        // Keep the 30 FPS loop alive while the pose moves or eases, then stop.
        if (!cam.settled || now - lastMoveAt < MINI_GRACE) requestFrame();
    } else if (anim || ringMoving || need) {
        requestFrame();
    }
}

// Draws immediately instead of waiting for the next animation frame. Used when
// the minimap comes back after a NUI/pause menu, so it can never return with a
// stale viewport or a blank buffer.
function renderNow() {
    if (rafId) { cancelAnimationFrame(rafId); rafId = 0; }
    if (!ready) { requestFrame(true); return; }
    // Skip the 30 FPS accumulator on a re-show and force a real draw, even if
    // the player is standing still, instead of keeping the old canvas buffer.
    need = true;
    sizeNow(true);
    miniAcc = 1000 / CFG.Minimap.fps;
    miniClock = performance.now();
    frame(performance.now());
}

if (map.canvas) map.canvas.addEventListener('webglcontextrestored', () => renderNow());

requestFrame();

window.addEventListener('message', (e) => {
    const d = e.data;
    if (d.action === 'pose') {
        const wasShow = show;
        show = !!d.show;
        let moved = false;
        // Visibility-only poses (the client's hide message) have no position.
        // Feeding undefined coords to the camera turns its smoothed position
        // into NaN, which leaves the minimap blank/offset when it returns.
        if (d.x !== undefined) {
            pose = d;
            if (d.hour !== undefined) setDay(dayAt(d.hour));
            const nowMs = performance.now();
            moved = cam.update({ x: d.x, y: d.y, heading: d.heading, camYaw: d.camYaw, speed: d.speed, inVehicle: d.inVehicle, t: nowMs });
            // Only the minimap follows pose updates. The big map is paused and gets
            // its one fresh pose on open, so pose messages must never wake its loop.
            if (moved && show) lastMoveAt = nowMs;
        }
        if (!show) {
            // Hide the minimap synchronously: while a pause menu/NUI owns the
            // screen the page's animation frames can be throttled, so waiting
            // for frame() would leave the HUD visible and glitched.
            if (mode === 'mini') {
                if (rafId) { cancelAnimationFrame(rafId); rafId = 0; }
                if (box.className !== 'mini hidden') box.className = 'mini hidden';
            }
            return;
        }
        // Coming back from a NUI/pause menu: force a full redraw right away
        // instead of waiting for rAF, which can be throttled while unfocused.
        if (!wasShow) renderNow();
        else if (moved) touch();
    } else if (d.action === 'data') {
        blips = d.blips || [];
        if (focus) focus = blips.find((b) => b.id === focus.id) || null;
        waypoint = d.waypoint || false;
        drawSide();
        // The route is only present when the client actually re-sampled it.
        // An omitted route means "keep the current one".
        if (d.route !== undefined) {
            const nextRoute = d.route || null;
            if (!sameRoute(route, nextRoute)) {
                route = nextRoute;
                showRoute();
            }
        }
        touch();
    } else if (d.action === 'route') {
        // Route-only update: the blips and waypoint have not changed, so the
        // client sends just the polyline while driving.
        const nextRoute = d.route || null;
        if (!sameRoute(route, nextRoute)) {
            route = nextRoute;
            showRoute();
            touch();
        }
    } else if (d.action === 'bigZoom') {
        big.target = d.zoom; big.anchor = null; touch();
        if (d.x) { big.x = d.x; big.y = d.y; }
        if (d.hs) HEIGHT.value = d.hs;
        if (d.flat !== undefined) big.flat = !!d.flat;
    } else if (d.action === 'big') {
        if (d.locale) {
            applyLanguage(d.locale, d.strings);
            drawHints();
            drawSide();
        }
        if (d.theme) applyTheme(d.theme);
        if (d.hud) applyHud(d.hud);
        setMode(d.open ? 'big' : 'mini');
    }
});

let drag = null;
let lastClick = 0;
let looping = false;

function setLoop(on) {
    if (on === looping) return;
    looping = on;
    post('loop', { on });
}

function groundAt(sx, sy) {
    const r = box.getBoundingClientRect();
    return map.pick(sx - r.left, sy - r.top);
}

const onMenu = (e) => !!(e.target.closest && e.target.closest('#side'));
window.addEventListener('mousedown', (e) => {
    if (mode !== 'big' || onMenu(e)) return;
    big.pull = null;
    big.anchor = null;
    map.setView(bigView());
    drag = { button: e.button, x: e.clientX, y: e.clientY, moved: false, start: groundAt(e.clientX, e.clientY) };
    if (e.button === 0) big.goal = big.goal || { x: big.x, y: big.y };
    if (e.button === 2 && big.yawGoal === undefined) { big.yawGoal = big.yaw; big.tiltGoal = big.tilt; }
});

window.addEventListener('mousemove', (e) => {
    if (!drag || mode !== 'big') return;
    const dx = e.clientX - drag.x, dy = e.clientY - drag.y;
    if (Math.abs(dx) + Math.abs(dy) > 3) drag.moved = true;
    if (drag.button === 0 && drag.start) {

        const goalView = () => Object.assign(bigView(), { x: big.goal.x, y: big.goal.y });
        map.setView(goalView());
        const now = groundAt(e.clientX, e.clientY);
        if (now) {
            const k = focus ? CFG.Focus.sticky : 1;
            big.goal.x += (drag.start.x - now.x) * k; big.goal.y += (drag.start.y - now.y) * k;
            if (k < 1) { map.setView(goalView()); drag.start = groundAt(e.clientX, e.clientY) || drag.start; }
        }
        map.setView(bigView());
    } else if (drag.button === 2) {
        big.yawGoal -= dx * 0.3;
        big.tiltGoal = Math.max(-40, Math.min(40, big.tiltGoal + dy * 0.25));
        drag.x = e.clientX; drag.y = e.clientY;
    }
    touch();
});

window.addEventListener('mouseup', (e) => {
    if (!drag || mode !== 'big') return;
    const hit = drag.button === 0 && !drag.moved ? blipAt(e.clientX, e.clientY) : null;
    if (hit && focus && hit.id === focus.id) {
        post('waypoint', { x: focus.x, y: focus.y });
    } else if (hit) {
        sound('nav');
        pick(hit, true);
    } else if (drag.button === 0 && !drag.moved) {
        const t = performance.now();
        if (t - lastClick < 350) {
            const g = groundAt(e.clientX, e.clientY);
            if (g) post('waypoint', { x: g.x, y: g.y });
        }
        lastClick = t;
    } else if (drag.button === 2 && !drag.moved && waypoint) {
        post('waypoint', { clear: true });
    }
    if (drag.button === 0 && drag.moved && focusAt) {
        const r = box.getBoundingClientRect();
        const gb = groundAt(r.left + focusAt.sx, r.top + focusAt.sy), gc = groundAt(r.left + r.width / 2, r.top + r.height / 2);
        if (gb && gc) big.pull = { x: big.x + gb.x - gc.x, y: big.y + gb.y - gc.y };
    }
    drag = null;
    touch();
});

window.addEventListener('wheel', (e) => {
    if (mode !== 'big' || onMenu(e)) return;
    big.pull = null;
    big.anchor = null;
    big.target = Math.max(ZOOM.min, Math.min(ZOOM.max, big.target - Math.sign(e.deltaY) * 0.45));
    touch();
});

window.addEventListener('contextmenu', (e) => e.preventDefault());

window.addEventListener('keydown', (e) => {
    if (mode !== 'big') return;
    if (e.key === 'Escape') back();
    else if (e.key === 'p' || e.key === 'P') post('close');
    else if (e.key === 'v' || e.key === 'V') { big.flat = !big.flat; sound('select'); touch(); }
    else if (e.key === 'r' || e.key === 'R') { if (pose) { big.pull = { x: pose.x, y: pose.y }; sound('select'); touch(); } }
    else if (e.key === 'Enter' && focus) post('waypoint', { x: focus.x, y: focus.y });
    else if (e.key === 'ArrowUp') moveSel(-1);
    else if (e.key === 'ArrowDown') moveSel(1);
    else if (e.key === 'ArrowLeft') cycle(-1);
    else if (e.key === 'ArrowRight') cycle(1);
});

window.addEventListener('resize', () => { sizeNow(); touch(); });

applyConfig(null);
function askConfig() {
    fetch(`https://${GetParentResourceName()}/ready`, { method: 'POST', body: JSON.stringify({ version: '2026-11-21d' }) })
        .then((r) => r.json()).then((c) => { if (c && c.Route) applyConfig(c); else setTimeout(askConfig, 2000); })
        .catch(() => setTimeout(askConfig, 2000));
}
askConfig();
