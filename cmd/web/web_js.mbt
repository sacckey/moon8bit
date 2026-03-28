///|
extern "js" fn web_init_canvas(width : Int, height : Int, scale : Int) -> Unit =
  #| (width, height, scale) => {
  #|   let root = document.getElementById("moon8bit-root");
  #|   if (!root) {
  #|     root = document.createElement("div");
  #|     root.id = "moon8bit-root";
  #|     root.style.display = "grid";
  #|     root.style.gap = "8px";
  #|     root.style.justifyItems = "center";
  #|     document.body.appendChild(root);
  #|   }
  #|
  #|   const id = "moon8bit-canvas";
  #|   let canvas = document.getElementById(id);
  #|   if (!canvas) {
  #|     canvas = document.createElement("canvas");
  #|     canvas.id = id;
  #|     root.appendChild(canvas);
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
  #|
  #|   let editor = document.getElementById("moon8bit-editor");
  #|   if (!editor) {
  #|     editor = document.createElement("div");
  #|     editor.id = "moon8bit-editor";
  #|     editor.style.display = "grid";
  #|     editor.style.gap = "6px";
  #|     editor.style.width = `${width * scale}px`;
  #|     root.appendChild(editor);
  #|   }
  #|
  #|   let textarea = document.getElementById("moon8bit-dsl-input");
  #|   if (!textarea) {
  #|     textarea = document.createElement("textarea");
  #|     textarea.id = "moon8bit-dsl-input";
  #|     textarea.style.width = "100%";
  #|     textarea.style.height = "160px";
  #|     textarea.style.background = "#0f1720";
  #|     textarea.style.color = "#d9e2ec";
  #|     textarea.style.border = "1px solid #334e68";
  #|     textarea.style.padding = "8px";
  #|     textarea.style.fontFamily = "ui-monospace, SFMono-Regular, Menlo, monospace";
  #|     textarea.style.fontSize = "12px";
  #|     textarea.spellcheck = false;
  #|     editor.appendChild(textarea);
  #|   }
  #|
  #|   let controls = document.getElementById("moon8bit-editor-controls");
  #|   if (!controls) {
  #|     controls = document.createElement("div");
  #|     controls.id = "moon8bit-editor-controls";
  #|     controls.style.display = "flex";
  #|     controls.style.flexWrap = "wrap";
  #|     controls.style.gap = "8px";
  #|     controls.style.alignItems = "center";
  #|     editor.appendChild(controls);
  #|   }
  #|
  #|   let button = document.getElementById("moon8bit-apply-btn");
  #|   if (!button) {
  #|     button = document.createElement("button");
  #|     button.id = "moon8bit-apply-btn";
  #|     button.textContent = "Apply DSL";
  #|     button.style.padding = "6px 10px";
  #|     button.style.background = "#274060";
  #|     button.style.color = "#f6f7eb";
  #|     button.style.border = "1px solid #486581";
  #|     button.style.cursor = "pointer";
  #|     controls.appendChild(button);
  #|   }
  #|
  #|   let exportButton = document.getElementById("moon8bit-export-btn");
  #|   if (!exportButton) {
  #|     exportButton = document.createElement("button");
  #|     exportButton.id = "moon8bit-export-btn";
  #|     exportButton.textContent = "Export DSL";
  #|     exportButton.style.padding = "6px 10px";
  #|     exportButton.style.background = "#486581";
  #|     exportButton.style.color = "#f6f7eb";
  #|     exportButton.style.border = "1px solid #627d98";
  #|     exportButton.style.cursor = "pointer";
  #|     controls.appendChild(exportButton);
  #|   }
  #|
  #|   let importButton = document.getElementById("moon8bit-import-btn");
  #|   if (!importButton) {
  #|     importButton = document.createElement("button");
  #|     importButton.id = "moon8bit-import-btn";
  #|     importButton.textContent = "Import DSL";
  #|     importButton.style.padding = "6px 10px";
  #|     importButton.style.background = "#486581";
  #|     importButton.style.color = "#f6f7eb";
  #|     importButton.style.border = "1px solid #627d98";
  #|     importButton.style.cursor = "pointer";
  #|     controls.appendChild(importButton);
  #|   }
  #|
  #|   let importInput = document.getElementById("moon8bit-import-input");
  #|   if (!importInput) {
  #|     importInput = document.createElement("input");
  #|     importInput.id = "moon8bit-import-input";
  #|     importInput.type = "file";
  #|     importInput.accept = ".dsl,.txt,text/plain";
  #|     importInput.style.display = "none";
  #|     controls.appendChild(importInput);
  #|   }
  #|
  #|   let hint = document.getElementById("moon8bit-editor-hint");
  #|   if (!hint) {
  #|     hint = document.createElement("span");
  #|     hint.id = "moon8bit-editor-hint";
  #|     hint.textContent = "Ctrl/Cmd+Enter applies current DSL";
  #|     hint.style.fontFamily = "monospace";
  #|     hint.style.fontSize = "12px";
  #|     hint.style.opacity = "0.8";
  #|     controls.appendChild(hint);
  #|   }
  #|
  #|   let feedback = document.getElementById("moon8bit-editor-feedback");
  #|   if (!feedback) {
  #|     feedback = document.createElement("div");
  #|     feedback.id = "moon8bit-editor-feedback";
  #|     feedback.style.fontFamily = "monospace";
  #|     feedback.style.fontSize = "12px";
  #|     feedback.style.color = "#9fb3c8";
  #|     editor.appendChild(feedback);
  #|   }
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
  #|     const root = document.getElementById("moon8bit-root");
  #|     if (root) {
  #|       root.appendChild(el);
  #|     } else {
  #|       document.body.appendChild(el);
  #|     }
  #|   }
  #|   el.textContent = text;
  #| }

