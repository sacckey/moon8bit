///|
extern "js" fn web_init_palette_editor() -> Unit =
  #| () => {
  #|   const editor = document.getElementById("moon8bit-tab-panel-palette") || document.getElementById("moon8bit-editor");
  #|   const textarea = document.getElementById("moon8bit-dsl-input");
  #|   if (!editor || !textarea) return;
  #|
  #|   const fallbackPalette = [
  #|     "#101820", "#1f4068", "#2e8b57", "#f2aa4c",
  #|     "#e94f37", "#8f6f4f", "#f6f7eb", "#7f5af0",
  #|     "#264653", "#2a9d8f", "#e9c46a", "#f4a261",
  #|     "#e76f51", "#577590", "#90be6d", "#ffffff",
  #|   ];
  #|
  #|   const normalizeHex = (raw, fallback) => {
  #|     const v = String(raw || "").trim();
  #|     if (v === "") return fallback;
  #|     const s = v.startsWith("#") ? v.slice(1) : v;
  #|     if (/^[0-9a-fA-F]{6}$/.test(s)) return `#${s.toLowerCase()}`;
  #|     if (/^[0-9a-fA-F]{3}$/.test(s)) {
  #|       const [r, g, b] = s.toLowerCase().split("");
  #|       return `#${r}${r}${g}${g}${b}${b}`;
  #|     }
  #|     return fallback;
  #|   };
  #|
  #|   let panel = document.getElementById("moon8bit-palette-panel");
  #|   if (!panel) {
  #|     panel = document.createElement("div");
  #|     panel.id = "moon8bit-palette-panel";
  #|     panel.style.display = "grid";
  #|     panel.style.gap = "10px";
  #|     panel.style.padding = "8px";
  #|     panel.style.border = "1px solid #334e68";
  #|     panel.style.background = "#111827";
  #|     editor.appendChild(panel);
  #|   }
  #|   if (panel.parentElement !== editor) editor.appendChild(panel);
  #|
  #|   let title = document.getElementById("moon8bit-palette-title");
  #|   if (!title) {
  #|     title = document.createElement("div");
  #|     title.id = "moon8bit-palette-title";
  #|     title.textContent = "Palette Editor (0-15)";
  #|     title.style.fontWeight = "600";
  #|     title.style.fontFamily = "monospace";
  #|     title.style.fontSize = "18px";
  #|     panel.appendChild(title);
  #|   }
  #|
  #|   let hint = document.getElementById("moon8bit-palette-hint");
  #|   if (!hint) {
  #|     hint = document.createElement("div");
  #|     hint.id = "moon8bit-palette-hint";
  #|     hint.textContent = "Click a swatch, then use color picker or HEX.";
  #|     hint.style.fontFamily = "monospace";
  #|     hint.style.fontSize = "13px";
  #|     hint.style.color = "#9fb3c8";
  #|     panel.appendChild(hint);
  #|   }
  #|
  #|   let layout = document.getElementById("moon8bit-palette-layout");
  #|   if (!layout) {
  #|     layout = document.createElement("div");
  #|     layout.id = "moon8bit-palette-layout";
  #|     layout.style.display = "flex";
  #|     layout.style.gap = "16px";
  #|     layout.style.alignItems = "flex-start";
  #|     layout.style.flexWrap = "nowrap";
  #|     panel.appendChild(layout);
  #|   }
  #|
  #|   let swatchPane = document.getElementById("moon8bit-palette-swatch-pane");
  #|   if (!swatchPane) {
  #|     swatchPane = document.createElement("div");
  #|     swatchPane.id = "moon8bit-palette-swatch-pane";
  #|     swatchPane.style.display = "grid";
  #|     swatchPane.style.gridTemplateColumns = "repeat(4, 72px)";
  #|     swatchPane.style.gap = "8px";
  #|     swatchPane.style.alignContent = "start";
  #|     layout.appendChild(swatchPane);
  #|   }
  #|
  #|   let rightPane = document.getElementById("moon8bit-palette-right-pane");
  #|   if (!rightPane) {
  #|     rightPane = document.createElement("div");
  #|     rightPane.id = "moon8bit-palette-right-pane";
  #|     rightPane.style.display = "grid";
  #|     rightPane.style.gap = "10px";
  #|     rightPane.style.minWidth = "280px";
  #|     rightPane.style.alignContent = "start";
  #|     layout.appendChild(rightPane);
  #|   }
  #|
  #|   let indexLabel = document.getElementById("moon8bit-palette-index");
  #|   if (!indexLabel) {
  #|     indexLabel = document.createElement("div");
  #|     indexLabel.id = "moon8bit-palette-index";
  #|     indexLabel.style.fontFamily = "monospace";
  #|     indexLabel.style.fontSize = "14px";
  #|     indexLabel.style.fontWeight = "600";
  #|     rightPane.appendChild(indexLabel);
  #|   }
  #|
  #|   let preview = document.getElementById("moon8bit-palette-preview");
  #|   if (!preview) {
  #|     preview = document.createElement("div");
  #|     preview.id = "moon8bit-palette-preview";
  #|     preview.style.width = "140px";
  #|     preview.style.height = "96px";
  #|     preview.style.border = "1px solid #486581";
  #|     preview.style.boxShadow = "inset 0 0 0 1px rgba(255,255,255,0.08)";
  #|     preview.style.cursor = "pointer";
  #|     preview.title = "Click to open color picker";
  #|     rightPane.appendChild(preview);
  #|   }
  #|
  #|   let picker = document.getElementById("moon8bit-palette-hidden-picker");
  #|   if (!picker) {
  #|     picker = document.createElement("input");
  #|     picker.id = "moon8bit-palette-hidden-picker";
  #|     picker.type = "color";
  #|     picker.style.position = "absolute";
  #|     picker.style.opacity = "0";
  #|     picker.style.pointerEvents = "none";
  #|     picker.style.width = "1px";
  #|     picker.style.height = "1px";
  #|     panel.appendChild(picker);
  #|   }
  #|
  #|   let hexLabel = document.getElementById("moon8bit-palette-hex-label");
  #|   if (!hexLabel) {
  #|     hexLabel = document.createElement("label");
  #|     hexLabel.id = "moon8bit-palette-hex-label";
  #|     hexLabel.textContent = "HEX (#RRGGBB)";
  #|     hexLabel.style.fontFamily = "monospace";
  #|     hexLabel.style.fontSize = "12px";
  #|     hexLabel.style.opacity = "0.9";
  #|     rightPane.appendChild(hexLabel);
  #|   }
  #|
  #|   let hexInput = document.getElementById("moon8bit-palette-hex");
  #|   if (!hexInput) {
  #|     hexInput = document.createElement("input");
  #|     hexInput.id = "moon8bit-palette-hex";
  #|     hexInput.type = "text";
  #|     hexInput.placeholder = "#2f2a3a";
  #|     hexInput.style.width = "200px";
  #|     hexInput.style.background = "#0f1720";
  #|     hexInput.style.color = "#d9e2ec";
  #|     hexInput.style.border = "1px solid #486581";
  #|     hexInput.style.padding = "6px 8px";
  #|     hexInput.style.fontFamily = "ui-monospace, SFMono-Regular, Menlo, monospace";
  #|     rightPane.appendChild(hexInput);
  #|   }
  #|
  #|   if (!globalThis.__moon8bit_palette_state) {
  #|     globalThis.__moon8bit_palette_state = {
  #|       lines: [],
  #|       colors: fallbackPalette.slice(0, 16),
  #|       selected: 0,
  #|       paletteHeader: "palette default",
  #|       paletteRange: null,
  #|     };
  #|   }
  #|   const state = globalThis.__moon8bit_palette_state;
  #|   let writeTimer = null;
  #|
  #|   const setFeedback = (text, isError = false) => {
  #|     const fb = document.getElementById("moon8bit-editor-feedback");
  #|     if (!fb) return;
  #|     fb.textContent = text;
  #|     fb.style.color = isError ? "#ef6f6c" : "#7bd389";
  #|   };
  #|
  #|   const parsePaletteFromText = () => {
  #|     const lines = textarea.value.replace(/\r\n/g, "\n").replace(/\r/g, "\n").split("\n");
  #|     const colors = fallbackPalette.slice(0, 16);
  #|     let header = "palette default";
  #|     let start = -1;
  #|     let end = -1;
  #|
  #|     for (let i = 0; i < lines.length; i += 1) {
  #|       const trimmed = lines[i].trim();
  #|       if (start < 0 && /^palette\s+\S+$/i.test(trimmed)) {
  #|         start = i;
  #|         header = trimmed;
  #|         continue;
  #|       }
  #|       if (start >= 0) {
  #|         if (trimmed === "end") {
  #|           end = i;
  #|           break;
  #|         }
  #|         const m = trimmed.match(/^color\s+(\d+)\s+(\S+)$/i);
  #|         if (m) {
  #|           const idx = Number(m[1]);
  #|           if (Number.isFinite(idx) && idx >= 0 && idx < 16) {
  #|             colors[idx] = normalizeHex(m[2], colors[idx]);
  #|           }
  #|         }
  #|       }
  #|     }
  #|
  #|     state.lines = lines;
  #|     state.colors = colors;
  #|     state.paletteHeader = header;
  #|     state.paletteRange = start >= 0 && end >= start ? { start, end } : null;
  #|     state.selected = Math.max(0, Math.min(15, Number(state.selected) || 0));
  #|   };
  #|
  #|   const renderControls = () => {
  #|     const idx = state.selected;
  #|     const color = normalizeHex(state.colors[idx], fallbackPalette[idx]);
  #|     state.colors[idx] = color;
  #|     indexLabel.textContent = `Selected color ${idx}`;
  #|     preview.style.background = color;
  #|     picker.value = color;
  #|     hexInput.value = color;
  #|   };
  #|
  #|   const renderSwatches = () => {
  #|     swatchPane.innerHTML = "";
  #|     for (let i = 0; i < 16; i += 1) {
  #|       const cell = document.createElement("div");
  #|       cell.style.display = "grid";
  #|       cell.style.gap = "4px";
  #|       cell.style.justifyItems = "center";
  #|
  #|       const label = document.createElement("div");
  #|       label.textContent = String(i);
  #|       label.style.fontFamily = "monospace";
  #|       label.style.fontSize = "12px";
  #|       label.style.color = "#e5e7eb";
  #|       label.style.lineHeight = "1";
  #|       cell.appendChild(label);
  #|
  #|       const btn = document.createElement("button");
  #|       btn.type = "button";
  #|       btn.style.width = "72px";
  #|       btn.style.height = "72px";
  #|       btn.style.padding = "0";
  #|       btn.style.cursor = "pointer";
  #|       btn.style.border = i === state.selected ? "3px solid #4aa96c" : "1px solid #486581";
  #|       btn.style.background = normalizeHex(state.colors[i], fallbackPalette[i]);
  #|       btn.title = `color ${i}`;
  #|       btn.addEventListener("click", () => {
  #|         state.selected = i;
  #|         renderSwatches();
  #|         renderControls();
  #|       });
  #|       cell.appendChild(btn);
  #|       swatchPane.appendChild(cell);
  #|     }
  #|   };
  #|
  #|   const writePaletteToDsl = () => {
  #|     const block = [state.paletteHeader];
  #|     for (let i = 0; i < 16; i += 1) {
  #|       block.push(`color ${i} ${normalizeHex(state.colors[i], fallbackPalette[i])}`);
  #|     }
  #|     block.push("end");
  #|
  #|     const lines = state.lines.slice();
  #|     if (state.paletteRange && Number.isInteger(state.paletteRange.start) && Number.isInteger(state.paletteRange.end)) {
  #|       const count = state.paletteRange.end - state.paletteRange.start + 1;
  #|       lines.splice(state.paletteRange.start, count, ...block);
  #|       state.paletteRange = {
  #|         start: state.paletteRange.start,
  #|         end: state.paletteRange.start + block.length - 1,
  #|       };
  #|     } else {
  #|       const prefix = block.concat([""]);
  #|       lines.splice(0, 0, ...prefix);
  #|       state.paletteRange = { start: 0, end: block.length - 1 };
  #|     }
  #|
  #|     textarea.value = lines.join("\n");
  #|     state.lines = lines;
  #|     if (globalThis.__moon8bit_sprite_refresh) globalThis.__moon8bit_sprite_refresh();
  #|     if (globalThis.__moon8bit_tilemap_refresh) globalThis.__moon8bit_tilemap_refresh();
  #|     setFeedback("Palette updated in DSL.");
  #|   };
  #|
  #|   const scheduleWrite = () => {
  #|     if (writeTimer !== null) clearTimeout(writeTimer);
  #|     writeTimer = setTimeout(() => {
  #|       writeTimer = null;
  #|       writePaletteToDsl();
  #|     }, 60);
  #|   };
  #|
  #|   const refreshFromText = () => {
  #|     parsePaletteFromText();
  #|     renderSwatches();
  #|     renderControls();
  #|   };
  #|
  #|   if (!globalThis.__moon8bit_palette_bound) {
  #|     preview.addEventListener("click", () => {
  #|       try {
  #|         if (typeof picker.showPicker === "function") {
  #|           picker.showPicker();
  #|         } else {
  #|           picker.click();
  #|         }
  #|       } catch (_) {
  #|         picker.click();
  #|       }
  #|     });
  #|     picker.addEventListener("input", () => {
  #|       const idx = state.selected;
  #|       state.colors[idx] = normalizeHex(picker.value, state.colors[idx] || fallbackPalette[idx]);
  #|       renderSwatches();
  #|       renderControls();
  #|       scheduleWrite();
  #|     });
  #|     hexInput.addEventListener("input", () => {
  #|       const raw = String(hexInput.value || "").trim();
  #|       if (!/^#?[0-9a-fA-F]{3}$/.test(raw) && !/^#?[0-9a-fA-F]{6}$/.test(raw)) return;
  #|       const idx = state.selected;
  #|       state.colors[idx] = normalizeHex(raw, state.colors[idx] || fallbackPalette[idx]);
  #|       renderSwatches();
  #|       renderControls();
  #|       scheduleWrite();
  #|     });
  #|     hexInput.addEventListener("change", () => {
  #|       const idx = state.selected;
  #|       const normalized = normalizeHex(hexInput.value, state.colors[idx] || fallbackPalette[idx]);
  #|       state.colors[idx] = normalized;
  #|       renderSwatches();
  #|       renderControls();
  #|       scheduleWrite();
  #|     });
  #|     textarea.addEventListener("input", refreshFromText);
  #|     globalThis.__moon8bit_palette_bound = true;
  #|   }
  #|
  #|   globalThis.__moon8bit_palette_refresh = refreshFromText;
  #|   refreshFromText();
  #| }

