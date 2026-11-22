/* #####################################################################
 * #                                                                   #
 * #                 THIS SCRIPT IS MADE BY TOT                        #
 * #                 https://discord.gg/VnpMqz96YH                     #
 * #                                                                   #
 * ##################################################################### */
(() => {
    const config = { resolutionScale: 0.5, defaultBlurStrength: 8, maxBlurSize: 20 };

    // The source texture is a single solid colour, so the gaussian result is that
    // same colour. Sampling it directly keeps the exact look without a 41x41 loop
    // per pixel.
    const fragmentShaderSrc = `
  precision mediump float;
  varying vec2 v_texcoord;
  uniform sampler2D u_texture;
  uniform vec4 u_shape;
  uniform float u_borderRadius;
  float roundedBoxSDF(vec2 centerPosition, vec2 size, float radius) {
    return length(max(abs(centerPosition) - size + radius, 0.0)) - radius;
  }
  void main() {
    vec2 centerPosition = gl_FragCoord.xy - u_shape.xy;
    float distance = u_shape.w == 0.0 ? length(centerPosition) - u_shape.z : roundedBoxSDF(centerPosition, u_shape.zw, u_borderRadius);
    if (distance > 0.0) discard;
    gl_FragColor = texture2D(u_texture, v_texcoord);
  }`;

    const vertexShaderSrc = `
  attribute vec2 a_position;
  attribute vec2 a_texcoord;
  varying vec2 v_texcoord;
  void main() {
    gl_Position = vec4(a_position, 0.0, 1.0);
    v_texcoord = a_texcoord;
  }`;

    function makeShader(gl, type, src) {
        const shader = gl.createShader(type);
        gl.shaderSource(shader, src);
        gl.compileShader(shader);
        const infoLog = gl.getShaderInfoLog(shader);
        if (infoLog) console.error(infoLog);
        return shader;
    }

    function createTexture(gl) {
        const tex = gl.createTexture();
        // Dark map background, not a debug blue: if the WebGL map is still
        // warming up or unavailable, the HUD stays neutral instead of a solid
        // blue rectangle.
        const texPixels = new Uint8Array([8, 16, 26, 255]);
        gl.bindTexture(gl.TEXTURE_2D, tex);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, texPixels);
        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameterf(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        return tex;
    }

    const canvas = document.createElement('canvas');
    Object.assign(canvas.style, { position: 'fixed', left: '0', top: '0', width: '100%', height: '100%', pointerEvents: 'none', zIndex: '-1' });
    const mount = () => document.body.insertBefore(canvas, document.body.firstChild);
    if (document.body) mount(); else document.addEventListener('DOMContentLoaded', mount, { once: true });

    const gl = canvas.getContext('webgl', { antialias: false, depth: false, stencil: false, alpha: true, preserveDrawingBuffer: true, failIfMajorPerformanceCaveat: false });
    if (!gl) return;

    const tex = createTexture(gl);
    const program = gl.createProgram();
    gl.attachShader(program, makeShader(gl, gl.VERTEX_SHADER, vertexShaderSrc));
    gl.attachShader(program, makeShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSrc));
    gl.linkProgram(program);
    gl.useProgram(program);
    gl.bindTexture(gl.TEXTURE_2D, tex);
    gl.uniform1i(gl.getUniformLocation(program, 'u_texture'), 0);

    function buffer(data, attrib) {
        const buf = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, buf);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(data), gl.STATIC_DRAW);
        const loc = gl.getAttribLocation(program, attrib);
        gl.vertexAttribPointer(loc, 2, gl.FLOAT, false, 0, 0);
        gl.enableVertexAttribArray(loc);
    }
    buffer([-1, -1, 1, -1, -1, 1, 1, 1], 'a_position');
    buffer([0, 0, 1, 0, 0, 1, 1, 1], 'a_texcoord');

    const u = {
        shape: gl.getUniformLocation(program, 'u_shape'),
        radius: gl.getUniformLocation(program, 'u_borderRadius'),
    };

    function resize() {
        canvas.width = Math.ceil(window.innerWidth * config.resolutionScale);
        canvas.height = Math.ceil(window.innerHeight * config.resolutionScale);
        gl.viewport(0, 0, canvas.width, canvas.height);
    }
    resize();
    window.addEventListener('resize', () => { resize(); schedule(); });
    gl.clearColor(0, 0, 0, 0);

    function render() {
        gl.clear(gl.COLOR_BUFFER_BIT);
        const s = config.resolutionScale;
        document.querySelectorAll('[data-hlsl]').forEach((el) => {
            const rect = el.getBoundingClientRect();
            if (rect.width === 0 || rect.height === 0) return;
            const w = Math.ceil(rect.width * s), h = Math.ceil(rect.height * s);
            const left = Math.floor(rect.left * s), top = Math.floor(rect.top * s);
            const style = getComputedStyle(el);
            const radius = parseFloat(style.borderRadius) || 0;
            const circle = style.borderRadius.includes('%') && radius >= 50;
            gl.uniform4f(u.shape, left + w / 2, canvas.height - (top + h / 2), w / 2, circle ? 0 : h / 2);
            gl.uniform1f(u.radius, circle ? 0 : radius * s);
            gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
        });
    }

    // Redraw only when an observed element changes size/class. The minimap is a
    // static shape, so the old 60 FPS loop was doing no visible work.
    let raf = 0;
    function schedule() {
        if (!raf) raf = requestAnimationFrame(() => { raf = 0; render(); });
    }

    const observed = new Set();
    const resizeObserver = typeof ResizeObserver !== 'undefined' ? new ResizeObserver(schedule) : null;
    const mutationObserver = typeof MutationObserver !== 'undefined' ? new MutationObserver(schedule) : null;

    function observe(el) {
        if (!el || observed.has(el)) return;
        observed.add(el);
        if (resizeObserver) resizeObserver.observe(el);
        if (mutationObserver) mutationObserver.observe(el, { attributes: true, attributeFilter: ['class', 'data-hlsl'] });
    }

    document.querySelectorAll('[data-hlsl]').forEach(observe);
    observe(document.getElementById('map'));

    window.__ataGlassRefresh = schedule;
    schedule();
})();
