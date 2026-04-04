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
  #|   if (!globalThis.__moon8bit_ensure_audio) {
  #|     globalThis.__moon8bit_ensure_audio = () => {
  #|       const AudioCtx = globalThis.AudioContext || globalThis.webkitAudioContext;
  #|       if (!AudioCtx) return null;
  #|       if (!globalThis.__moon8bit_audio_ctx) {
  #|         globalThis.__moon8bit_audio_ctx = new AudioCtx();
  #|       }
  #|       const ctx = globalThis.__moon8bit_audio_ctx;
  #|       if (ctx.state === "suspended") {
  #|         ctx.resume().catch(() => {});
  #|       }
  #|       return ctx;
  #|     };
  #|   }
  #|   globalThis.addEventListener("keydown", (e) => {
  #|     const target = e.target;
  #|     const editable = target && (
  #|       target.tagName === "TEXTAREA" ||
  #|       target.tagName === "INPUT" ||
  #|       target.isContentEditable
  #|     );
  #|     if (!editable && (e.code === "Space" || e.code === "ArrowUp")) {
  #|       e.preventDefault();
  #|     }
  #|     globalThis.__moon8bit_keys.add(e.code);
  #|     if (globalThis.__moon8bit_ensure_audio) {
  #|       globalThis.__moon8bit_ensure_audio();
  #|     }
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
extern "js" fn web_init_sprite_editor() -> Unit =
  #| () => {
  #|   const editor = document.getElementById("moon8bit-editor");
  #|   const textarea = document.getElementById("moon8bit-dsl-input");
  #|   if (!editor || !textarea) return;
  #|
  #|   const fallbackPalette = ["#101820", "#1f4068", "#2e8b57", "#f2aa4c", "#e94f37", "#8f6f4f", "#f6f7eb", "#7f5af0"];
  #|
  #|   let panel = document.getElementById("moon8bit-sprite-panel");
  #|   if (!panel) {
  #|     panel = document.createElement("div");
  #|     panel.id = "moon8bit-sprite-panel";
  #|     panel.style.display = "grid";
  #|     panel.style.gap = "6px";
  #|     panel.style.padding = "8px";
  #|     panel.style.border = "1px solid #334e68";
  #|     panel.style.background = "#111827";
  #|     editor.appendChild(panel);
  #|   }
  #|
  #|   let title = document.getElementById("moon8bit-sprite-title");
  #|   if (!title) {
  #|     title = document.createElement("div");
  #|     title.id = "moon8bit-sprite-title";
  #|     title.textContent = "Sprite Editor (8/16/32)";
  #|     title.style.fontWeight = "600";
  #|     title.style.fontFamily = "monospace";
  #|     panel.appendChild(title);
  #|   }
  #|
  #|   let row = document.getElementById("moon8bit-sprite-row");
  #|   if (!row) {
  #|     row = document.createElement("div");
  #|     row.id = "moon8bit-sprite-row";
  #|     row.style.display = "flex";
  #|     row.style.gap = "6px";
  #|     row.style.flexWrap = "wrap";
  #|     row.style.alignItems = "center";
  #|     panel.appendChild(row);
  #|   }
  #|
  #|   let select = document.getElementById("moon8bit-sprite-select");
  #|   if (!select) {
  #|     select = document.createElement("select");
  #|     select.id = "moon8bit-sprite-select";
  #|     select.style.background = "#0f1720";
  #|     select.style.color = "#d9e2ec";
  #|     select.style.border = "1px solid #486581";
  #|     row.appendChild(select);
  #|   }
  #|
  #|   let syncBtn = document.getElementById("moon8bit-sprite-sync-btn");
  #|   if (!syncBtn) {
  #|     syncBtn = document.createElement("button");
  #|     syncBtn.id = "moon8bit-sprite-sync-btn";
  #|     syncBtn.textContent = "Sync from DSL";
  #|     syncBtn.style.padding = "4px 8px";
  #|     syncBtn.style.background = "#486581";
  #|     syncBtn.style.color = "#f6f7eb";
  #|     syncBtn.style.border = "1px solid #627d98";
  #|     row.appendChild(syncBtn);
  #|   }
  #|
  #|   let writeBtn = document.getElementById("moon8bit-sprite-write-btn");
  #|   if (!writeBtn) {
  #|     writeBtn = document.createElement("button");
  #|     writeBtn.id = "moon8bit-sprite-write-btn";
  #|     writeBtn.textContent = "Write to DSL";
  #|     writeBtn.style.padding = "4px 8px";
  #|     writeBtn.style.background = "#274060";
  #|     writeBtn.style.color = "#f6f7eb";
  #|     writeBtn.style.border = "1px solid #486581";
  #|     row.appendChild(writeBtn);
  #|   }
  #|
  #|   let applyBtn = document.getElementById("moon8bit-sprite-apply-btn");
  #|   if (!applyBtn) {
  #|     applyBtn = document.createElement("button");
  #|     applyBtn.id = "moon8bit-sprite-apply-btn";
  #|     applyBtn.textContent = "Write + Apply";
  #|     applyBtn.style.padding = "4px 8px";
  #|     applyBtn.style.background = "#2e8b57";
  #|     applyBtn.style.color = "#f6f7eb";
  #|     applyBtn.style.border = "1px solid #4aa96c";
  #|     row.appendChild(applyBtn);
  #|   }
  #|
  #|   let paletteRow = document.getElementById("moon8bit-sprite-palette");
  #|   if (!paletteRow) {
  #|     paletteRow = document.createElement("div");
  #|     paletteRow.id = "moon8bit-sprite-palette";
  #|     paletteRow.style.display = "flex";
  #|     paletteRow.style.flexWrap = "wrap";
  #|     paletteRow.style.gap = "4px";
  #|     panel.appendChild(paletteRow);
  #|   }
  #|
  #|   let canvas = document.getElementById("moon8bit-sprite-canvas");
  #|   if (!canvas) {
  #|     canvas = document.createElement("canvas");
  #|     canvas.id = "moon8bit-sprite-canvas";
  #|     canvas.style.border = "1px solid #334e68";
  #|     canvas.style.imageRendering = "pixelated";
  #|     canvas.style.touchAction = "none";
  #|     panel.appendChild(canvas);
  #|   }
  #|
  #|   let info = document.getElementById("moon8bit-sprite-info");
  #|   if (!info) {
  #|     info = document.createElement("div");
  #|     info.id = "moon8bit-sprite-info";
  #|     info.style.fontFamily = "monospace";
  #|     info.style.fontSize = "12px";
  #|     info.style.opacity = "0.8";
  #|     panel.appendChild(info);
  #|   }
  #|
  #|   if (!globalThis.__moon8bit_sprite_state) {
  #|     globalThis.__moon8bit_sprite_state = {
  #|       lines: [],
  #|       sprites: [],
  #|       palette: fallbackPalette.slice(),
  #|       selectedSprite: 0,
  #|       selectedColor: 3,
  #|       cell: 16,
  #|     };
  #|   }
  #|   const state = globalThis.__moon8bit_sprite_state;
  #|
  #|   const decodeSym = (ch) => {
  #|     if (ch === ".") return -1;
  #|     if (ch >= "0" && ch <= "9") return ch.charCodeAt(0) - 48;
  #|     if (ch >= "a" && ch <= "f") return 10 + ch.charCodeAt(0) - 97;
  #|     if (ch >= "A" && ch <= "F") return 10 + ch.charCodeAt(0) - 65;
  #|     return -1;
  #|   };
  #|   const encodeSym = (v) => {
  #|     if (v < 0) return ".";
  #|     if (v < 10) return String(v);
  #|     return "abcdef"[Math.max(0, Math.min(5, v - 10))];
  #|   };
  #|
  #|   const parseDsl = (text) => {
  #|     const lines = text.replace(/\r\n/g, "\n").replace(/\r/g, "\n").split("\n");
  #|     const palette = fallbackPalette.slice();
  #|     const sprites = [];
  #|
  #|     for (let i = 0; i < lines.length; i++) {
  #|       const t = lines[i].trim();
  #|       const cm = t.match(/^color\s+(\d+)\s+(\S+)$/i);
  #|       if (cm) {
  #|         const idx = Number(cm[1]);
  #|         if (Number.isFinite(idx) && idx >= 0 && idx < 256) {
  #|           palette[idx] = cm[2];
  #|         }
  #|       }
  #|       const sm = t.match(/^sprite\s+([^\s]+)\s+(\d+)\s+(\d+)$/);
  #|       if (!sm) continue;
  #|
  #|       const name = sm[1];
  #|       const width = Number(sm[2]);
  #|       const height = Number(sm[3]);
  #|       const dataStart = i + 1;
  #|       let endLine = dataStart + height;
  #|       const pixels = Array(Math.max(0, width * height)).fill(-1);
  #|
  #|       let row = 0;
  #|       for (let j = dataStart; j < lines.length; j++) {
  #|         const raw = lines[j].trim();
  #|         if (raw === "" || raw.startsWith("#")) continue;
  #|         if (raw === "end") {
  #|           endLine = j;
  #|           break;
  #|         }
  #|         if (row < height) {
  #|           for (let x = 0; x < Math.min(width, raw.length); x++) {
  #|             pixels[row * width + x] = decodeSym(raw[x]);
  #|           }
  #|           row += 1;
  #|         }
  #|       }
  #|       sprites.push({ name, width, height, pixels, headerLine: i, dataStart, endLine });
  #|     }
  #|     return { lines, palette, sprites };
  #|   };
  #|
  #|   const activeSprite = () => {
  #|     if (state.sprites.length === 0) return null;
  #|     const idx = Math.max(0, Math.min(state.selectedSprite, state.sprites.length - 1));
  #|     state.selectedSprite = idx;
  #|     return state.sprites[idx];
  #|   };
  #|
  #|   const colorFor = (idx) => {
  #|     if (idx < 0) return null;
  #|     return state.palette[idx] || fallbackPalette[idx % fallbackPalette.length] || "#ffffff";
  #|   };
  #|
  #|   const renderPalette = () => {
  #|     paletteRow.innerHTML = "";
  #|     const mk = (idx, hex, label) => {
  #|       const b = document.createElement("button");
  #|       b.type = "button";
  #|       b.title = label;
  #|       b.style.width = "20px";
  #|       b.style.height = "20px";
  #|       b.style.padding = "0";
  #|       b.style.border = state.selectedColor === idx ? "2px solid #f6f7eb" : "1px solid #627d98";
  #|       b.style.cursor = "pointer";
  #|       b.style.background = hex;
  #|       b.addEventListener("click", () => {
  #|         state.selectedColor = idx;
  #|         renderPalette();
  #|       });
  #|       paletteRow.appendChild(b);
  #|     };
  #|
  #|     const transparent = document.createElement("button");
  #|     transparent.type = "button";
  #|     transparent.title = "transparent";
  #|     transparent.textContent = ".";
  #|     transparent.style.width = "20px";
  #|     transparent.style.height = "20px";
  #|     transparent.style.padding = "0";
  #|     transparent.style.border = state.selectedColor < 0 ? "2px solid #f6f7eb" : "1px solid #627d98";
  #|     transparent.style.background = "linear-gradient(45deg,#334e68 25%,#1f2a37 25%,#1f2a37 50%,#334e68 50%,#334e68 75%,#1f2a37 75%)";
  #|     transparent.style.backgroundSize = "8px 8px";
  #|     transparent.style.color = "#d9e2ec";
  #|     transparent.style.cursor = "pointer";
  #|     transparent.addEventListener("click", () => {
  #|       state.selectedColor = -1;
  #|       renderPalette();
  #|     });
  #|     paletteRow.appendChild(transparent);
  #|
  #|     const maxIdx = Math.max(7, state.palette.length - 1);
  #|     for (let i = 0; i <= maxIdx; i++) {
  #|       if (!state.palette[i]) continue;
  #|       mk(i, state.palette[i], `color ${i}`);
  #|     }
  #|   };
  #|
  #|   const renderCanvas = () => {
  #|     const sprite = activeSprite();
  #|     const ctx = canvas.getContext("2d");
  #|     if (!ctx || !sprite) {
  #|       canvas.width = 1;
  #|       canvas.height = 1;
  #|       info.textContent = "No sprite found in DSL.";
  #|       return;
  #|     }
  #|     if (![8, 16, 32].includes(sprite.width) || ![8, 16, 32].includes(sprite.height)) {
  #|       info.textContent = `Sprite ${sprite.name}: ${sprite.width}x${sprite.height} (read-only: only 8/16/32 are editable).`;
  #|     } else {
  #|       info.textContent = `Editing sprite ${sprite.name} (${sprite.width}x${sprite.height})`;
  #|     }
  #|     state.cell = Math.max(8, Math.floor(256 / Math.max(sprite.width, sprite.height)));
  #|     canvas.width = sprite.width * state.cell;
  #|     canvas.height = sprite.height * state.cell;
  #|     ctx.imageSmoothingEnabled = false;
  #|     ctx.fillStyle = "#0f1720";
  #|     ctx.fillRect(0, 0, canvas.width, canvas.height);
  #|
  #|     for (let y = 0; y < sprite.height; y++) {
  #|       for (let x = 0; x < sprite.width; x++) {
  #|         const v = sprite.pixels[y * sprite.width + x];
  #|         const px = x * state.cell;
  #|         const py = y * state.cell;
  #|         if (v >= 0) {
  #|           ctx.fillStyle = colorFor(v) || "#ffffff";
  #|           ctx.fillRect(px, py, state.cell, state.cell);
  #|         } else {
  #|           ctx.fillStyle = "#1f2a37";
  #|           ctx.fillRect(px, py, state.cell, state.cell);
  #|           ctx.fillStyle = "#334e68";
  #|           ctx.fillRect(px, py, state.cell / 2, state.cell / 2);
  #|           ctx.fillRect(px + state.cell / 2, py + state.cell / 2, state.cell / 2, state.cell / 2);
  #|         }
  #|         ctx.strokeStyle = "#334e68";
  #|         ctx.lineWidth = 1;
  #|         ctx.strokeRect(px + 0.5, py + 0.5, state.cell - 1, state.cell - 1);
  #|       }
  #|     }
  #|   };
  #|
  #|   const rowsFromSprite = (sprite) => {
  #|     const rows = [];
  #|     for (let y = 0; y < sprite.height; y++) {
  #|       let row = "";
  #|       for (let x = 0; x < sprite.width; x++) {
  #|         row += encodeSym(sprite.pixels[y * sprite.width + x]);
  #|       }
  #|       rows.push(row);
  #|     }
  #|     return rows;
  #|   };
  #|
  #|   const writeSpriteToDsl = (andApply) => {
  #|     const sprite = activeSprite();
  #|     if (!sprite) return;
  #|     if (![8, 16, 32].includes(sprite.width) || ![8, 16, 32].includes(sprite.height)) {
  #|       info.textContent = `Sprite ${sprite.name} is not editable (${sprite.width}x${sprite.height}).`;
  #|       return;
  #|     }
  #|     const lines = state.lines.slice();
  #|     const rows = rowsFromSprite(sprite);
  #|     for (let i = 0; i < rows.length; i++) {
  #|       lines[sprite.dataStart + i] = rows[i];
  #|     }
  #|     const text = lines.join("\n");
  #|     textarea.value = text;
  #|     refreshFromText();
  #|     if (andApply && globalThis.__moon8bit_apply_cb) {
  #|       globalThis.__moon8bit_apply_cb();
  #|     }
  #|   };
  #|
  #|   const refreshFromText = () => {
  #|     const parsed = parseDsl(textarea.value);
  #|     state.lines = parsed.lines;
  #|     state.palette = parsed.palette;
  #|     state.sprites = parsed.sprites;
  #|
  #|     if (state.selectedSprite >= state.sprites.length) {
  #|       state.selectedSprite = 0;
  #|     }
  #|     const before = select.value;
  #|     select.innerHTML = "";
  #|     state.sprites.forEach((sp, i) => {
  #|       const opt = document.createElement("option");
  #|       opt.value = String(i);
  #|       opt.textContent = `${sp.name} (${sp.width}x${sp.height})`;
  #|       select.appendChild(opt);
  #|     });
  #|     if (state.sprites.length > 0) {
  #|       let idx = state.selectedSprite;
  #|       if (before !== "" && Number(before) >= 0 && Number(before) < state.sprites.length) {
  #|         idx = Number(before);
  #|       }
  #|       state.selectedSprite = idx;
  #|       select.value = String(idx);
  #|     }
  #|     renderPalette();
  #|     renderCanvas();
  #|   };
  #|
  #|   const paintAt = (evt) => {
  #|     const sprite = activeSprite();
  #|     if (!sprite) return;
  #|     if (![8, 16, 32].includes(sprite.width) || ![8, 16, 32].includes(sprite.height)) return;
  #|     const rect = canvas.getBoundingClientRect();
  #|     const x = Math.floor((evt.clientX - rect.left) / state.cell);
  #|     const y = Math.floor((evt.clientY - rect.top) / state.cell);
  #|     if (x < 0 || y < 0 || x >= sprite.width || y >= sprite.height) return;
  #|     const erase = (evt.buttons & 2) !== 0;
  #|     sprite.pixels[y * sprite.width + x] = erase ? -1 : state.selectedColor;
  #|     renderCanvas();
  #|   };
  #|
  #|   if (!globalThis.__moon8bit_sprite_bound) {
  #|     select.addEventListener("change", () => {
  #|       state.selectedSprite = Number(select.value) || 0;
  #|       renderCanvas();
  #|     });
  #|     syncBtn.addEventListener("click", refreshFromText);
  #|     writeBtn.addEventListener("click", () => writeSpriteToDsl(false));
  #|     applyBtn.addEventListener("click", () => writeSpriteToDsl(true));
  #|     textarea.addEventListener("input", refreshFromText);
  #|
  #|     let drawing = false;
  #|     canvas.addEventListener("pointerdown", (evt) => {
  #|       drawing = true;
  #|       paintAt(evt);
  #|     });
  #|     canvas.addEventListener("pointermove", (evt) => {
  #|       if (drawing) paintAt(evt);
  #|     });
  #|     globalThis.addEventListener("pointerup", () => {
  #|       drawing = false;
  #|     });
  #|     canvas.addEventListener("contextmenu", (evt) => evt.preventDefault());
  #|     globalThis.__moon8bit_sprite_bound = true;
  #|   }
  #|
  #|   globalThis.__moon8bit_sprite_refresh = refreshFromText;
  #|   refreshFromText();
  #| }

