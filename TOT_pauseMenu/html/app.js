/* #####################################################################
 * #                                                                   #
 * #                 THIS SCRIPT IS MADE BY TOT                        #
 * #                 https://discord.gg/VnpMqz96YH                     #
 * #                                                                   #
 * ##################################################################### */
// TOT_pauseMenu by TOT: pause menu, settings and free camera page
const post = (name, data) => fetch(`https://${GetParentResourceName()}/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data || {}),
});
const sound = (name) => post('sound', { name });
const later = (ms, fn) => setTimeout(fn, ms);

// English fallback: the active language is sent from config.lua when the UI opens
const EN = {
    map: 'Map', game: 'Game', store: 'Store', help: 'Help', camera: 'Free Camera', settings: 'Settings',
    gameTitle: 'GAME', disconnect: 'Disconnect', exit: 'Exit', exitTitle: 'EXIT GAME',
    disconnectAsk: 'Are you sure you want to leave this server?',
    exitAsk: 'Are you sure you want to quit the game?',
    select: 'SELECT', back: 'BACK',
    settingsTitle: 'SETTINGS', restoreAll: 'RESTORE ALL', keyBindings: 'KEY BINDINGS', category: 'Category',
    on: 'On', off: 'Off', pressKey: 'Press a key', empty: 'Empty',
    no: 'NO', yes: 'YES', other: 'OTHER', confirmation: 'CONFIRMATION',
    apply: 'APPLY', applying: 'APPLYING', applySuccess: 'Settings applied.',
    applyRestart: 'Settings applied. Restart the game to finish.',
    applyNoChanges: 'No pending changes.', applyFailed: 'The game did not apply the settings. Try again.',
    cameraTitle: 'CAMERA', hideUi: 'HIDE UI',
    speed: 'Speed', speedDesc: 'The movement speed of the camera.',
    fov: 'Field of View', fovDesc: 'How wide the camera sees. The mouse wheel zooms too.',
    roll: 'Roll', rollDesc: 'Tilts the camera to the side.',
    grid: 'Grid', gridDesc: 'Shows a grid to help line up the shot.',
};

const THEME = {
    accent: '--pm-accent',
    accent2: '--pm-accent2',
    panel: '--pm-panel',
    panel2: '--pm-panel2',
    background: '--pm-bg',
    cam: '--pm-cam',
    text: '--pm-text',
    title: '--pm-title',
    active: '--pm-active',
    tint: '--pm-tint',
    button: '--pm-button',
};

function applyLook(locale, theme) {
    const rtl = locale === 'ar';
    document.documentElement.lang = locale || 'en';
    document.documentElement.dir = rtl ? 'rtl' : 'ltr';
    if (!theme) return;
    const st = document.documentElement.style;
    for (const [key, prop] of Object.entries(THEME)) {
        if (theme[key]) st.setProperty(prop, theme[key]);
    }

    // settings page background image and its colour controls
    const image = String(theme.settingsImage || 'img/settings-bg.jpg').replace(/"/g, '%22');
    st.setProperty('--pm-settings-image', `url("${image}")`);

    if (theme.settingsImageColor) {
        // recolour the photo itself: the gradient and palm trees stay, only its pink changes
        st.setProperty('--pm-settings-tint', theme.settingsImageColor);
        st.setProperty('--pm-settings-blend', 'color');
    } else {
        if (theme.settingsTint) st.setProperty('--pm-settings-tint', theme.settingsTint);
        if (theme.settingsBlend) st.setProperty('--pm-settings-blend', theme.settingsBlend);
    }

    const hue = Number(theme.settingsHue);
    const saturation = Number(theme.settingsSaturation);
    const brightness = Number(theme.settingsBrightness);
    st.setProperty('--pm-settings-filter',
        `hue-rotate(${Number.isFinite(hue) ? hue : 0}deg) ` +
        `saturate(${Number.isFinite(saturation) ? saturation : 100}%) ` +
        `brightness(${Number.isFinite(brightness) ? brightness : 100}%)`);
}

const ITEMS = [
    { id: 'map', icon: 'map' },
    { id: 'game', icon: 'device-sd-card' },
    { id: 'store', icon: 'tag' },
    { id: 'help', icon: 'help-circle' },
    { id: 'camera', icon: 'camera' },
    { id: 'settings', icon: 'adjustments-alt' },
];
const CAM_ROWS = [
    { key: 'speed', labelKey: 'speed', type: 'slider', min: 10, max: 300, step: 10, unit: '%', descKey: 'speedDesc' },
    { key: 'fov', labelKey: 'fov', type: 'slider', min: 15, max: 90, step: 1, unit: '°', descKey: 'fovDesc' },
    { key: 'roll', labelKey: 'roll', type: 'slider', min: -45, max: 45, step: 1, unit: '°', descKey: 'rollDesc' },
    { key: 'grid', labelKey: 'grid', type: 'toggle', descKey: 'gridDesc' },
];
const OFF_ON = (o) => o && o.length === 2 && /^off$/i.test(o[0]) && /^on$/i.test(o[1]);

Vue.createApp({
    data() {
        return {
            pause: null, set: null, cam: null, ask: null,
            urls: {}, tabs: [], gtaRows: {}, keymap: null,
            lang: 'en', strings: EN, toastSeq: 0,
        };
    },
    computed: {
        items() {
            return ITEMS.map((it) => Object.assign({}, it, { label: this.t(it.id) }));
        },
        gameItems() {
            return [
                { id: 'disconnect', label: this.t('disconnect'), ask: { title: this.t('disconnect'), text: this.t('disconnectAsk') } },
                { id: 'quit', label: this.t('exit'), ask: { title: this.t('exitTitle'), text: this.t('exitAsk') } },
            ];
        },
        camRows() {
            return CAM_ROWS.map((r) => Object.assign({}, r, { label: this.t(r.labelKey), desc: this.t(r.descKey) }));
        },
        tab() { return this.set && this.tabs.find((t) => t.id === this.set.tab); },

        rows() {
            const t = this.tab;
            if (!t) return [];
            const out = [];
            if (t.keys) {
                const k = this.keymap;
                if (!k) return out;
                const cats = k.categories.filter((c) => !c.restore), restore = k.categories.find((c) => c.restore);
                const ci = Math.max(0, cats.findIndex((c) => c.index === k.category));
                out.push({ section: this.t('keyBindings') });
                out.push({ key: 'kcat', label: this.t('category'), type: 'select', value: cats[ci] ? cats[ci].label : '', options: cats.map((c) => c.label), index: ci, kcat: true });
                if (restore) out.push({ key: 'krestore', label: restore.label, type: 'action', krestore: true });
                out.push({ section: (cats[ci] ? cats[ci].label : '').toUpperCase() });
                for (const r of k.rows) out.push({ key: 'k' + r.row, label: r.label, type: 'keys', krow: r.row, keys: r.keys, disabled: !r.mappable });
                return out;
            }
            for (const s of t.sections || []) {
                const list = this.gtaRows[s.page];
                if (!list || !list.length) continue;
                out.push({ section: this.tr(s.title, s.titleAr) });
                for (const r of list) {
                    if (r.type === 'select' && OFF_ON(r.options)) out.push(Object.assign({}, r, { type: 'toggle', on: r.index === 1 }));
                    else out.push(r);
                }
            }
            return out;
        },
        rowList() { return this.rows.filter((r) => !r.section); },
        selIndex() { return Math.max(0, this.rowList.findIndex((r) => r.key === (this.set && this.set.sel))); },
        selRow() { return this.set && (this.rowList.find((r) => r.key === this.set.sel) || null); },
        camDesc() {
            const r = this.cam && this.camRows.find((x) => x.key === this.cam.sel);
            return r ? r.desc : '';
        },
    },
    methods: {

        snd(name) { sound(name); },
        t(key) { return (this.strings && this.strings[key]) || EN[key] || key; },
        tr(en, ar) { return this.lang === 'ar' && ar ? ar : en; },
        tabLabel(tab) { return this.tr(tab.label, tab.labelAr); },
        applyLocale(d) {
            this.lang = d.locale === 'ar' ? 'ar' : 'en';
            this.strings = d.strings || EN;
            applyLook(this.lang, d.theme);
        },
        // a tick while the list scrolls, not more than one every 90 ms
        scrolled() {
            const t = performance.now();
            if (t - (this.lastTick || 0) > 90) { this.lastTick = t; sound('nav'); }
        },
        list() { return this.pause.sub ? this.gameItems : this.items; },
        hoverItem(i) {
            if (this.pause.sel === i) return;
            this.pause.sel = i;
            sound('nav');
        },
        moveItem(d) {
            const n = this.list().length;
            this.pause.sel = this.pause.sel < 0 ? (d > 0 ? 0 : n - 1) : (this.pause.sel + d + n) % n;
            sound('nav');
        },

        leave(cb) {
            this.pause.in = false;
            later(200, () => post(cb));
        },
        openSub(sub) {
            this.pause.in = false;
            later(150, () => {
                if (!this.pause) return;
                this.pause.sub = sub;
                this.pause.sel = 0;
                this.$nextTick(() => requestAnimationFrame(() => { if (this.pause) this.pause.in = true; }));
            });
        },
        chooseItem(i) {
            const it = this.list()[i];
            if (!it) return;
            sound('select');
            if (it.ask) { this.ask = Object.assign({ id: it.id }, it.ask); return; }
            if (it.id === 'game') this.openSub('game');
            else if (it.id === 'store') window.invokeNative('openUrl', this.urls.store);
            else if (it.id === 'help') window.invokeNative('openUrl', this.urls.help);
            else this.leave('pause:' + it.id);
        },
        pauseBack() {
            sound('back');
            if (this.pause.sub) this.openSub(null);
            else this.leave('pause:close');
        },
        answer(a) {
            const ask = this.ask;
            this.ask = null;
            if (ask.gta) { post('settings:answer', { choice: a }); return; }
            if (a === 'yes') { sound('select'); post('pause:' + ask.id); } else sound('back');
        },

        showRows() {
            this.set.rowsIn = false;
            this.$nextTick(() => requestAnimationFrame(() => requestAnimationFrame(() => {
                if (!this.set) return;
                this.set.rowsIn = true;
                if (!this.rowList.some((r) => r.key === this.set.sel) && this.rowList.length) this.set.sel = this.rowList[0].key;
            })));
        },
        switchTab(id) {
            if (!this.set || this.set.tab === id) return;
            sound('select');
            this.set.rowsIn = false;
            later(130, () => {
                if (!this.set) return;
                this.set.tab = id;
                this.set.sel = null;
                if (this.$refs.rows) this.$refs.rows.scrollTop = 0;
                if (this.tab.keys && !this.keymap) post('settings:keymap', { category: 0 });
                this.showRows();
            });
        },
        moveTab(d) {
            const i = this.tabs.findIndex((t) => t.id === this.set.tab);
            this.switchTab(this.tabs[(i + d + this.tabs.length) % this.tabs.length].id);
        },
        hoverRow(r) {
            if (this.set.sel === r.key) return;
            this.set.sel = r.key;
            sound('nav');
        },
        moveRow(d) {
            const list = this.rowList;
            if (!list.length) return;
            const i = list.findIndex((r) => r.key === this.set.sel);
            const next = list[i < 0 ? 0 : (i + d + list.length) % list.length];
            this.set.sel = next.key;
            sound('nav');
            this.$nextTick(() => {
                const el = this.$refs.rows && this.$refs.rows.querySelector('.row.on');
                if (el) el.scrollIntoView({ block: 'nearest' });
            });
        },
        pct(r) { return ((r.value - r.min) / ((r.max - r.min) || 1)) * 100; },

        markDirty() {
            if (!this.set) return;
            this.set.dirty = true;
            this.set.status = null;
            this.set.statusKind = null;
        },
        stepRow(r, d) {
            if (r.disabled) return;
            sound('side');
            if (r.kcat) return this.keyCategory(d);
            if (!r.gta) return;
            this.markDirty();
            if (r.type === 'slider') {
                const v = Math.max(r.min, Math.min(r.max, r.value + d * (r.step || 1)));
                r.value = v;
                return post('settings:gtaSet', { tab: r.gta.tab, prefId: r.gta.prefId, value: v });
            }
            if (r.gta.codeBuilt) return post('settings:gtaStep', { tab: r.gta.tab, prefId: r.gta.prefId, direction: d });
            const n = r.options.length, index = ((r.index || 0) + d + n) % n;
            this.optimistic(r, index);
            post('settings:gtaSet', { tab: r.gta.tab, prefId: r.gta.prefId, value: index });
        },
        optimistic(r, index) {
            const list = this.gtaRows[r.gta.tab] || [];
            const src = list.find((x) => x.key === r.key);
            if (src) { src.index = index; src.value = src.options[index]; }
        },
        clickRow(r) {
            if (r.disabled) return;
            if (r.type === 'toggle') this.stepRow(r, 1);
            else if (r.type === 'action') {
                sound('select');
                if (r.krestore) post('settings:restoreKeys');
                else {
                    this.markDirty();
                    post('settings:gtaTrigger', { tab: r.gta.tab, row: r.gta.row });
                }
            }
        },
        keyCategory(d) {
            const cats = this.keymap.categories.filter((c) => !c.restore);
            const i = cats.findIndex((c) => c.index === this.keymap.category);
            post('settings:keymap', { category: cats[(i + d + cats.length) % cats.length].index });
        },
        rebind(r, slot) {
            if (r.disabled || this.set.cap) return;
            sound('select');
            this.set.cap = r.krow + ':' + slot;
            post('settings:rebind', { row: r.krow, slot });
        },
        clearKeys(r) {
            if (r.disabled) return;
            sound('back');
            post('settings:clearKey', { row: r.krow, slot: 0 });
            post('settings:clearKey', { row: r.krow, slot: 1 });
        },

        slideStart(r, e, isCam) {
            const bar = e.currentTarget, rect = bar.getBoundingClientRect();
            const at = (x) => {
                let t = Math.max(0, Math.min(1, (x - rect.left) / rect.width));
                if (document.documentElement.dir === 'rtl') t = 1 - t;
                const step = r.step || 1;
                return Math.round((r.min + t * (r.max - r.min)) / step) * step;
            };
            const apply = (x) => {
                const v = at(x);
                if (isCam) { this.cam.opts[r.key] = v; post('cam:set', { key: r.key, value: v }); } else r.value = v;
            };
            apply(e.clientX);
            const move = (ev) => apply(ev.clientX);
            const up = () => {
                window.removeEventListener('mousemove', move);
                window.removeEventListener('mouseup', up);
                sound('side');
                if (!isCam && r.gta) {
                    this.markDirty();
                    post('settings:gtaSet', { tab: r.gta.tab, prefId: r.gta.prefId, value: r.value });
                }
            };
            window.addEventListener('mousemove', move);
            window.addEventListener('mouseup', up);
        },
        applySettings() {
            if (!this.set || this.set.applying || !this.set.dirty || this.set.cap) return;
            sound('select');
            this.set.applying = true;
            this.set.leaving = false;
            this.set.status = null;
            this.set.statusKind = null;
            post('settings:apply');
        },
        applyResult(d) {
            if (!this.set) return;
            this.set.applying = false;
            if (d.noChanges) {
                this.set.dirty = false;
                this.toast('applyNoChanges', 'info');
            } else if (d.ok) {
                this.set.dirty = false;
                this.toast(d.restartRequired ? 'applyRestart' : 'applySuccess', 'ok', d.restartRequired ? 12000 : 6500);
            } else {
                this.set.dirty = true;
                this.set.leaving = false;
                this.toast('applyFailed', 'bad');
            }
        },
        toast(key, kind, ms) {
            if (!this.set) return;
            this.set.status = this.t(key);
            this.set.statusKind = kind;
            const seq = ++this.toastSeq;
            const hold = ms || (kind === 'bad' ? 8000 : 6500);
            later(hold, () => {
                if (this.set && this.toastSeq === seq) {
                    this.set.status = null;
                    this.set.statusKind = null;
                }
            });
        },
        closeSettings() {
            if (!this.set || this.set.leaving) return;
            sound('back');
            this.set.leaving = true;
            this.set.applying = this.set.dirty === true;
            this.set.status = null;
            this.set.statusKind = null;
            post('settings:confirm');
        },

        hoverCam(r) {
            if (this.cam.sel === r.key) return;
            this.cam.sel = r.key;
            sound('nav');
        },
        clickCam(r) {
            if (r.type !== 'toggle') return;
            this.cam.opts[r.key] = !this.cam.opts[r.key];
            sound('side');
            post('cam:set', { key: r.key, value: this.cam.opts[r.key] });
        },
        camValue(r) { return Math.round(this.cam.opts[r.key]) + r.unit; },
        camPct(r) { return ((this.cam.opts[r.key] - r.min) / (r.max - r.min)) * 100; },
    },
    mounted() {
        window.addEventListener('message', (e) => {
            const d = e.data;
            if (d.action === 'pause:open') {
                this.applyLocale(d);
                this.urls = { store: d.store, help: d.help };
                this.pause = { in: false, sel: -1, sub: null };
                this.$nextTick(() => requestAnimationFrame(() => requestAnimationFrame(() => { if (this.pause) this.pause.in = true; })));
            } else if (d.action === 'pause:close') {
                this.pause = null;
                this.ask = null;
            } else if (d.action === 'settings:open') {
                this.applyLocale(d);
                this.tabs = d.tabs;
                this.gtaRows = {};
                this.keymap = null;
                this.set = { in: false, rowsIn: false, tab: d.tabs[0].id, sel: null, cap: null, leaving: false,
                    dirty: false, applying: false, status: null, statusKind: null };
                this.$nextTick(() => requestAnimationFrame(() => requestAnimationFrame(() => { if (this.set) { this.set.in = true; this.set.rowsIn = true; } })));
            } else if (d.action === 'settings:dirty') {
                if (this.set) this.set.dirty = d.dirty === true;
            } else if (d.action === 'settings:applying') {
                if (this.set) {
                    this.set.applying = d.on === true;
                    if (d.on) { this.set.status = null; this.set.statusKind = null; }
                }
            } else if (d.action === 'settings:applyResult') {
                this.applyResult(d);
            } else if (d.action === 'settings:gtaRows') {
                const first = !this.gtaRows[d.tab];
                this.gtaRows[d.tab] = d.rows;

                if (first && this.set && this.tab && (this.tab.sections || []).some((s) => s.page === d.tab)) this.showRows();
            } else if (d.action === 'settings:keymap') {
                const first = !this.keymap;
                this.keymap = d.page;
                if (first && this.set && this.tab && this.tab.keys) this.showRows();
            } else if (d.action === 'settings:capturing') {
                if (!d.on && this.set) this.set.cap = null;
            } else if (d.action === 'settings:gtaWarning') {
                this.ask = { gta: true, title: this.t('confirmation'), text: d.text, alt: d.alt };
            } else if (d.action === 'settings:close') {
                this.set = null;
            } else if (d.action === 'cam:open') {
                this.applyLocale(d);
                this.cam = { in: false, hidden: false, sel: 'speed', opts: d.opts };
                this.$nextTick(() => requestAnimationFrame(() => requestAnimationFrame(() => { if (this.cam) this.cam.in = true; })));
            } else if (d.action === 'cam:opts') {
                if (this.cam) Object.assign(this.cam.opts, d.opts);
            } else if (d.action === 'cam:close') {
                this.cam = null;
            }
        });
        window.addEventListener('keydown', (e) => {
            const k = e.key;
            if (this.ask) {
                if (k === 'Enter') this.answer('yes');
                else if (k === 'Escape') this.answer('no');
                else if (k === ' ' && this.ask.alt) this.answer('alt');
                return;
            }
            if (this.cam) {
                if (k === 'h' || k === 'H') { this.cam.hidden = !this.cam.hidden; sound('select'); }
                else if (k === 'Escape' || k === 'Backspace') post('cam:back');
                return;
            }
            if (this.pause) {
                if (k === 'ArrowUp') this.moveItem(-1);
                else if (k === 'ArrowDown') this.moveItem(1);
                else if (k === 'Enter' && this.pause.sel >= 0) this.chooseItem(this.pause.sel);
                else if (k === 'Escape' || k === 'Backspace') this.pauseBack();
                return;
            }
            if (this.set) {
                if (this.set.cap || this.set.leaving) return;
                if (k === 'ArrowUp') { e.preventDefault(); this.moveRow(-1); }
                else if (k === 'ArrowDown') { e.preventDefault(); this.moveRow(1); }
                else if (k === 'ArrowLeft' && this.selRow) this.stepRow(this.selRow, -1);
                else if (k === 'ArrowRight' && this.selRow) this.stepRow(this.selRow, 1);
                else if (k === 'Enter' && this.selRow) this.clickRow(this.selRow);
                else if (k === 'q' || k === 'Q') this.moveTab(-1);
                else if (k === 'e' || k === 'E') this.moveTab(1);
                else if ((k === 'x' || k === 'X') && this.set.dirty) this.applySettings();
                else if (k === 'r' || k === 'R') { sound('select'); this.markDirty(); post('settings:default'); }
                else if (k === 'Escape' || k === 'Backspace') this.closeSettings();
            }
        });
    },
}).mount('#app');