///|
extern "js" fn web_get_editor_text() -> String =
  #| () => {
  #|   const input = document.getElementById("moon8bit-dsl-input");
  #|   return input ? input.value : "";
  #| }

///|
extern "js" fn web_set_editor_text(text : String) -> Unit =
  #| (text) => {
  #|   const input = document.getElementById("moon8bit-dsl-input");
  #|   if (input) {
  #|     input.value = text;
  #|   }
  #| }

///|
extern "js" fn web_set_editor_feedback(text : String, is_error : Bool) -> Unit =
  #| (text, is_error) => {
  #|   const el = document.getElementById("moon8bit-editor-feedback");
  #|   if (!el) return;
  #|   el.textContent = text;
  #|   el.style.color = is_error ? "#ef6f6c" : "#7bd389";
  #| }

///|
extern "js" fn web_bind_apply(cb : () -> Unit) -> Unit =
  #| (cb) => {
  #|   globalThis.__moon8bit_apply_cb = cb;
  #|   if (globalThis.__moon8bit_apply_bound) {
  #|     return;
  #|   }
  #|   const button = document.getElementById("moon8bit-apply-btn");
  #|   const input = document.getElementById("moon8bit-dsl-input");
  #|   if (!button || !input) return;
  #|   const run = () => {
  #|     if (globalThis.__moon8bit_apply_cb) {
  #|       globalThis.__moon8bit_apply_cb();
  #|     }
  #|   };
  #|   button.addEventListener("click", run);
  #|   input.addEventListener("keydown", (e) => {
  #|     if ((e.ctrlKey || e.metaKey) && e.key === "Enter") {
  #|       e.preventDefault();
  #|       run();
  #|     }
  #|   });
  #|   globalThis.__moon8bit_apply_bound = true;
  #| }

///|
extern "js" fn web_bind_export(cb : () -> Unit) -> Unit =
  #| (cb) => {
  #|   globalThis.__moon8bit_export_cb = cb;
  #|   if (globalThis.__moon8bit_export_bound) {
  #|     return;
  #|   }
  #|   const button = document.getElementById("moon8bit-export-btn");
  #|   if (!button) return;
  #|   button.addEventListener("click", () => {
  #|     if (globalThis.__moon8bit_export_cb) {
  #|       globalThis.__moon8bit_export_cb();
  #|     }
  #|   });
  #|   globalThis.__moon8bit_export_bound = true;
  #| }

///|
extern "js" fn web_bind_import(cb : (String) -> Unit) -> Unit =
  #| (cb) => {
  #|   globalThis.__moon8bit_import_cb = cb;
  #|   if (globalThis.__moon8bit_import_bound) {
  #|     return;
  #|   }
  #|   const button = document.getElementById("moon8bit-import-btn");
  #|   const input = document.getElementById("moon8bit-import-input");
  #|   if (!button || !input) return;
  #|
  #|   button.addEventListener("click", () => input.click());
  #|   input.addEventListener("change", async () => {
  #|     const file = input.files && input.files[0];
  #|     if (!file) return;
  #|     try {
  #|       const text = await file.text();
  #|       if (globalThis.__moon8bit_import_cb) {
  #|         globalThis.__moon8bit_import_cb(text);
  #|       }
  #|     } catch (error) {
  #|       console.error("moon8bit import failed", error);
  #|     } finally {
  #|       input.value = "";
  #|     }
  #|   });
  #|   globalThis.__moon8bit_import_bound = true;
  #| }

///|
extern "js" fn web_download_text(filename : String, text : String) -> Unit =
  #| (filename, text) => {
  #|   const blob = new Blob([text], { type: "text/plain;charset=utf-8" });
  #|   const url = URL.createObjectURL(blob);
  #|   const link = document.createElement("a");
  #|   link.href = url;
  #|   link.download = filename;
  #|   link.style.display = "none";
  #|   document.body.appendChild(link);
  #|   link.click();
  #|   document.body.removeChild(link);
  #|   URL.revokeObjectURL(url);
  #| }

///|
extern "js" fn web_start_loop(cb : () -> Unit, fps : Int) -> Unit =
  #| (cb, fps) => {
  #|   const interval = Math.max(1, Math.floor(1000 / Math.max(1, fps)));
  #|   setInterval(() => cb(), interval);
  #| }