///|
extern "js" fn web_sprite_editor_refresh() -> Unit =
  #| () => {
  #|   if (globalThis.__moon8bit_sprite_refresh) {
  #|     globalThis.__moon8bit_sprite_refresh();
  #|   }
  #| }

///|
extern "js" fn web_audio_start_bgm() -> Unit =
  #| () => {
  #|   const ensure = globalThis.__moon8bit_ensure_audio;
  #|   if (!ensure || globalThis.__moon8bit_bgm_nodes) return;
  #|   const ctx = ensure();
  #|   if (!ctx) return;
  #|
  #|   const osc = ctx.createOscillator();
  #|   osc.type = "square";
  #|   osc.frequency.value = 110;
  #|
  #|   const lfo = ctx.createOscillator();
  #|   lfo.type = "sine";
  #|   lfo.frequency.value = 0.35;
  #|
  #|   const lfoGain = ctx.createGain();
  #|   lfoGain.gain.value = 2.5;
  #|
  #|   const gain = ctx.createGain();
  #|   gain.gain.value = 0.0;
  #|
  #|   lfo.connect(lfoGain);
  #|   lfoGain.connect(osc.frequency);
  #|   osc.connect(gain);
  #|   gain.connect(ctx.destination);
  #|
  #|   const now = ctx.currentTime;
  #|   osc.start(now);
  #|   lfo.start(now);
  #|
  #|   globalThis.__moon8bit_bgm_nodes = { osc, lfo, lfoGain, gain };
  #| }

