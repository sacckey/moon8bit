///|
extern "js" fn web_init_canvas(width : Int, height : Int, scale : Int) -> Unit =
  #| (width, height, scale) => {
  #|   const id = "moon8bit-canvas";
  #|   let canvas = document.getElementById(id);
  #|   if (!canvas) {
  #|     canvas = document.createElement("canvas");
  #|     canvas.id = id;
  #|     document.body.appendChild(canvas);
  #|   }
  #|   canvas.width = width;
  #|   canvas.height = height;
  #|   canvas.style.width = `${width * scale}px`;
  #|   canvas.style.height = `${height * scale}px`;
  #|   canvas.style.imageRendering = "pixelated";
  #|   canvas.style.border = "2px solid #333";
  #|   const ctx = canvas.getContext("2d", { alpha: false });
  #|   if (!ctx) {
  #|     throw new Error("2d context is unavailable");
  #|   }
  #|   ctx.imageSmoothingEnabled = false;
  #|   globalThis.__moon8bit_ctx = ctx;
  #|   globalThis.__moon8bit_keys = new Set();
  #|   globalThis.addEventListener("keydown", (e) => {
  #|     globalThis.__moon8bit_keys.add(e.code);
  #|   });
  #|   globalThis.addEventListener("keyup", (e) => {
  #|     globalThis.__moon8bit_keys.delete(e.code);
  #|   });
  #| }

///|
extern "js" fn web_key_down(code : String) -> Bool =
  #| (code) => !!(globalThis.__moon8bit_keys && globalThis.__moon8bit_keys.has(code))

///|
extern "js" fn web_clear(color : String) -> Unit =
  #| (color) => {
  #|   const ctx = globalThis.__moon8bit_ctx;
  #|   if (!ctx) return;
  #|   ctx.fillStyle = color;
  #|   ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);
  #| }

///|
extern "js" fn web_fill_rect(
  x : Int,
  y : Int,
  w : Int,
  h : Int,
  color : String,
) -> Unit =
  #| (x, y, w, h, color) => {
  #|   const ctx = globalThis.__moon8bit_ctx;
  #|   if (!ctx) return;
  #|   ctx.fillStyle = color;
  #|   ctx.fillRect(x, y, w, h);
  #| }

///|
extern "js" fn web_set_status(text : String) -> Unit =
  #| (text) => {
  #|   const id = "moon8bit-status";
  #|   let el = document.getElementById(id);
  #|   if (!el) {
  #|     el = document.createElement("div");
  #|     el.id = id;
  #|     el.style.marginTop = "8px";
  #|     el.style.fontFamily = "monospace";
  #|     el.style.color = "#d9e2ec";
  #|     document.body.appendChild(el);
  #|   }
  #|   el.textContent = text;
  #| }

///|
extern "js" fn web_start_loop(cb : () -> Unit, fps : Int) -> Unit =
  #| (cb, fps) => {
  #|   const interval = Math.max(1, Math.floor(1000 / Math.max(1, fps)));
  #|   setInterval(() => cb(), interval);
  #| }
