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
extern "js" fn web_init_tilemap_editor() -> Unit =
  #| () => {
  #|   const mapEditor = document.getElementById("moon8bit-tab-panel-tilemap") || document.getElementById("moon8bit-editor");
  #|   const tileEditor = document.getElementById("moon8bit-tab-panel-tile") || mapEditor;
  #|   const textarea = document.getElementById("moon8bit-dsl-input");
  #|   if (!mapEditor || !tileEditor || !textarea) return;
  #|
  #|   const fallbackPalette = ["#101820", "#1f4068", "#2e8b57", "#f2aa4c", "#e94f37", "#8f6f4f", "#f6f7eb", "#7f5af0"];
  #|
  #|   let panel = document.getElementById("moon8bit-tilemap-panel");
  #|   if (!panel) {
  #|     panel = document.createElement("div");
  #|     panel.id = "moon8bit-tilemap-panel";
  #|     panel.style.display = "grid";
  #|     panel.style.gap = "6px";
  #|     panel.style.padding = "8px";
  #|     panel.style.border = "1px solid #334e68";
  #|     panel.style.background = "#111827";
  #|   }
  #|   if (panel.parentElement !== mapEditor) {
  #|     mapEditor.appendChild(panel);
  #|   }
  #|
  #|   let title = document.getElementById("moon8bit-tilemap-title");
  #|   if (!title) {
  #|     title = document.createElement("div");
  #|     title.id = "moon8bit-tilemap-title";
  #|     title.textContent = "Tilemap Editor (8x8)";
  #|     title.style.fontWeight = "600";
  #|     title.style.fontFamily = "monospace";
  #|   }
  #|   if (title.parentElement !== panel) {
  #|     panel.appendChild(title);
  #|   }
  #|
  #|   let row = document.getElementById("moon8bit-tilemap-row");
  #|   if (!row) {
  #|     row = document.createElement("div");
  #|     row.id = "moon8bit-tilemap-row";
  #|     row.style.display = "flex";
  #|     row.style.gap = "6px";
  #|     row.style.flexWrap = "wrap";
  #|     row.style.alignItems = "center";
  #|   }
  #|   if (row.parentElement !== panel) {
  #|     panel.appendChild(row);
  #|   }
  #|
  #|   let mapSelect = document.getElementById("moon8bit-tilemap-select");
  #|   if (!mapSelect) {
  #|     mapSelect = document.createElement("select");
  #|     mapSelect.id = "moon8bit-tilemap-select";
  #|     mapSelect.style.background = "#0f1720";
  #|     mapSelect.style.color = "#d9e2ec";
  #|     mapSelect.style.border = "1px solid #486581";
  #|   }
  #|   if (mapSelect.parentElement !== row) {
  #|     row.appendChild(mapSelect);
  #|   }
  #|
  #|   let brushSelect = document.getElementById("moon8bit-tilemap-brush");
  #|   if (!brushSelect) {
  #|     brushSelect = document.createElement("select");
  #|     brushSelect.id = "moon8bit-tilemap-brush";
  #|     brushSelect.style.background = "#0f1720";
  #|     brushSelect.style.color = "#d9e2ec";
  #|     brushSelect.style.border = "1px solid #486581";
  #|   }
  #|   if (brushSelect.parentElement !== row) {
  #|     row.appendChild(brushSelect);
  #|   }
  #|
  #|   let mapWInput = document.getElementById("moon8bit-tilemap-width");
  #|   if (!mapWInput) {
  #|     mapWInput = document.createElement("input");
  #|     mapWInput.id = "moon8bit-tilemap-width";
  #|     mapWInput.type = "number";
  #|     mapWInput.min = "1";
  #|     mapWInput.max = "256";
  #|     mapWInput.value = "16";
  #|     mapWInput.style.width = "64px";
  #|     mapWInput.style.background = "#0f1720";
  #|     mapWInput.style.color = "#d9e2ec";
  #|     mapWInput.style.border = "1px solid #486581";
  #|     mapWInput.title = "tilemap width";
  #|   }
  #|   if (mapWInput.parentElement !== row) {
  #|     row.appendChild(mapWInput);
  #|   }
  #|   let mapHInput = document.getElementById("moon8bit-tilemap-height");
  #|   if (!mapHInput) {
  #|     mapHInput = document.createElement("input");
  #|     mapHInput.id = "moon8bit-tilemap-height";
  #|     mapHInput.type = "number";
  #|     mapHInput.min = "1";
  #|     mapHInput.max = "256";
  #|     mapHInput.value = "16";
  #|     mapHInput.style.width = "64px";
  #|     mapHInput.style.background = "#0f1720";
  #|     mapHInput.style.color = "#d9e2ec";
  #|     mapHInput.style.border = "1px solid #486581";
  #|     mapHInput.title = "tilemap height";
  #|   }
  #|   if (mapHInput.parentElement !== row) {
  #|     row.appendChild(mapHInput);
  #|   }
  #|
  #|   const ensureBtn = (id, label, bg, border) => {
  #|     let btn = document.getElementById(id);
  #|     if (!btn) {
  #|       btn = document.createElement("button");
  #|       btn.id = id;
  #|       btn.textContent = label;
  #|       btn.style.padding = "4px 8px";
  #|       btn.style.background = bg;
  #|       btn.style.color = "#f6f7eb";
  #|       btn.style.border = `1px solid ${border}`;
  #|       btn.style.cursor = "pointer";
  #|     }
  #|     if (btn.parentElement !== row) {
  #|       row.appendChild(btn);
  #|     }
  #|     return btn;
  #|   };
  #|
  #|   const syncBtn = ensureBtn("moon8bit-tilemap-sync-btn", "Sync from DSL", "#486581", "#627d98");
  #|   const writeBtn = ensureBtn("moon8bit-tilemap-write-btn", "Write to DSL", "#274060", "#486581");
  #|   const applyBtn = ensureBtn("moon8bit-tilemap-apply-btn", "Write + Apply", "#2e8b57", "#4aa96c");
  #|   const addMapBtn = ensureBtn("moon8bit-tilemap-add-btn", "+ Map", "#274060", "#486581");
  #|   const delMapBtn = ensureBtn("moon8bit-tilemap-del-btn", "Del Map", "#7a2e2e", "#964040");
  #|   const resizeMapBtn = ensureBtn("moon8bit-tilemap-resize-btn", "Resize", "#486581", "#627d98");
  #|
  #|   let canvas = document.getElementById("moon8bit-tilemap-canvas");
  #|   if (!canvas) {
  #|     canvas = document.createElement("canvas");
  #|     canvas.id = "moon8bit-tilemap-canvas";
  #|     canvas.style.border = "1px solid #334e68";
  #|     canvas.style.imageRendering = "pixelated";
  #|     canvas.style.touchAction = "none";
  #|   }
  #|   if (canvas.parentElement !== panel) {
  #|     panel.appendChild(canvas);
  #|   }
  #|
  #|   let tilePanel = document.getElementById("moon8bit-tile-panel");
  #|   if (!tilePanel) {
  #|     tilePanel = document.createElement("div");
  #|     tilePanel.id = "moon8bit-tile-panel";
  #|     tilePanel.style.display = "grid";
  #|     tilePanel.style.gap = "6px";
  #|     tilePanel.style.padding = "8px";
  #|     tilePanel.style.border = "1px solid #334e68";
  #|     tilePanel.style.background = "#111827";
  #|   }
  #|   if (tilePanel.parentElement !== tileEditor) {
  #|     tileEditor.appendChild(tilePanel);
  #|   }
  #|
  #|   let tileTitle = document.getElementById("moon8bit-tile-title");
  #|   if (!tileTitle) {
  #|     tileTitle = document.createElement("div");
  #|     tileTitle.id = "moon8bit-tile-title";
  #|     tileTitle.textContent = "Tile Editor (8x8)";
  #|     tileTitle.style.fontWeight = "600";
  #|     tileTitle.style.fontFamily = "monospace";
  #|   }
  #|   if (tileTitle.parentElement !== tilePanel) {
  #|     tilePanel.appendChild(tileTitle);
  #|   }
  #|
  #|   let tileRow = document.getElementById("moon8bit-tile-row");
  #|   if (!tileRow) {
  #|     tileRow = document.createElement("div");
  #|     tileRow.id = "moon8bit-tile-row";
  #|     tileRow.style.display = "flex";
  #|     tileRow.style.gap = "6px";
  #|     tileRow.style.flexWrap = "wrap";
  #|     tileRow.style.alignItems = "center";
  #|   }
  #|   if (tileRow.parentElement !== tilePanel) {
  #|     tilePanel.appendChild(tileRow);
  #|   }
  #|
  #|   let tileSelect = document.getElementById("moon8bit-tile-select");
  #|   if (!tileSelect) {
  #|     tileSelect = document.createElement("select");
  #|     tileSelect.id = "moon8bit-tile-select";
  #|     tileSelect.style.background = "#0f1720";
  #|     tileSelect.style.color = "#d9e2ec";
  #|     tileSelect.style.border = "1px solid #486581";
  #|   }
  #|   if (tileSelect.parentElement !== tileRow) {
  #|     tileRow.appendChild(tileSelect);
  #|   }
  #|
  #|   let tileNameInput = document.getElementById("moon8bit-tilemap-tile-name");
  #|   if (!tileNameInput) {
  #|     tileNameInput = document.createElement("input");
  #|     tileNameInput.id = "moon8bit-tilemap-tile-name";
  #|     tileNameInput.type = "text";
  #|     tileNameInput.placeholder = "selected tile name";
  #|     tileNameInput.style.width = "160px";
  #|     tileNameInput.style.background = "#0f1720";
  #|     tileNameInput.style.color = "#d9e2ec";
  #|     tileNameInput.style.border = "1px solid #486581";
  #|   }
  #|   if (tileNameInput.parentElement !== tileRow) {
  #|     tileRow.appendChild(tileNameInput);
  #|   }
  #|
  #|   let solidWrap = document.getElementById("moon8bit-tilemap-solid-wrap");
  #|   if (!solidWrap) {
  #|     solidWrap = document.createElement("label");
  #|     solidWrap.id = "moon8bit-tilemap-solid-wrap";
  #|     solidWrap.style.display = "inline-flex";
  #|     solidWrap.style.alignItems = "center";
  #|     solidWrap.style.gap = "4px";
  #|     solidWrap.style.fontFamily = "monospace";
  #|     solidWrap.style.fontSize = "12px";
  #|   }
  #|   if (solidWrap.parentElement !== tileRow) {
  #|     tileRow.appendChild(solidWrap);
  #|   }
  #|   let solidInput = document.getElementById("moon8bit-tilemap-solid");
  #|   if (!solidInput) {
  #|     solidInput = document.createElement("input");
  #|     solidInput.id = "moon8bit-tilemap-solid";
  #|     solidInput.type = "checkbox";
  #|     solidWrap.appendChild(solidInput);
  #|     const txt = document.createElement("span");
  #|     txt.textContent = "selected tile is solid";
  #|     solidWrap.appendChild(txt);
  #|   }
  #|
  #|   const ensureTileBtn = (id, label, bg, border) => {
  #|     let btn = document.getElementById(id);
  #|     if (!btn) {
  #|       btn = document.createElement("button");
  #|       btn.id = id;
  #|       btn.textContent = label;
  #|       btn.style.padding = "4px 8px";
  #|       btn.style.background = bg;
  #|       btn.style.color = "#f6f7eb";
  #|       btn.style.border = `1px solid ${border}`;
  #|       btn.style.cursor = "pointer";
  #|     }
  #|     if (btn.parentElement !== tileRow) {
  #|       tileRow.appendChild(btn);
  #|     }
  #|     return btn;
  #|   };
  #|   const addTileBtn = ensureTileBtn("moon8bit-tile-add-btn", "+ Tile", "#274060", "#486581");
  #|   const delTileBtn = ensureTileBtn("moon8bit-tile-del-btn", "Del Tile", "#7a2e2e", "#964040");
  #|
  #|   let tilePaletteRow = document.getElementById("moon8bit-tilemap-palette");
  #|   if (!tilePaletteRow) {
  #|     tilePaletteRow = document.createElement("div");
  #|     tilePaletteRow.id = "moon8bit-tilemap-palette";
  #|     tilePaletteRow.style.display = "flex";
  #|     tilePaletteRow.style.flexWrap = "wrap";
  #|     tilePaletteRow.style.gap = "4px";
  #|   }
  #|   if (tilePaletteRow.parentElement !== tilePanel) {
  #|     tilePanel.appendChild(tilePaletteRow);
  #|   }
  #|
  #|   let tileCanvas = document.getElementById("moon8bit-tilemap-tile-canvas");
  #|   if (!tileCanvas) {
  #|     tileCanvas = document.createElement("canvas");
  #|     tileCanvas.id = "moon8bit-tilemap-tile-canvas";
  #|     tileCanvas.style.border = "1px solid #334e68";
  #|     tileCanvas.style.imageRendering = "pixelated";
  #|     tileCanvas.style.touchAction = "none";
  #|   }
  #|   if (tileCanvas.parentElement !== tilePanel) {
  #|     tilePanel.appendChild(tileCanvas);
  #|   }
  #|
  #|   let tileInfo = document.getElementById("moon8bit-tilemap-tile-info");
  #|   if (!tileInfo) {
  #|     tileInfo = document.createElement("div");
  #|     tileInfo.id = "moon8bit-tilemap-tile-info";
  #|     tileInfo.style.fontFamily = "monospace";
  #|     tileInfo.style.fontSize = "12px";
  #|     tileInfo.style.opacity = "0.8";
  #|   }
  #|   if (tileInfo.parentElement !== tilePanel) {
  #|     tilePanel.appendChild(tileInfo);
  #|   }
  #|
  #|   let info = document.getElementById("moon8bit-tilemap-info");
  #|   if (!info) {
  #|     info = document.createElement("div");
  #|     info.id = "moon8bit-tilemap-info";
  #|     info.style.fontFamily = "monospace";
  #|     info.style.fontSize = "12px";
  #|     info.style.opacity = "0.8";
  #|   }
  #|   if (info.parentElement !== panel) {
  #|     panel.appendChild(info);
  #|   }
  #|
  #|   let dirty = document.getElementById("moon8bit-tilemap-dirty");
  #|   if (!dirty) {
  #|     dirty = document.createElement("div");
  #|     dirty.id = "moon8bit-tilemap-dirty";
  #|     dirty.style.fontFamily = "monospace";
  #|     dirty.style.fontSize = "12px";
  #|     dirty.style.color = "#7bd389";
  #|     dirty.textContent = "Saved";
  #|   }
  #|   if (dirty.parentElement !== panel) {
  #|     panel.appendChild(dirty);
  #|   }
  #|
  #|   let feedback = document.getElementById("moon8bit-tilemap-feedback");
  #|   if (!feedback) {
  #|     feedback = document.createElement("div");
  #|     feedback.id = "moon8bit-tilemap-feedback";
  #|     feedback.style.fontFamily = "monospace";
  #|     feedback.style.fontSize = "12px";
  #|     feedback.style.color = "#9fb3c8";
  #|   }
  #|   if (feedback.parentElement !== panel) {
  #|     panel.appendChild(feedback);
  #|   }
  #|
  #|   if (!globalThis.__moon8bit_tilemap_state) {
  #|     globalThis.__moon8bit_tilemap_state = {
  #|       lines: [],
  #|       palette: fallbackPalette.slice(),
  #|       tileset: null,
  #|       tileRange: null,
  #|       tilemaps: [],
  #|       tilemapRange: null,
  #|       errors: [],
  #|       selectedMap: 0,
  #|       selectedToken: -1,
  #|       selectedTileColor: 0,
  #|       dirty: false,
  #|       cell: 16,
  #|       tileCell: 20,
  #|     };
  #|   }
  #|   const state = globalThis.__moon8bit_tilemap_state;
  #|
  #|   const setDirty = (v) => {
  #|     state.dirty = !!v;
  #|     dirty.textContent = state.dirty ? "Modified" : "Saved";
  #|     dirty.style.color = state.dirty ? "#efb366" : "#7bd389";
  #|   };
  #|   const setFeedback = (msg, isErr = false) => {
  #|     feedback.textContent = msg || "";
  #|     feedback.style.color = isErr ? "#ef6f6c" : "#9fb3c8";
  #|   };
  #|
  #|   const decodeSym = (ch) => {
  #|     if (ch === ".") return -1;
  #|     if (ch >= "0" && ch <= "9") return ch.charCodeAt(0) - 48;
  #|     if (ch >= "a" && ch <= "f") return 10 + ch.charCodeAt(0) - 97;
  #|     if (ch >= "A" && ch <= "F") return 10 + ch.charCodeAt(0) - 65;
  #|     return -1;
  #|   };
  #|   const encodeTileSym = (v) => {
  #|     if (v < 0) return ".";
  #|     if (v < 10) return String(v);
  #|     if (v < 16) return "abcdef"[v - 10];
  #|     return ".";
  #|   };
  #|
  #|   const colorFor = (idx) => {
  #|     if (idx < 0) return null;
  #|     return state.palette[idx] || fallbackPalette[idx % fallbackPalette.length] || "#ffffff";
  #|   };
  #|
  #|   const parseDsl = (text) => {
  #|     const lines = String(text || "").replace(/\r\n/g, "\n").replace(/\r/g, "\n").split("\n");
  #|     const palette = fallbackPalette.slice();
  #|     const tileset = {
  #|       tile_count: 256,
  #|       tile_names: Array.from({ length: 256 }, (_, i) => `tile_${i}`),
  #|       tile_solid: Array(256).fill(false),
  #|       tile_defined: Array(256).fill(false),
  #|       pixels: Array(256 * 64).fill(-1),
  #|     };
  #|     const tilemaps = [];
  #|     let tileFirstHeader = -1;
  #|     let tileLastEnd = -1;
  #|     let tilemapFirstHeader = -1;
  #|     let tilemapLastEnd = -1;
  #|     const errors = [];
  #|     const pushErr = (line, message) => {
  #|       errors.push({ line, message });
  #|     };
  #|     const isIgnorable = (raw) => raw === "" || raw.startsWith("#");
  #|     const parseIntStrict = (token) => (/^-?\d+$/.test(token) ? Number(token) : NaN);
  #|
  #|     for (let i = 0; i < lines.length; i += 1) {
  #|       const t = lines[i].trim();
  #|       if (isIgnorable(t)) continue;
  #|
  #|       const cm = t.match(/^color\s+(\d+)\s+(\S+)$/i);
  #|       if (cm) {
  #|         const idx = Number(cm[1]);
  #|         if (Number.isFinite(idx) && idx >= 0 && idx < 256) {
  #|           palette[idx] = cm[2];
  #|         }
  #|         continue;
  #|       }
  #|
  #|       if (/^tileset\s+/i.test(t)) {
  #|         pushErr(i + 1, "tileset directive was removed; use top-level `tile <id> ... end` blocks");
  #|         continue;
  #|       }
  #|
  #|       const tileHeader = t.match(/^tile\s+(-?\d+)(?:\s+(.*))?$/i);
  #|       if (tileHeader) {
  #|         const headerIndex = i;
  #|         const id = parseIntStrict(tileHeader[1]);
  #|         if (!Number.isFinite(id) || id < 0 || id > 255) {
  #|           pushErr(i + 1, "tile id must be in 0..255");
  #|         }
  #|         let tileName = Number.isFinite(id) ? `tile_${id}` : "tile_0";
  #|         let hasName = false;
  #|         let solid = false;
  #|         const attrs = (tileHeader[2] || "").split(/\s+/).filter(Boolean);
  #|         for (const attr of attrs) {
  #|           if (attr === "solid") {
  #|             solid = true;
  #|           } else if (!hasName) {
  #|             tileName = attr;
  #|             hasName = true;
  #|           } else {
  #|             pushErr(i + 1, `unknown tile attribute: ${attr} (supported: <name> and solid)`);
  #|           }
  #|         }
  #|
  #|         let j = i + 1;
  #|         let row = 0;
  #|         let endLine = -1;
  #|         const pixels = Array(64).fill(-1);
  #|         while (j < lines.length) {
  #|           const raw = lines[j].trim();
  #|           if (isIgnorable(raw)) {
  #|             j += 1;
  #|             continue;
  #|           }
  #|           if (raw === "end") {
  #|             endLine = j;
  #|             break;
  #|           }
  #|           if (row >= 8) {
  #|             pushErr(j + 1, `tile ${id} has too many rows`);
  #|             j += 1;
  #|             continue;
  #|           }
  #|           if (raw.length !== 8) {
  #|             pushErr(j + 1, `tile row must be exactly 8 characters wide, got ${raw.length}`);
  #|           }
  #|           for (let x = 0; x < 8; x += 1) {
  #|             const ch = x < raw.length ? raw[x] : ".";
  #|             if (!/[0-9a-fA-F.]/.test(ch)) {
  #|               pushErr(j + 1, `unsupported tile symbol: ${ch} (use .,0-9,a-f)`);
  #|             }
  #|             pixels[row * 8 + x] = decodeSym(ch);
  #|           }
  #|           row += 1;
  #|           j += 1;
  #|         }
  #|         if (endLine < 0) {
  #|           pushErr(i + 1, "tile block is missing `end`");
  #|         } else {
  #|           i = endLine;
  #|         }
  #|         if (row !== 8) {
  #|           pushErr((endLine >= 0 ? endLine + 1 : i + 1), `tile ${id} expects 8 rows, got ${row}`);
  #|         }
  #|         if (Number.isFinite(id) && id >= 0 && id <= 255) {
  #|           tileset.tile_names[id] = tileName;
  #|           tileset.tile_solid[id] = !!solid;
  #|           tileset.tile_defined[id] = true;
  #|           const base = id * 64;
  #|           for (let k = 0; k < 64; k += 1) tileset.pixels[base + k] = pixels[k];
  #|           if (tileFirstHeader < 0 || headerIndex < tileFirstHeader) tileFirstHeader = headerIndex;
  #|           const realEnd = endLine >= 0 ? endLine : headerIndex;
  #|           if (realEnd > tileLastEnd) tileLastEnd = realEnd;
  #|         }
  #|         continue;
  #|       }
  #|
  #|       const mm = t.match(/^tilemap\s+([^\s]+)\s+(\d+)\s+(\d+)$/i);
  #|       if (mm) {
  #|         const headerIndex = i;
  #|         const name = mm[1];
  #|         const width = Math.max(1, Number(mm[2]) | 0);
  #|         const height = Math.max(1, Number(mm[3]) | 0);
  #|         const tiles = Array(width * height).fill(-1);
  #|         const rowLineIndices = [];
  #|         let j = i + 1;
  #|         let row = 0;
  #|         let endLine = -1;
  #|         while (j < lines.length) {
  #|           const raw = lines[j].trim();
  #|           if (isIgnorable(raw)) {
  #|             j += 1;
  #|             continue;
  #|           }
  #|           if (raw === "end") {
  #|             endLine = j;
  #|             break;
  #|           }
  #|           if (row >= height) {
  #|             pushErr(j + 1, `tilemap ${name} has too many rows`);
  #|             j += 1;
  #|             continue;
  #|           }
  #|           rowLineIndices.push(j);
  #|           const tokens = raw.split(/\s+/).filter(Boolean);
  #|           if (tokens.length !== width) {
  #|             pushErr(j + 1, `tilemap row width mismatch: expected ${width}, got ${tokens.length}`);
  #|           }
  #|           for (let x = 0; x < width; x += 1) {
  #|             const tok = x < tokens.length ? tokens[x] : ".";
  #|             if (tok === ".") {
  #|               tiles[row * width + x] = -1;
  #|             } else {
  #|               const n = parseIntStrict(tok);
  #|               if (!Number.isFinite(n)) {
  #|                 pushErr(j + 1, `invalid integer for tile id: ${tok}`);
  #|                 tiles[row * width + x] = -1;
  #|               } else if (n === -1) {
  #|                 pushErr(j + 1, "tilemap transparent cell must be `.` (do not use -1)");
  #|                 tiles[row * width + x] = -1;
  #|               } else {
  #|                 tiles[row * width + x] = n | 0;
  #|               }
  #|             }
  #|           }
  #|           row += 1;
  #|           j += 1;
  #|         }
  #|         if (endLine < 0) {
  #|           pushErr(headerIndex + 1, "tilemap block is missing `end`");
  #|         } else {
  #|           i = endLine;
  #|         }
  #|         if (row !== height) {
  #|           pushErr((endLine >= 0 ? endLine + 1 : headerIndex + 1), `tilemap ${name} expects ${height} rows, got ${row}`);
  #|         }
  #|         tilemaps.push({ name, width, height, tiles, headerLine: headerIndex, rowLineIndices, endLine: endLine >= 0 ? endLine : headerIndex });
  #|         if (tilemapFirstHeader < 0 || (headerIndex >= 0 && headerIndex < tilemapFirstHeader)) tilemapFirstHeader = headerIndex;
  #|         const realEnd = endLine >= 0 ? endLine : headerIndex;
  #|         if (realEnd > tilemapLastEnd) tilemapLastEnd = realEnd;
  #|         continue;
  #|       }
  #|     }
  #|
  #|     for (const tm of tilemaps) {
  #|       for (let y = 0; y < tm.height; y += 1) {
  #|         for (let x = 0; x < tm.width; x += 1) {
  #|           const tile_id = tm.tiles[y * tm.width + x];
  #|           if (tile_id < -1 || tile_id > 255) {
  #|             pushErr(tm.headerLine + 1, `tilemap '${tm.name}': tile ID ${tile_id} at (${x}, ${y}) out of range (valid: 0..255 or .)`);
  #|           }
  #|         }
  #|       }
  #|     }
  #|
  #|     const tileRange = (tileFirstHeader >= 0 && tileLastEnd >= tileFirstHeader)
  #|       ? { first: tileFirstHeader, last: tileLastEnd }
  #|       : null;
  #|     const tilemapRange = (tilemapFirstHeader >= 0 && tilemapLastEnd >= tilemapFirstHeader)
  #|       ? { first: tilemapFirstHeader, last: tilemapLastEnd }
  #|       : null;
  #|     return { lines, palette, tileset, tileRange, tilemaps, tilemapRange, errors };
  #|   };
  #|
  #|   const activeMap = () => {
  #|     if (state.tilemaps.length === 0) return null;
  #|     const idx = Math.max(0, Math.min(state.selectedMap, state.tilemaps.length - 1));
  #|     state.selectedMap = idx;
  #|     return state.tilemaps[idx];
  #|   };
  #|
  #|   const renderBrushSelect = () => {
  #|     const before = brushSelect.value;
  #|     brushSelect.innerHTML = "";
  #|     const transparent = document.createElement("option");
  #|     transparent.value = "-1";
  #|     transparent.textContent = ". (transparent)";
  #|     brushSelect.appendChild(transparent);
  #|
  #|     const ts = state.tileset;
  #|     if (ts && ts.tile_count > 0) {
  #|       for (let i = 0; i < ts.tile_count; i += 1) {
  #|         const opt = document.createElement("option");
  #|         const nm = ts.tile_names && ts.tile_names[i] ? ts.tile_names[i] : `tile_${i}`;
  #|         const solid = ts.tile_solid && ts.tile_solid[i] ? " [solid]" : "";
  #|         opt.value = String(i);
  #|         opt.textContent = `${i}: ${nm}${solid}`;
  #|         brushSelect.appendChild(opt);
  #|       }
  #|     }
  #|     let candidate = Number.isInteger(state.selectedToken) ? state.selectedToken : -1;
  #|     if (!Number.isInteger(candidate) || candidate < -1) candidate = -1;
  #|     if (before !== "" && [...brushSelect.options].some((o) => o.value === before)) {
  #|       candidate = Number(before);
  #|     }
  #|     if (![...brushSelect.options].some((o) => o.value === String(candidate))) {
  #|       candidate = -1;
  #|     }
  #|     state.selectedToken = candidate;
  #|     brushSelect.value = String(candidate);
  #|   };
  #|
  #|   const renderTileSelect = () => {
  #|     const before = tileSelect.value;
  #|     tileSelect.innerHTML = "";
  #|     const ts = state.tileset;
  #|     if (ts && ts.tile_count > 0) {
  #|       for (let i = 0; i < ts.tile_count; i += 1) {
  #|         const opt = document.createElement("option");
  #|         const nm = ts.tile_names && ts.tile_names[i] ? ts.tile_names[i] : `tile_${i}`;
  #|         const solid = ts.tile_solid && ts.tile_solid[i] ? " [solid]" : "";
  #|         opt.value = String(i);
  #|         opt.textContent = `${i}: ${nm}${solid}`;
  #|         tileSelect.appendChild(opt);
  #|       }
  #|     }
  #|     if (!ts || ts.tile_count <= 0) {
  #|       state.selectedToken = -1;
  #|       return;
  #|     }
  #|     let candidate = Number.isInteger(state.selectedToken) && state.selectedToken >= 0 ? state.selectedToken : 0;
  #|     if (before !== "" && [...tileSelect.options].some((o) => o.value === before)) {
  #|       candidate = Number(before);
  #|     }
  #|     if (![...tileSelect.options].some((o) => o.value === String(candidate))) {
  #|       candidate = 0;
  #|     }
  #|     state.selectedToken = candidate;
  #|     tileSelect.value = String(candidate);
  #|   };
  #|
  #|   const renderMapSelect = (preferCurrent = false) => {
  #|     const before = mapSelect.value;
  #|     mapSelect.innerHTML = "";
  #|     state.tilemaps.forEach((tm, i) => {
  #|       const opt = document.createElement("option");
  #|       opt.value = String(i);
  #|       opt.textContent = `${tm.name} (${tm.width}x${tm.height})`;
  #|       mapSelect.appendChild(opt);
  #|     });
  #|     if (state.tilemaps.length <= 0) {
  #|       state.selectedMap = 0;
  #|       return;
  #|     }
  #|     let idx = state.selectedMap;
  #|     if (!preferCurrent && before !== "" && Number(before) >= 0 && Number(before) < state.tilemaps.length) {
  #|       idx = Number(before);
  #|     }
  #|     idx = Math.max(0, Math.min(idx, state.tilemaps.length - 1));
  #|     state.selectedMap = idx;
  #|     mapSelect.value = String(idx);
  #|   };
  #|
  #|   const activeTileId = () => {
  #|     const ts = state.tileset;
  #|     const id = Number(tileSelect.value);
  #|     if (!ts || !Number.isInteger(id) || id < 0 || id >= ts.tile_count) return -1;
  #|     return id;
  #|   };
  #|
  #|   const renderTilePalette = () => {
  #|     tilePaletteRow.innerHTML = "";
  #|     const mk = (idx, hex, label) => {
  #|       const b = document.createElement("button");
  #|       b.type = "button";
  #|       b.title = label;
  #|       b.style.width = "20px";
  #|       b.style.height = "20px";
  #|       b.style.padding = "0";
  #|       b.style.border = state.selectedTileColor === idx ? "2px solid #f6f7eb" : "1px solid #627d98";
  #|       b.style.cursor = "pointer";
  #|       b.style.background = hex;
  #|       b.addEventListener("click", () => {
  #|         state.selectedTileColor = idx;
  #|         renderTilePalette();
  #|       });
  #|       tilePaletteRow.appendChild(b);
  #|     };
  #|     const transparent = document.createElement("button");
  #|     transparent.type = "button";
  #|     transparent.title = "transparent";
  #|     transparent.textContent = ".";
  #|     transparent.style.width = "20px";
  #|     transparent.style.height = "20px";
  #|     transparent.style.padding = "0";
  #|     transparent.style.border = state.selectedTileColor < 0 ? "2px solid #f6f7eb" : "1px solid #627d98";
  #|     transparent.style.background = "linear-gradient(45deg,#334e68 25%,#1f2a37 25%,#1f2a37 50%,#334e68 50%,#334e68 75%,#1f2a37 75%)";
  #|     transparent.style.backgroundSize = "8px 8px";
  #|     transparent.style.color = "#d9e2ec";
  #|     transparent.style.cursor = "pointer";
  #|     transparent.addEventListener("click", () => {
  #|       state.selectedTileColor = -1;
  #|       renderTilePalette();
  #|     });
  #|     tilePaletteRow.appendChild(transparent);
  #|
  #|     const maxIdx = Math.max(7, state.palette.length - 1);
  #|     for (let i = 0; i <= maxIdx; i += 1) {
  #|       if (!state.palette[i]) continue;
  #|       mk(i, state.palette[i], `color ${i}`);
  #|     }
  #|   };
  #|
  #|   const renderTileCanvas = () => {
  #|     const ts = state.tileset;
  #|     const id = activeTileId();
  #|     const ctx = tileCanvas.getContext("2d");
  #|     if (!ctx || !ts || id < 0) {
  #|       tileCanvas.width = 1;
  #|       tileCanvas.height = 1;
  #|       tileInfo.textContent = "Tile editor: choose a tile.";
  #|       return;
  #|     }
  #|     state.tileCell = 20;
  #|     tileCanvas.width = 8 * state.tileCell;
  #|     tileCanvas.height = 8 * state.tileCell;
  #|     ctx.imageSmoothingEnabled = false;
  #|     ctx.fillStyle = "#0f1720";
  #|     ctx.fillRect(0, 0, tileCanvas.width, tileCanvas.height);
  #|     const base = id * 64;
  #|     const nm = ts.tile_names && ts.tile_names[id] ? ts.tile_names[id] : `tile_${id}`;
  #|     const solid = ts.tile_solid && ts.tile_solid[id] ? "solid" : "non-solid";
  #|     tileInfo.textContent = `Tile ${id}: ${nm} (${solid})`;
  #|     for (let y = 0; y < 8; y += 1) {
  #|       for (let x = 0; x < 8; x += 1) {
  #|         const v = ts.pixels[base + y * 8 + x];
  #|         const px = x * state.tileCell;
  #|         const py = y * state.tileCell;
  #|         if (v >= 0) {
  #|           ctx.fillStyle = colorFor(v) || "#ffffff";
  #|           ctx.fillRect(px, py, state.tileCell, state.tileCell);
  #|         } else {
  #|           ctx.fillStyle = "#1f2a37";
  #|           ctx.fillRect(px, py, state.tileCell, state.tileCell);
  #|           ctx.fillStyle = "#334e68";
  #|           ctx.fillRect(px, py, state.tileCell / 2, state.tileCell / 2);
  #|           ctx.fillRect(px + state.tileCell / 2, py + state.tileCell / 2, state.tileCell / 2, state.tileCell / 2);
  #|         }
  #|         ctx.strokeStyle = "#334e68";
  #|         ctx.lineWidth = 1;
  #|         ctx.strokeRect(px + 0.5, py + 0.5, state.tileCell - 1, state.tileCell - 1);
  #|       }
  #|     }
  #|   };
  #|
  #|   const refreshSolidUi = () => {
  #|     const ts = state.tileset;
  #|     const id = activeTileId();
  #|     if (!ts || !Number.isInteger(id) || id < 0 || id >= ts.tile_count) {
  #|       tileSelect.disabled = true;
  #|       solidInput.checked = false;
  #|       solidInput.disabled = true;
  #|       tileNameInput.value = "";
  #|       tileNameInput.disabled = true;
  #|       renderTileCanvas();
  #|       return;
  #|     }
  #|     tileSelect.disabled = false;
  #|     if ([...tileSelect.options].some((o) => o.value === String(id))) {
  #|       tileSelect.value = String(id);
  #|     }
  #|     solidInput.disabled = false;
  #|     tileNameInput.disabled = false;
  #|     solidInput.checked = !!(ts.tile_solid && ts.tile_solid[id]);
  #|     tileNameInput.value = ts.tile_names && ts.tile_names[id] ? ts.tile_names[id] : `tile_${id}`;
  #|     renderTileCanvas();
  #|   };
  #|
  #|   const drawTilePreview = (ctx, ts, tileId, px, py, cell) => {
  #|     if (!ts || tileId < 0) return;
  #|     const base = tileId * 64;
  #|     const dot = cell / 8;
  #|     for (let ty = 0; ty < 8; ty += 1) {
  #|       for (let tx = 0; tx < 8; tx += 1) {
  #|         const ci = ts.pixels[base + ty * 8 + tx];
  #|         if (ci >= 0) {
  #|           ctx.fillStyle = colorFor(ci) || "#ffffff";
  #|           ctx.fillRect(px + tx * dot, py + ty * dot, Math.ceil(dot), Math.ceil(dot));
  #|         }
  #|       }
  #|     }
  #|   };
  #|
  #|   const renderCanvas = () => {
  #|     const map = activeMap();
  #|     const ctx = canvas.getContext("2d");
  #|     if (!ctx || !map) {
  #|       canvas.width = 1;
  #|       canvas.height = 1;
  #|       info.textContent = "No tilemap found in DSL.";
  #|       return;
  #|     }
  #|     info.textContent = `Editing tilemap ${map.name} (${map.width}x${map.height})`;
  #|     mapWInput.value = String(map.width);
  #|     mapHInput.value = String(map.height);
  #|     state.cell = Math.max(8, Math.floor(320 / Math.max(map.width, map.height)));
  #|     canvas.width = map.width * state.cell;
  #|     canvas.height = map.height * state.cell;
  #|     ctx.imageSmoothingEnabled = false;
  #|     ctx.fillStyle = "#0f1720";
  #|     ctx.fillRect(0, 0, canvas.width, canvas.height);
  #|
  #|     for (let y = 0; y < map.height; y += 1) {
  #|       for (let x = 0; x < map.width; x += 1) {
  #|         const v = map.tiles[y * map.width + x];
  #|         const px = x * state.cell;
  #|         const py = y * state.cell;
  #|         if (v >= 0) {
  #|           drawTilePreview(ctx, state.tileset, v, px, py, state.cell);
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
  #|   const encodeTileBlocks = () => {
  #|     const ts = state.tileset;
  #|     if (!ts || ts.tile_count <= 0) return [];
  #|     const out = [];
  #|     for (let i = 0; i < ts.tile_count; i += 1) {
  #|       const defined = !!(ts.tile_defined && ts.tile_defined[i]);
  #|       if (!defined) continue;
  #|       const nm = ts.tile_names && ts.tile_names[i] ? ts.tile_names[i] : `tile_${i}`;
  #|       const defaultName = `tile_${i}`;
  #|       const solid = ts.tile_solid && ts.tile_solid[i] ? " solid" : "";
  #|       const namePart = nm !== defaultName ? ` ${nm}` : "";
  #|       out.push(`tile ${i}${namePart}${solid}`);
  #|       const base = i * 64;
  #|       for (let y = 0; y < 8; y += 1) {
  #|         let row = "";
  #|         for (let x = 0; x < 8; x += 1) {
  #|           row += encodeTileSym(ts.pixels[base + y * 8 + x] ?? -1);
  #|         }
  #|         out.push(row);
  #|       }
  #|       out.push("end");
  #|       out.push("");
  #|     }
  #|     if (out.length > 0 && out[out.length - 1] === "") out.pop();
  #|     return out;
  #|   };
  #|
  #|   const replaceTileBlocksInLines = (lines) => {
  #|     const rendered = encodeTileBlocks();
  #|     if (state.tileRange && Number.isInteger(state.tileRange.first) && Number.isInteger(state.tileRange.last)) {
  #|       const first = state.tileRange.first;
  #|       const last = state.tileRange.last;
  #|       if (first >= 0 && last >= first) {
  #|         const before = lines.slice(0, first);
  #|         const after = lines.slice(last + 1);
  #|         const out = before.concat(rendered);
  #|         if (out.length > 0 && after.length > 0 && out[out.length - 1].trim() !== "") out.push("");
  #|         return out.concat(after);
  #|       }
  #|     }
  #|     let first = -1;
  #|     let last = -1;
  #|     for (let i = 0; i < lines.length; i += 1) {
  #|       const raw = lines[i].trim();
  #|       if (/^tile\s+-?\d+/i.test(raw)) {
  #|         if (first < 0) first = i;
  #|         let end = i;
  #|         for (let j = i + 1; j < lines.length; j += 1) {
  #|           const rr = lines[j].trim();
  #|           if (rr === "end") {
  #|             end = j;
  #|             break;
  #|           }
  #|         }
  #|         if (end > last) last = end;
  #|       }
  #|     }
  #|     if (first >= 0 && last >= first) {
  #|       const before = lines.slice(0, first);
  #|       const after = lines.slice(last + 1);
  #|       const out = before.concat(rendered);
  #|       if (out.length > 0 && after.length > 0 && out[out.length - 1].trim() !== "") out.push("");
  #|       return out.concat(after);
  #|     }
  #|     let insertAt = lines.length;
  #|     for (let i = 0; i < lines.length; i += 1) {
  #|       const raw = lines[i].trim();
  #|       if (/^tilemap\s+/i.test(raw)) {
  #|         insertAt = i;
  #|         break;
  #|       }
  #|     }
  #|     const before = lines.slice(0, insertAt);
  #|     const after = lines.slice(insertAt);
  #|     const out = before.concat(rendered);
  #|     if (out.length > 0 && after.length > 0 && out[out.length - 1].trim() !== "") out.push("");
  #|     return out.concat(after);
  #|   };
  #|
  #|   const encodeTilemapBlocks = () => {
  #|     const blocks = [];
  #|     for (const tm of state.tilemaps || []) {
  #|       blocks.push(`tilemap ${tm.name} ${tm.width} ${tm.height}`);
  #|       for (let y = 0; y < tm.height; y += 1) {
  #|         const row = [];
  #|         for (let x = 0; x < tm.width; x += 1) {
  #|           const v = tm.tiles[y * tm.width + x];
  #|           row.push(v < 0 ? "." : String(v));
  #|         }
  #|         blocks.push(row.join(" "));
  #|       }
  #|       blocks.push("end");
  #|       blocks.push("");
  #|     }
  #|     if (blocks.length > 0 && blocks[blocks.length - 1] === "") blocks.pop();
  #|     return blocks;
  #|   };
  #|
  #|   const replaceTilemapBlocksInLines = (lines) => {
  #|     const maps = state.tilemaps || [];
  #|     const rendered = encodeTilemapBlocks();
  #|     let first = -1;
  #|     let last = -1;
  #|     if (state.tilemapRange && Number.isInteger(state.tilemapRange.first) && Number.isInteger(state.tilemapRange.last)) {
  #|       first = state.tilemapRange.first;
  #|       last = state.tilemapRange.last;
  #|     } else {
  #|       for (const tm of maps) {
  #|         if (Number.isInteger(tm.headerLine)) {
  #|           if (first < 0 || tm.headerLine < first) first = tm.headerLine;
  #|         }
  #|         if (Number.isInteger(tm.endLine) && tm.endLine > last) last = tm.endLine;
  #|       }
  #|     }
  #|     if (first < 0 || last < first) {
  #|       if (rendered.length === 0) return lines;
  #|       const out = lines.slice();
  #|       if (out.length > 0 && out[out.length - 1].trim() !== "") out.push("");
  #|       return out.concat(rendered);
  #|     }
  #|     const before = lines.slice(0, first);
  #|     const after = lines.slice(last + 1);
  #|     const out = before.concat(rendered);
  #|     if (out.length > 0 && after.length > 0 && out[out.length - 1].trim() !== "") out.push("");
  #|     return out.concat(after);
  #|   };
  #|
  #|   const writeTilemapToDsl = (andApply) => {
  #|     const map = activeMap();
  #|     if (!map) return;
  #|     if (Array.isArray(state.errors) && state.errors.length > 0) {
  #|       const e = state.errors[0];
  #|       setFeedback(`Write aborted: line ${e.line}: ${e.message}`, true);
  #|       return;
  #|     }
  #|     const lines = state.lines.slice();
  #|     // Replace tilemap first: its stored line range is based on the original text.
  #|     // Replacing tile blocks first can shift line numbers and leave trailing `end`.
  #|     const withTilemaps = replaceTilemapBlocksInLines(lines);
  #|     const merged = replaceTileBlocksInLines(withTilemaps);
  #|     const text = merged.join("\n");
  #|     textarea.value = text;
  #|     setDirty(false);
  #|     setFeedback(andApply ? "Tilemap written and applied." : "Tilemap written to DSL.");
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
  #|     state.tileset = parsed.tileset;
  #|     state.tileRange = parsed.tileRange;
  #|     state.tilemaps = parsed.tilemaps;
  #|     state.tilemapRange = parsed.tilemapRange;
  #|     state.errors = parsed.errors || [];
  #|     if (state.selectedMap >= state.tilemaps.length) state.selectedMap = 0;
  #|
  #|     renderMapSelect(true);
  #|
  #|     renderTilePalette();
  #|     renderTileSelect();
  #|     renderBrushSelect();
  #|     refreshSolidUi();
  #|     renderCanvas();
  #|     setDirty(false);
  #|     if (state.errors.length > 0) {
  #|       const e = state.errors[0];
  #|       setFeedback(`Parse error at line ${e.line}: ${e.message}`, true);
  #|     } else {
  #|       setFeedback("Tilemap synced from DSL.");
  #|     }
  #|   };
  #|
  #|   const paintAt = (evt) => {
  #|     const map = activeMap();
  #|     if (!map) return;
  #|     const rect = canvas.getBoundingClientRect();
  #|     const x = Math.floor((evt.clientX - rect.left) / state.cell);
  #|     const y = Math.floor((evt.clientY - rect.top) / state.cell);
  #|     if (x < 0 || y < 0 || x >= map.width || y >= map.height) return;
  #|     const erase = ((evt.buttons & 2) !== 0) || !!evt.shiftKey;
  #|     map.tiles[y * map.width + x] = erase ? -1 : state.selectedToken;
  #|     setDirty(true);
  #|     renderCanvas();
  #|   };
  #|
  #|   const paintTileAt = (evt) => {
  #|     const ts = state.tileset;
  #|     const id = activeTileId();
  #|     if (!ts || id < 0) return;
  #|     const rect = tileCanvas.getBoundingClientRect();
  #|     const x = Math.floor((evt.clientX - rect.left) / state.tileCell);
  #|     const y = Math.floor((evt.clientY - rect.top) / state.tileCell);
  #|     if (x < 0 || y < 0 || x >= 8 || y >= 8) return;
  #|     const erase = ((evt.buttons & 2) !== 0) || !!evt.shiftKey;
  #|     const base = id * 64;
  #|     ts.pixels[base + y * 8 + x] = erase ? -1 : state.selectedTileColor;
  #|     ts.tile_defined[id] = true;
  #|     setDirty(true);
  #|     renderTileCanvas();
  #|     renderCanvas();
  #|   };
  #|
  #|   const nextMapName = () => {
  #|     const used = new Set((state.tilemaps || []).map((m) => String(m.name)));
  #|     if (!used.has("stage")) return "stage";
  #|     let i = 2;
  #|     while (used.has(`stage_${i}`)) i += 1;
  #|     return `stage_${i}`;
  #|   };
  #|   const readSizeInputs = () => {
  #|     const w = Math.max(1, Math.min(256, Number(mapWInput.value) | 0));
  #|     const h = Math.max(1, Math.min(256, Number(mapHInput.value) | 0));
  #|     mapWInput.value = String(w);
  #|     mapHInput.value = String(h);
  #|     return { w, h };
  #|   };
  #|   const addMap = () => {
  #|     const { w, h } = readSizeInputs();
  #|     const tiles = Array(w * h).fill(-1);
  #|     const name = nextMapName();
  #|     const tm = {
  #|       name,
  #|       width: w,
  #|       height: h,
  #|       tiles,
  #|       headerLine: -1,
  #|       rowLineIndices: [],
  #|       endLine: -1,
  #|     };
  #|     if (!Array.isArray(state.tilemaps)) state.tilemaps = [];
  #|     state.tilemaps.push(tm);
  #|     state.selectedMap = state.tilemaps.length - 1;
  #|     setDirty(true);
  #|     setFeedback(`Added tilemap ${name}.`);
  #|     renderMapSelect(true);
  #|     renderTileSelect();
  #|     renderBrushSelect();
  #|     refreshSolidUi();
  #|     renderCanvas();
  #|   };
  #|   const deleteMap = () => {
  #|     const maps = state.tilemaps || [];
  #|     if (maps.length === 0) return;
  #|     const idx = Math.max(0, Math.min(state.selectedMap, maps.length - 1));
  #|     const removed = maps[idx].name;
  #|     maps.splice(idx, 1);
  #|     state.selectedMap = Math.max(0, Math.min(idx, maps.length - 1));
  #|     setDirty(true);
  #|     setFeedback(`Deleted tilemap ${removed}.`);
  #|     renderMapSelect();
  #|     renderTileSelect();
  #|     renderBrushSelect();
  #|     refreshSolidUi();
  #|     renderCanvas();
  #|   };
  #|   const resizeMap = () => {
  #|     const tm = activeMap();
  #|     if (!tm) return;
  #|     const { w, h } = readSizeInputs();
  #|     if (w === tm.width && h === tm.height) return;
  #|     const nextTiles = Array(w * h).fill(-1);
  #|     const copyW = Math.min(w, tm.width);
  #|     const copyH = Math.min(h, tm.height);
  #|     for (let y = 0; y < copyH; y += 1) {
  #|       for (let x = 0; x < copyW; x += 1) {
  #|         nextTiles[y * w + x] = tm.tiles[y * tm.width + x];
  #|       }
  #|     }
  #|     tm.width = w;
  #|     tm.height = h;
  #|     tm.tiles = nextTiles;
  #|     setDirty(true);
  #|     setFeedback(`Resized ${tm.name} to ${w}x${h}.`);
  #|     renderMapSelect();
  #|     renderCanvas();
  #|   };
  #|   const addTile = () => {
  #|     const ts = state.tileset;
  #|     if (!ts) return;
  #|     let id = -1;
  #|     for (let i = 0; i < ts.tile_count; i += 1) {
  #|       if (!ts.tile_defined[i]) {
  #|         id = i;
  #|         break;
  #|       }
  #|     }
  #|     if (id < 0) {
  #|       setFeedback("All 256 tile IDs are already defined.", true);
  #|       return;
  #|     }
  #|     ts.tile_defined[id] = true;
  #|     ts.tile_names[id] = `tile_${id}`;
  #|     ts.tile_solid[id] = false;
  #|     const base = id * 64;
  #|     for (let i = 0; i < 64; i += 1) ts.pixels[base + i] = -1;
  #|     state.selectedToken = id;
  #|     setDirty(true);
  #|     setFeedback(`Reserved tile ${id}.`);
  #|     renderTilePalette();
  #|     renderTileSelect();
  #|     renderBrushSelect();
  #|     refreshSolidUi();
  #|     renderCanvas();
  #|   };
  #|   const deleteTile = () => {
  #|     const ts = state.tileset;
  #|     const id = activeTileId();
  #|     if (!ts || id < 0) return;
  #|     ts.tile_names[id] = `tile_${id}`;
  #|     ts.tile_solid[id] = false;
  #|     ts.tile_defined[id] = false;
  #|     const base = id * 64;
  #|     for (let i = 0; i < 64; i += 1) ts.pixels[base + i] = -1;
  #|     setDirty(true);
  #|     setFeedback(`Cleared tile ${id}.`);
  #|     renderTilePalette();
  #|     renderTileSelect();
  #|     renderBrushSelect();
  #|     refreshSolidUi();
  #|     renderCanvas();
  #|   };
  #|
  #|   if (!globalThis.__moon8bit_tilemap_bound) {
  #|     mapSelect.addEventListener("change", () => {
  #|       state.selectedMap = Number(mapSelect.value) || 0;
  #|       renderCanvas();
  #|     });
  #|     brushSelect.addEventListener("change", () => {
  #|       state.selectedToken = Number(brushSelect.value);
  #|       renderTileSelect();
  #|       refreshSolidUi();
  #|     });
  #|     tileSelect.addEventListener("change", () => {
  #|       state.selectedToken = Number(tileSelect.value);
  #|       renderBrushSelect();
  #|       brushSelect.value = String(state.selectedToken);
  #|       refreshSolidUi();
  #|     });
  #|     tileNameInput.addEventListener("input", () => {
  #|       const ts = state.tileset;
  #|       const id = activeTileId();
  #|       if (!ts || id < 0) return;
  #|       const next = String(tileNameInput.value || "").trim();
  #|       ts.tile_names[id] = next === "" ? `tile_${id}` : next;
  #|       ts.tile_defined[id] = true;
  #|       setDirty(true);
  #|       setFeedback(`Tile ${id} name updated.`);
  #|       renderTileSelect();
  #|       renderBrushSelect();
  #|       brushSelect.value = String(id);
  #|       state.selectedToken = id;
  #|       refreshSolidUi();
  #|     });
  #|     solidInput.addEventListener("change", () => {
  #|       const ts = state.tileset;
  #|       const id = activeTileId();
  #|       if (!ts || id < 0) return;
  #|       if (!Array.isArray(ts.tile_solid)) ts.tile_solid = [];
  #|       ts.tile_solid[id] = !!solidInput.checked;
  #|       ts.tile_defined[id] = true;
  #|       setDirty(true);
  #|       setFeedback(`Tile ${id} solid=${ts.tile_solid[id] ? "on" : "off"}.`);
  #|       renderTileSelect();
  #|       renderBrushSelect();
  #|       brushSelect.value = String(id);
  #|       state.selectedToken = id;
  #|       refreshSolidUi();
  #|     });
  #|     syncBtn.addEventListener("click", refreshFromText);
  #|     writeBtn.addEventListener("click", () => writeTilemapToDsl(false));
  #|     applyBtn.addEventListener("click", () => writeTilemapToDsl(true));
  #|     addMapBtn.addEventListener("click", addMap);
  #|     delMapBtn.addEventListener("click", deleteMap);
  #|     resizeMapBtn.addEventListener("click", resizeMap);
  #|     addTileBtn.addEventListener("click", addTile);
  #|     delTileBtn.addEventListener("click", deleteTile);
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
  #|
  #|     let tileDrawing = false;
  #|     tileCanvas.addEventListener("pointerdown", (evt) => {
  #|       tileDrawing = true;
  #|       paintTileAt(evt);
  #|     });
  #|     tileCanvas.addEventListener("pointermove", (evt) => {
  #|       if (tileDrawing) paintTileAt(evt);
  #|     });
  #|     globalThis.addEventListener("pointerup", () => {
  #|       tileDrawing = false;
  #|     });
  #|     tileCanvas.addEventListener("contextmenu", (evt) => evt.preventDefault());
  #|     globalThis.__moon8bit_tilemap_bound = true;
  #|   }
  #|
  #|   globalThis.__moon8bit_tilemap_refresh = refreshFromText;
  #|   refreshFromText();
  #| }

///|
extern "js" fn web_tilemap_editor_refresh() -> Unit =
  #| () => {
  #|   if (globalThis.__moon8bit_tilemap_refresh) {
  #|     globalThis.__moon8bit_tilemap_refresh();
  #|   }
  #| }

///|
fn web_init_tile_editor() -> Unit {
  web_init_tilemap_editor()
}

///|
fn web_tile_editor_refresh() -> Unit {
  web_tilemap_editor_refresh()
}

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
