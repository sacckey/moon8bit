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
  #|   const viewWidth = width * scale;
  #|
  #|   let tabButtons = document.getElementById("moon8bit-tab-buttons");
  #|   if (!tabButtons) {
  #|     tabButtons = document.createElement("div");
  #|     tabButtons.id = "moon8bit-tab-buttons";
  #|     tabButtons.style.display = "flex";
  #|     tabButtons.style.flexWrap = "wrap";
  #|     tabButtons.style.gap = "6px";
  #|     tabButtons.style.width = `${viewWidth}px`;
  #|     root.appendChild(tabButtons);
  #|   }
  #|   tabButtons.style.width = `${viewWidth}px`;
  #|
  #|   let tabPanels = document.getElementById("moon8bit-tab-panels");
  #|   if (!tabPanels) {
  #|     tabPanels = document.createElement("div");
  #|     tabPanels.id = "moon8bit-tab-panels";
  #|     tabPanels.style.width = `${viewWidth}px`;
  #|     root.appendChild(tabPanels);
  #|   }
  #|   tabPanels.style.width = `${viewWidth}px`;
  #|
  #|   const tabs = [
  #|     { key: "game", label: "Game" },
  #|     { key: "dsl", label: "DSL" },
  #|     { key: "sprite", label: "Sprite" },
  #|     { key: "tile", label: "Tile" },
  #|     { key: "tilemap", label: "Tilemap" },
  #|     { key: "sound", label: "Sound" },
  #|   ];
  #|
  #|   const ensureTab = (key, label) => {
  #|     const buttonId = `moon8bit-tab-btn-${key}`;
  #|     const panelId = `moon8bit-tab-panel-${key}`;
  #|
  #|     let button = document.getElementById(buttonId);
  #|     if (!button) {
  #|       button = document.createElement("button");
  #|       button.id = buttonId;
  #|       button.textContent = label;
  #|       button.style.padding = "6px 10px";
  #|       button.style.cursor = "pointer";
  #|       button.style.border = "1px solid #486581";
  #|       button.style.background = "#274060";
  #|       button.style.color = "#f6f7eb";
  #|       tabButtons.appendChild(button);
  #|     }
  #|
  #|     let panel = document.getElementById(panelId);
  #|     if (!panel) {
  #|       panel = document.createElement("div");
  #|       panel.id = panelId;
  #|       panel.style.display = "none";
  #|       panel.style.width = "100%";
  #|       panel.style.boxSizing = "border-box";
  #|       panel.style.gap = "8px";
  #|       panel.style.alignItems = "start";
  #|       tabPanels.appendChild(panel);
  #|     }
  #|     return { button, panel };
  #|   };
  #|
  #|   const tabUi = {};
  #|   tabs.forEach((tab) => {
  #|     tabUi[tab.key] = ensureTab(tab.key, tab.label);
  #|   });
  #|
  #|   const setActiveTab = (key) => {
  #|     const active = tabs.some((tab) => tab.key === key) ? key : "game";
  #|     tabs.forEach((tab) => {
  #|       const isActive = tab.key === active;
  #|       tabUi[tab.key].panel.style.display = isActive ? "grid" : "none";
  #|       tabUi[tab.key].button.style.background = isActive ? "#2e8b57" : "#274060";
  #|       tabUi[tab.key].button.style.borderColor = isActive ? "#4aa96c" : "#486581";
  #|     });
  #|     globalThis.__moon8bit_active_tab = active;
  #|   };
  #|
  #|   tabs.forEach((tab) => {
  #|     const button = tabUi[tab.key].button;
  #|     if (button.dataset.bound !== "1") {
  #|       button.dataset.bound = "1";
  #|       button.addEventListener("click", () => setActiveTab(tab.key));
  #|     }
  #|   });
  #|   setActiveTab(globalThis.__moon8bit_active_tab || "game");
  #|
  #|   const id = "moon8bit-canvas";
  #|   let canvas = document.getElementById(id);
  #|   if (!canvas) {
  #|     canvas = document.createElement("canvas");
  #|     canvas.id = id;
  #|   }
  #|   if (canvas.parentElement !== tabUi.game.panel) {
  #|     tabUi.game.panel.appendChild(canvas);
  #|   }
  #|   canvas.width = width;
  #|   canvas.height = height;
  #|   canvas.style.width = `${viewWidth}px`;
  #|   canvas.style.height = `${height * scale}px`;
  #|   canvas.style.imageRendering = "pixelated";
  #|   canvas.style.border = "2px solid #333";
  #|   globalThis.__moon8bit_scale = scale;
  #|
  #|   let status = document.getElementById("moon8bit-status");
  #|   if (!status) {
  #|     status = document.createElement("div");
  #|     status.id = "moon8bit-status";
  #|     status.style.fontFamily = "monospace";
  #|     status.style.color = "#d9e2ec";
  #|   }
  #|   if (status.parentElement !== tabUi.game.panel) {
  #|     tabUi.game.panel.appendChild(status);
  #|   }
  #|
  #|   // Rendering backend is initialized in web_init_gpu:
  #|   // - WebGPU if available
  #|   // - Canvas2D fallback otherwise
  #|   globalThis.__moon8bit_ctx = null;
  #|   if (!globalThis.__moon8bit_renderer_kind) {
  #|     globalThis.__moon8bit_renderer_kind = "pending";
  #|   }
  #|   globalThis.__moon8bit_keys = new Set();
  #|   if (!globalThis.__moon8bit_pointer) {
  #|     globalThis.__moon8bit_pointer = { x: 0, y: 0, down: false };
  #|   }
  #|
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
  #|
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
  #|   const updatePointer = (evt) => {
  #|     const p = globalThis.__moon8bit_pointer || (globalThis.__moon8bit_pointer = { x: 0, y: 0, down: false });
  #|     const rect = canvas.getBoundingClientRect();
  #|     const fx = (evt.clientX - rect.left) / Math.max(1, rect.width);
  #|     const fy = (evt.clientY - rect.top) / Math.max(1, rect.height);
  #|     const x = Math.floor(fx * canvas.width);
  #|     const y = Math.floor(fy * canvas.height);
  #|     p.x = Math.max(0, Math.min(canvas.width - 1, x));
  #|     p.y = Math.max(0, Math.min(canvas.height - 1, y));
  #|   };
  #|
  #|   if (!globalThis.__moon8bit_game_pointer_bound) {
  #|     canvas.addEventListener("pointerdown", (evt) => {
  #|       updatePointer(evt);
  #|       globalThis.__moon8bit_pointer.down = true;
  #|       if (globalThis.__moon8bit_ensure_audio) {
  #|         globalThis.__moon8bit_ensure_audio();
  #|       }
  #|     });
  #|     canvas.addEventListener("pointermove", (evt) => {
  #|       updatePointer(evt);
  #|     });
  #|     globalThis.addEventListener("pointerup", (evt) => {
  #|       if (evt && typeof evt.clientX === "number" && typeof evt.clientY === "number") {
  #|         updatePointer(evt);
  #|       }
  #|       globalThis.__moon8bit_pointer.down = false;
  #|     });
  #|     globalThis.__moon8bit_game_pointer_bound = true;
  #|   }
  #|
  #|   let editor = document.getElementById("moon8bit-editor");
  #|   if (!editor) {
  #|     editor = document.createElement("div");
  #|     editor.id = "moon8bit-editor";
  #|     editor.style.display = "grid";
  #|     editor.style.gap = "6px";
  #|     editor.style.width = "100%";
  #|   }
  #|   if (editor.parentElement !== tabUi.dsl.panel) {
  #|     tabUi.dsl.panel.appendChild(editor);
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
  #|
  #|   let soundEditor = document.getElementById("moon8bit-sound-editor");
  #|   if (!soundEditor) {
  #|     soundEditor = document.createElement("div");
  #|     soundEditor.id = "moon8bit-sound-editor";
  #|     soundEditor.style.display = "grid";
  #|     soundEditor.style.gap = "8px";
  #|     soundEditor.style.padding = "8px";
  #|     soundEditor.style.border = "1px solid #334e68";
  #|     soundEditor.style.background = "#111827";
  #|     tabUi.sound.panel.appendChild(soundEditor);
  #|   }
  #|   if (soundEditor.parentElement !== tabUi.sound.panel) {
  #|     tabUi.sound.panel.appendChild(soundEditor);
  #|   }
  #|
  #|   let soundTitle = document.getElementById("moon8bit-sound-title");
  #|   if (!soundTitle) {
  #|     soundTitle = document.createElement("div");
  #|     soundTitle.id = "moon8bit-sound-title";
  #|     soundTitle.textContent = "Sound Editor";
  #|     soundTitle.style.fontWeight = "600";
  #|     soundTitle.style.fontFamily = "monospace";
  #|     soundEditor.appendChild(soundTitle);
  #|   }
  #|
  #|   let soundHint = document.getElementById("moon8bit-sound-hint");
  #|   if (!soundHint) {
  #|     soundHint = document.createElement("div");
  #|     soundHint.id = "moon8bit-sound-hint";
  #|     soundHint.textContent = "Tune BGM and SFX synth parameters, then test sounds directly.";
  #|     soundHint.style.fontFamily = "monospace";
  #|     soundHint.style.fontSize = "12px";
  #|     soundHint.style.color = "#9fb3c8";
  #|     soundEditor.appendChild(soundHint);
  #|   }
  #|
  #|   let soundActionRow = document.getElementById("moon8bit-sound-actions");
  #|   if (!soundActionRow) {
  #|     soundActionRow = document.createElement("div");
  #|     soundActionRow.id = "moon8bit-sound-actions";
  #|     soundActionRow.style.display = "flex";
  #|     soundActionRow.style.gap = "6px";
  #|     soundActionRow.style.flexWrap = "wrap";
  #|     soundActionRow.style.alignItems = "center";
  #|     soundEditor.appendChild(soundActionRow);
  #|   }
  #|
  #|   const ensureSoundActionButton = (id, label, bg, border) => {
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
  #|       soundActionRow.appendChild(btn);
  #|     }
  #|     return btn;
  #|   };
  #|
  #|   const soundSyncBtn = ensureSoundActionButton(
  #|     "moon8bit-sound-sync-btn",
  #|     "Sync from DSL",
  #|     "#486581",
  #|     "#627d98",
  #|   );
  #|   const soundWriteBtn = ensureSoundActionButton(
  #|     "moon8bit-sound-write-btn",
  #|     "Write to DSL",
  #|     "#274060",
  #|     "#486581",
  #|   );
  #|   const soundApplyBtn = ensureSoundActionButton(
  #|     "moon8bit-sound-apply-btn",
  #|     "Write + Apply",
  #|     "#2e8b57",
  #|     "#4aa96c",
  #|   );
  #|   let soundDirtyIndicator = document.getElementById("moon8bit-sound-dirty");
  #|   if (!soundDirtyIndicator) {
  #|     soundDirtyIndicator = document.createElement("span");
  #|     soundDirtyIndicator.id = "moon8bit-sound-dirty";
  #|     soundDirtyIndicator.style.fontFamily = "monospace";
  #|     soundDirtyIndicator.style.fontSize = "12px";
  #|     soundDirtyIndicator.style.marginLeft = "4px";
  #|     soundDirtyIndicator.textContent = "Saved";
  #|     soundDirtyIndicator.style.color = "#7bd389";
  #|     soundActionRow.appendChild(soundDirtyIndicator);
  #|   }
  #|
  #|   if (!globalThis.__moon8bit_audio_state) {
  #|     globalThis.__moon8bit_audio_state = {
  #|       bgmDefined: false,
  #|       bgmVolume: 0.0,
  #|       bgmWave: null,
  #|       bgmStepSec: 0.125,
  #|       bgmLoop: true,
  #|       bgmNotes: [],
  #|       sfx: {},
  #|       bgms: [],
  #|       selectedBgmName: null,
  #|       dirty: false,
  #|       transientErrors: {},
  #|     };
  #|   }
  #|   const audioState = globalThis.__moon8bit_audio_state;
  #|   if (!audioState.sfx) audioState.sfx = {};
  #|   if (!audioState.bgms) audioState.bgms = [];
  #|   if (!audioState.transientErrors) audioState.transientErrors = {};
  #|   const waveAllow = new Set(["sine", "square", "triangle", "sawtooth"]);
  #|
  #|   const clamp = (v, min, max) => Math.max(min, Math.min(max, v));
  #|   const soundKeyToId = (key) =>
  #|     key.toLowerCase().replace(/[^a-z0-9_-]/g, "_");
  #|   const nextUniqueName = (existing, base) => {
  #|     const used = new Set(existing);
  #|     if (!used.has(base)) return base;
  #|     let i = 2;
  #|     while (used.has(`${base}_${i}`)) i += 1;
  #|     return `${base}_${i}`;
  #|   };
  #|   const getSfxProfile = (key) =>
  #|     audioState.sfx && audioState.sfx[key] ? audioState.sfx[key] : null;
  #|
  #|   let soundValidation = document.getElementById("moon8bit-sound-validation");
  #|   if (!soundValidation) {
  #|     soundValidation = document.createElement("div");
  #|     soundValidation.id = "moon8bit-sound-validation";
  #|     soundValidation.style.fontFamily = "monospace";
  #|     soundValidation.style.fontSize = "12px";
  #|     soundValidation.style.color = "#7bd389";
  #|     soundValidation.style.whiteSpace = "pre-wrap";
  #|     soundValidation.style.lineHeight = "1.4";
  #|     soundEditor.appendChild(soundValidation);
  #|   }
  #|
  #|   const setTransientError = (key, message) => {
  #|     audioState.transientErrors[key] = message;
  #|   };
  #|   const clearTransientError = (key) => {
  #|     if (audioState.transientErrors && key in audioState.transientErrors) {
  #|       delete audioState.transientErrors[key];
  #|     }
  #|   };
  #|   const clearTransientErrorsByPrefix = (prefix) => {
  #|     if (!audioState.transientErrors) return;
  #|     for (const key of Object.keys(audioState.transientErrors)) {
  #|       if (String(key).startsWith(prefix)) {
  #|         delete audioState.transientErrors[key];
  #|       }
  #|     }
  #|   };
  #|   const transientErrorMessages = () => {
  #|     if (!audioState.transientErrors) return [];
  #|     return Object.values(audioState.transientErrors).filter((x) => typeof x === "string" && x.length > 0);
  #|   };
  #|
  #|   const validateAudioState = () => {
  #|     const errors = [];
  #|     const sfx = audioState.sfx || {};
  #|     for (const [name, profile] of Object.entries(sfx)) {
  #|       if (!/^[A-Za-z0-9_-]+$/.test(name)) {
  #|         errors.push(`SFX "${name}": invalid name`);
  #|       }
  #|       const wave = String(profile && profile.type || "");
  #|       if (!waveAllow.has(wave)) {
  #|         errors.push(`SFX "${name}": wave must be sine/square/triangle/sawtooth`);
  #|       }
  #|       const numericChecks = [
  #|         ["attack", profile.attack, 0.001, 0.1],
  #|         ["decay", profile.decay, 0.02, 0.4],
  #|         ["volume", profile.volume, 0.01, 0.25],
  #|         ["f0", profile.f0, 60, 1800],
  #|         ["f1", profile.f1, 40, 1600],
  #|       ];
  #|       for (const [k, v, min, max] of numericChecks) {
  #|         const n = Number(v);
  #|         if (!Number.isFinite(n) || n < min || n > max) {
  #|           errors.push(`SFX "${name}": ${k} must be in [${min}, ${max}]`);
  #|         }
  #|       }
  #|     }
  #|
  #|     const bgms = Array.isArray(audioState.bgms) ? audioState.bgms : [];
  #|     const seenBgm = new Set();
  #|     for (const bgm of bgms) {
  #|       if (!/^[A-Za-z0-9_-]+$/.test(String(bgm.name || ""))) {
  #|         errors.push(`BGM "${bgm.name}": invalid name`);
  #|       }
  #|       if (seenBgm.has(bgm.name)) {
  #|         errors.push(`BGM "${bgm.name}": duplicated name`);
  #|       }
  #|       seenBgm.add(bgm.name);
  #|       const wave = String(bgm.wave || "");
  #|       if (!waveAllow.has(wave)) {
  #|         errors.push(`BGM "${bgm.name}": wave must be sine/square/triangle/sawtooth`);
  #|       }
  #|       const volume = Number(bgm.volume);
  #|       if (!Number.isFinite(volume) || volume < 0.0 || volume > 0.3) {
  #|         errors.push(`BGM "${bgm.name}": volume must be in [0.0, 0.3]`);
  #|       }
  #|       const stepSec = Number(bgm.step_sec);
  #|       if (!Number.isFinite(stepSec) || stepSec < 0.05 || stepSec > 1.5) {
  #|         errors.push(`BGM "${bgm.name}": step_sec must be in [0.05, 1.5]`);
  #|       }
  #|       if (!Array.isArray(bgm.notes)) {
  #|         errors.push(`BGM "${bgm.name}": notes must be an array`);
  #|       } else {
  #|         for (let i = 0; i < bgm.notes.length; i += 1) {
  #|           const midi = Number(bgm.notes[i]);
  #|           if (!Number.isInteger(midi) || (midi !== -1 && (midi < 0 || midi > 127))) {
  #|             errors.push(`BGM "${bgm.name}": notes[${i}] must be -1 or MIDI 0..127`);
  #|             break;
  #|           }
  #|         }
  #|       }
  #|     }
  #|
  #|     errors.push(...transientErrorMessages());
  #|     return errors;
  #|   };
  #|
  #|   const renderSoundValidation = () => {
  #|     const errors = validateAudioState();
  #|     if (errors.length == 0) {
  #|       soundValidation.textContent = "Validation: OK";
  #|       soundValidation.style.color = "#7bd389";
  #|       soundWriteBtn.disabled = false;
  #|       soundApplyBtn.disabled = false;
  #|       return true;
  #|     }
  #|     let text = `Validation errors (${errors.length}):`;
  #|     const maxLines = Math.min(6, errors.length);
  #|     for (let i = 0; i < maxLines; i += 1) {
  #|       text += `\n- ${errors[i]}`;
  #|     }
  #|     if (errors.length > maxLines) {
  #|       text += `\n... and ${errors.length - maxLines} more`;
  #|     }
  #|     soundValidation.textContent = text;
  #|     soundValidation.style.color = "#ef6f6c";
  #|     soundWriteBtn.disabled = true;
  #|     soundApplyBtn.disabled = true;
  #|     return false;
  #|   };
  #|   const parseSoundEventsFromDsl = (text) => {
  #|     const lines = String(text || "").replace(/\r\n/g, "\n").replace(/\r/g, "\n").split("\n");
  #|     const events = [];
  #|     const seen = new Set();
  #|     for (const line of lines) {
  #|       // New format: sound <name> block
  #|       const sm = line.trim().match(/^sound\s+([A-Za-z0-9_-]+)$/i);
  #|       if (sm) {
  #|         const key = sm[1].trim();
  #|         if (key && !seen.has(key.toLowerCase())) {
  #|           seen.add(key.toLowerCase());
  #|           events.push({ key, label: key });
  #|         }
  #|         continue;
  #|       }
  #|     }
  #|     return events;
  #|   };
  #|
  #|   const noteNameFromMidi = (midi) => {
  #|     if (midi < 0) return "R";
  #|     const names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
  #|     const semitone = ((midi % 12) + 12) % 12;
  #|     const octave = Math.floor(midi / 12) - 1;
  #|     return `${names[semitone]}${octave}`;
  #|   };
  #|
  #|   const parseNoteToken = (raw) => {
  #|     const token = String(raw || "").trim();
  #|     if (!token) return null;
  #|     if (token.toUpperCase() === "R") return -1;
  #|     const m = token.match(/^([A-Ga-g])([#b]?)([0-9])$/);
  #|     if (!m) return null;
  #|     const base = m[1].toUpperCase();
  #|     const accidental = m[2];
  #|     const octave = Number(m[3]);
  #|     if (!Number.isFinite(octave) || octave < 0 || octave > 9) return null;
  #|     const baseMap = { C: 0, D: 2, E: 4, F: 5, G: 7, A: 9, B: 11 };
  #|     let semitone = baseMap[base];
  #|     if (accidental === "#") semitone += 1;
  #|     if (accidental === "b") semitone -= 1;
  #|     semitone = ((semitone % 12) + 12) % 12;
  #|     return 12 * (octave + 1) + semitone;
  #|   };
  #|
  #|   const parseNotesText = (text) => {
  #|     const raw = String(text || "").trim();
  #|     if (raw.length === 0) return [];
  #|     const tokens = raw.split(/[\s,]+/).filter(Boolean);
  #|     const notes = [];
  #|     for (const token of tokens) {
  #|       const midi = parseNoteToken(token);
  #|       if (midi === null) return null;
  #|       notes.push(midi);
  #|     }
  #|     return notes;
  #|   };
  #|   const firstInvalidNoteToken = (text) => {
  #|     const raw = String(text || "").trim();
  #|     if (raw.length === 0) return null;
  #|     const tokens = raw.split(/[\s,]+/).filter(Boolean);
  #|     for (const token of tokens) {
  #|       if (parseNoteToken(token) === null) return token;
  #|     }
  #|     return null;
  #|   };
  #|
  #|   const parseSoundBundleFromDsl = (text) => {
  #|     const lines = String(text || "").replace(/\r\n/g, "\n").replace(/\r/g, "\n").split("\n");
  #|     const sounds = [];
  #|     const bgms = [];
  #|     const errors = [];
  #|     let i = 0;
  #|     while (i < lines.length) {
  #|       const line = lines[i].trim();
  #|       const soundHeader = line.match(/^sound\s+([A-Za-z0-9_-]+)$/i);
  #|       if (soundHeader) {
  #|         const sound = {
  #|           name: soundHeader[1],
  #|           type: "square",
  #|           attack: 0.003,
  #|           decay: 0.10,
  #|           volume: 0.07,
  #|           f0: 520,
  #|           f1: 360,
  #|         };
  #|         i += 1;
  #|         let foundEnd = false;
  #|         while (i < lines.length) {
  #|           const row = lines[i].trim();
  #|           if (row === "" || row.startsWith("#")) { i += 1; continue; }
  #|           if (row === "end") { i += 1; foundEnd = true; break; }
  #|           if (/^(sound|bgm)\s+[A-Za-z0-9_-]+$/i.test(row)) {
  #|             errors.push(`sound ${sound.name}: missing end before "${row}"`);
  #|             break;
  #|           }
  #|           const tokens = row.split(/\s+/).filter(Boolean);
  #|           if (tokens.length >= 2) {
  #|             const key = tokens[0];
  #|             const value = tokens[1];
  #|             if (key === "wave") {
  #|               if (waveAllow.has(value)) {
  #|                 sound.type = value;
  #|               } else {
  #|                 errors.push(`sound ${sound.name}: invalid wave "${value}"`);
  #|               }
  #|             } else if (key === "attack") {
  #|               const n = Number(value);
  #|               if (Number.isFinite(n)) sound.attack = n;
  #|               else errors.push(`sound ${sound.name}: invalid attack "${value}"`);
  #|             } else if (key === "decay") {
  #|               const n = Number(value);
  #|               if (Number.isFinite(n)) sound.decay = n;
  #|               else errors.push(`sound ${sound.name}: invalid decay "${value}"`);
  #|             } else if (key === "volume" || key === "peak") {
  #|               const n = Number(value);
  #|               if (Number.isFinite(n)) sound.volume = n;
  #|               else errors.push(`sound ${sound.name}: invalid volume "${value}"`);
  #|             } else if (key === "f0") {
  #|               const n = Number(value);
  #|               if (Number.isFinite(n)) sound.f0 = Math.round(n);
  #|               else errors.push(`sound ${sound.name}: invalid f0 "${value}"`);
  #|             } else if (key === "f1") {
  #|               const n = Number(value);
  #|               if (Number.isFinite(n)) sound.f1 = Math.round(n);
  #|               else errors.push(`sound ${sound.name}: invalid f1 "${value}"`);
  #|             } else {
  #|               errors.push(`sound ${sound.name}: unknown field "${key}"`);
  #|             }
  #|           }
  #|           i += 1;
  #|         }
  #|         if (!foundEnd) {
  #|           errors.push(`sound ${sound.name}: missing end`);
  #|         }
  #|         sounds.push(sound);
  #|         continue;
  #|       }
  #|
  #|       const bgmHeader = line.match(/^bgm\s+([A-Za-z0-9_-]+)$/i);
  #|       if (bgmHeader) {
  #|         const bgm = {
  #|           name: bgmHeader[1],
  #|           wave: "square",
  #|           volume: 0.05,
  #|           step_sec: 0.125,
  #|           loop_: true,
  #|           notes: [],
  #|         };
  #|         i += 1;
  #|         let foundEnd = false;
  #|         while (i < lines.length) {
  #|           const row = lines[i].trim();
  #|           if (row === "" || row.startsWith("#")) { i += 1; continue; }
  #|           if (row === "end") { i += 1; foundEnd = true; break; }
  #|           if (/^(sound|bgm)\s+[A-Za-z0-9_-]+$/i.test(row)) {
  #|             errors.push(`bgm ${bgm.name}: missing end before "${row}"`);
  #|             break;
  #|           }
  #|           const tokens = row.split(/\s+/).filter(Boolean);
  #|           if (tokens.length >= 2) {
  #|             const key = tokens[0];
  #|             if (key === "wave") {
  #|               if (waveAllow.has(tokens[1])) {
  #|                 bgm.wave = tokens[1];
  #|               } else {
  #|                 errors.push(`bgm ${bgm.name}: invalid wave "${tokens[1]}"`);
  #|               }
  #|             } else if (key === "volume") {
  #|               const n = Number(tokens[1]);
  #|               if (Number.isFinite(n)) bgm.volume = n;
  #|               else errors.push(`bgm ${bgm.name}: invalid volume "${tokens[1]}"`);
  #|             } else if (key === "step_sec") {
  #|               const n = Number(tokens[1]);
  #|               if (Number.isFinite(n)) bgm.step_sec = n;
  #|               else errors.push(`bgm ${bgm.name}: invalid step_sec "${tokens[1]}"`);
  #|             } else if (key === "loop") {
  #|               if (tokens[1] === "true" || tokens[1] === "false") {
  #|                 bgm.loop_ = tokens[1] === "true";
  #|               } else {
  #|                 errors.push(`bgm ${bgm.name}: invalid loop "${tokens[1]}"`);
  #|               }
  #|             } else if (key === "notes") {
  #|               const noteTokens = tokens.slice(1);
  #|               const parsedNotes = [];
  #|               let ok = true;
  #|               for (const token of noteTokens) {
  #|                 const midi = parseNoteToken(token);
  #|                 if (midi === null) {
  #|                   errors.push(`bgm ${bgm.name}: invalid note "${token}"`);
  #|                   ok = false;
  #|                   break;
  #|                 }
  #|                 parsedNotes.push(midi);
  #|               }
  #|               if (ok) bgm.notes = parsedNotes;
  #|             } else {
  #|               errors.push(`bgm ${bgm.name}: unknown field "${key}"`);
  #|             }
  #|           }
  #|           i += 1;
  #|         }
  #|         if (!foundEnd) {
  #|           errors.push(`bgm ${bgm.name}: missing end`);
  #|         }
  #|         bgms.push(bgm);
  #|         continue;
  #|       }
  #|
  #|       i += 1;
  #|     }
  #|     return { sounds, bgms, errors };
  #|   };
  #|
  #|   const applySoundBundleToState = (bundle) => {
  #|     audioState.sfx = {};
  #|     for (const s of bundle.sounds || []) {
  #|       audioState.sfx[s.name] = {
  #|         type: s.type || "square",
  #|         attack: Number.isFinite(Number(s.attack)) ? Number(s.attack) : 0.003,
  #|         decay: Number.isFinite(Number(s.decay)) ? Number(s.decay) : 0.10,
  #|         volume: Number.isFinite(Number(s.volume)) ? Number(s.volume) : 0.07,
  #|         f0: Number.isFinite(Number(s.f0)) ? Math.round(Number(s.f0)) : 520,
  #|         f1: Number.isFinite(Number(s.f1)) ? Math.round(Number(s.f1)) : 360,
  #|       };
  #|     }
  #|     // Populate bgms array for multi-BGM editor support
  #|     audioState.bgms = (bundle.bgms || []).map((b) => ({
  #|       name: b.name,
  #|       wave: ["sine", "square", "triangle", "sawtooth"].includes(b.wave) ? b.wave : "square",
  #|       volume: Number.isFinite(Number(b.volume)) ? Number(b.volume) : 0.05,
  #|       step_sec: Number.isFinite(Number(b.step_sec)) ? Number(b.step_sec) : 0.125,
  #|       loop_: !!b.loop_,
  #|       notes: Array.isArray(b.notes) ? b.notes.slice() : [],
  #|     }));
  #|     // Auto-select BGM: preserve existing selection if still valid, else "main" or first
  #|     const names = audioState.bgms.map((b) => b.name);
  #|     if (!names.includes(audioState.selectedBgmName)) {
  #|       audioState.selectedBgmName = names.includes("main") ? "main" : (names[0] || null);
  #|     }
  #|     // Sync legacy playback fields from selected BGM
  #|     const selectedBgm = audioState.bgms.find((b) => b.name === audioState.selectedBgmName) || null;
  #|     if (selectedBgm) {
  #|       audioState.bgmDefined = true;
  #|       audioState.bgmWave = selectedBgm.wave;
  #|       audioState.bgmVolume = selectedBgm.volume;
  #|       audioState.bgmStepSec = selectedBgm.step_sec;
  #|       audioState.bgmLoop = selectedBgm.loop_;
  #|       audioState.bgmNotes = selectedBgm.notes.slice();
  #|     } else {
  #|       audioState.bgmDefined = false;
  #|       audioState.bgmWave = null;
  #|       audioState.bgmVolume = 0.0;
  #|       audioState.bgmStepSec = 0.125;
  #|       audioState.bgmLoop = true;
  #|       audioState.bgmNotes = [];
  #|     }
  #|     audioState.dirty = false;
  #|   };
  #|
  #|   const encodeSoundBundleFromState = () => {
  #|     const waveAllow = new Set(["sine", "square", "triangle", "sawtooth"]);
  #|     const fmt = (n) => {
  #|       const x = Number(n);
  #|       if (!Number.isFinite(x)) return "0";
  #|       const fixed = x.toFixed(6);
  #|       return fixed.replace(/\.?0+$/, "");
  #|     };
  #|     const eventOrder = parseSoundEventsFromDsl(textarea ? textarea.value : "").map((e) => e.key);
  #|     const sfxKeys = Object.keys(audioState.sfx || {});
  #|     const orderedKeys = [];
  #|     const seen = new Set();
  #|     for (const key of eventOrder) {
  #|       if (sfxKeys.includes(key) && !seen.has(key)) { orderedKeys.push(key); seen.add(key); }
  #|     }
  #|     for (const key of sfxKeys) {
  #|       if (!seen.has(key)) { orderedKeys.push(key); seen.add(key); }
  #|     }
  #|     const lines = [];
  #|     for (const key of orderedKeys) {
  #|       const s = audioState.sfx[key];
  #|       if (!s) continue;
  #|       const wave = waveAllow.has(String(s.type || "")) ? String(s.type) : "square";
  #|       lines.push(`sound ${key}`);
  #|       lines.push(`  wave ${wave}`);
  #|       lines.push(`  attack ${fmt(clamp(Number(s.attack ?? 0.003), 0.001, 0.1))}`);
  #|       lines.push(`  decay ${fmt(clamp(Number(s.decay ?? 0.10), 0.02, 0.4))}`);
  #|       lines.push(`  volume ${fmt(clamp(Number(s.volume ?? 0.07), 0.01, 0.25))}`);
  #|       lines.push(`  f0 ${Math.round(clamp(Number(s.f0 ?? 520), 60, 1800))}`);
  #|       lines.push(`  f1 ${Math.round(clamp(Number(s.f1 ?? 360), 40, 1600))}`);
  #|       lines.push("end");
  #|       lines.push("");
  #|     }
  #|     // Encode all BGMs from the bgms array
  #|     const bgmList = Array.isArray(audioState.bgms) ? audioState.bgms : [];
  #|     for (const bgm of bgmList) {
  #|       const wave = waveAllow.has(String(bgm.wave || "")) ? String(bgm.wave) : "square";
  #|       lines.push(`bgm ${bgm.name}`);
  #|       lines.push(`  wave ${wave}`);
  #|       lines.push(`  volume ${fmt(clamp(Number(bgm.volume ?? 0.05), 0.0, 0.3))}`);
  #|       lines.push(`  step_sec ${fmt(clamp(Number(bgm.step_sec ?? 0.125), 0.05, 1.5))}`);
  #|       lines.push(`  loop ${bgm.loop_ ? "true" : "false"}`);
  #|       const noteTokens = (Array.isArray(bgm.notes) ? bgm.notes : []).map(noteNameFromMidi);
  #|       lines.push(`  notes${noteTokens.length > 0 ? " " + noteTokens.join(" ") : ""}`);
  #|       lines.push("end");
  #|       lines.push("");
  #|     }
  #|     // Fallback: if no bgms array but legacy bgmDefined, encode it
  #|     if (bgmList.length === 0 && audioState.bgmDefined) {
  #|       const wave = waveAllow.has(String(audioState.bgmWave || "")) ? String(audioState.bgmWave) : "square";
  #|       lines.push("bgm main");
  #|       lines.push(`  wave ${wave}`);
  #|       lines.push(`  volume ${fmt(clamp(Number(audioState.bgmVolume ?? 0.05), 0.0, 0.3))}`);
  #|       lines.push(`  step_sec ${fmt(clamp(Number(audioState.bgmStepSec ?? 0.125), 0.05, 1.5))}`);
  #|       lines.push(`  loop ${audioState.bgmLoop ? "true" : "false"}`);
  #|       const noteTokens = (Array.isArray(audioState.bgmNotes) ? audioState.bgmNotes : []).map(noteNameFromMidi);
  #|       lines.push(`  notes${noteTokens.length > 0 ? " " + noteTokens.join(" ") : ""}`);
  #|       lines.push("end");
  #|       lines.push("");
  #|     }
  #|     return lines;
  #|   };
  #|
  #|   const writeSoundToDsl = (andApply) => {
  #|     if (!textarea) return;
  #|     if (!renderSoundValidation()) {
  #|       if (feedback) {
  #|         feedback.textContent = "Sound DSL write aborted: fix validation errors first.";
  #|         feedback.style.color = "#ef6f6c";
  #|       }
  #|       return false;
  #|     }
  #|     const sourceLines = textarea.value.replace(/\r\n/g, "\n").replace(/\r/g, "\n").split("\n");
  #|     const kept = [];
  #|     let insertAt = null;
  #|     const isSoundHeader = (trimmed) =>
  #|       /^sound\s+[A-Za-z0-9_-]+$/i.test(trimmed) || /^bgm\s+[A-Za-z0-9_-]+$/i.test(trimmed);
  #|     let sawSoundBlocks = false;
  #|     let sawMeaningfulAfterSound = false;
  #|     let i = 0;
  #|     while (i < sourceLines.length) {
  #|       const row = sourceLines[i];
  #|       const trimmed = row.trim();
  #|       if (isSoundHeader(trimmed)) {
  #|         if (sawMeaningfulAfterSound) {
  #|           if (feedback) {
  #|             feedback.textContent = "Sound DSL write aborted: sound/bgm blocks must be contiguous.";
  #|             feedback.style.color = "#ef6f6c";
  #|           }
  #|           return false;
  #|         }
  #|         sawSoundBlocks = true;
  #|         if (insertAt === null) insertAt = kept.length;
  #|         i += 1;
  #|         let foundEnd = false;
  #|         while (i < sourceLines.length) {
  #|           const t = sourceLines[i].trim();
  #|           i += 1;
  #|           if (t === "end") {
  #|             foundEnd = true;
  #|             break;
  #|           }
  #|           if (isSoundHeader(t)) {
  #|             // Broken block (missing end): stop to avoid destructive rewrite.
  #|             foundEnd = false;
  #|             break;
  #|           }
  #|         }
  #|         if (!foundEnd) {
  #|           if (feedback) {
  #|             feedback.textContent = "Sound DSL write aborted: unterminated sound/bgm block.";
  #|             feedback.style.color = "#ef6f6c";
  #|           }
  #|           return false;
  #|         }
  #|         continue;
  #|       }
  #|       if (sawSoundBlocks && trimmed !== "" && !trimmed.startsWith("#")) {
  #|         sawMeaningfulAfterSound = true;
  #|       }
  #|       kept.push(row);
  #|       i += 1;
  #|     }
  #|     while (kept.length > 0 && kept[kept.length - 1].trim() === "") kept.pop();
  #|     const soundLines = encodeSoundBundleFromState();
  #|     let rendered = soundLines.slice();
  #|     while (rendered.length > 0 && rendered[rendered.length - 1].trim() === "") rendered.pop();
  #|     if (insertAt === null) insertAt = kept.length;
  #|     const before = kept.slice(0, insertAt);
  #|     const after = kept.slice(insertAt);
  #|     const merged = before.slice();
  #|     if (rendered.length > 0) {
  #|       if (merged.length > 0 && merged[merged.length - 1].trim() !== "") merged.push("");
  #|       merged.push(...rendered);
  #|       if (after.length > 0 && after[0].trim() !== "") merged.push("");
  #|     }
  #|     merged.push(...after);
  #|     textarea.value = merged.join("\n");
  #|     if (feedback) {
  #|       feedback.textContent = andApply ? "Sound written and applied." : "Sound written to DSL.";
  #|       feedback.style.color = "#7bd389";
  #|     }
  #|     if (andApply && globalThis.__moon8bit_apply_cb) {
  #|       globalThis.__moon8bit_apply_cb();
  #|     }
  #|     return true;
  #|   };
  #|
  #|   if (!globalThis.__moon8bit_audio_start_bgm_impl) {
  #|     globalThis.__moon8bit_audio_start_bgm_impl = () => {
  #|       const ensure = globalThis.__moon8bit_ensure_audio;
  #|       if (!ensure) return;
  #|       if (globalThis.__moon8bit_bgm_nodes) {
  #|         if (globalThis.__moon8bit_audio_apply_bgm) {
  #|           globalThis.__moon8bit_audio_apply_bgm();
  #|         }
  #|         return;
  #|       }
  #|       const ctx = ensure();
  #|       if (!ctx) return;
  #|
  #|       const state = globalThis.__moon8bit_audio_state || {};
  #|       const bgmDefined = Boolean(state.bgmDefined);
  #|       const bgmVolume = Number(state.bgmVolume ?? 0.0);
  #|       const wave = typeof state.bgmWave === "string" ? state.bgmWave : null;
  #|       const loopByDefault = Boolean(state.bgmLoop ?? true);
  #|       const notes = Array.isArray(state.bgmNotes) && state.bgmNotes.length > 0
  #|         ? state.bgmNotes : null;
  #|       const stepSec = Math.max(0.05, Number(state.bgmStepSec ?? 0.125));
  #|       if (!bgmDefined || !wave || !notes) return;
  #|
  #|       const gain = ctx.createGain();
  #|       gain.gain.value = Math.max(0.0, Math.min(1.0, bgmVolume));
  #|       gain.connect(ctx.destination);
  #|
  #|       // MIDI note number to Hz: 440 * 2^((midi-69)/12)
  #|       const midiToHz = (midi) => 440 * Math.pow(2, (midi - 69) / 12);
  #|
  #|       let stopped = false;
  #|       let stepIdx = 0;
  #|       let nextTime = ctx.currentTime;
  #|       const activeOscs = [];
  #|
  #|       const scheduleStep = () => {
  #|         if (stopped) return;
  #|         const lookahead = 0.1;
  #|         while (nextTime < ctx.currentTime + lookahead) {
  #|           const st = globalThis.__moon8bit_audio_state || {};
  #|           const loopEnabled = Boolean(st.bgmLoop ?? loopByDefault);
  #|           const ns = Array.isArray(st.bgmNotes) && st.bgmNotes.length > 0
  #|             ? st.bgmNotes : notes;
  #|           if (!ns || ns.length === 0) {
  #|             if (!loopEnabled) { stopped = true; break; }
  #|             nextTime += stepSec;
  #|             continue;
  #|           }
  #|           if (!loopEnabled && stepIdx >= ns.length) {
  #|             stopped = true;
  #|             break;
  #|           }
  #|           const midi = loopEnabled ? ns[stepIdx % ns.length] : ns[stepIdx];
  #|           stepIdx++;
  #|           if (midi >= 0) {
  #|             const osc = ctx.createOscillator();
  #|             osc.type = st.bgmWave || wave;
  #|             osc.frequency.value = midiToHz(midi);
  #|             osc.connect(gain);
  #|             osc.start(nextTime);
  #|             osc.stop(nextTime + stepSec * 0.9);
  #|             activeOscs.push(osc);
  #|           }
  #|           nextTime += stepSec;
  #|         }
  #|         if (!stopped) setTimeout(scheduleStep, 50);
  #|       };
  #|
  #|       scheduleStep();
  #|
  #|       globalThis.__moon8bit_bgm_nodes = { gain, activeOscs, stopFn: () => { stopped = true; } };
  #|       globalThis.__moon8bit_audio_apply_bgm = () => {
  #|         const nodes = globalThis.__moon8bit_bgm_nodes;
  #|         if (!nodes) return;
  #|         const st = globalThis.__moon8bit_audio_state || {};
  #|         const v = Number(st.bgmVolume ?? 0.0);
  #|         try { nodes.gain.gain.setTargetAtTime(Math.max(0.0, Math.min(1.0, v)), ctx.currentTime, 0.03); } catch (_) {}
  #|       };
  #|     };
  #|   }
  #|
  #|   if (!globalThis.__moon8bit_audio_stop_bgm_impl) {
  #|     globalThis.__moon8bit_audio_stop_bgm_impl = () => {
  #|       const nodes = globalThis.__moon8bit_bgm_nodes;
  #|       if (!nodes) return;
  #|       const now = (globalThis.__moon8bit_audio_ctx && globalThis.__moon8bit_audio_ctx.currentTime) || 0;
  #|       try { nodes.gain.gain.setTargetAtTime(0.0001, now, 0.05); } catch (_) {}
  #|       if (nodes.stopFn) try { nodes.stopFn(); } catch (_) {}
  #|       setTimeout(() => {
  #|         try { nodes.gain.disconnect(); } catch (_) {}
  #|       }, 120);
  #|       globalThis.__moon8bit_bgm_nodes = null;
  #|       globalThis.__moon8bit_audio_apply_bgm = null;
  #|     };
  #|   }
  #|
  #|   if (!globalThis.__moon8bit_audio_play_sfx_impl) {
  #|     globalThis.__moon8bit_audio_play_sfx_impl = (kind) => {
  #|       const ensure = globalThis.__moon8bit_ensure_audio;
  #|       if (!ensure) return;
  #|       const ctx = ensure();
  #|       if (!ctx) return;
  #|
  #|       const state = globalThis.__moon8bit_audio_state || {};
  #|       const sfx = state.sfx && state.sfx[kind] ? state.sfx[kind] : null;
  #|       if (!sfx) return;
  #|
  #|       const osc = ctx.createOscillator();
  #|       const gain = ctx.createGain();
  #|       osc.connect(gain);
  #|       gain.connect(ctx.destination);
  #|
  #|       const now = ctx.currentTime;
  #|       const attack = Math.max(0.001, Number(sfx.attack ?? 0.004));
  #|       const decay = Math.max(0.02, Number(sfx.decay ?? 0.12));
  #|       const volume = Math.max(
  #|         0.001,
  #|         Math.min(1.0, Number(sfx.volume ?? 0.08)),
  #|       );
  #|       const f0 = Math.max(40, Number(sfx.f0 ?? 520));
  #|       const f1 = Math.max(30, Number(sfx.f1 ?? 420));
  #|       const type = sfx.type || "square";
  #|
  #|       osc.type = type;
  #|       osc.frequency.setValueAtTime(f0, now);
  #|       osc.frequency.exponentialRampToValueAtTime(Math.max(40, f1), now + decay);
  #|
  #|       gain.gain.setValueAtTime(0.0001, now);
  #|       gain.gain.linearRampToValueAtTime(volume, now + attack);
  #|       gain.gain.exponentialRampToValueAtTime(0.0001, now + decay);
  #|
  #|       osc.start(now);
  #|       osc.stop(now + decay + 0.02);
  #|     };
  #|   }
  #|
  #|   const getSelectedBgm = () =>
  #|     audioState.bgms.find((b) => b.name === audioState.selectedBgmName) || null;
  #|
  #|   const updateSoundDirtyIndicator = () => {
  #|     const dirtyIndicator = document.getElementById("moon8bit-sound-dirty");
  #|     if (!dirtyIndicator) return;
  #|     dirtyIndicator.textContent = audioState.dirty ? "Modified" : "Saved";
  #|     dirtyIndicator.style.color = audioState.dirty ? "#e8c547" : "#7bd389";
  #|   };
  #|
  #|   const syncPlaybackFromSelectedBgm = () => {
  #|     const bgm = getSelectedBgm();
  #|     if (bgm) {
  #|       audioState.bgmDefined = true;
  #|       audioState.bgmWave = bgm.wave;
  #|       audioState.bgmVolume = bgm.volume;
  #|       audioState.bgmStepSec = bgm.step_sec;
  #|       audioState.bgmLoop = bgm.loop_;
  #|       audioState.bgmNotes = bgm.notes.slice();
  #|     } else {
  #|       audioState.bgmDefined = false;
  #|       audioState.bgmWave = null;
  #|       audioState.bgmVolume = 0.0;
  #|       audioState.bgmStepSec = 0.125;
  #|       audioState.bgmLoop = true;
  #|       audioState.bgmNotes = [];
  #|     }
  #|   };
  #|
  #|   const markDirty = () => {
  #|     audioState.dirty = true;
  #|     updateSoundDirtyIndicator();
  #|     renderSoundValidation();
  #|   };
  #|   const markSaved = () => {
  #|     audioState.dirty = false;
  #|     updateSoundDirtyIndicator();
  #|     renderSoundValidation();
  #|   };
  #|
  #|   const ensureSlider = (id, label, min, max, step, getValue, setValue) => {
  #|     let row = document.getElementById(`${id}-row`);
  #|     if (!row) {
  #|       row = document.createElement("div");
  #|       row.id = `${id}-row`;
  #|       row.style.display = "grid";
  #|       row.style.gridTemplateColumns = "120px 1fr 56px";
  #|       row.style.alignItems = "center";
  #|       row.style.gap = "8px";
  #|       soundEditor.appendChild(row);
  #|     }
  #|
  #|     let text = document.getElementById(`${id}-label`);
  #|     if (!text) {
  #|       text = document.createElement("div");
  #|       text.id = `${id}-label`;
  #|       text.textContent = label;
  #|       text.style.fontFamily = "monospace";
  #|       text.style.fontSize = "12px";
  #|       row.appendChild(text);
  #|     }
  #|
  #|     let input = document.getElementById(id);
  #|     if (!input) {
  #|       input = document.createElement("input");
  #|       input.id = id;
  #|       input.type = "range";
  #|       input.min = String(min);
  #|       input.max = String(max);
  #|       input.step = String(step);
  #|       row.appendChild(input);
  #|     }
  #|
  #|     let valueText = document.getElementById(`${id}-value`);
  #|     if (!valueText) {
  #|       valueText = document.createElement("div");
  #|       valueText.id = `${id}-value`;
  #|       valueText.style.fontFamily = "monospace";
  #|       valueText.style.fontSize = "12px";
  #|       row.appendChild(valueText);
  #|     }
  #|
  #|     const apply = () => {
  #|       const n = Number(input.value);
  #|       setValue(clamp(n, min, max));
  #|       valueText.textContent = Number(input.value).toFixed(2);
  #|       if (globalThis.__moon8bit_audio_apply_bgm) {
  #|         globalThis.__moon8bit_audio_apply_bgm();
  #|       }
  #|     };
  #|
  #|     if (input.dataset.bound !== "1") {
  #|       input.dataset.bound = "1";
  #|       input.addEventListener("input", apply);
  #|     }
  #|
  #|     input.value = String(getValue());
  #|     valueText.textContent = Number(input.value).toFixed(2);
  #|   };
  #|
  #|   ensureSlider(
  #|     "moon8bit-sound-bgm",
  #|     "BGM Volume",
  #|     0.0,
  #|     0.3,
  #|     0.005,
  #|     () => { const b = getSelectedBgm(); return b ? b.volume : Number(audioState.bgmVolume ?? 0.0); },
  #|     (v) => {
  #|       audioState.bgmVolume = v;
  #|       const b = getSelectedBgm();
  #|       if (b) b.volume = v;
  #|       markDirty();
  #|     },
  #|   );
  #|
  #|   // BGM selector row (multi-BGM support)
  #|   let bgmSelectorRow = document.getElementById("moon8bit-bgm-selector-row");
  #|   if (!bgmSelectorRow) {
  #|     bgmSelectorRow = document.createElement("div");
  #|     bgmSelectorRow.id = "moon8bit-bgm-selector-row";
  #|     bgmSelectorRow.style.display = "flex";
  #|     bgmSelectorRow.style.gap = "6px";
  #|     bgmSelectorRow.style.alignItems = "center";
  #|     bgmSelectorRow.style.flexWrap = "wrap";
  #|     soundEditor.appendChild(bgmSelectorRow);
  #|   }
  #|   let bgmSelectorLabel = document.getElementById("moon8bit-bgm-selector-label");
  #|   if (!bgmSelectorLabel) {
  #|     bgmSelectorLabel = document.createElement("span");
  #|     bgmSelectorLabel.id = "moon8bit-bgm-selector-label";
  #|     bgmSelectorLabel.textContent = "BGM:";
  #|     bgmSelectorLabel.style.fontFamily = "monospace";
  #|     bgmSelectorLabel.style.fontSize = "12px";
  #|     bgmSelectorRow.appendChild(bgmSelectorLabel);
  #|   }
  #|   let bgmSelector = document.getElementById("moon8bit-bgm-selector");
  #|   if (!bgmSelector) {
  #|     bgmSelector = document.createElement("select");
  #|     bgmSelector.id = "moon8bit-bgm-selector";
  #|     bgmSelector.style.fontFamily = "monospace";
  #|     bgmSelector.style.fontSize = "12px";
  #|     bgmSelectorRow.appendChild(bgmSelector);
  #|   }
  #|   const refreshBgmSelector = () => {
  #|     bgmSelector.innerHTML = "";
  #|     if (audioState.bgms.length === 0) {
  #|       const opt = document.createElement("option");
  #|       opt.value = "";
  #|       opt.textContent = "(none)";
  #|       bgmSelector.appendChild(opt);
  #|     } else {
  #|       for (const b of audioState.bgms) {
  #|         const opt = document.createElement("option");
  #|         opt.value = b.name;
  #|         opt.textContent = b.name;
  #|         bgmSelector.appendChild(opt);
  #|       }
  #|       bgmSelector.value = audioState.selectedBgmName || "";
  #|     }
  #|   };
  #|   if (bgmSelector.dataset.bound !== "1") {
  #|     bgmSelector.dataset.bound = "1";
  #|     bgmSelector.addEventListener("change", () => {
  #|       audioState.selectedBgmName = bgmSelector.value || null;
  #|       syncPlaybackFromSelectedBgm();
  #|       syncBgmControlsFromState();
  #|     });
  #|   }
  #|   // Add BGM button
  #|   let addBgmBtn = document.getElementById("moon8bit-bgm-add-btn");
  #|   if (!addBgmBtn) {
  #|     addBgmBtn = document.createElement("button");
  #|     addBgmBtn.id = "moon8bit-bgm-add-btn";
  #|     addBgmBtn.textContent = "+ BGM";
  #|     addBgmBtn.style.padding = "2px 7px";
  #|     addBgmBtn.style.background = "#274060";
  #|     addBgmBtn.style.color = "#f6f7eb";
  #|     addBgmBtn.style.border = "1px solid #486581";
  #|     addBgmBtn.style.cursor = "pointer";
  #|     addBgmBtn.style.fontFamily = "monospace";
  #|     addBgmBtn.style.fontSize = "12px";
  #|     bgmSelectorRow.appendChild(addBgmBtn);
  #|   }
  #|   if (addBgmBtn.dataset.bound !== "1") {
  #|     addBgmBtn.dataset.bound = "1";
  #|     addBgmBtn.addEventListener("click", () => {
  #|       let name = prompt("New BGM name:", "bgm" + (audioState.bgms.length + 1));
  #|       if (!name) return;
  #|       name = name.trim().replace(/[^A-Za-z0-9_-]/g, "_");
  #|       if (!name || audioState.bgms.some((b) => b.name === name)) {
  #|         alert("Name empty or already in use.");
  #|         return;
  #|       }
  #|       audioState.bgms.push({ name, wave: "square", volume: 0.05, step_sec: 0.125, loop_: true, notes: [] });
  #|       audioState.selectedBgmName = name;
  #|       syncPlaybackFromSelectedBgm();
  #|       refreshBgmSelector();
  #|       syncBgmControlsFromState();
  #|       markDirty();
  #|     });
  #|   }
  #|   // Duplicate BGM button
  #|   let dupBgmBtn = document.getElementById("moon8bit-bgm-dup-btn");
  #|   if (!dupBgmBtn) {
  #|     dupBgmBtn = document.createElement("button");
  #|     dupBgmBtn.id = "moon8bit-bgm-dup-btn";
  #|     dupBgmBtn.textContent = "Dup";
  #|     dupBgmBtn.style.padding = "2px 7px";
  #|     dupBgmBtn.style.background = "#274060";
  #|     dupBgmBtn.style.color = "#f6f7eb";
  #|     dupBgmBtn.style.border = "1px solid #486581";
  #|     dupBgmBtn.style.cursor = "pointer";
  #|     dupBgmBtn.style.fontFamily = "monospace";
  #|     dupBgmBtn.style.fontSize = "12px";
  #|     bgmSelectorRow.appendChild(dupBgmBtn);
  #|   }
  #|   if (dupBgmBtn.dataset.bound !== "1") {
  #|     dupBgmBtn.dataset.bound = "1";
  #|     dupBgmBtn.addEventListener("click", () => {
  #|       const src = getSelectedBgm();
  #|       if (!src) return;
  #|       const name = nextUniqueName(audioState.bgms.map((b) => b.name), `${src.name}_copy`);
  #|       audioState.bgms.push({
  #|         name,
  #|         wave: src.wave,
  #|         volume: src.volume,
  #|         step_sec: src.step_sec,
  #|         loop_: src.loop_,
  #|         notes: Array.isArray(src.notes) ? src.notes.slice() : [],
  #|       });
  #|       audioState.selectedBgmName = name;
  #|       syncPlaybackFromSelectedBgm();
  #|       refreshBgmSelector();
  #|       syncBgmControlsFromState();
  #|       markDirty();
  #|     });
  #|   }
  #|   // Delete BGM button
  #|   let delBgmBtn = document.getElementById("moon8bit-bgm-del-btn");
  #|   if (!delBgmBtn) {
  #|     delBgmBtn = document.createElement("button");
  #|     delBgmBtn.id = "moon8bit-bgm-del-btn";
  #|     delBgmBtn.textContent = "Del";
  #|     delBgmBtn.style.padding = "2px 7px";
  #|     delBgmBtn.style.background = "#5c2b2b";
  #|     delBgmBtn.style.color = "#f6f7eb";
  #|     delBgmBtn.style.border = "1px solid #a04040";
  #|     delBgmBtn.style.cursor = "pointer";
  #|     delBgmBtn.style.fontFamily = "monospace";
  #|     delBgmBtn.style.fontSize = "12px";
  #|     bgmSelectorRow.appendChild(delBgmBtn);
  #|   }
  #|   if (delBgmBtn.dataset.bound !== "1") {
  #|     delBgmBtn.dataset.bound = "1";
  #|     delBgmBtn.addEventListener("click", () => {
  #|       const name = audioState.selectedBgmName;
  #|       if (!name) return;
  #|       if (!confirm(`Delete BGM "${name}"?`)) return;
  #|       audioState.bgms = audioState.bgms.filter((b) => b.name !== name);
  #|       const names = audioState.bgms.map((b) => b.name);
  #|       audioState.selectedBgmName = names[0] || null;
  #|       syncPlaybackFromSelectedBgm();
  #|       refreshBgmSelector();
  #|       syncBgmControlsFromState();
  #|       markDirty();
  #|     });
  #|   }
  #|
  #|   let bgmAdvanced = document.getElementById("moon8bit-sound-bgm-advanced");
  #|   if (!bgmAdvanced) {
  #|     bgmAdvanced = document.createElement("div");
  #|     bgmAdvanced.id = "moon8bit-sound-bgm-advanced";
  #|     bgmAdvanced.style.display = "grid";
  #|     bgmAdvanced.style.gap = "6px";
  #|     soundEditor.appendChild(bgmAdvanced);
  #|   }
  #|
  #|   const ensureBgmRow = (id, label, hint) => {
  #|     let row = document.getElementById(id);
  #|     if (!row) {
  #|       row = document.createElement("div");
  #|       row.id = id;
  #|       row.style.display = "grid";
  #|       row.style.gridTemplateColumns = "140px 1fr";
  #|       row.style.alignItems = "center";
  #|       row.style.gap = "8px";
  #|
  #|       const left = document.createElement("div");
  #|       left.style.display = "grid";
  #|       left.style.gap = "2px";
  #|       const title = document.createElement("div");
  #|       title.textContent = label;
  #|       title.style.fontFamily = "monospace";
  #|       title.style.fontSize = "12px";
  #|       left.appendChild(title);
  #|       const hintEl = document.createElement("div");
  #|       hintEl.textContent = hint;
  #|       hintEl.style.fontFamily = "monospace";
  #|       hintEl.style.fontSize = "10px";
  #|       hintEl.style.color = "#9fb3c8";
  #|       left.appendChild(hintEl);
  #|       row.appendChild(left);
  #|
  #|       const field = document.createElement("div");
  #|       field.id = `${id}-field`;
  #|       row.appendChild(field);
  #|       bgmAdvanced.appendChild(row);
  #|     }
  #|     return document.getElementById(`${id}-field`);
  #|   };
  #|
  #|   const bgmWaveField = ensureBgmRow(
  #|     "moon8bit-sound-bgm-wave-row",
  #|     "BGM Wave",
  #|     "oscillator type",
  #|   );
  #|   let bgmWaveSelect = document.getElementById("moon8bit-sound-bgm-wave");
  #|   if (!bgmWaveSelect) {
  #|     bgmWaveSelect = document.createElement("select");
  #|     bgmWaveSelect.id = "moon8bit-sound-bgm-wave";
  #|     ["sine", "square", "triangle", "sawtooth"].forEach((wave) => {
  #|       const option = document.createElement("option");
  #|       option.value = wave;
  #|       option.textContent = wave;
  #|       bgmWaveSelect.appendChild(option);
  #|     });
  #|     bgmWaveSelect.style.width = "100%";
  #|     bgmWaveSelect.style.boxSizing = "border-box";
  #|     bgmWaveField.appendChild(bgmWaveSelect);
  #|   }
  #|   if (bgmWaveSelect.dataset.bound !== "1") {
  #|     bgmWaveSelect.dataset.bound = "1";
  #|     bgmWaveSelect.addEventListener("change", () => {
  #|       audioState.bgmWave = bgmWaveSelect.value || null;
  #|       const b = getSelectedBgm();
  #|       if (b) b.wave = bgmWaveSelect.value || "square";
  #|       markDirty();
  #|     });
  #|   }
  #|
  #|   const bgmStepField = ensureBgmRow(
  #|     "moon8bit-sound-bgm-step-row",
  #|     "BGM Step (sec)",
  #|     "duration of each note",
  #|   );
  #|   let bgmStepInput = document.getElementById("moon8bit-sound-bgm-step");
  #|   if (!bgmStepInput) {
  #|     bgmStepInput = document.createElement("input");
  #|     bgmStepInput.id = "moon8bit-sound-bgm-step";
  #|     bgmStepInput.type = "number";
  #|     bgmStepInput.min = "0.05";
  #|     bgmStepInput.max = "1.5";
  #|     bgmStepInput.step = "0.005";
  #|     bgmStepInput.style.width = "100%";
  #|     bgmStepInput.style.boxSizing = "border-box";
  #|     bgmStepField.appendChild(bgmStepInput);
  #|   }
  #|   if (bgmStepInput.dataset.bound !== "1") {
  #|     bgmStepInput.dataset.bound = "1";
  #|     bgmStepInput.addEventListener("input", () => {
  #|       const n = Number(bgmStepInput.value);
  #|       if (!Number.isFinite(n)) {
  #|         bgmStepInput.style.border = "1px solid #ef6f6c";
  #|         setTransientError("bgm:step_sec", "BGM: step_sec must be a number");
  #|         renderSoundValidation();
  #|         return;
  #|       }
  #|       bgmStepInput.style.border = "";
  #|       clearTransientError("bgm:step_sec");
  #|       audioState.bgmStepSec = clamp(n, 0.05, 1.5);
  #|       const b = getSelectedBgm();
  #|       if (b) b.step_sec = audioState.bgmStepSec;
  #|       markDirty();
  #|     });
  #|   }
  #|
  #|   const bgmLoopField = ensureBgmRow(
  #|     "moon8bit-sound-bgm-loop-row",
  #|     "BGM Loop",
  #|     "repeat note sequence",
  #|   );
  #|   let bgmLoopInput = document.getElementById("moon8bit-sound-bgm-loop");
  #|   if (!bgmLoopInput) {
  #|     bgmLoopInput = document.createElement("input");
  #|     bgmLoopInput.id = "moon8bit-sound-bgm-loop";
  #|     bgmLoopInput.type = "checkbox";
  #|     bgmLoopField.appendChild(bgmLoopInput);
  #|   }
  #|   if (bgmLoopInput.dataset.bound !== "1") {
  #|     bgmLoopInput.dataset.bound = "1";
  #|     bgmLoopInput.addEventListener("change", () => {
  #|       audioState.bgmLoop = !!bgmLoopInput.checked;
  #|       const b = getSelectedBgm();
  #|       if (b) b.loop_ = audioState.bgmLoop;
  #|       markDirty();
  #|     });
  #|   }
  #|
  #|   const bgmNotesField = ensureBgmRow(
  #|     "moon8bit-sound-bgm-notes-row",
  #|     "BGM Notes",
  #|     "space-separated notes (C4 E4 G4 R)",
  #|   );
  #|   let bgmNotesInput = document.getElementById("moon8bit-sound-bgm-notes");
  #|   if (!bgmNotesInput) {
  #|     bgmNotesInput = document.createElement("input");
  #|     bgmNotesInput.id = "moon8bit-sound-bgm-notes";
  #|     bgmNotesInput.type = "text";
  #|     bgmNotesInput.spellcheck = false;
  #|     bgmNotesInput.style.width = "100%";
  #|     bgmNotesInput.style.boxSizing = "border-box";
  #|     bgmNotesField.appendChild(bgmNotesInput);
  #|   }
  #|   if (bgmNotesInput.dataset.bound !== "1") {
  #|     bgmNotesInput.dataset.bound = "1";
  #|     bgmNotesInput.addEventListener("input", () => {
  #|       const notes = parseNotesText(bgmNotesInput.value);
  #|       if (notes === null) {
  #|         const bad = firstInvalidNoteToken(bgmNotesInput.value);
  #|         bgmNotesInput.style.border = "1px solid #ef6f6c";
  #|         setTransientError(
  #|           "bgm:notes",
  #|           `BGM: invalid note token${bad ? ` "${bad}"` : ""} (use C4 C#4 Db4 R)`,
  #|         );
  #|         renderSoundValidation();
  #|         return;
  #|       }
  #|       bgmNotesInput.style.border = "";
  #|       clearTransientError("bgm:notes");
  #|       audioState.bgmNotes = notes;
  #|       const b = getSelectedBgm();
  #|       if (b) b.notes = notes.slice();
  #|       markDirty();
  #|     });
  #|   }
  #|
  #|   let bgmControls = document.getElementById("moon8bit-sound-bgm-controls");
  #|   if (!bgmControls) {
  #|     bgmControls = document.createElement("div");
  #|     bgmControls.id = "moon8bit-sound-bgm-controls";
  #|     bgmControls.style.display = "flex";
  #|     bgmControls.style.flexWrap = "wrap";
  #|     bgmControls.style.gap = "8px";
  #|     bgmControls.style.alignItems = "center";
  #|     soundEditor.appendChild(bgmControls);
  #|   }
  #|
  #|   const ensureButton = (id, label, onClick) => {
  #|     let button = document.getElementById(id);
  #|     if (!button) {
  #|       button = document.createElement("button");
  #|       button.id = id;
  #|       button.textContent = label;
  #|       button.style.padding = "6px 10px";
  #|       button.style.background = "#274060";
  #|       button.style.color = "#f6f7eb";
  #|       button.style.border = "1px solid #486581";
  #|       button.style.cursor = "pointer";
  #|       bgmControls.appendChild(button);
  #|     }
  #|     if (button.dataset.bound !== "1") {
  #|       button.dataset.bound = "1";
  #|       button.addEventListener("click", onClick);
  #|     }
  #|     return button;
  #|   };
  #|
  #|   const bgmStartButton = ensureButton("moon8bit-sound-bgm-start", "Start BGM", () => {
  #|     try { globalThis.__moon8bit_audio_start_bgm_impl(); } catch (_) {}
  #|   });
  #|   const bgmStopButton = ensureButton("moon8bit-sound-bgm-stop", "Stop BGM", () => {
  #|     try { globalThis.__moon8bit_audio_stop_bgm_impl(); } catch (_) {}
  #|   });
  #|
  #|   let eventControls = document.getElementById("moon8bit-sound-event-controls");
  #|   if (!eventControls) {
  #|     eventControls = document.createElement("div");
  #|     eventControls.id = "moon8bit-sound-event-controls";
  #|     eventControls.style.display = "flex";
  #|     eventControls.style.flexWrap = "wrap";
  #|     eventControls.style.gap = "8px";
  #|     eventControls.style.alignItems = "center";
  #|     soundEditor.appendChild(eventControls);
  #|   }
  #|
  #|   let sfxGrid = document.getElementById("moon8bit-sound-sfx-grid");
  #|   if (!sfxGrid) {
  #|     sfxGrid = document.createElement("div");
  #|     sfxGrid.id = "moon8bit-sound-sfx-grid";
  #|     sfxGrid.style.display = "grid";
  #|     sfxGrid.style.gap = "6px";
  #|     soundEditor.appendChild(sfxGrid);
  #|   }
  #|
  #|   let sfxLegend = document.getElementById("moon8bit-sound-sfx-legend");
  #|   if (!sfxLegend) {
  #|     sfxLegend = document.createElement("div");
  #|     sfxLegend.id = "moon8bit-sound-sfx-legend";
  #|     sfxLegend.textContent = "SFX params: Wave=oscillator type, F0/F1=frequency(Hz), ATK/DEC=seconds, VOL=volume(0..1)";
  #|     sfxLegend.style.fontFamily = "monospace";
  #|     sfxLegend.style.fontSize = "11px";
  #|     sfxLegend.style.color = "#9fb3c8";
  #|     soundEditor.insertBefore(sfxLegend, sfxGrid);
  #|   }
  #|
  #|   const renderSfxCard = (kind, title, onDelete, onDuplicate) => {
  #|     const profile = getSfxProfile(kind);
  #|     if (!profile) return;
  #|     const slug = soundKeyToId(kind);
  #|     const card = document.createElement("div");
  #|     card.id = `moon8bit-sfx-${slug}-card`;
  #|     card.style.display = "grid";
  #|     card.style.gridTemplateColumns = "84px 100px 1fr 1fr 1fr 1fr 1fr 52px 52px 52px";
  #|     card.style.gap = "6px";
  #|     card.style.alignItems = "start";
  #|     card.style.padding = "6px";
  #|     card.style.border = "1px solid #334e68";
  #|     card.style.background = "#0f1720";
  #|
  #|     const label = document.createElement("div");
  #|     label.textContent = title;
  #|     label.style.fontFamily = "monospace";
  #|     label.style.fontSize = "12px";
  #|     card.appendChild(label);
  #|
  #|     // Wave selector
  #|     const waveWrap = document.createElement("div");
  #|     waveWrap.style.display = "grid";
  #|     waveWrap.style.gap = "2px";
  #|     const waveLabel = document.createElement("div");
  #|     waveLabel.textContent = "Wave";
  #|     waveLabel.style.fontFamily = "monospace";
  #|     waveLabel.style.fontSize = "10px";
  #|     waveLabel.style.color = "#9fb3c8";
  #|     waveWrap.appendChild(waveLabel);
  #|     const waveSelect = document.createElement("select");
  #|     ["sine", "square", "triangle", "sawtooth"].forEach((w) => {
  #|       const opt = document.createElement("option");
  #|       opt.value = w;
  #|       opt.textContent = w;
  #|       waveSelect.appendChild(opt);
  #|     });
  #|     waveSelect.value = String(profile.type || "square");
  #|     waveSelect.style.width = "100%";
  #|     waveSelect.style.boxSizing = "border-box";
  #|     waveSelect.style.fontSize = "11px";
  #|     waveSelect.addEventListener("change", () => {
  #|       profile.type = waveSelect.value;
  #|       markDirty();
  #|     });
  #|     waveWrap.appendChild(waveSelect);
  #|     card.appendChild(waveWrap);
  #|
  #|     const fields = [
  #|       { key: "f0", label: "F0 Start Hz", min: 60, max: 1800, step: 1 },
  #|       { key: "f1", label: "F1 End Hz", min: 40, max: 1600, step: 1 },
  #|       { key: "attack", label: "ATK Sec", min: 0.001, max: 0.1, step: 0.001 },
  #|       { key: "decay", label: "DEC Sec", min: 0.02, max: 0.4, step: 0.005 },
  #|       { key: "volume", label: "VOL 0..1", min: 0.01, max: 0.25, step: 0.005 },
  #|     ];
  #|
  #|     fields.forEach((field) => {
  #|       const fieldWrap = document.createElement("div");
  #|       fieldWrap.style.display = "grid";
  #|       fieldWrap.style.gap = "2px";
  #|       const fieldLabel = document.createElement("div");
  #|       fieldLabel.textContent = field.label;
  #|       fieldLabel.style.fontFamily = "monospace";
  #|       fieldLabel.style.fontSize = "10px";
  #|       fieldLabel.style.color = "#9fb3c8";
  #|       fieldWrap.appendChild(fieldLabel);
  #|       const input = document.createElement("input");
  #|       input.type = "number";
  #|       input.min = String(field.min);
  #|       input.max = String(field.max);
  #|       input.step = String(field.step);
  #|       input.title = field.label;
  #|       input.style.width = "100%";
  #|       input.style.boxSizing = "border-box";
  #|       input.value = String(profile[field.key]);
  #|       input.addEventListener("input", () => {
  #|         const n = Number(input.value);
  #|         const errorKey = `sfx:${kind}:${field.key}`;
  #|         if (!Number.isFinite(n)) {
  #|           input.style.border = "1px solid #ef6f6c";
  #|           setTransientError(errorKey, `SFX "${kind}": ${field.key} must be a number`);
  #|           renderSoundValidation();
  #|           return;
  #|         }
  #|         input.style.border = "";
  #|         clearTransientError(errorKey);
  #|         profile[field.key] = clamp(n, field.min, field.max);
  #|         markDirty();
  #|       });
  #|       fieldWrap.appendChild(input);
  #|       card.appendChild(fieldWrap);
  #|     });
  #|
  #|     const testBtn = document.createElement("button");
  #|     testBtn.textContent = "Test";
  #|     testBtn.style.padding = "4px 8px";
  #|     testBtn.style.background = "#486581";
  #|     testBtn.style.color = "#f6f7eb";
  #|     testBtn.style.border = "1px solid #627d98";
  #|     testBtn.style.cursor = "pointer";
  #|     testBtn.addEventListener("click", () => {
  #|       try { globalThis.__moon8bit_audio_play_sfx_impl(kind); } catch (_) {}
  #|     });
  #|     card.appendChild(testBtn);
  #|
  #|     const delBtn = document.createElement("button");
  #|     delBtn.textContent = "Del";
  #|     delBtn.style.padding = "4px 6px";
  #|     delBtn.style.background = "#5c2b2b";
  #|     delBtn.style.color = "#f6f7eb";
  #|     delBtn.style.border = "1px solid #a04040";
  #|     delBtn.style.cursor = "pointer";
  #|     delBtn.addEventListener("click", () => {
  #|       if (onDelete) onDelete(kind);
  #|     });
  #|     card.appendChild(delBtn);
  #|
  #|     const dupBtn = document.createElement("button");
  #|     dupBtn.textContent = "Dup";
  #|     dupBtn.style.padding = "4px 6px";
  #|     dupBtn.style.background = "#274060";
  #|     dupBtn.style.color = "#f6f7eb";
  #|     dupBtn.style.border = "1px solid #486581";
  #|     dupBtn.style.cursor = "pointer";
  #|     dupBtn.addEventListener("click", () => {
  #|       if (onDuplicate) onDuplicate(kind);
  #|     });
  #|     card.appendChild(dupBtn);
  #|
  #|     sfxGrid.appendChild(card);
  #|   };
  #|
  #|   const syncBgmControlsFromState = () => {
  #|     const bgm = getSelectedBgm();
  #|     const defined = bgm !== null;
  #|     // Refresh BGM selector
  #|     if (bgmSelector) {
  #|       const prevValue = bgmSelector.value;
  #|       bgmSelector.innerHTML = "";
  #|       if (audioState.bgms.length === 0) {
  #|         const opt = document.createElement("option");
  #|         opt.value = "";
  #|         opt.textContent = "(none)";
  #|         bgmSelector.appendChild(opt);
  #|       } else {
  #|         for (const b of audioState.bgms) {
  #|           const opt = document.createElement("option");
  #|           opt.value = b.name;
  #|           opt.textContent = b.name;
  #|           bgmSelector.appendChild(opt);
  #|         }
  #|         bgmSelector.value = audioState.selectedBgmName || prevValue || "";
  #|       }
  #|     }
  #|     const bgmVolumeInput = document.getElementById("moon8bit-sound-bgm");
  #|     const bgmVolumeValue = document.getElementById("moon8bit-sound-bgm-value");
  #|     if (bgmVolumeInput) {
  #|       bgmVolumeInput.value = String(bgm ? bgm.volume : Number(audioState.bgmVolume ?? 0.0));
  #|       bgmVolumeInput.disabled = !defined;
  #|     }
  #|     if (bgmVolumeValue && bgmVolumeInput) {
  #|       bgmVolumeValue.textContent = Number(bgmVolumeInput.value).toFixed(2);
  #|     }
  #|     if (bgmWaveSelect) {
  #|       bgmWaveSelect.value = String(bgm ? bgm.wave : (audioState.bgmWave || "square"));
  #|       bgmWaveSelect.disabled = !defined;
  #|     }
  #|     if (bgmStepInput) {
  #|       bgmStepInput.value = String(bgm ? bgm.step_sec : Number(audioState.bgmStepSec ?? 0.125));
  #|       bgmStepInput.disabled = !defined;
  #|       bgmStepInput.style.border = "";
  #|     }
  #|     if (bgmLoopInput) {
  #|       bgmLoopInput.checked = Boolean(bgm ? bgm.loop_ : (audioState.bgmLoop ?? true));
  #|       bgmLoopInput.disabled = !defined;
  #|     }
  #|     if (bgmNotesInput) {
  #|       const notes = Array.isArray(bgm ? bgm.notes : audioState.bgmNotes) ? (bgm ? bgm.notes : audioState.bgmNotes) : [];
  #|       bgmNotesInput.value = notes.map(noteNameFromMidi).join(" ");
  #|       bgmNotesInput.disabled = !defined;
  #|       bgmNotesInput.style.border = "";
  #|     }
  #|     if (bgmStartButton) bgmStartButton.disabled = !defined;
  #|     if (bgmStopButton) bgmStopButton.disabled = !defined;
  #|     if (dupBgmBtn) dupBgmBtn.disabled = !defined;
  #|     // Sync playback fields from selected BGM
  #|     if (bgm) {
  #|       audioState.bgmDefined = true;
  #|       audioState.bgmWave = bgm.wave;
  #|       audioState.bgmVolume = bgm.volume;
  #|       audioState.bgmStepSec = bgm.step_sec;
  #|       audioState.bgmLoop = bgm.loop_;
  #|       audioState.bgmNotes = bgm.notes.slice();
  #|     } else {
  #|       audioState.bgmDefined = false;
  #|     }
  #|   };
  #|
  #|   const refreshSoundEditorFromDsl = () => {
  #|     const events = parseSoundEventsFromDsl(textarea ? textarea.value : "");
  #|     syncBgmControlsFromState();
  #|     eventControls.innerHTML = "";
  #|     sfxGrid.innerHTML = "";
  #|     globalThis.__moon8bit_sound_events = events;
  #|
  #|     const deleteSfx = (kind) => {
  #|       if (!confirm(`Delete SFX "${kind}"?`)) return;
  #|       delete audioState.sfx[kind];
  #|       if (writeSoundToDsl(false)) {
  #|         markSaved();
  #|         refreshSoundEditorFromDsl();
  #|       }
  #|     };
  #|
  #|     const duplicateSfx = (kind) => {
  #|       const src = audioState.sfx && audioState.sfx[kind] ? audioState.sfx[kind] : null;
  #|       if (!src) return;
  #|       const name = nextUniqueName(Object.keys(audioState.sfx || {}), `${kind}_copy`);
  #|       audioState.sfx[name] = {
  #|         type: src.type || "square",
  #|         attack: Number(src.attack ?? 0.003),
  #|         decay: Number(src.decay ?? 0.10),
  #|         volume: Number(src.volume ?? 0.07),
  #|         f0: Math.round(Number(src.f0 ?? 520)),
  #|         f1: Math.round(Number(src.f1 ?? 360)),
  #|       };
  #|       if (writeSoundToDsl(false)) {
  #|         markSaved();
  #|         refreshSoundEditorFromDsl();
  #|       }
  #|     };
  #|
  #|     events.forEach((event) => {
  #|       const testBtn = document.createElement("button");
  #|       testBtn.textContent = `Test ${event.label}`;
  #|       testBtn.style.padding = "6px 10px";
  #|       testBtn.style.background = "#274060";
  #|       testBtn.style.color = "#f6f7eb";
  #|       testBtn.style.border = "1px solid #486581";
  #|       testBtn.style.cursor = "pointer";
  #|       testBtn.addEventListener("click", () => {
  #|         try { globalThis.__moon8bit_audio_play_sfx_impl(event.key); } catch (_) {}
  #|       });
  #|       eventControls.appendChild(testBtn);
  #|
  #|       renderSfxCard(event.key, event.label, deleteSfx, duplicateSfx);
  #|     });
  #|
  #|     // Add SFX button
  #|     const addSfxBtn = document.createElement("button");
  #|     addSfxBtn.textContent = "+ SFX";
  #|     addSfxBtn.style.padding = "6px 10px";
  #|     addSfxBtn.style.background = "#1a3a1a";
  #|     addSfxBtn.style.color = "#f6f7eb";
  #|     addSfxBtn.style.border = "1px solid #4aa96c";
  #|     addSfxBtn.style.cursor = "pointer";
  #|     addSfxBtn.addEventListener("click", () => {
  #|       let name = prompt("New SFX name:", "sfx" + (Object.keys(audioState.sfx || {}).length + 1));
  #|       if (!name) return;
  #|       name = name.trim().replace(/[^A-Za-z0-9_-]/g, "_");
  #|       if (!name) { alert("Invalid name."); return; }
  #|       if (audioState.sfx && audioState.sfx[name]) { alert("Name already in use."); return; }
  #|       if (!audioState.sfx) audioState.sfx = {};
  #|       audioState.sfx[name] = { type: "square", attack: 0.003, decay: 0.10, volume: 0.07, f0: 520, f1: 360 };
  #|       if (writeSoundToDsl(false)) {
  #|         markSaved();
  #|         refreshSoundEditorFromDsl();
  #|       }
  #|     });
  #|     eventControls.appendChild(addSfxBtn);
  #|
  #|     if (events.length === 0) {
  #|       const note = document.createElement("div");
  #|       note.style.fontFamily = "monospace";
  #|       note.style.fontSize = "12px";
  #|       note.style.color = "#9fb3c8";
  #|       note.textContent = "No SFX defined. Click + SFX to add one.";
  #|       sfxGrid.appendChild(note);
  #|     }
  #|
  #|     updateSoundDirtyIndicator();
  #|     renderSoundValidation();
  #|   };
  #|
  #|   if (textarea && !globalThis.__moon8bit_sound_bound) {
  #|     textarea.addEventListener("input", refreshSoundEditorFromDsl);
  #|     soundSyncBtn.addEventListener("click", () => {
  #|       const bundle = parseSoundBundleFromDsl(textarea.value);
  #|       applySoundBundleToState(bundle);
  #|       if (feedback) {
  #|         if (Array.isArray(bundle.errors) && bundle.errors.length > 0) {
  #|           const maxLines = Math.min(4, bundle.errors.length);
  #|           let msg = `Sound DSL sync warnings (${bundle.errors.length}):`;
  #|           for (let i = 0; i < maxLines; i += 1) msg += `\n- ${bundle.errors[i]}`;
  #|           if (bundle.errors.length > maxLines) msg += `\n... and ${bundle.errors.length - maxLines} more`;
  #|           feedback.textContent = msg;
  #|           feedback.style.color = "#e8c547";
  #|         } else {
  #|           feedback.textContent = "Sound DSL synced.";
  #|           feedback.style.color = "#9fb3c8";
  #|         }
  #|       }
  #|       refreshSoundEditorFromDsl();
  #|     });
  #|     soundWriteBtn.addEventListener("click", () => {
  #|       if (writeSoundToDsl(false)) {
  #|         markSaved();
  #|         refreshSoundEditorFromDsl();
  #|       }
  #|     });
  #|     soundApplyBtn.addEventListener("click", () => {
  #|       if (writeSoundToDsl(true)) {
  #|         markSaved();
  #|         refreshSoundEditorFromDsl();
  #|       }
  #|     });
  #|     globalThis.__moon8bit_sound_bound = true;
  #|   }
  #|   globalThis.__moon8bit_sound_refresh = refreshSoundEditorFromDsl;
  #|   refreshSoundEditorFromDsl();
  #| }

///|