///|
extern "js" fn web_palette_editor_refresh() -> Unit =
  #| () => {
  #|   if (globalThis.__moon8bit_palette_refresh) {
  #|     globalThis.__moon8bit_palette_refresh();
  #|   }
  #| }

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
  #|     panel.style.gap = "10px";
  #|     panel.style.padding = "8px";
  #|     panel.style.border = "1px solid #334e68";
  #|     panel.style.background = "#111827";
  #|     editor.appendChild(panel);
  #|   }
  #|   if (panel.parentElement !== editor) {
  #|     editor.appendChild(panel);
  #|   }
  #|
  #|   let layout = document.getElementById("moon8bit-sprite-layout");
  #|   if (!layout) {
  #|     layout = document.createElement("div");
  #|     layout.id = "moon8bit-sprite-layout";
  #|     layout.style.display = "flex";
  #|     layout.style.flexDirection = "row";
  #|     layout.style.alignItems = "flex-start";
  #|     layout.style.flexWrap = "nowrap";
  #|     layout.style.overflowX = "auto";
  #|     layout.style.gap = "24px";
  #|     panel.appendChild(layout);
  #|   }
  #|
  #|   let listPane = document.getElementById("moon8bit-sprite-list-pane");
  #|   if (!listPane) {
  #|     listPane = document.createElement("div");
  #|     listPane.id = "moon8bit-sprite-list-pane";
  #|     listPane.style.display = "grid";
  #|     listPane.style.gap = "10px";
  #|     listPane.style.alignContent = "start";
  #|     listPane.style.flex = "0 0 360px";
  #|     listPane.style.width = "360px";
  #|     listPane.style.minWidth = "360px";
  #|     listPane.style.maxWidth = "360px";
  #|     listPane.style.padding = "10px";
  #|     listPane.style.background = "#0f1720";
  #|     listPane.style.maxHeight = "70vh";
  #|     listPane.style.overflowY = "auto";
  #|     layout.appendChild(listPane);
  #|   }
  #|
  #|   let mainPane = document.getElementById("moon8bit-sprite-main-pane");
  #|   if (!mainPane) {
  #|     mainPane = document.createElement("div");
  #|     mainPane.id = "moon8bit-sprite-main-pane";
  #|     mainPane.style.display = "grid";
  #|     mainPane.style.gap = "10px";
  #|     mainPane.style.alignContent = "start";
  #|     mainPane.style.flex = "1 1 auto";
  #|     mainPane.style.minWidth = "0";
  #|     mainPane.style.padding = "10px";
  #|     mainPane.style.background = "#0f1720";
  #|     layout.appendChild(mainPane);
  #|   }
  #|
  #|   let title = document.getElementById("moon8bit-sprite-title");
  #|   if (!title) {
  #|     title = document.createElement("div");
  #|     title.id = "moon8bit-sprite-title";
  #|     title.textContent = "Sprite Editor (8/16/32)";
  #|     title.style.fontWeight = "600";
  #|     title.style.fontFamily = "monospace";
  #|     mainPane.appendChild(title);
  #|   }
  #|   title.style.fontSize = "18px";
  #|   if (title.parentElement !== mainPane) {
  #|     mainPane.appendChild(title);
  #|   }
  #|
  #|   let listTitle = document.getElementById("moon8bit-sprite-list-title");
  #|   if (!listTitle) {
  #|     listTitle = document.createElement("div");
  #|     listTitle.id = "moon8bit-sprite-list-title";
  #|     listTitle.textContent = "All Sprites";
  #|     listTitle.style.fontWeight = "600";
  #|     listTitle.style.fontFamily = "monospace";
  #|     listTitle.style.fontSize = "18px";
  #|     listPane.appendChild(listTitle);
  #|   }
  #|
  #|   let addSpriteBtn = document.getElementById("moon8bit-sprite-add-btn");
  #|   if (!addSpriteBtn) {
  #|     addSpriteBtn = document.createElement("button");
  #|     addSpriteBtn.id = "moon8bit-sprite-add-btn";
  #|     addSpriteBtn.textContent = "+ Sprite";
  #|     addSpriteBtn.style.padding = "8px 14px";
  #|     addSpriteBtn.style.background = "#1a3a1a";
  #|     addSpriteBtn.style.color = "#f6f7eb";
  #|     addSpriteBtn.style.border = "1px solid #4aa96c";
  #|     addSpriteBtn.style.cursor = "pointer";
  #|     listPane.appendChild(addSpriteBtn);
  #|   }
  #|
  #|   let listGrid = document.getElementById("moon8bit-sprite-list");
  #|   if (!listGrid) {
  #|     listGrid = document.createElement("div");
  #|     listGrid.id = "moon8bit-sprite-list";
  #|     listGrid.style.display = "grid";
  #|     listGrid.style.gap = "6px";
  #|     listPane.appendChild(listGrid);
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
  #|     mainPane.appendChild(row);
  #|   }
  #|   if (row.parentElement !== mainPane) {
  #|     mainPane.appendChild(row);
  #|   }
  #|
  #|   let nameLabel = document.getElementById("moon8bit-sprite-name-label");
  #|   if (!nameLabel) {
  #|     nameLabel = document.createElement("label");
  #|     nameLabel.id = "moon8bit-sprite-name-label";
  #|     nameLabel.textContent = "Name";
  #|     nameLabel.style.fontFamily = "monospace";
  #|     nameLabel.style.fontSize = "12px";
  #|     nameLabel.style.opacity = "0.8";
  #|     row.appendChild(nameLabel);
  #|   }
  #|
  #|   let nameInput = document.getElementById("moon8bit-sprite-name");
  #|   if (!nameInput) {
  #|     nameInput = document.createElement("input");
  #|     nameInput.id = "moon8bit-sprite-name";
  #|     nameInput.type = "text";
  #|     nameInput.placeholder = "sprite_name";
  #|     nameInput.style.width = "170px";
  #|     nameInput.style.background = "#0f1720";
  #|     nameInput.style.color = "#d9e2ec";
  #|     nameInput.style.border = "1px solid #486581";
  #|     nameInput.style.padding = "4px 6px";
  #|     row.appendChild(nameInput);
  #|   }
  #|
  #|   let sizeLabel = document.getElementById("moon8bit-sprite-size-label");
  #|   if (!sizeLabel) {
  #|     sizeLabel = document.createElement("label");
  #|     sizeLabel.id = "moon8bit-sprite-size-label";
  #|     sizeLabel.textContent = "Size";
  #|     sizeLabel.style.fontFamily = "monospace";
  #|     sizeLabel.style.fontSize = "12px";
  #|     sizeLabel.style.opacity = "0.8";
  #|     row.appendChild(sizeLabel);
  #|   }
  #|
  #|   let sizeSelect = document.getElementById("moon8bit-sprite-size");
  #|   if (!sizeSelect) {
  #|     sizeSelect = document.createElement("select");
  #|     sizeSelect.id = "moon8bit-sprite-size";
  #|     sizeSelect.style.background = "#0f1720";
  #|     sizeSelect.style.color = "#d9e2ec";
  #|     sizeSelect.style.border = "1px solid #486581";
  #|     sizeSelect.style.padding = "4px 6px";
  #|     [8, 16, 32].forEach((n) => {
  #|       const opt = document.createElement("option");
  #|       opt.value = String(n);
  #|       opt.textContent = `${n}x${n}`;
  #|       sizeSelect.appendChild(opt);
  #|     });
  #|     row.appendChild(sizeSelect);
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
  #|   select.style.display = "none";
  #|
  #|   let dupBtn = document.getElementById("moon8bit-sprite-dup-btn");
  #|   if (!dupBtn) {
  #|     dupBtn = document.createElement("button");
  #|     dupBtn.id = "moon8bit-sprite-dup-btn";
  #|     dupBtn.textContent = "Dup";
  #|     dupBtn.style.padding = "4px 8px";
  #|     dupBtn.style.background = "#355070";
  #|     dupBtn.style.color = "#f6f7eb";
  #|     dupBtn.style.border = "1px solid #486581";
  #|     row.appendChild(dupBtn);
  #|   }
  #|
  #|   let delBtn = document.getElementById("moon8bit-sprite-del-btn");
  #|   if (!delBtn) {
  #|     delBtn = document.createElement("button");
  #|     delBtn.id = "moon8bit-sprite-del-btn";
  #|     delBtn.textContent = "Del";
  #|     delBtn.style.padding = "4px 8px";
  #|     delBtn.style.background = "#7a2e2e";
  #|     delBtn.style.color = "#f6f7eb";
  #|     delBtn.style.border = "1px solid #964040";
  #|     row.appendChild(delBtn);
  #|   }
  #|
  #|   let paletteRow = document.getElementById("moon8bit-sprite-palette");
  #|   if (!paletteRow) {
  #|     paletteRow = document.createElement("div");
  #|     paletteRow.id = "moon8bit-sprite-palette";
  #|     paletteRow.style.display = "flex";
  #|     paletteRow.style.flexWrap = "wrap";
  #|     paletteRow.style.gap = "4px";
  #|     mainPane.appendChild(paletteRow);
  #|   }
  #|   if (paletteRow.parentElement !== mainPane) {
  #|     mainPane.appendChild(paletteRow);
  #|   }
  #|
  #|   let canvas = document.getElementById("moon8bit-sprite-canvas");
  #|   if (!canvas) {
  #|     canvas = document.createElement("canvas");
  #|     canvas.id = "moon8bit-sprite-canvas";
  #|     canvas.style.border = "1px solid #334e68";
  #|     canvas.style.imageRendering = "pixelated";
  #|     canvas.style.touchAction = "none";
  #|     mainPane.appendChild(canvas);
  #|   }
  #|   if (canvas.parentElement !== mainPane) {
  #|     mainPane.appendChild(canvas);
  #|   }
  #|
  #|   let info = document.getElementById("moon8bit-sprite-info");
  #|   if (!info) {
  #|     info = document.createElement("div");
  #|     info.id = "moon8bit-sprite-info";
  #|     info.style.fontFamily = "monospace";
  #|     info.style.fontSize = "12px";
  #|     info.style.opacity = "0.8";
  #|     mainPane.appendChild(info);
  #|   }
  #|   if (info.parentElement !== mainPane) {
  #|     mainPane.appendChild(info);
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
  #|   let spriteAutoWriteTimer = null;
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
  #|   const uniqueSpriteName = (base) => {
  #|     const used = new Set(state.sprites.map((sp) => sp.name));
  #|     if (!used.has(base)) return base;
  #|     let i = 1;
  #|     while (used.has(`${base}_${i}`)) i += 1;
  #|     return `${base}_${i}`;
  #|   };
  #|
  #|   const drawSpritePreview = (ctx, sprite, px, py, cell) => {
  #|     const dot = Math.max(1, Math.floor(cell / Math.max(sprite.width, sprite.height)));
  #|     const dw = sprite.width * dot;
  #|     const dh = sprite.height * dot;
  #|     const ox = px + Math.floor((cell - dw) / 2);
  #|     const oy = py + Math.floor((cell - dh) / 2);
  #|     for (let y = 0; y < sprite.height; y++) {
  #|       for (let x = 0; x < sprite.width; x++) {
  #|         const ci = sprite.pixels[y * sprite.width + x];
  #|         if (ci < 0) continue;
  #|         ctx.fillStyle = colorFor(ci) || "#ffffff";
  #|         ctx.fillRect(ox + x * dot, oy + y * dot, dot, dot);
  #|       }
  #|     }
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
  #|   const renderSpriteList = () => {
  #|     listGrid.innerHTML = "";
  #|     listTitle.textContent = `All Sprites (${state.sprites.length})`;
  #|     if (state.sprites.length === 0) return;
  #|     const selectedIdx = Math.max(0, Math.min(state.selectedSprite, state.sprites.length - 1));
  #|
  #|     state.sprites.forEach((sp, i) => {
  #|       const rowBtn = document.createElement("button");
  #|       rowBtn.type = "button";
  #|       rowBtn.style.display = "grid";
  #|       rowBtn.style.gridTemplateColumns = "56px 1fr";
  #|       rowBtn.style.gap = "10px";
  #|       rowBtn.style.alignItems = "center";
  #|       rowBtn.style.padding = "6px";
  #|       rowBtn.style.background = "#0f1720";
  #|       rowBtn.style.color = "#d9e2ec";
  #|       rowBtn.style.border = i === selectedIdx ? "2px solid #4aa96c" : "1px solid #334e68";
  #|       rowBtn.style.cursor = "pointer";
  #|       rowBtn.style.textAlign = "left";
  #|
  #|       const preview = document.createElement("canvas");
  #|       preview.width = 48;
  #|       preview.height = 48;
  #|       preview.style.width = "48px";
  #|       preview.style.height = "48px";
  #|       preview.style.imageRendering = "pixelated";
  #|       preview.style.display = "block";
  #|       const pctx = preview.getContext("2d");
  #|       if (pctx) {
  #|         pctx.imageSmoothingEnabled = false;
  #|         pctx.fillStyle = "#1f2a37";
  #|         pctx.fillRect(0, 0, 48, 48);
  #|         pctx.fillStyle = "#334e68";
  #|         pctx.fillRect(0, 0, 24, 24);
  #|         pctx.fillRect(24, 24, 24, 24);
  #|         drawSpritePreview(pctx, sp, 0, 0, 48);
  #|       }
  #|       rowBtn.appendChild(preview);
  #|
  #|       const meta = document.createElement("div");
  #|       meta.style.display = "grid";
  #|       meta.style.gap = "2px";
  #|       const nm = document.createElement("div");
  #|       nm.textContent = sp.name;
  #|       nm.style.fontFamily = "monospace";
  #|       nm.style.fontSize = "14px";
  #|       nm.style.fontWeight = "600";
  #|       const sz = document.createElement("div");
  #|       sz.textContent = `${sp.width}x${sp.height}`;
  #|       sz.style.fontFamily = "monospace";
  #|       sz.style.fontSize = "12px";
  #|       sz.style.opacity = "0.8";
  #|       meta.appendChild(nm);
  #|       meta.appendChild(sz);
  #|       rowBtn.appendChild(meta);
  #|
  #|       rowBtn.addEventListener("click", () => {
  #|         state.selectedSprite = i;
  #|         select.value = String(i);
  #|         renderSelectedMeta();
  #|         renderSpriteList();
  #|         renderCanvas();
  #|       });
  #|       listGrid.appendChild(rowBtn);
  #|     });
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
  #|   const resizeSpritePixels = (sprite, nextSize) => {
  #|     const oldW = sprite.width;
  #|     const oldH = sprite.height;
  #|     if (oldW === nextSize && oldH === nextSize) return;
  #|     const nextPixels = Array(nextSize * nextSize).fill(-1);
  #|     for (let y = 0; y < Math.min(oldH, nextSize); y++) {
  #|       for (let x = 0; x < Math.min(oldW, nextSize); x++) {
  #|         nextPixels[y * nextSize + x] = sprite.pixels[y * oldW + x];
  #|       }
  #|     }
  #|     sprite.width = nextSize;
  #|     sprite.height = nextSize;
  #|     sprite.pixels = nextPixels;
  #|   };
  #|
  #|   const renderSelectedMeta = () => {
  #|     const sprite = activeSprite();
  #|     if (!sprite) {
  #|       nameInput.value = "";
  #|       nameInput.disabled = true;
  #|       sizeSelect.disabled = true;
  #|       return;
  #|     }
  #|     nameInput.disabled = false;
  #|     sizeSelect.disabled = false;
  #|     nameInput.value = sprite.name;
  #|     sizeSelect.value = [8, 16, 32].includes(sprite.width) ? String(sprite.width) : "8";
  #|   };
  #|
  #|   const applyMetaFromUi = () => {
  #|     const sprite = activeSprite();
  #|     if (!sprite) return;
  #|     const nm = nameInput.value.trim();
  #|     if (nm !== "") {
  #|       sprite.name = nm;
  #|     }
  #|     const nextSize = Number(sizeSelect.value || "8");
  #|     if ([8, 16, 32].includes(nextSize)) {
  #|       resizeSpritePixels(sprite, nextSize);
  #|     }
  #|   };
  #|
  #|   const writeSpriteToDsl = (andApply) => {
  #|     const sprite = activeSprite();
  #|     if (!sprite) return;
  #|     applyMetaFromUi();
  #|     if (![8, 16, 32].includes(sprite.width) || ![8, 16, 32].includes(sprite.height)) {
  #|       info.textContent = `Sprite ${sprite.name} is not editable (${sprite.width}x${sprite.height}).`;
  #|       return;
  #|     }
  #|     if (!/^[A-Za-z0-9_-]+$/.test(sprite.name)) {
  #|       info.textContent = "Invalid sprite name. Use [A-Za-z0-9_-].";
  #|       return;
  #|     }
  #|     if (state.sprites.some((sp, i) => i !== state.selectedSprite && sp.name === sprite.name)) {
  #|       info.textContent = `Sprite ${sprite.name} already exists.`;
  #|       return;
  #|     }
  #|     const lines = state.lines.slice();
  #|     const rows = rowsFromSprite(sprite);
  #|     const block = [`sprite ${sprite.name} ${sprite.width} ${sprite.height}`, ...rows, "end"];
  #|     const start = sprite.headerLine;
  #|     const count = Math.max(1, sprite.endLine - sprite.headerLine + 1);
  #|     lines.splice(start, count, ...block);
  #|     const text = lines.join("\n");
  #|     textarea.value = text;
  #|     const keepName = sprite.name;
  #|     refreshFromText();
  #|     const idx = state.sprites.findIndex((sp) => sp.name === keepName);
  #|     if (idx >= 0) {
  #|       state.selectedSprite = idx;
  #|       select.value = String(idx);
  #|     }
  #|     renderSelectedMeta();
  #|     renderSpriteList();
  #|     renderCanvas();
  #|     if (andApply && globalThis.__moon8bit_apply_cb) {
  #|       globalThis.__moon8bit_apply_cb();
  #|     }
  #|   };
  #|
  #|   const scheduleSpriteAutoWrite = () => {
  #|     if (spriteAutoWriteTimer !== null) {
  #|       clearTimeout(spriteAutoWriteTimer);
  #|     }
  #|     spriteAutoWriteTimer = setTimeout(() => {
  #|       spriteAutoWriteTimer = null;
  #|       writeSpriteToDsl(false);
  #|     }, 60);
  #|   };
  #|
  #|   const deleteSelectedSprite = () => {
  #|     const sprite = activeSprite();
  #|     if (!sprite) return;
  #|     const lines = state.lines.slice();
  #|     const start = Math.max(0, sprite.headerLine);
  #|     const end = Math.max(start, sprite.endLine);
  #|     const count = end - start + 1;
  #|     if (count <= 0 || start >= lines.length) return;
  #|     lines.splice(start, count);
  #|     let text = lines.join("\n").replace(/\n{3,}/g, "\n\n");
  #|     if (text.trim() !== "") {
  #|       text = text.replace(/\s+$/, "") + "\n";
  #|     }
  #|     textarea.value = text;
  #|     const nextIdx = Math.max(0, state.selectedSprite - 1);
  #|     refreshFromText();
  #|     if (state.sprites.length > 0) {
  #|       state.selectedSprite = Math.min(nextIdx, state.sprites.length - 1);
  #|       select.value = String(state.selectedSprite);
  #|     }
  #|     renderSelectedMeta();
  #|     renderSpriteList();
  #|     renderCanvas();
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
  #|     renderSelectedMeta();
  #|     renderPalette();
  #|     renderSpriteList();
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
  #|     scheduleSpriteAutoWrite();
  #|   };
  #|
  #|   if (!globalThis.__moon8bit_sprite_bound) {
  #|     select.addEventListener("change", () => {
  #|       state.selectedSprite = Number(select.value) || 0;
  #|       renderSelectedMeta();
  #|       renderSpriteList();
  #|       renderCanvas();
  #|     });
  #|     nameInput.addEventListener("input", () => {
  #|       applyMetaFromUi();
  #|       renderSpriteList();
  #|       renderCanvas();
  #|       scheduleSpriteAutoWrite();
  #|     });
  #|     sizeSelect.addEventListener("change", () => {
  #|       applyMetaFromUi();
  #|       renderSelectedMeta();
  #|       renderSpriteList();
  #|       renderCanvas();
  #|       scheduleSpriteAutoWrite();
  #|     });
  #|     dupBtn.addEventListener("click", () => {
  #|       const src = activeSprite();
  #|       if (!src) return;
  #|       const name = uniqueSpriteName(`${src.name}_copy`);
  #|       const pixels = src.pixels.slice();
  #|       const row = (y) => {
  #|         let out = "";
  #|         for (let x = 0; x < src.width; x++) {
  #|           out += encodeSym(pixels[y * src.width + x]);
  #|         }
  #|         return out;
  #|       };
  #|       const block = [`sprite ${name} ${src.width} ${src.height}`];
  #|       for (let y = 0; y < src.height; y++) block.push(row(y));
  #|       block.push("end");
  #|       const baseText = textarea.value.replace(/\s+$/, "");
  #|       textarea.value = (baseText ? `${baseText}\n\n` : "") + block.join("\n") + "\n";
  #|       refreshFromText();
  #|       const idx = state.sprites.findIndex((sp) => sp.name === name);
  #|       if (idx >= 0) {
  #|         state.selectedSprite = idx;
  #|         select.value = String(idx);
  #|       }
  #|       renderSelectedMeta();
  #|       renderSpriteList();
  #|       renderCanvas();
  #|     });
  #|     delBtn.addEventListener("click", () => {
  #|       const sprite = activeSprite();
  #|       if (!sprite) return;
  #|       if (globalThis.confirm && !globalThis.confirm(`Delete sprite "${sprite.name}"?`)) return;
  #|       deleteSelectedSprite();
  #|     });
  #|     addSpriteBtn.addEventListener("click", () => {
  #|       const name = uniqueSpriteName("sprite");
  #|       const size = 8;
  #|       const row = ".".repeat(size);
  #|       const block = [`sprite ${name} ${size} ${size}`];
  #|       for (let i = 0; i < size; i++) block.push(row);
  #|       block.push("end");
  #|       const baseText = textarea.value.replace(/\s+$/, "");
  #|       textarea.value = (baseText ? `${baseText}\n\n` : "") + block.join("\n") + "\n";
  #|       refreshFromText();
  #|       const idx = state.sprites.findIndex((sp) => sp.name === name);
  #|       if (idx >= 0) {
  #|         state.selectedSprite = idx;
  #|         select.value = String(idx);
  #|       }
  #|       renderSelectedMeta();
  #|       renderSpriteList();
  #|       renderCanvas();
  #|     });
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
  #|   let mapLayout = document.getElementById("moon8bit-tilemap-layout");
  #|   if (!mapLayout) {
  #|     mapLayout = document.createElement("div");
  #|     mapLayout.id = "moon8bit-tilemap-layout";
  #|     mapLayout.style.display = "flex";
  #|     mapLayout.style.flexDirection = "row";
  #|     mapLayout.style.alignItems = "flex-start";
  #|     mapLayout.style.flexWrap = "nowrap";
  #|     mapLayout.style.overflowX = "auto";
  #|     mapLayout.style.gap = "24px";
  #|   }
  #|   if (mapLayout.parentElement !== panel) {
  #|     panel.appendChild(mapLayout);
  #|   }
  #|
  #|   let mapThumbPane = document.getElementById("moon8bit-tilemap-thumb-pane");
  #|   if (!mapThumbPane) {
  #|     mapThumbPane = document.createElement("div");
  #|     mapThumbPane.id = "moon8bit-tilemap-thumb-pane";
  #|     mapThumbPane.style.display = "grid";
  #|     mapThumbPane.style.gap = "10px";
  #|     mapThumbPane.style.alignContent = "start";
  #|     mapThumbPane.style.flex = "0 0 600px";
  #|     mapThumbPane.style.width = "600px";
  #|     mapThumbPane.style.minWidth = "600px";
  #|     mapThumbPane.style.maxWidth = "600px";
  #|     mapThumbPane.style.padding = "10px";
  #|     mapThumbPane.style.background = "#0f1720";
  #|     mapThumbPane.style.maxHeight = "70vh";
  #|     mapThumbPane.style.overflowY = "auto";
  #|   }
  #|   if (mapThumbPane.parentElement !== mapLayout) {
  #|     mapLayout.appendChild(mapThumbPane);
  #|   }
  #|
  #|   let mapMainPane = document.getElementById("moon8bit-tilemap-main-pane");
  #|   if (!mapMainPane) {
  #|     mapMainPane = document.createElement("div");
  #|     mapMainPane.id = "moon8bit-tilemap-main-pane";
  #|     mapMainPane.style.display = "grid";
  #|     mapMainPane.style.gap = "12px";
  #|     mapMainPane.style.alignContent = "start";
  #|     mapMainPane.style.flex = "1 1 auto";
  #|     mapMainPane.style.minWidth = "0";
  #|     mapMainPane.style.padding = "10px";
  #|     mapMainPane.style.background = "#0f1720";
  #|     mapMainPane.style.maxHeight = "70vh";
  #|     mapMainPane.style.overflow = "auto";
  #|   }
  #|   mapMainPane.style.maxHeight = "70vh";
  #|   mapMainPane.style.overflow = "auto";
  #|   if (mapMainPane.parentElement !== mapLayout) {
  #|     mapLayout.appendChild(mapMainPane);
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
  #|   title.style.fontSize = "18px";
  #|   if (title.parentElement !== mapMainPane) {
  #|     mapMainPane.appendChild(title);
  #|   }
  #|
  #|   let row = document.getElementById("moon8bit-tilemap-row");
  #|   if (!row) {
  #|     row = document.createElement("div");
  #|     row.id = "moon8bit-tilemap-row";
  #|     row.style.display = "flex";
  #|     row.style.gap = "10px";
  #|     row.style.flexWrap = "wrap";
  #|     row.style.alignItems = "center";
  #|   }
  #|   row.style.gap = "10px";
  #|   if (row.parentElement !== mapMainPane) {
  #|     mapMainPane.appendChild(row);
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
  #|   let viewportWrap = document.getElementById("moon8bit-tilemap-viewport-wrap");
  #|   if (!viewportWrap) {
  #|     viewportWrap = document.createElement("label");
  #|     viewportWrap.id = "moon8bit-tilemap-viewport-wrap";
  #|     viewportWrap.style.display = "inline-flex";
  #|     viewportWrap.style.alignItems = "center";
  #|     viewportWrap.style.gap = "6px";
  #|     viewportWrap.style.fontFamily = "monospace";
  #|     viewportWrap.style.fontSize = "13px";
  #|     viewportWrap.style.color = "#d9e2ec";
  #|   }
  #|   if (viewportWrap.parentElement !== row) {
  #|     row.appendChild(viewportWrap);
  #|   }
  #|   let viewportInput = document.getElementById("moon8bit-tilemap-viewport");
  #|   if (!viewportInput) {
  #|     viewportInput = document.createElement("input");
  #|     viewportInput.id = "moon8bit-tilemap-viewport";
  #|     viewportInput.type = "checkbox";
  #|     viewportWrap.appendChild(viewportInput);
  #|     const viewportText = document.createElement("span");
  #|     viewportText.textContent = "Viewport Grid";
  #|     viewportWrap.appendChild(viewportText);
  #|   }
  #|
  #|   const ensureBtn = (id, label, bg, border) => {
  #|     let btn = document.getElementById(id);
  #|     if (!btn) {
  #|       btn = document.createElement("button");
  #|       btn.id = id;
  #|       btn.textContent = label;
  #|       btn.style.padding = "7px 12px";
  #|       btn.style.background = bg;
  #|       btn.style.color = "#f6f7eb";
  #|       btn.style.border = `1px solid ${border}`;
  #|       btn.style.cursor = "pointer";
  #|       btn.style.fontSize = "14px";
  #|     }
  #|     btn.style.padding = "7px 12px";
  #|     btn.style.fontSize = "14px";
  #|     if (btn.parentElement !== row) {
  #|       row.appendChild(btn);
  #|     }
  #|     return btn;
  #|   };
  #|
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
  #|   if (canvas.parentElement !== mapMainPane) {
  #|     mapMainPane.appendChild(canvas);
  #|   }
  #|
  #|   let mapThumbTitle = document.getElementById("moon8bit-tilemap-thumb-title");
  #|   if (!mapThumbTitle) {
  #|     mapThumbTitle = document.createElement("div");
  #|     mapThumbTitle.id = "moon8bit-tilemap-thumb-title";
  #|     mapThumbTitle.textContent = "Brush Assets";
  #|     mapThumbTitle.style.fontWeight = "600";
  #|     mapThumbTitle.style.fontFamily = "monospace";
  #|   }
  #|   mapThumbTitle.style.fontSize = "18px";
  #|   if (mapThumbTitle.parentElement !== mapThumbPane) {
  #|     mapThumbPane.appendChild(mapThumbTitle);
  #|   }
  #|
  #|   let mapThumbTabRow = document.getElementById("moon8bit-tilemap-thumb-tab-row");
  #|   if (!mapThumbTabRow) {
  #|     mapThumbTabRow = document.createElement("div");
  #|     mapThumbTabRow.id = "moon8bit-tilemap-thumb-tab-row";
  #|     mapThumbTabRow.style.display = "flex";
  #|     mapThumbTabRow.style.gap = "8px";
  #|     mapThumbTabRow.style.alignItems = "center";
  #|   }
  #|   if (mapThumbTabRow.parentElement !== mapThumbPane) {
  #|     mapThumbPane.appendChild(mapThumbTabRow);
  #|   }
  #|
  #|   const ensureMapAssetTabBtn = (id, label) => {
  #|     let btn = document.getElementById(id);
  #|     if (!btn) {
  #|       btn = document.createElement("button");
  #|       btn.id = id;
  #|       btn.type = "button";
  #|       btn.textContent = label;
  #|       btn.style.padding = "6px 10px";
  #|       btn.style.cursor = "pointer";
  #|       btn.style.fontFamily = "monospace";
  #|       btn.style.fontSize = "13px";
  #|     }
  #|     if (btn.parentElement !== mapThumbTabRow) {
  #|       mapThumbTabRow.appendChild(btn);
  #|     }
  #|     return btn;
  #|   };
  #|   const mapTilesTabBtn = ensureMapAssetTabBtn("moon8bit-tilemap-assets-tab-tiles", "Tiles");
  #|   const mapSpritesTabBtn = ensureMapAssetTabBtn("moon8bit-tilemap-assets-tab-sprites", "Sprites");
  #|
  #|   let mapThumbGrid = document.getElementById("moon8bit-tilemap-thumb-grid");
  #|   if (!mapThumbGrid) {
  #|     mapThumbGrid = document.createElement("div");
  #|     mapThumbGrid.id = "moon8bit-tilemap-thumb-grid";
  #|     mapThumbGrid.style.display = "grid";
  #|     mapThumbGrid.style.gap = "0";
  #|   }
  #|   if (mapThumbGrid.parentElement !== mapThumbPane) {
  #|     mapThumbPane.appendChild(mapThumbGrid);
  #|   }
  #|
  #|   let mapSpriteThumbGrid = document.getElementById("moon8bit-tilemap-sprite-thumb-grid");
  #|   if (!mapSpriteThumbGrid) {
  #|     mapSpriteThumbGrid = document.createElement("div");
  #|     mapSpriteThumbGrid.id = "moon8bit-tilemap-sprite-thumb-grid";
  #|     mapSpriteThumbGrid.style.display = "grid";
  #|     mapSpriteThumbGrid.style.gap = "8px";
  #|   }
  #|   if (mapSpriteThumbGrid.parentElement !== mapThumbPane) {
  #|     mapThumbPane.appendChild(mapSpriteThumbGrid);
  #|   }
  #|
  #|   let tilePanel = document.getElementById("moon8bit-tile-panel");
  #|   if (!tilePanel) {
  #|     tilePanel = document.createElement("div");
  #|     tilePanel.id = "moon8bit-tile-panel";
  #|     tilePanel.style.display = "grid";
  #|     tilePanel.style.gap = "10px";
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
  #|   tileTitle.style.fontSize = "18px";
  #|
  #|   let tileLayout = document.getElementById("moon8bit-tile-layout");
  #|   if (!tileLayout) {
  #|     tileLayout = document.createElement("div");
  #|     tileLayout.id = "moon8bit-tile-layout";
  #|     tileLayout.style.display = "flex";
  #|     tileLayout.style.flexDirection = "row";
  #|     tileLayout.style.alignItems = "flex-start";
  #|     tileLayout.style.flexWrap = "nowrap";
  #|     tileLayout.style.overflowX = "auto";
  #|     tileLayout.style.gap = "24px";
  #|   }
  #|   tileLayout.style.display = "flex";
  #|   tileLayout.style.flexDirection = "row";
  #|   tileLayout.style.alignItems = "flex-start";
  #|   tileLayout.style.flexWrap = "nowrap";
  #|   tileLayout.style.overflowX = "auto";
  #|   tileLayout.style.gridTemplateColumns = "";
  #|   tileLayout.style.gap = "24px";
  #|   if (tileLayout.parentElement !== tilePanel) {
  #|     tilePanel.appendChild(tileLayout);
  #|   }
  #|
  #|   let tileEditorPane = document.getElementById("moon8bit-tile-editor-pane");
  #|   if (!tileEditorPane) {
  #|     tileEditorPane = document.createElement("div");
  #|     tileEditorPane.id = "moon8bit-tile-editor-pane";
  #|     tileEditorPane.style.display = "grid";
  #|     tileEditorPane.style.gap = "12px";
  #|     tileEditorPane.style.alignContent = "start";
  #|     tileEditorPane.style.minWidth = "0";
  #|   }
  #|   tileEditorPane.id = "moon8bit-tile-editor-pane";
  #|   tileEditorPane.style.gap = "12px";
  #|   tileEditorPane.style.flex = "1 1 auto";
  #|   tileEditorPane.style.minWidth = "0";
  #|   tileEditorPane.style.padding = "10px";
  #|   tileEditorPane.style.border = "none";
  #|   tileEditorPane.style.background = "#0f1720";
  #|   if (tileEditorPane.parentElement !== tileLayout) {
  #|     tileLayout.appendChild(tileEditorPane);
  #|   }
  #|   if (tileTitle.parentElement !== tileEditorPane) {
  #|     tileEditorPane.appendChild(tileTitle);
  #|   }
  #|
  #|   let tileThumbPane = document.getElementById("moon8bit-tile-thumb-pane");
  #|   if (!tileThumbPane) {
  #|     tileThumbPane = document.createElement("div");
  #|     tileThumbPane.id = "moon8bit-tile-thumb-pane";
  #|     tileThumbPane.style.display = "grid";
  #|     tileThumbPane.style.gap = "10px";
  #|     tileThumbPane.style.alignContent = "start";
  #|     tileThumbPane.style.minWidth = "600px";
  #|     tileThumbPane.style.maxHeight = "70vh";
  #|     tileThumbPane.style.overflowY = "auto";
  #|   }
  #|   tileThumbPane.id = "moon8bit-tile-thumb-pane";
  #|   tileThumbPane.style.gap = "10px";
  #|   tileThumbPane.style.flex = "0 0 600px";
  #|   tileThumbPane.style.width = "600px";
  #|   tileThumbPane.style.minWidth = "600px";
  #|   tileThumbPane.style.maxWidth = "600px";
  #|   tileThumbPane.style.padding = "10px";
  #|   tileThumbPane.style.border = "none";
  #|   tileThumbPane.style.background = "#0f1720";
  #|   if (tileThumbPane.parentElement !== tileLayout) {
  #|     tileLayout.appendChild(tileThumbPane);
  #|   }
  #|   // Keep visual order: left = thumbnails (tileThumbPane), right = editor (tileEditorPane)
  #|   if (tileLayout.firstElementChild !== tileThumbPane) {
  #|     tileLayout.insertBefore(tileThumbPane, tileLayout.firstElementChild);
  #|   }
  #|   if (tileLayout.lastElementChild !== tileEditorPane) {
  #|     tileLayout.appendChild(tileEditorPane);
  #|   }
  #|
  #|   let tileRow = document.getElementById("moon8bit-tile-row");
  #|   if (!tileRow) {
  #|     tileRow = document.createElement("div");
  #|     tileRow.id = "moon8bit-tile-row";
  #|     tileRow.style.display = "flex";
  #|     tileRow.style.gap = "10px";
  #|     tileRow.style.flexWrap = "wrap";
  #|     tileRow.style.alignItems = "center";
  #|   }
  #|   tileRow.style.gap = "10px";
  #|   if (tileRow.parentElement !== tileEditorPane) {
  #|     tileEditorPane.appendChild(tileRow);
  #|   }
  #|
  #|   let tileNameInput = document.getElementById("moon8bit-tilemap-tile-name");
  #|   if (!tileNameInput) {
  #|     tileNameInput = document.createElement("input");
  #|     tileNameInput.id = "moon8bit-tilemap-tile-name";
  #|     tileNameInput.type = "text";
  #|     tileNameInput.placeholder = "selected tile name";
  #|     tileNameInput.style.width = "320px";
  #|     tileNameInput.style.background = "#0f1720";
  #|     tileNameInput.style.color = "#d9e2ec";
  #|     tileNameInput.style.border = "1px solid #486581";
  #|   }
  #|   tileNameInput.style.width = "320px";
  #|   tileNameInput.style.fontSize = "15px";
  #|   tileNameInput.style.padding = "6px 8px";
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
  #|     solidWrap.style.gap = "6px";
  #|     solidWrap.style.fontFamily = "monospace";
  #|     solidWrap.style.fontSize = "14px";
  #|   }
  #|   solidWrap.style.gap = "6px";
  #|   solidWrap.style.fontSize = "14px";
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
  #|     txt.textContent = "solid";
  #|     solidWrap.appendChild(txt);
  #|   }
  #|
  #|   const ensureTileBtn = (id, label, bg, border) => {
  #|     let btn = document.getElementById(id);
  #|     if (!btn) {
  #|       btn = document.createElement("button");
  #|       btn.id = id;
  #|       btn.textContent = label;
  #|       btn.style.padding = "7px 12px";
  #|       btn.style.background = bg;
  #|       btn.style.color = "#f6f7eb";
  #|       btn.style.border = `1px solid ${border}`;
  #|       btn.style.cursor = "pointer";
  #|       btn.style.fontSize = "14px";
  #|     }
  #|     btn.style.padding = "7px 12px";
  #|     btn.style.fontSize = "14px";
  #|     if (btn.parentElement !== tileRow) {
  #|       tileRow.appendChild(btn);
  #|     }
  #|     return btn;
  #|   };
  #|   const delTileBtn = ensureTileBtn("moon8bit-tile-del-btn", "Del Tile", "#7a2e2e", "#964040");
  #|
  #|   let tilePaletteRow = document.getElementById("moon8bit-tilemap-palette");
  #|   if (!tilePaletteRow) {
  #|     tilePaletteRow = document.createElement("div");
  #|     tilePaletteRow.id = "moon8bit-tilemap-palette";
  #|     tilePaletteRow.style.display = "flex";
  #|     tilePaletteRow.style.flexWrap = "wrap";
  #|     tilePaletteRow.style.gap = "8px";
  #|   }
  #|   tilePaletteRow.style.gap = "8px";
  #|   if (tilePaletteRow.parentElement !== tileEditorPane) {
  #|     tileEditorPane.appendChild(tilePaletteRow);
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
  #|   if (tileCanvas.parentElement !== tileEditorPane) {
  #|     tileEditorPane.appendChild(tileCanvas);
  #|   }
  #|
  #|   let tileInfo = document.getElementById("moon8bit-tilemap-tile-info");
  #|   if (!tileInfo) {
  #|     tileInfo = document.createElement("div");
  #|     tileInfo.id = "moon8bit-tilemap-tile-info";
  #|     tileInfo.style.fontFamily = "monospace";
  #|     tileInfo.style.fontSize = "14px";
  #|     tileInfo.style.opacity = "0.8";
  #|   }
  #|   tileInfo.style.fontSize = "14px";
  #|   if (tileInfo.parentElement !== tileEditorPane) {
  #|     tileEditorPane.appendChild(tileInfo);
  #|   }
  #|
  #|   let tileThumbTitle = document.getElementById("moon8bit-tile-thumb-title");
  #|   if (!tileThumbTitle) {
  #|     tileThumbTitle = document.createElement("div");
  #|     tileThumbTitle.id = "moon8bit-tile-thumb-title";
  #|     tileThumbTitle.textContent = "All Tiles";
  #|     tileThumbTitle.style.fontWeight = "600";
  #|     tileThumbTitle.style.fontFamily = "monospace";
  #|   }
  #|   tileThumbTitle.style.fontSize = "18px";
  #|   if (tileThumbTitle.parentElement !== tileThumbPane) {
  #|     tileThumbPane.appendChild(tileThumbTitle);
  #|   }
  #|
  #|   let tileThumbGrid = document.getElementById("moon8bit-tile-thumb-grid");
  #|   if (!tileThumbGrid) {
  #|     tileThumbGrid = document.createElement("div");
  #|     tileThumbGrid.id = "moon8bit-tile-thumb-grid";
  #|     tileThumbGrid.style.display = "grid";
  #|     tileThumbGrid.style.gap = "0";
  #|   }
  #|   if (tileThumbGrid.parentElement !== tileThumbPane) {
  #|     tileThumbPane.appendChild(tileThumbGrid);
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
  #|   if (info.parentElement !== mapMainPane) {
  #|     mapMainPane.appendChild(info);
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
  #|   if (dirty.parentElement !== mapMainPane) {
  #|     mapMainPane.appendChild(dirty);
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
  #|   if (feedback.parentElement !== mapMainPane) {
  #|     mapMainPane.appendChild(feedback);
  #|   }
  #|
  #|   if (!globalThis.__moon8bit_tilemap_state) {
  #|     globalThis.__moon8bit_tilemap_state = {
  #|       lines: [],
  #|       palette: fallbackPalette.slice(),
  #|       tiles: null,
  #|       tileRange: null,
  #|       tilemaps: [],
  #|       tilemapRange: null,
  #|       sprites: [],
  #|       placements: [],
  #|       placementRange: null,
  #|       errors: [],
  #|       selectedMap: 0,
  #|       selectedSpriteName: "",
  #|       mapThumbTab: "tiles",
  #|       selectedTileId: 0,
  #|       selectedTileColor: 0,
  #|       showViewportGrid: true,
  #|       dirty: false,
  #|       cell: 16,
  #|       tileCell: 20,
  #|       tileClipboard: null,
  #|     };
  #|   }
  #|   const state = globalThis.__moon8bit_tilemap_state;
  #|   let tilemapAutoWriteTimer = null;
  #|   if (!("tileClipboard" in state)) {
  #|     state.tileClipboard = null;
  #|   }
  #|   if (!Array.isArray(state.sprites)) state.sprites = [];
  #|   if (!Array.isArray(state.placements)) state.placements = [];
  #|   if (!state.placementRange || !Number.isInteger(state.placementRange.first) || !Number.isInteger(state.placementRange.last)) {
  #|     state.placementRange = null;
  #|   }
  #|   if (typeof state.selectedSpriteName !== "string") state.selectedSpriteName = "";
  #|   if (state.mapThumbTab !== "tiles" && state.mapThumbTab !== "sprites") state.mapThumbTab = "tiles";
  #|   if (typeof state.showViewportGrid !== "boolean") state.showViewportGrid = true;
  #|
  #|   function scheduleTilemapAutoWrite() {
  #|     if (tilemapAutoWriteTimer !== null) {
  #|       clearTimeout(tilemapAutoWriteTimer);
  #|     }
  #|     tilemapAutoWriteTimer = setTimeout(() => {
  #|       tilemapAutoWriteTimer = null;
  #|       writeTilemapToDsl(false);
  #|     }, 80);
  #|   }
  #|
  #|   const setDirty = (v, autoWrite = true) => {
  #|     state.dirty = !!v;
  #|     dirty.textContent = state.dirty ? "Modified" : "Saved";
  #|     dirty.style.color = state.dirty ? "#efb366" : "#7bd389";
  #|     if (state.dirty && autoWrite) {
  #|       scheduleTilemapAutoWrite();
  #|     }
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
  #|     const sprites = [];
  #|     const tiles = {
  #|       tile_count: 256,
  #|       tile_names: Array.from({ length: 256 }, (_, i) => `tile_${i}`),
  #|       tile_solid: Array(256).fill(false),
  #|       tile_defined: Array(256).fill(false),
  #|       pixels: Array(256 * 64).fill(-1),
  #|     };
  #|     const tilemaps = [];
  #|     const placements = [];
  #|     let tileFirstHeader = -1;
  #|     let tileLastEnd = -1;
  #|     let tilemapFirstHeader = -1;
  #|     let tilemapLastEnd = -1;
  #|     let placementFirstLine = -1;
  #|     let placementLastLine = -1;
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
  #|       const sm = t.match(/^sprite\s+([^\s]+)\s+(\d+)\s+(\d+)$/i);
  #|       if (sm) {
  #|         const name = sm[1];
  #|         const width = Math.max(1, parseIntStrict(sm[2]) | 0);
  #|         const height = Math.max(1, parseIntStrict(sm[3]) | 0);
  #|         const pixels = Array(width * height).fill(-1);
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
  #|             pushErr(j + 1, `sprite ${name} has too many rows`);
  #|             j += 1;
  #|             continue;
  #|           }
  #|           if (raw.length !== width) {
  #|             pushErr(j + 1, `sprite row width mismatch: expected ${width}, got ${raw.length}`);
  #|           }
  #|           for (let x = 0; x < width; x += 1) {
  #|             const ch = x < raw.length ? raw[x] : ".";
  #|             if (!/[0-9a-fA-F.]/.test(ch)) {
  #|               pushErr(j + 1, `unsupported sprite symbol: ${ch}`);
  #|             }
  #|             pixels[row * width + x] = decodeSym(ch);
  #|           }
  #|           row += 1;
  #|           j += 1;
  #|         }
  #|         if (endLine < 0) {
  #|           pushErr(i + 1, `sprite ${name} block is missing end`);
  #|         } else {
  #|           i = endLine;
  #|         }
  #|         if (row !== height) {
  #|           pushErr((endLine >= 0 ? endLine + 1 : i + 1), `sprite ${name} expects ${height} rows, got ${row}`);
  #|         }
  #|         sprites.push({ name, width, height, pixels });
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
  #|           tiles.tile_names[id] = tileName;
  #|           tiles.tile_solid[id] = !!solid;
  #|           tiles.tile_defined[id] = true;
  #|           const base = id * 64;
  #|           for (let k = 0; k < 64; k += 1) tiles.pixels[base + k] = pixels[k];
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
  #|
  #|       const pm = t.match(/^place\s+([^\s]+)\s+([^\s]+)\s+(-?\d+)\s+(-?\d+)$/i);
  #|       if (pm) {
  #|         const name = pm[1];
  #|         const sprite = pm[2];
  #|         const x = parseIntStrict(pm[3]);
  #|         const y = parseIntStrict(pm[4]);
  #|         if (!Number.isFinite(x) || !Number.isFinite(y)) {
  #|           pushErr(i + 1, "place directive x/y must be integers");
  #|         } else {
  #|           placements.push({ name, sprite, x: x | 0, y: y | 0, line: i });
  #|           if (placementFirstLine < 0 || i < placementFirstLine) placementFirstLine = i;
  #|           if (i > placementLastLine) placementLastLine = i;
  #|         }
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
  #|     for (const p of placements) {
  #|       if (!sprites.some((s) => s.name === p.sprite)) {
  #|         pushErr((Number.isInteger(p.line) ? p.line : 0) + 1, `placement '${p.name}' references unknown sprite: ${p.sprite}`);
  #|       }
  #|     }
  #|
  #|     const tileRange = (tileFirstHeader >= 0 && tileLastEnd >= tileFirstHeader)
  #|       ? { first: tileFirstHeader, last: tileLastEnd }
  #|       : null;
  #|     const tilemapRange = (tilemapFirstHeader >= 0 && tilemapLastEnd >= tilemapFirstHeader)
  #|       ? { first: tilemapFirstHeader, last: tilemapLastEnd }
  #|       : null;
  #|     const placementRange = (placementFirstLine >= 0 && placementLastLine >= placementFirstLine)
  #|       ? { first: placementFirstLine, last: placementLastLine }
  #|       : null;
  #|     return { lines, palette, sprites, tiles, tileRange, tilemaps, tilemapRange, placements, placementRange, errors };
  #|   };
  #|
  #|   const activeMap = () => {
  #|     if (state.tilemaps.length === 0) return null;
  #|     const idx = Math.max(0, Math.min(state.selectedMap, state.tilemaps.length - 1));
  #|     state.selectedMap = idx;
  #|     return state.tilemaps[idx];
  #|   };
  #|
  #|   const applyMapAssetTabUi = () => {
  #|     const tab = state.mapThumbTab === "sprites" ? "sprites" : "tiles";
  #|     state.mapThumbTab = tab;
  #|     const tabBtnStyle = (btn, active) => {
  #|       btn.style.background = active ? "#274060" : "#0f1720";
  #|       btn.style.color = active ? "#f6f7eb" : "#9fb3c8";
  #|       btn.style.border = active ? "1px solid #4aa96c" : "1px solid #486581";
  #|     };
  #|     tabBtnStyle(mapTilesTabBtn, tab === "tiles");
  #|     tabBtnStyle(mapSpritesTabBtn, tab === "sprites");
  #|     mapThumbTitle.textContent = tab === "tiles" ? "All Tiles" : "All Sprites";
  #|     mapThumbGrid.style.display = tab === "tiles" ? "grid" : "none";
  #|     mapSpriteThumbGrid.style.display = tab === "sprites" ? "grid" : "none";
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
  #|     const ts = state.tiles;
  #|     if (!ts || ts.tile_count <= 0) return -1;
  #|     let id = Number.isInteger(state.selectedTileId) ? state.selectedTileId : 0;
  #|     if (id < 0) id = 0;
  #|     if (id >= ts.tile_count) id = ts.tile_count - 1;
  #|     state.selectedTileId = id;
  #|     return id;
  #|   };
  #|
  #|   const renderTilePalette = () => {
  #|     tilePaletteRow.innerHTML = "";
  #|     const mk = (idx, hex, label) => {
  #|       const b = document.createElement("button");
  #|       b.type = "button";
  #|       b.title = label;
  #|       b.style.width = "30px";
  #|       b.style.height = "30px";
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
  #|     transparent.style.width = "30px";
  #|     transparent.style.height = "30px";
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
  #|     const ts = state.tiles;
  #|     const id = activeTileId();
  #|     const ctx = tileCanvas.getContext("2d");
  #|     if (!ctx || !ts || id < 0) {
  #|       tileCanvas.width = 1;
  #|       tileCanvas.height = 1;
  #|       tileInfo.textContent = "Tile editor: choose a tile.";
  #|       return;
  #|     }
  #|     state.tileCell = 52;
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
  #|     const ts = state.tiles;
  #|     const id = activeTileId();
  #|     if (!ts || !Number.isInteger(id) || id < 0 || id >= ts.tile_count) {
  #|       solidInput.checked = false;
  #|       solidInput.disabled = true;
  #|       tileNameInput.value = "";
  #|       tileNameInput.disabled = true;
  #|       renderTileCanvas();
  #|       return;
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
  #|   const drawSpritePreviewInMap = (ctx, sprite, px, py, unit) => {
  #|     if (!sprite || !Array.isArray(sprite.pixels)) return;
  #|     for (let y = 0; y < sprite.height; y += 1) {
  #|       for (let x = 0; x < sprite.width; x += 1) {
  #|         const ci = sprite.pixels[y * sprite.width + x];
  #|         if (ci < 0) continue;
  #|         ctx.fillStyle = colorFor(ci) || "#ffffff";
  #|         const dx = Math.floor(px + x * unit);
  #|         const dy = Math.floor(py + y * unit);
  #|         const dw = Math.max(1, Math.ceil(unit));
  #|         const dh = Math.max(1, Math.ceil(unit));
  #|         ctx.fillRect(dx, dy, dw, dh);
  #|       }
  #|     }
  #|   };
  #|
  #|   const activeSpriteBrushName = () => {
  #|     const sprites = Array.isArray(state.sprites) ? state.sprites : [];
  #|     let name = String(state.selectedSpriteName || "");
  #|     if (!sprites.some((sp) => String(sp.name) === name)) {
  #|       name = sprites.length > 0 ? String(sprites[0].name || "") : "";
  #|     }
  #|     state.selectedSpriteName = name;
  #|     return name;
  #|   };
  #|
  #|   const findSpriteMetaByName = (name) => {
  #|     const sprites = Array.isArray(state.sprites) ? state.sprites : [];
  #|     for (const sp of sprites) {
  #|       if (String(sp.name) === String(name)) return sp;
  #|     }
  #|     return null;
  #|   };
  #|
  #|   const nextPlacementName = (spriteName) => {
  #|     const base = String(spriteName || "spawn");
  #|     const used = new Set((state.placements || []).map((p) => String(p.name || "")));
  #|     let i = 1;
  #|     while (used.has(`${base}_${i}`)) i += 1;
  #|     return `${base}_${i}`;
  #|   };
  #|
  #|   const renderTileThumbnails = () => {
  #|     tileThumbGrid.innerHTML = "";
  #|     const ts = state.tiles;
  #|     if (!ts || ts.tile_count <= 0) return;
  #|     const selectedId = activeTileId();
  #|
  #|     const cols = 10;
  #|     const thumbSize = 48;
  #|     const rows = Math.ceil(ts.tile_count / cols);
  #|
  #|     const header = document.createElement("div");
  #|     header.style.display = "grid";
  #|     header.style.gridTemplateColumns = `28px repeat(${cols}, ${thumbSize}px)`;
  #|     header.style.gap = "0";
  #|     header.style.marginBottom = "0";
  #|     header.style.width = "fit-content";
  #|     const headerBlank = document.createElement("div");
  #|     header.appendChild(headerBlank);
  #|     for (let col = 0; col < cols; col += 1) {
  #|       const mark = document.createElement("div");
  #|       mark.textContent = String(col);
  #|       mark.style.fontFamily = "monospace";
  #|       mark.style.fontSize = "13px";
  #|       mark.style.color = "#9fb3c8";
  #|       mark.style.textAlign = "center";
  #|       header.appendChild(mark);
  #|     }
  #|     tileThumbGrid.appendChild(header);
  #|
  #|     for (let row = 0; row < rows; row += 1) {
  #|       const rowWrap = document.createElement("div");
  #|       rowWrap.style.display = "grid";
  #|       rowWrap.style.gridTemplateColumns = `28px repeat(${cols}, ${thumbSize}px)`;
  #|       rowWrap.style.gap = "0";
  #|       rowWrap.style.width = "fit-content";
  #|
  #|       const rowMark = document.createElement("div");
  #|       rowMark.textContent = String(row * cols).toString(16).toUpperCase().padStart(2, "0");
  #|       rowMark.style.fontFamily = "monospace";
  #|       rowMark.style.fontSize = "13px";
  #|       rowMark.style.color = "#9fb3c8";
  #|       rowMark.style.textAlign = "right";
  #|       rowMark.style.paddingRight = "4px";
  #|       rowMark.style.lineHeight = `${thumbSize}px`;
  #|       rowWrap.appendChild(rowMark);
  #|
  #|       for (let col = 0; col < cols; col += 1) {
  #|         const i = row * cols + col;
  #|         if (i >= ts.tile_count) {
  #|           const spacer = document.createElement("div");
  #|           rowWrap.appendChild(spacer);
  #|           continue;
  #|         }
  #|
  #|         const cell = document.createElement("button");
  #|         cell.type = "button";
  #|         cell.style.display = "grid";
  #|         cell.style.placeItems = "center";
  #|         cell.style.padding = "0";
  #|         cell.style.border = "0";
  #|         cell.style.background = "transparent";
  #|         cell.style.outline = i === selectedId ? "2px solid #4aa96c" : "none";
  #|         cell.style.outlineOffset = i === selectedId ? "-2px" : "0";
  #|         cell.style.cursor = "pointer";
  #|         cell.style.borderRadius = "0";
  #|         cell.style.width = `${thumbSize}px`;
  #|         cell.style.height = `${thumbSize}px`;
  #|         cell.style.minHeight = `${thumbSize}px`;
  #|         const nm = ts.tile_names && ts.tile_names[i] ? ts.tile_names[i] : `tile_${i}`;
  #|         cell.title = `#${i} ${nm}`;
  #|
  #|         const preview = document.createElement("canvas");
  #|         preview.width = thumbSize;
  #|         preview.height = thumbSize;
  #|         preview.style.width = `${thumbSize}px`;
  #|         preview.style.height = `${thumbSize}px`;
  #|         preview.style.imageRendering = "pixelated";
  #|         preview.style.display = "block";
  #|         preview.style.filter = "none";
  #|         const pctx = preview.getContext("2d");
  #|         if (pctx) {
  #|           pctx.imageSmoothingEnabled = false;
  #|           pctx.fillStyle = "#1f2a37";
  #|           pctx.fillRect(0, 0, thumbSize, thumbSize);
  #|           pctx.fillStyle = "#334e68";
  #|           pctx.fillRect(0, 0, thumbSize / 2, thumbSize / 2);
  #|           pctx.fillRect(thumbSize / 2, thumbSize / 2, thumbSize / 2, thumbSize / 2);
  #|           if (ts.tile_defined && ts.tile_defined[i]) {
  #|             drawTilePreview(pctx, ts, i, 0, 0, thumbSize);
  #|           }
  #|         }
  #|         cell.appendChild(preview);
  #|
  #|         cell.addEventListener("click", () => {
  #|           state.selectedTileId = i;
  #|           refreshSolidUi();
  #|           renderTileThumbnails();
  #|           renderMapTileThumbnails();
  #|           renderCanvas();
  #|         });
  #|         rowWrap.appendChild(cell);
  #|       }
  #|       tileThumbGrid.appendChild(rowWrap);
  #|     }
  #|   };
  #|
  #|   const renderMapTileThumbnails = () => {
  #|     mapThumbGrid.innerHTML = "";
  #|     const ts = state.tiles;
  #|     if (!ts || ts.tile_count <= 0) return;
  #|     const selectedId = activeTileId();
  #|
  #|     const cols = 10;
  #|     const thumbSize = 48;
  #|     const rows = Math.ceil(ts.tile_count / cols);
  #|
  #|     const header = document.createElement("div");
  #|     header.style.display = "grid";
  #|     header.style.gridTemplateColumns = `28px repeat(${cols}, ${thumbSize}px)`;
  #|     header.style.gap = "0";
  #|     header.style.marginBottom = "0";
  #|     header.style.width = "fit-content";
  #|     const headerBlank = document.createElement("div");
  #|     header.appendChild(headerBlank);
  #|     for (let col = 0; col < cols; col += 1) {
  #|       const mark = document.createElement("div");
  #|       mark.textContent = String(col);
  #|       mark.style.fontFamily = "monospace";
  #|       mark.style.fontSize = "13px";
  #|       mark.style.color = "#9fb3c8";
  #|       mark.style.textAlign = "center";
  #|       header.appendChild(mark);
  #|     }
  #|     mapThumbGrid.appendChild(header);
  #|
  #|     for (let row = 0; row < rows; row += 1) {
  #|       const rowWrap = document.createElement("div");
  #|       rowWrap.style.display = "grid";
  #|       rowWrap.style.gridTemplateColumns = `28px repeat(${cols}, ${thumbSize}px)`;
  #|       rowWrap.style.gap = "0";
  #|       rowWrap.style.width = "fit-content";
  #|
  #|       const rowMark = document.createElement("div");
  #|       rowMark.textContent = String(row * cols).toString(16).toUpperCase().padStart(2, "0");
  #|       rowMark.style.fontFamily = "monospace";
  #|       rowMark.style.fontSize = "13px";
  #|       rowMark.style.color = "#9fb3c8";
  #|       rowMark.style.textAlign = "right";
  #|       rowMark.style.paddingRight = "4px";
  #|       rowMark.style.lineHeight = `${thumbSize}px`;
  #|       rowWrap.appendChild(rowMark);
  #|
  #|       for (let col = 0; col < cols; col += 1) {
  #|         const i = row * cols + col;
  #|         if (i >= ts.tile_count) {
  #|           const spacer = document.createElement("div");
  #|           rowWrap.appendChild(spacer);
  #|           continue;
  #|         }
  #|
  #|         const cell = document.createElement("button");
  #|         cell.type = "button";
  #|         cell.style.display = "grid";
  #|         cell.style.placeItems = "center";
  #|         cell.style.padding = "0";
  #|         cell.style.border = "0";
  #|         cell.style.background = "transparent";
  #|         cell.style.outline = i === selectedId ? "2px solid #4aa96c" : "none";
  #|         cell.style.outlineOffset = i === selectedId ? "-2px" : "0";
  #|         cell.style.cursor = "pointer";
  #|         cell.style.borderRadius = "0";
  #|         cell.style.width = `${thumbSize}px`;
  #|         cell.style.height = `${thumbSize}px`;
  #|         cell.style.minHeight = `${thumbSize}px`;
  #|         const nm = ts.tile_names && ts.tile_names[i] ? ts.tile_names[i] : `tile_${i}`;
  #|         cell.title = `#${i} ${nm}`;
  #|
  #|         const preview = document.createElement("canvas");
  #|         preview.width = thumbSize;
  #|         preview.height = thumbSize;
  #|         preview.style.width = `${thumbSize}px`;
  #|         preview.style.height = `${thumbSize}px`;
  #|         preview.style.imageRendering = "pixelated";
  #|         preview.style.display = "block";
  #|         const pctx = preview.getContext("2d");
  #|         if (pctx) {
  #|           pctx.imageSmoothingEnabled = false;
  #|           pctx.fillStyle = "#1f2a37";
  #|           pctx.fillRect(0, 0, thumbSize, thumbSize);
  #|           pctx.fillStyle = "#334e68";
  #|           pctx.fillRect(0, 0, thumbSize / 2, thumbSize / 2);
  #|           pctx.fillRect(thumbSize / 2, thumbSize / 2, thumbSize / 2, thumbSize / 2);
  #|           if (ts.tile_defined && ts.tile_defined[i]) {
  #|             drawTilePreview(pctx, ts, i, 0, 0, thumbSize);
  #|           }
  #|         }
  #|         cell.appendChild(preview);
  #|
  #|         cell.addEventListener("click", () => {
  #|           state.selectedTileId = i;
  #|           state.mapThumbTab = "tiles";
  #|           applyMapAssetTabUi();
  #|           renderMapTileThumbnails();
  #|           renderCanvas();
  #|         });
  #|         rowWrap.appendChild(cell);
  #|       }
  #|       mapThumbGrid.appendChild(rowWrap);
  #|     }
  #|   };
  #|
  #|   const renderMapSpriteThumbnails = () => {
  #|     mapSpriteThumbGrid.innerHTML = "";
  #|     const sprites = Array.isArray(state.sprites) ? state.sprites : [];
  #|     if (sprites.length <= 0) {
  #|       const empty = document.createElement("div");
  #|       empty.textContent = "No sprites";
  #|       empty.style.fontFamily = "monospace";
  #|       empty.style.fontSize = "12px";
  #|       empty.style.opacity = "0.8";
  #|       mapSpriteThumbGrid.appendChild(empty);
  #|       return;
  #|     }
  #|     const selectedName = activeSpriteBrushName();
  #|     for (const sp of sprites) {
  #|       const rowBtn = document.createElement("button");
  #|       rowBtn.type = "button";
  #|       rowBtn.style.display = "grid";
  #|       rowBtn.style.gridTemplateColumns = "56px 1fr";
  #|       rowBtn.style.gap = "10px";
  #|       rowBtn.style.alignItems = "center";
  #|       rowBtn.style.padding = "6px";
  #|       rowBtn.style.background = "#0f1720";
  #|       rowBtn.style.color = "#d9e2ec";
  #|       rowBtn.style.border = String(sp.name) === selectedName ? "2px solid #4aa96c" : "1px solid #334e68";
  #|       rowBtn.style.cursor = "pointer";
  #|       rowBtn.style.textAlign = "left";
  #|
  #|       const preview = document.createElement("canvas");
  #|       preview.width = 48;
  #|       preview.height = 48;
  #|       preview.style.width = "48px";
  #|       preview.style.height = "48px";
  #|       preview.style.imageRendering = "pixelated";
  #|       preview.style.display = "block";
  #|       const pctx = preview.getContext("2d");
  #|       if (pctx) {
  #|         pctx.imageSmoothingEnabled = false;
  #|         pctx.fillStyle = "#1f2a37";
  #|         pctx.fillRect(0, 0, 48, 48);
  #|         pctx.fillStyle = "#334e68";
  #|         pctx.fillRect(0, 0, 24, 24);
  #|         pctx.fillRect(24, 24, 24, 24);
  #|         const unit = Math.max(1, Math.floor(48 / Math.max(sp.width, sp.height)));
  #|         const sw = sp.width * unit;
  #|         const sh = sp.height * unit;
  #|         const ox = Math.floor((48 - sw) / 2);
  #|         const oy = Math.floor((48 - sh) / 2);
  #|         drawSpritePreviewInMap(pctx, sp, ox, oy, unit);
  #|       }
  #|       rowBtn.appendChild(preview);
  #|
  #|       const meta = document.createElement("div");
  #|       meta.style.display = "grid";
  #|       meta.style.gap = "2px";
  #|       const nm = document.createElement("div");
  #|       nm.textContent = sp.name;
  #|       nm.style.fontFamily = "monospace";
  #|       nm.style.fontSize = "14px";
  #|       nm.style.fontWeight = "600";
  #|       const sz = document.createElement("div");
  #|       sz.textContent = `${sp.width}x${sp.height}`;
  #|       sz.style.fontFamily = "monospace";
  #|       sz.style.fontSize = "12px";
  #|       sz.style.opacity = "0.8";
  #|       meta.appendChild(nm);
  #|       meta.appendChild(sz);
  #|       rowBtn.appendChild(meta);
  #|
  #|       rowBtn.addEventListener("click", () => {
  #|         state.selectedSpriteName = String(sp.name || "");
  #|         state.mapThumbTab = "sprites";
  #|         applyMapAssetTabUi();
  #|         renderMapSpriteThumbnails();
  #|         renderCanvas();
  #|       });
  #|       mapSpriteThumbGrid.appendChild(rowBtn);
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
  #|     const modeLabel = state.mapThumbTab === "sprites" ? "sprite brush" : "tile brush";
  #|     info.textContent = `Editing tilemap ${map.name} (${map.width}x${map.height}) [${modeLabel}]`;
  #|     mapWInput.value = String(map.width);
  #|     mapHInput.value = String(map.height);
  #|     const fitCell = Math.floor(1024 / Math.max(map.width, map.height));
  #|     state.cell = Math.max(8, Math.min(24, fitCell));
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
  #|           drawTilePreview(ctx, state.tiles, v, px, py, state.cell);
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
  #|
  #|     if (Array.isArray(state.placements) && state.placements.length > 0) {
  #|       const unit = state.cell / 8;
  #|       for (const p of state.placements) {
  #|         const sp = findSpriteMetaByName(p.sprite);
  #|         if (!sp) continue;
  #|         const sx = Number(p.x) * unit;
  #|         const sy = Number(p.y) * unit;
  #|         const sw = Math.max(1, Number(sp.width || 8) * unit);
  #|         const sh = Math.max(1, Number(sp.height || 8) * unit);
  #|         if (sx + sw < 0 || sy + sh < 0 || sx >= canvas.width || sy >= canvas.height) continue;
  #|         drawSpritePreviewInMap(ctx, sp, sx, sy, unit);
  #|         if (state.mapThumbTab === "sprites" && String(p.sprite) === String(activeSpriteBrushName())) {
  #|           ctx.strokeStyle = "#4aa96c";
  #|           ctx.lineWidth = 2;
  #|           ctx.strokeRect(
  #|             Math.floor(sx) + 1,
  #|             Math.floor(sy) + 1,
  #|             Math.max(1, Math.floor(sw) - 2),
  #|             Math.max(1, Math.floor(sh) - 2),
  #|           );
  #|         }
  #|       }
  #|     }
  #|
  #|     if (state.showViewportGrid) {
  #|       const logicalW = Math.max(8, Number(globalThis.__moon8bit_logical_width) || 128);
  #|       const logicalH = Math.max(8, Number(globalThis.__moon8bit_logical_height) || 128);
  #|       const vpTilesW = Math.max(1, Math.floor(logicalW / 8));
  #|       const vpTilesH = Math.max(1, Math.floor(logicalH / 8));
  #|
  #|       ctx.save();
  #|       ctx.strokeStyle = "rgba(74, 169, 108, 0.9)";
  #|       ctx.lineWidth = 2;
  #|       for (let gx = vpTilesW; gx < map.width; gx += vpTilesW) {
  #|         const px = Math.floor(gx * state.cell) + 0.5;
  #|         ctx.beginPath();
  #|         ctx.moveTo(px, 0);
  #|         ctx.lineTo(px, canvas.height);
  #|         ctx.stroke();
  #|       }
  #|       for (let gy = vpTilesH; gy < map.height; gy += vpTilesH) {
  #|         const py = Math.floor(gy * state.cell) + 0.5;
  #|         ctx.beginPath();
  #|         ctx.moveTo(0, py);
  #|         ctx.lineTo(canvas.width, py);
  #|         ctx.stroke();
  #|       }
  #|       ctx.restore();
  #|     }
  #|   };
  #|
  #|   const encodeTileBlocks = () => {
  #|     const ts = state.tiles;
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
  #|   const encodePlacementLines = () => {
  #|     const placements = Array.isArray(state.placements) ? state.placements.slice() : [];
  #|     placements.sort((a, b) => {
  #|       if ((a.y | 0) !== (b.y | 0)) return (a.y | 0) - (b.y | 0);
  #|       if ((a.x | 0) !== (b.x | 0)) return (a.x | 0) - (b.x | 0);
  #|       return String(a.name || "").localeCompare(String(b.name || ""));
  #|     });
  #|     const out = [];
  #|     for (const p of placements) {
  #|       const sprite = String(p.sprite || "").trim();
  #|       if (!sprite) continue;
  #|       const x = Number(p.x) | 0;
  #|       const y = Number(p.y) | 0;
  #|       let name = String(p.name || "").trim();
  #|       if (!name) {
  #|         name = nextPlacementName(sprite);
  #|       }
  #|       out.push(`place ${name} ${sprite} ${x} ${y}`);
  #|     }
  #|     return out;
  #|   };
  #|
  #|   const replacePlacementLinesInLines = (lines) => {
  #|     const rendered = encodePlacementLines();
  #|     let firstPlace = -1;
  #|     const kept = [];
  #|     for (let i = 0; i < lines.length; i += 1) {
  #|       const raw = lines[i].trim();
  #|       if (/^place\s+/i.test(raw)) {
  #|         if (firstPlace < 0) firstPlace = kept.length;
  #|         continue;
  #|       }
  #|       kept.push(lines[i]);
  #|     }
  #|     if (firstPlace < 0) {
  #|       if (rendered.length === 0) return kept;
  #|       firstPlace = kept.length;
  #|       for (let i = 0; i < kept.length; i += 1) {
  #|         const raw = kept[i].trim();
  #|         if (/^(sound|bgm)\s+/i.test(raw)) {
  #|           firstPlace = i;
  #|           break;
  #|         }
  #|       }
  #|     }
  #|     if (rendered.length === 0) return kept;
  #|     const before = kept.slice(0, firstPlace);
  #|     const after = kept.slice(firstPlace);
  #|     const out = before.slice();
  #|     if (out.length > 0 && out[out.length - 1].trim() !== "") out.push("");
  #|     out.push(...rendered);
  #|     if (after.length > 0 && after[0].trim() !== "") out.push("");
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
  #|     const withTiles = replaceTileBlocksInLines(withTilemaps);
  #|     const merged = replacePlacementLinesInLines(withTiles);
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
  #|     state.sprites = parsed.sprites || [];
  #|     state.tiles = parsed.tiles;
  #|     state.tileRange = parsed.tileRange;
  #|     state.tilemaps = parsed.tilemaps;
  #|     state.tilemapRange = parsed.tilemapRange;
  #|     state.placements = parsed.placements || [];
  #|     state.placementRange = parsed.placementRange || null;
  #|     state.errors = parsed.errors || [];
  #|     viewportInput.checked = !!state.showViewportGrid;
  #|     if (state.selectedMap >= state.tilemaps.length) state.selectedMap = 0;
  #|     if (state.mapThumbTab !== "tiles" && state.mapThumbTab !== "sprites") {
  #|       state.mapThumbTab = "tiles";
  #|     }
  #|     const tileCount = parsed.tiles && Number.isInteger(parsed.tiles.tile_count) ? parsed.tiles.tile_count : 0;
  #|     if (tileCount <= 0) {
  #|       state.selectedTileId = -1;
  #|     } else if (!Number.isInteger(state.selectedTileId) || state.selectedTileId < 0 || state.selectedTileId >= tileCount) {
  #|       state.selectedTileId = 0;
  #|     }
  #|
  #|     renderMapSelect(true);
  #|
  #|     renderTilePalette();
  #|     applyMapAssetTabUi();
  #|     refreshSolidUi();
  #|     renderTileThumbnails();
  #|     renderMapTileThumbnails();
  #|     renderMapSpriteThumbnails();
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
  #|   const paintPlacementAt = (map, gridX, gridY, erase) => {
  #|     const cellX = gridX * 8;
  #|     const cellY = gridY * 8;
  #|     if (!Array.isArray(state.placements)) state.placements = [];
  #|     const beforeLen = state.placements.length;
  #|     state.placements = state.placements.filter((p) => !((p.x | 0) === cellX && (p.y | 0) === cellY));
  #|     if (!erase) {
  #|       const spriteName = activeSpriteBrushName();
  #|       if (!spriteName) {
  #|         setFeedback("No sprite selected for sprite brush.", true);
  #|         return;
  #|       }
  #|       state.placements.push({
  #|         name: nextPlacementName(spriteName),
  #|         sprite: spriteName,
  #|         x: cellX,
  #|         y: cellY,
  #|       });
  #|     }
  #|     const changed = state.placements.length !== beforeLen || !erase;
  #|     if (changed) {
  #|       setDirty(true);
  #|       renderCanvas();
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
  #|     if (state.mapThumbTab === "sprites") {
  #|       paintPlacementAt(map, x, y, erase);
  #|       return;
  #|     }
  #|     const tileId = activeTileId();
  #|     if (tileId < 0) return;
  #|     map.tiles[y * map.width + x] = erase ? -1 : tileId;
  #|     setDirty(true);
  #|     renderCanvas();
  #|   };
  #|
  #|   const paintTileAt = (evt) => {
  #|     const ts = state.tiles;
  #|     const id = activeTileId();
  #|     if (!ts || id < 0) return;
  #|     const rect = tileCanvas.getBoundingClientRect();
  #|     const x = Math.floor((evt.clientX - rect.left) / state.tileCell);
  #|     const y = Math.floor((evt.clientY - rect.top) / state.tileCell);
  #|     if (x < 0 || y < 0 || x >= 8 || y >= 8) return;
  #|     const erase = ((evt.buttons & 2) !== 0) || !!evt.shiftKey;
  #|     const next = erase ? -1 : state.selectedTileColor;
  #|     const base = id * 64;
  #|     const idx = base + y * 8 + x;
  #|     if (ts.pixels[idx] === next) return;
  #|     ts.pixels[idx] = next;
  #|     ts.tile_defined[id] = true;
  #|     setDirty(true, false);
  #|     tilePaintPending = true;
  #|     renderTileCanvas();
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
  #|   const deleteTile = () => {
  #|     const ts = state.tiles;
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
  #|     refreshSolidUi();
  #|     renderTileThumbnails();
  #|     renderMapTileThumbnails();
  #|     renderCanvas();
  #|   };
  #|
  #|   const copySelectedTileToClipboard = () => {
  #|     const ts = state.tiles;
  #|     const id = activeTileId();
  #|     if (!ts || id < 0) {
  #|       setFeedback("Copy failed: no tile selected.", true);
  #|       return false;
  #|     }
  #|     const base = id * 64;
  #|     const pixels = Array(64).fill(-1);
  #|     for (let i = 0; i < 64; i += 1) {
  #|       const v = ts.pixels[base + i];
  #|       pixels[i] = Number.isInteger(v) ? v : -1;
  #|     }
  #|     state.tileClipboard = { pixels };
  #|     setFeedback(`Copied tile ${id}.`);
  #|     return true;
  #|   };
  #|
  #|   const pasteClipboardToSelectedTile = () => {
  #|     const ts = state.tiles;
  #|     const id = activeTileId();
  #|     if (!ts || id < 0) {
  #|       setFeedback("Paste failed: no tile selected.", true);
  #|       return false;
  #|     }
  #|     const clip = state.tileClipboard;
  #|     if (!clip || !Array.isArray(clip.pixels) || clip.pixels.length !== 64) {
  #|       setFeedback("Paste failed: tile clipboard is empty.", true);
  #|       return false;
  #|     }
  #|     const base = id * 64;
  #|     for (let i = 0; i < 64; i += 1) {
  #|       const v = clip.pixels[i];
  #|       ts.pixels[base + i] = Number.isInteger(v) && v >= -1 && v <= 15 ? v : -1;
  #|     }
  #|     ts.tile_defined[id] = true;
  #|     setDirty(true);
  #|     setFeedback(`Pasted into tile ${id}.`);
  #|     renderTileCanvas();
  #|     renderTileThumbnails();
  #|     renderMapTileThumbnails();
  #|     renderCanvas();
  #|     return true;
  #|   };
  #|   let tilePaintPending = false;
  #|
  #|   if (!globalThis.__moon8bit_tilemap_bound) {
  #|     mapSelect.addEventListener("change", () => {
  #|       state.selectedMap = Number(mapSelect.value) || 0;
  #|       renderCanvas();
  #|     });
  #|     viewportInput.addEventListener("change", () => {
  #|       state.showViewportGrid = !!viewportInput.checked;
  #|       renderCanvas();
  #|     });
  #|     mapTilesTabBtn.addEventListener("click", () => {
  #|       state.mapThumbTab = "tiles";
  #|       applyMapAssetTabUi();
  #|       renderCanvas();
  #|     });
  #|     mapSpritesTabBtn.addEventListener("click", () => {
  #|       state.mapThumbTab = "sprites";
  #|       applyMapAssetTabUi();
  #|       renderMapSpriteThumbnails();
  #|       renderCanvas();
  #|     });
  #|     tileNameInput.addEventListener("input", () => {
  #|       const ts = state.tiles;
  #|       const id = activeTileId();
  #|       if (!ts || id < 0) return;
  #|       const next = String(tileNameInput.value || "").trim();
  #|       ts.tile_names[id] = next === "" ? `tile_${id}` : next;
  #|       ts.tile_defined[id] = true;
  #|       setDirty(true);
  #|       setFeedback(`Tile ${id} name updated.`);
  #|       state.selectedTileId = id;
  #|       refreshSolidUi();
  #|       renderTileThumbnails();
  #|       renderMapTileThumbnails();
  #|     });
  #|     solidInput.addEventListener("change", () => {
  #|       const ts = state.tiles;
  #|       const id = activeTileId();
  #|       if (!ts || id < 0) return;
  #|       if (!Array.isArray(ts.tile_solid)) ts.tile_solid = [];
  #|       ts.tile_solid[id] = !!solidInput.checked;
  #|       ts.tile_defined[id] = true;
  #|       setDirty(true);
  #|       setFeedback(`Tile ${id} solid=${ts.tile_solid[id] ? "on" : "off"}.`);
  #|       state.selectedTileId = id;
  #|       refreshSolidUi();
  #|       renderTileThumbnails();
  #|       renderMapTileThumbnails();
  #|     });
  #|     addMapBtn.addEventListener("click", addMap);
  #|     delMapBtn.addEventListener("click", deleteMap);
  #|     resizeMapBtn.addEventListener("click", resizeMap);
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
  #|       tilePaintPending = false;
  #|       paintTileAt(evt);
  #|     });
  #|     tileCanvas.addEventListener("pointermove", (evt) => {
  #|       if (tileDrawing) paintTileAt(evt);
  #|     });
  #|     globalThis.addEventListener("pointerup", () => {
  #|       if (tileDrawing && tilePaintPending) {
  #|         tilePaintPending = false;
  #|         renderTileThumbnails();
  #|         renderMapTileThumbnails();
  #|         renderCanvas();
  #|         scheduleTilemapAutoWrite();
  #|       }
  #|       tileDrawing = false;
  #|     });
  #|     tileCanvas.addEventListener("contextmenu", (evt) => evt.preventDefault());
  #|
  #|     globalThis.addEventListener("keydown", (evt) => {
  #|       if (globalThis.__moon8bit_active_tab !== "tile") return;
  #|       const target = evt.target;
  #|       const editable = target && (
  #|         target.tagName === "TEXTAREA" ||
  #|         target.tagName === "INPUT" ||
  #|         target.isContentEditable
  #|       );
  #|       if (editable) return;
  #|       if (!(evt.ctrlKey || evt.metaKey) || evt.altKey || evt.shiftKey) return;
  #|       const key = String(evt.key || "").toLowerCase();
  #|       if (key === "c") {
  #|         if (copySelectedTileToClipboard()) evt.preventDefault();
  #|       } else if (key === "v") {
  #|         if (pasteClipboardToSelectedTile()) evt.preventDefault();
  #|       }
  #|     });
  #|
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