///|
extern "js" fn web_audio_stop_bgm() -> Unit =
  #| () => {
  #|   const nodes = globalThis.__moon8bit_bgm_nodes;
  #|   if (!nodes) return;
  #|   const now = (globalThis.__moon8bit_audio_ctx && globalThis.__moon8bit_audio_ctx.currentTime) || 0;
  #|   try { nodes.gain.gain.setTargetAtTime(0.0001, now, 0.05); } catch (_) {}
  #|   try { nodes.osc.stop(now + 0.08); } catch (_) {}
  #|   try { nodes.lfo.stop(now + 0.08); } catch (_) {}
  #|   setTimeout(() => {
  #|     try { nodes.osc.disconnect(); } catch (_) {}
  #|     try { nodes.lfo.disconnect(); } catch (_) {}
  #|     try { nodes.lfoGain.disconnect(); } catch (_) {}
  #|     try { nodes.gain.disconnect(); } catch (_) {}
  #|   }, 120);
  #|   globalThis.__moon8bit_bgm_nodes = null;
  #| }

///|
extern "js" fn web_audio_play_sfx(kind : String) -> Unit =
  #| (kind) => {
  #|   const ensure = globalThis.__moon8bit_ensure_audio;
  #|   if (!ensure) return;
  #|   const ctx = ensure();
  #|   if (!ctx) return;
  #|
  #|   const osc = ctx.createOscillator();
  #|   const gain = ctx.createGain();
  #|   osc.connect(gain);
  #|   gain.connect(ctx.destination);
  #|
  #|   const now = ctx.currentTime;
  #|   let attack = 0.004;
  #|   let decay = 0.12;
  #|   let peak = 0.08;
  #|   let f0 = 520;
  #|   let f1 = 420;
  #|   let type = "square";
  #|
  #|   if (kind === "flap") {
  #|     attack = 0.001; decay = 0.06; peak = 0.12; f0 = 900; f1 = 620; type = "triangle";
  #|   } else if (kind === "hit") {
  #|     attack = 0.003; decay = 0.12; peak = 0.045; f0 = 440; f1 = 220; type = "square";
  #|   } else if (kind === "reset") {
  #|     attack = 0.003; decay = 0.1; peak = 0.06; f0 = 420; f1 = 620; type = "sine";
  #|   }
  #|
  #|   osc.type = type;
  #|   osc.frequency.setValueAtTime(f0, now);
  #|   osc.frequency.exponentialRampToValueAtTime(Math.max(40, f1), now + decay);
  #|
  #|   gain.gain.setValueAtTime(0.0001, now);
  #|   gain.gain.linearRampToValueAtTime(peak, now + attack);
  #|   gain.gain.exponentialRampToValueAtTime(0.0001, now + decay);
  #|
  #|   if (kind === "hit") {
  #|     const osc2 = ctx.createOscillator();
  #|     const gain2 = ctx.createGain();
  #|     osc2.type = "triangle";
  #|     osc2.frequency.setValueAtTime(660, now);
  #|     osc2.frequency.exponentialRampToValueAtTime(330, now + 0.09);
  #|     gain2.gain.setValueAtTime(0.0001, now);
  #|     gain2.gain.linearRampToValueAtTime(0.03, now + 0.002);
  #|     gain2.gain.exponentialRampToValueAtTime(0.0001, now + 0.09);
  #|     osc2.connect(gain2);
  #|     gain2.connect(ctx.destination);
  #|     osc2.start(now);
  #|     osc2.stop(now + 0.11);
  #|   }
  #|
  #|   osc.start(now);
  #|   osc.stop(now + decay + 0.02);
  #| }

///|
extern "js" fn web_start_loop(cb : () -> Unit, fps : Int) -> Unit =
  #| (cb, fps) => {
  #|   const interval = Math.max(1, Math.floor(1000 / Math.max(1, fps)));
  #|   setInterval(() => cb(), interval);
  #| }
