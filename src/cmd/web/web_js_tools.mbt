///|
extern "js" fn web_init_sprite_editor() -> Unit =
  #| () => {
  #|   const editor = document.getElementById("moon8bit-tab-panel-sprite") || document.getElementById("moon8bit-editor");
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
  #|   if (globalThis.__moon8bit_audio_start_bgm_impl) {
  #|     globalThis.__moon8bit_audio_start_bgm_impl();
  #|   }
  #| }

///|
extern "js" fn web_audio_stop_bgm() -> Unit =
  #| () => {
  #|   if (globalThis.__moon8bit_audio_stop_bgm_impl) {
  #|     globalThis.__moon8bit_audio_stop_bgm_impl();
  #|   }
  #| }

///|
extern "js" fn web_audio_play_sfx(kind : String) -> Unit =
  #| (kind) => {
  #|   if (globalThis.__moon8bit_audio_play_sfx_impl) {
  #|     globalThis.__moon8bit_audio_play_sfx_impl(kind);
  #|   }
  #| }

///|
extern "js" fn web_start_loop(cb : () -> Unit, fps : Int) -> Unit =
  #| (cb, fps) => {
  #|   if (globalThis.__moon8bit_loop_stop) {
  #|     globalThis.__moon8bit_loop_stop();
  #|   }
  #|
  #|   const targetFps = Math.max(1, fps | 0);
  #|   const stepMs = 1000 / targetFps;
  #|   const maxCatchUpSteps = 8;
  #|   let acc = 0;
  #|   let prev = performance.now();
  #|   let rafId = 0;
  #|   let stopped = false;
  #|
  #|   const frame = (now) => {
  #|     if (stopped) return;
  #|     let delta = now - prev;
  #|     prev = now;
  #|     if (delta < 0) delta = 0;
  #|     if (delta > 250) delta = 250;
  #|     acc += delta;
  #|
  #|     let steps = 0;
  #|     while (acc >= stepMs && steps < maxCatchUpSteps) {
  #|       cb();
  #|       acc -= stepMs;
  #|       steps += 1;
  #|     }
  #|
  #|     rafId = requestAnimationFrame(frame);
  #|   };
  #|
  #|   globalThis.__moon8bit_loop_stop = () => {
  #|     stopped = true;
  #|     if (rafId) cancelAnimationFrame(rafId);
  #|     rafId = 0;
  #|   };
  #|
  #|   rafId = requestAnimationFrame(frame);
  #| }
