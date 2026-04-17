///|
extern "js" fn web_init_canvas(width : Int, height : Int, scale : Int) -> Unit =
  #| (width, height, scale) => {
  #|   document.body.style.margin = "0";
  #|   document.body.style.display = "block";
  #|   document.body.style.placeContent = "initial";
  #|   document.body.style.overflow = "hidden";
  #|   document.body.style.background = "#0a1628";
  #|   document.body.style.fontSize = "15px";
  #|   document.body.style.fontFamily = "ui-monospace, SFMono-Regular, Menlo, monospace";
  #|
  #|   let root = document.getElementById("moon8bit-root");
  #|   if (!root) {
  #|     root = document.createElement("div");
  #|     root.id = "moon8bit-root";
  #|     document.body.appendChild(root);
  #|   }
  #|   root.style.display = "flex";
  #|   root.style.flexDirection = "column";
  #|   root.style.width = "100%";
  #|   root.style.boxSizing = "border-box";
  #|   root.style.padding = "8px";
  #|   root.style.gap = "8px";
  #|   root.style.background = "#0a1628";
  #|   const updateRootHeight = () => {
  #|     const top = root.getBoundingClientRect().top + window.scrollY;
  #|     root.style.height = `${window.innerHeight - top}px`;
  #|   };
  #|   updateRootHeight();
  #|   if (!globalThis.__moon8bit_root_resize_bound) {
  #|     window.addEventListener("resize", updateRootHeight);
  #|     globalThis.__moon8bit_root_resize_bound = true;
  #|   }
  #|
  #|   let tabButtons = document.getElementById("moon8bit-tab-buttons");
  #|   if (!tabButtons) {
  #|     tabButtons = document.createElement("div");
  #|     tabButtons.id = "moon8bit-tab-buttons";
  #|     root.appendChild(tabButtons);
  #|   }
  #|   tabButtons.style.display = "flex";
  #|   tabButtons.style.flexWrap = "wrap";
  #|   tabButtons.style.gap = "6px";
  #|   tabButtons.style.flexShrink = "0";
  #|
  #|   let tabPanels = document.getElementById("moon8bit-tab-panels");
  #|   if (!tabPanels) {
  #|     tabPanels = document.createElement("div");
  #|     tabPanels.id = "moon8bit-tab-panels";
  #|     root.appendChild(tabPanels);
  #|   }
  #|   tabPanels.style.flex = "1";
  #|   tabPanels.style.minHeight = "0";
  #|   tabPanels.style.width = "100%";
  #|   tabPanels.style.overflow = "hidden";
  #|   tabPanels.style.position = "relative";
  #|
  #|   const tabs = [
  #|     { key: "game", label: "Game" },
  #|     { key: "dsl", label: "DSL" },
  #|     { key: "sprite", label: "Sprite" },
  #|     { key: "tile", label: "Tile" },
  #|     { key: "tilemap", label: "Tilemap" },
  #|     { key: "sfx", label: "SFX" },
  #|     { key: "sound", label: "BGM" },
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
  #|       button.style.padding = "8px 14px";
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
  #|       tabPanels.appendChild(panel);
  #|     }
  #|     panel.style.display = "none";
  #|     panel.style.position = "absolute";
  #|     panel.style.inset = "0";
  #|     panel.style.width = "100%";
  #|     panel.style.height = "100%";
  #|     panel.style.boxSizing = "border-box";
  #|     panel.style.gap = "8px";
  #|     panel.style.alignItems = "start";
  #|     panel.style.overflowY = "auto";
  #|     if (key !== "game") {
  #|       panel.style.padding = "8px";
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
  #|       const display = isActive ? (tab.key === "game" ? "flex" : "grid") : "none";
  #|       tabUi[tab.key].panel.style.display = display;
  #|       if (tab.key === "game") {
  #|         tabUi[tab.key].panel.style.justifyContent = "center";
  #|         tabUi[tab.key].panel.style.alignItems = "center";
  #|         tabUi[tab.key].panel.style.flexDirection = "column";
  #|       }
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
  #|   canvas.style.imageRendering = "pixelated";
  #|   canvas.style.border = "2px solid #333";
  #|   canvas.style.display = "block";
  #|   globalThis.__moon8bit_scale = scale;
  #|   globalThis.__moon8bit_logical_width = width;
  #|   globalThis.__moon8bit_logical_height = height;
  #|
  #|   const resizeCanvas = () => {
  #|     const lw = globalThis.__moon8bit_logical_width;
  #|     const lh = globalThis.__moon8bit_logical_height;
  #|     const panelRect = tabPanels.getBoundingClientRect();
  #|     // Scale by height first, then clamp so canvas fits horizontally too
  #|     const s = Math.max(1, Math.min(
  #|       Math.floor(panelRect.height / lh),
  #|       Math.floor(panelRect.width / lw),
  #|     ));
  #|     canvas.style.width = `${lw * s}px`;
  #|     canvas.style.height = `${lh * s}px`;
  #|     globalThis.__moon8bit_scale = s;
  #|   };
  #|   globalThis.__moon8bit_resize_canvas = resizeCanvas;
  #|   resizeCanvas();
  #|   if (!globalThis.__moon8bit_resize_bound) {
  #|     window.addEventListener("resize", () => {
  #|       if (globalThis.__moon8bit_resize_canvas) globalThis.__moon8bit_resize_canvas();
  #|     });
  #|     globalThis.__moon8bit_resize_bound = true;
  #|   }
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
  #|     editor.style.height = "100%";
  #|     editor.style.minHeight = "0";
  #|     editor.style.minWidth = "0";
  #|     editor.style.boxSizing = "border-box";
  #|     editor.style.gridTemplateRows = "minmax(0, 1fr) auto auto";
  #|     editor.style.overflowX = "hidden";
  #|   }
  #|   if (editor.parentElement !== tabUi.dsl.panel) {
  #|     tabUi.dsl.panel.appendChild(editor);
  #|   }
  #|   editor.style.width = "100%";
  #|   editor.style.height = "100%";
  #|   editor.style.minHeight = "0";
  #|   editor.style.minWidth = "0";
  #|   editor.style.boxSizing = "border-box";
  #|   editor.style.gridTemplateRows = "minmax(0, 1fr) auto auto";
  #|   editor.style.overflowX = "hidden";
  #|
  #|   let textarea = document.getElementById("moon8bit-dsl-input");
  #|   if (!textarea) {
  #|     textarea = document.createElement("textarea");
  #|     textarea.id = "moon8bit-dsl-input";
  #|     textarea.style.width = "100%";
  #|     textarea.style.height = "100%";
  #|     textarea.style.minHeight = "220px";
  #|     textarea.style.maxHeight = "100%";
  #|     textarea.style.background = "#0f1720";
  #|     textarea.style.color = "#d9e2ec";
  #|     textarea.style.border = "1px solid #334e68";
  #|     textarea.style.padding = "12px";
  #|     textarea.style.fontFamily = "ui-monospace, SFMono-Regular, Menlo, monospace";
  #|     textarea.style.fontSize = "15px";
  #|     textarea.style.boxSizing = "border-box";
  #|     textarea.style.minWidth = "0";
  #|     textarea.style.resize = "none";
  #|     textarea.spellcheck = false;
  #|     editor.appendChild(textarea);
  #|   }
  #|   textarea.style.width = "100%";
  #|   textarea.style.height = "100%";
  #|   textarea.style.minHeight = "220px";
  #|   textarea.style.maxHeight = "100%";
  #|   textarea.style.boxSizing = "border-box";
  #|   textarea.style.minWidth = "0";
  #|   textarea.style.resize = "none";
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
  #|     button.textContent = "Apply";
  #|     button.style.padding = "8px 14px";
  #|     button.style.background = "#1d4ed8";
  #|     button.style.color = "#f6f7eb";
  #|     button.style.border = "1px solid #60a5fa";
  #|     button.style.cursor = "pointer";
  #|   }
  #|   if (button.parentElement !== tabButtons) {
  #|     tabButtons.appendChild(button);
  #|   }
  #|
  #|   let exportButton = document.getElementById("moon8bit-export-btn");
  #|   if (!exportButton) {
  #|     exportButton = document.createElement("button");
  #|     exportButton.id = "moon8bit-export-btn";
  #|     exportButton.textContent = "Export DSL";
  #|     exportButton.style.padding = "8px 14px";
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
  #|     importButton.style.padding = "8px 14px";
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
  #|     hint.style.fontSize = "15px";
  #|     hint.style.opacity = "0.8";
  #|     controls.appendChild(hint);
  #|   }
  #|
  #|   let feedback = document.getElementById("moon8bit-editor-feedback");
  #|   if (!feedback) {
  #|     feedback = document.createElement("div");
  #|     feedback.id = "moon8bit-editor-feedback";
  #|     feedback.style.fontFamily = "monospace";
  #|     feedback.style.fontSize = "15px";
  #|     feedback.style.color = "#9fb3c8";
  #|     feedback.style.overflowWrap = "anywhere";
  #|     feedback.style.wordBreak = "break-word";
  #|     editor.appendChild(feedback);
  #|   }
  #|   feedback.style.overflowWrap = "anywhere";
  #|   feedback.style.wordBreak = "break-word";
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
  #|   let sfxEditor = document.getElementById("moon8bit-sfx-editor");
  #|   if (!sfxEditor) {
  #|     sfxEditor = document.createElement("div");
  #|     sfxEditor.id = "moon8bit-sfx-editor";
  #|     sfxEditor.style.display = "grid";
  #|     sfxEditor.style.gap = "8px";
  #|     sfxEditor.style.padding = "8px";
  #|     sfxEditor.style.border = "1px solid #334e68";
  #|     sfxEditor.style.background = "#111827";
  #|     tabUi.sfx.panel.appendChild(sfxEditor);
  #|   }
  #|   if (sfxEditor.parentElement !== tabUi.sfx.panel) {
  #|     tabUi.sfx.panel.appendChild(sfxEditor);
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
  #|     soundHint.textContent = "Tune BGM parameters, then test playback directly.";
  #|     soundHint.style.fontFamily = "monospace";
  #|     soundHint.style.fontSize = "15px";
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
  #|   let soundDirtyIndicator = document.getElementById("moon8bit-sound-dirty");
  #|   if (!soundDirtyIndicator) {
  #|     soundDirtyIndicator = document.createElement("span");
  #|     soundDirtyIndicator.id = "moon8bit-sound-dirty";
  #|     soundDirtyIndicator.style.fontFamily = "monospace";
  #|     soundDirtyIndicator.style.fontSize = "15px";
  #|     soundDirtyIndicator.style.marginLeft = "4px";
  #|     soundDirtyIndicator.textContent = "Saved";
  #|     soundDirtyIndicator.style.color = "#7bd389";
  #|     soundActionRow.appendChild(soundDirtyIndicator);
  #|   }
  #|
  #|   let bgmLayout = document.getElementById("moon8bit-bgm-layout");
  #|   if (!bgmLayout) {
  #|     bgmLayout = document.createElement("div");
  #|     bgmLayout.id = "moon8bit-bgm-layout";
  #|     bgmLayout.style.display = "flex";
  #|     bgmLayout.style.gap = "12px";
  #|     bgmLayout.style.alignItems = "stretch";
  #|     bgmLayout.style.minHeight = "420px";
  #|     soundEditor.appendChild(bgmLayout);
  #|   }
  #|
  #|   let bgmListPane = document.getElementById("moon8bit-bgm-list-pane");
  #|   if (!bgmListPane) {
  #|     bgmListPane = document.createElement("div");
  #|     bgmListPane.id = "moon8bit-bgm-list-pane";
  #|     bgmListPane.style.width = "300px";
  #|     bgmListPane.style.flexShrink = "0";
  #|     bgmListPane.style.display = "grid";
  #|     bgmListPane.style.gridTemplateRows = "auto auto auto auto 1fr";
  #|     bgmListPane.style.gap = "8px";
  #|     bgmLayout.appendChild(bgmListPane);
  #|   }
  #|
  #|   let bgmListTitle = document.getElementById("moon8bit-bgm-list-title");
  #|   if (!bgmListTitle) {
  #|     bgmListTitle = document.createElement("div");
  #|     bgmListTitle.id = "moon8bit-bgm-list-title";
  #|     bgmListTitle.textContent = "All BGM";
  #|     bgmListTitle.style.fontFamily = "monospace";
  #|     bgmListTitle.style.fontSize = "18px";
  #|     bgmListTitle.style.fontWeight = "600";
  #|     bgmListPane.appendChild(bgmListTitle);
  #|   }
  #|
  #|   let bgmListHint = document.getElementById("moon8bit-bgm-list-hint");
  #|   if (!bgmListHint) {
  #|     bgmListHint = document.createElement("div");
  #|     bgmListHint.id = "moon8bit-bgm-list-hint";
  #|     bgmListHint.textContent = "Select BGM on the left, edit on the right.";
  #|     bgmListHint.style.fontFamily = "monospace";
  #|     bgmListHint.style.fontSize = "13px";
  #|     bgmListHint.style.color = "#9fb3c8";
  #|     bgmListPane.appendChild(bgmListHint);
  #|   }
  #|
  #|   let bgmListActions = document.getElementById("moon8bit-bgm-list-actions");
  #|   if (!bgmListActions) {
  #|     bgmListActions = document.createElement("div");
  #|     bgmListActions.id = "moon8bit-bgm-list-actions";
  #|     bgmListActions.style.display = "flex";
  #|     bgmListActions.style.gap = "8px";
  #|     bgmListActions.style.alignItems = "center";
  #|     bgmListPane.appendChild(bgmListActions);
  #|   }
  #|
  #|   let bgmList = document.getElementById("moon8bit-bgm-list");
  #|   if (!bgmList) {
  #|     bgmList = document.createElement("div");
  #|     bgmList.id = "moon8bit-bgm-list";
  #|     bgmList.style.display = "grid";
  #|     bgmList.style.gap = "6px";
  #|     bgmList.style.overflowY = "auto";
  #|     bgmList.style.minHeight = "0";
  #|     bgmList.style.paddingRight = "4px";
  #|     bgmListPane.appendChild(bgmList);
  #|   }
  #|
  #|   let bgmEditPane = document.getElementById("moon8bit-bgm-edit-pane");
  #|   if (!bgmEditPane) {
  #|     bgmEditPane = document.createElement("div");
  #|     bgmEditPane.id = "moon8bit-bgm-edit-pane";
  #|     bgmEditPane.style.flex = "1";
  #|     bgmEditPane.style.minWidth = "0";
  #|     bgmEditPane.style.display = "grid";
  #|     bgmEditPane.style.gridTemplateRows = "auto 1fr";
  #|     bgmEditPane.style.gap = "10px";
  #|     bgmLayout.appendChild(bgmEditPane);
  #|   }
  #|
  #|   let bgmEditorTitle = document.getElementById("moon8bit-bgm-editor-title");
  #|   if (!bgmEditorTitle) {
  #|     bgmEditorTitle = document.createElement("div");
  #|     bgmEditorTitle.id = "moon8bit-bgm-editor-title";
  #|     bgmEditorTitle.textContent = "Selected BGM";
  #|     bgmEditorTitle.style.fontFamily = "monospace";
  #|     bgmEditorTitle.style.fontSize = "18px";
  #|     bgmEditorTitle.style.fontWeight = "600";
  #|     bgmEditPane.appendChild(bgmEditorTitle);
  #|   }
  #|
  #|   let bgmEditorBody = document.getElementById("moon8bit-bgm-editor-body");
  #|   if (!bgmEditorBody) {
  #|     bgmEditorBody = document.createElement("div");
  #|     bgmEditorBody.id = "moon8bit-bgm-editor-body";
  #|     bgmEditorBody.style.display = "grid";
  #|     bgmEditorBody.style.gridTemplateRows = "auto 1fr";
  #|     bgmEditorBody.style.gap = "10px";
  #|     bgmEditorBody.style.minHeight = "0";
  #|     bgmEditPane.appendChild(bgmEditorBody);
  #|   }
  #|
  #|   let bgmControlsTop = document.getElementById("moon8bit-bgm-controls-top");
  #|   if (!bgmControlsTop) {
  #|     bgmControlsTop = document.createElement("div");
  #|     bgmControlsTop.id = "moon8bit-bgm-controls-top";
  #|     bgmControlsTop.style.display = "grid";
  #|     bgmControlsTop.style.gap = "8px";
  #|     bgmEditorBody.appendChild(bgmControlsTop);
  #|   }
  #|
  #|   let bgmRollWrap = document.getElementById("moon8bit-bgm-roll-wrap");
  #|   if (!bgmRollWrap) {
  #|     bgmRollWrap = document.createElement("div");
  #|     bgmRollWrap.id = "moon8bit-bgm-roll-wrap";
  #|     bgmRollWrap.style.display = "grid";
  #|     bgmRollWrap.style.gridTemplateRows = "auto 1fr";
  #|     bgmRollWrap.style.gap = "6px";
  #|     bgmRollWrap.style.minHeight = "220px";
  #|     bgmRollWrap.style.border = "1px solid #334e68";
  #|     bgmRollWrap.style.padding = "8px";
  #|     bgmEditorBody.appendChild(bgmRollWrap);
  #|   }
  #|
  #|   let bgmRollTitle = document.getElementById("moon8bit-bgm-roll-title");
  #|   if (!bgmRollTitle) {
  #|     bgmRollTitle = document.createElement("div");
  #|     bgmRollTitle.id = "moon8bit-bgm-roll-title";
  #|     bgmRollTitle.textContent = "Piano Roll";
  #|     bgmRollTitle.style.fontFamily = "monospace";
  #|     bgmRollTitle.style.fontSize = "14px";
  #|     bgmRollTitle.style.color = "#9fb3c8";
  #|     bgmRollWrap.appendChild(bgmRollTitle);
  #|   }
  #|
  #|   let bgmRollPanel = document.getElementById("moon8bit-bgm-roll-panel");
  #|   if (!bgmRollPanel) {
  #|     bgmRollPanel = document.createElement("div");
  #|     bgmRollPanel.id = "moon8bit-bgm-roll-panel";
  #|     bgmRollPanel.style.display = "grid";
  #|     bgmRollPanel.style.gridTemplateColumns = "52px 1fr";
  #|     bgmRollPanel.style.gap = "6px";
  #|     bgmRollPanel.style.minHeight = "0";
  #|     bgmRollPanel.style.alignItems = "start";
  #|     bgmRollPanel.style.justifyItems = "start";
  #|     bgmRollPanel.style.overflow = "auto";
  #|     bgmRollWrap.appendChild(bgmRollPanel);
  #|   }
  #|
  #|   let bgmRollKeys = document.getElementById("moon8bit-bgm-roll-keys");
  #|   if (!bgmRollKeys) {
  #|     bgmRollKeys = document.createElement("canvas");
  #|     bgmRollKeys.id = "moon8bit-bgm-roll-keys";
  #|     bgmRollKeys.style.imageRendering = "pixelated";
  #|     bgmRollKeys.style.border = "1px solid #334e68";
  #|     bgmRollPanel.appendChild(bgmRollKeys);
  #|   }
  #|
  #|   let bgmRoll = document.getElementById("moon8bit-bgm-roll");
  #|   if (!bgmRoll) {
  #|     bgmRoll = document.createElement("canvas");
  #|     bgmRoll.id = "moon8bit-bgm-roll";
  #|     bgmRoll.style.imageRendering = "pixelated";
  #|     bgmRoll.style.border = "1px solid #334e68";
  #|     bgmRoll.style.cursor = "crosshair";
  #|     bgmRollPanel.appendChild(bgmRoll);
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
  #|       selectedSfxName: null,
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
  #|     soundValidation.style.fontSize = "15px";
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
  #|   let soundAutoWriteTimer = null;
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
  #|   const scheduleSoundAutoWrite = () => {
  #|     if (soundAutoWriteTimer !== null) {
  #|       clearTimeout(soundAutoWriteTimer);
  #|     }
  #|     soundAutoWriteTimer = setTimeout(() => {
  #|       soundAutoWriteTimer = null;
  #|       if (writeSoundToDsl(false)) {
  #|         markSaved();
  #|       }
  #|     }, 120);
  #|   };
  #|
  #|   const markDirty = () => {
  #|     audioState.dirty = true;
  #|     updateSoundDirtyIndicator();
  #|     renderSoundValidation();
  #|     scheduleSoundAutoWrite();
  #|   };
  #|   const markSaved = () => {
  #|     audioState.dirty = false;
  #|     updateSoundDirtyIndicator();
  #|     renderSoundValidation();
  #|   };
  #|
  #|   const ensureSlider = (id, label, min, max, step, getValue, setValue, parent) => {
  #|     let row = document.getElementById(`${id}-row`);
  #|     if (!row) {
  #|       row = document.createElement("div");
  #|       row.id = `${id}-row`;
  #|       row.style.display = "grid";
  #|       row.style.gridTemplateColumns = "120px 1fr 56px";
  #|       row.style.alignItems = "center";
  #|       row.style.gap = "8px";
  #|       parent.appendChild(row);
  #|     }
  #|     if (row.parentElement !== parent) {
  #|       parent.appendChild(row);
  #|     }
  #|
  #|     let text = document.getElementById(`${id}-label`);
  #|     if (!text) {
  #|       text = document.createElement("div");
  #|       text.id = `${id}-label`;
  #|       text.textContent = label;
  #|       text.style.fontFamily = "monospace";
  #|       text.style.fontSize = "15px";
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
  #|       valueText.style.fontSize = "15px";
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
  #|     bgmControlsTop,
  #|   );
  #|
  #|   let bgmNameRow = document.getElementById("moon8bit-bgm-name-row");
  #|   if (!bgmNameRow) {
  #|     bgmNameRow = document.createElement("div");
  #|     bgmNameRow.id = "moon8bit-bgm-name-row";
  #|     bgmNameRow.style.display = "grid";
  #|     bgmNameRow.style.gridTemplateColumns = "120px 1fr auto";
  #|     bgmNameRow.style.alignItems = "center";
  #|     bgmNameRow.style.gap = "8px";
  #|     bgmControlsTop.appendChild(bgmNameRow);
  #|   }
  #|   if (bgmNameRow.parentElement !== bgmControlsTop) {
  #|     bgmControlsTop.appendChild(bgmNameRow);
  #|   }
  #|
  #|   let bgmNameLabel = document.getElementById("moon8bit-bgm-name-label");
  #|   if (!bgmNameLabel) {
  #|     bgmNameLabel = document.createElement("div");
  #|     bgmNameLabel.id = "moon8bit-bgm-name-label";
  #|     bgmNameLabel.textContent = "BGM Name";
  #|     bgmNameLabel.style.fontFamily = "monospace";
  #|     bgmNameLabel.style.fontSize = "15px";
  #|     bgmNameRow.appendChild(bgmNameLabel);
  #|   }
  #|
  #|   let bgmNameInput = document.getElementById("moon8bit-bgm-name-input");
  #|   if (!bgmNameInput) {
  #|     bgmNameInput = document.createElement("input");
  #|     bgmNameInput.id = "moon8bit-bgm-name-input";
  #|     bgmNameInput.type = "text";
  #|     bgmNameInput.spellcheck = false;
  #|     bgmNameInput.style.width = "100%";
  #|     bgmNameInput.style.boxSizing = "border-box";
  #|     bgmNameRow.appendChild(bgmNameInput);
  #|   }
  #|
  #|   let bgmRenameBtn = document.getElementById("moon8bit-bgm-rename-btn");
  #|   if (!bgmRenameBtn) {
  #|     bgmRenameBtn = document.createElement("button");
  #|     bgmRenameBtn.id = "moon8bit-bgm-rename-btn";
  #|     bgmRenameBtn.textContent = "Rename";
  #|     bgmRenameBtn.style.padding = "6px 10px";
  #|     bgmRenameBtn.style.background = "#274060";
  #|     bgmRenameBtn.style.color = "#f6f7eb";
  #|     bgmRenameBtn.style.border = "1px solid #486581";
  #|     bgmRenameBtn.style.cursor = "pointer";
  #|     bgmNameRow.appendChild(bgmRenameBtn);
  #|   }
  #|
  #|   const runBgmRename = () => {
  #|     const bgm = getSelectedBgm();
  #|     if (!bgm) return;
  #|     const oldName = bgm.name;
  #|     const nextName = String(bgmNameInput.value || "").trim().replace(/[^A-Za-z0-9_-]/g, "_");
  #|     if (!nextName) {
  #|       alert("Invalid name.");
  #|       bgmNameInput.value = oldName;
  #|       return;
  #|     }
  #|     if (nextName === oldName) return;
  #|     if (audioState.bgms.some((x) => x.name === nextName)) {
  #|       alert("Name already in use.");
  #|       bgmNameInput.value = oldName;
  #|       return;
  #|     }
  #|     bgm.name = nextName;
  #|     audioState.selectedBgmName = nextName;
  #|     syncPlaybackFromSelectedBgm();
  #|     markDirty();
  #|     syncBgmControlsFromState();
  #|   };
  #|
  #|   if (bgmRenameBtn.dataset.bound !== "1") {
  #|     bgmRenameBtn.dataset.bound = "1";
  #|     bgmRenameBtn.addEventListener("click", runBgmRename);
  #|   }
  #|   if (bgmNameInput.dataset.bound !== "1") {
  #|     bgmNameInput.dataset.bound = "1";
  #|     bgmNameInput.addEventListener("keydown", (ev) => {
  #|       if (ev.key === "Enter") {
  #|         ev.preventDefault();
  #|         runBgmRename();
  #|       }
  #|     });
  #|   }
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
  #|     bgmListPane.appendChild(bgmSelectorRow);
  #|   }
  #|   if (bgmSelectorRow.parentElement !== bgmListPane) {
  #|     bgmListPane.appendChild(bgmSelectorRow);
  #|   }
  #|   bgmSelectorRow.style.display = "none";
  #|   let bgmSelectorLabel = document.getElementById("moon8bit-bgm-selector-label");
  #|   if (!bgmSelectorLabel) {
  #|     bgmSelectorLabel = document.createElement("span");
  #|     bgmSelectorLabel.id = "moon8bit-bgm-selector-label";
  #|     bgmSelectorLabel.textContent = "BGM:";
  #|     bgmSelectorLabel.style.fontFamily = "monospace";
  #|     bgmSelectorLabel.style.fontSize = "15px";
  #|     bgmSelectorRow.appendChild(bgmSelectorLabel);
  #|   }
  #|   bgmSelectorLabel.style.display = "none";
  #|   let bgmSelector = document.getElementById("moon8bit-bgm-selector");
  #|   if (!bgmSelector) {
  #|     bgmSelector = document.createElement("select");
  #|     bgmSelector.id = "moon8bit-bgm-selector";
  #|     bgmSelector.style.fontFamily = "monospace";
  #|     bgmSelector.style.fontSize = "15px";
  #|     bgmSelectorRow.appendChild(bgmSelector);
  #|   }
  #|   bgmSelector.style.display = "none";
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
  #|     addBgmBtn.style.padding = "5px 10px";
  #|     addBgmBtn.style.background = "#274060";
  #|     addBgmBtn.style.color = "#f6f7eb";
  #|     addBgmBtn.style.border = "1px solid #486581";
  #|     addBgmBtn.style.cursor = "pointer";
  #|     addBgmBtn.style.fontFamily = "monospace";
  #|     addBgmBtn.style.fontSize = "15px";
  #|     bgmListActions.appendChild(addBgmBtn);
  #|   }
  #|   if (addBgmBtn.parentElement !== bgmListActions) {
  #|     bgmListActions.appendChild(addBgmBtn);
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
  #|     dupBgmBtn.style.padding = "5px 10px";
  #|     dupBgmBtn.style.background = "#274060";
  #|     dupBgmBtn.style.color = "#f6f7eb";
  #|     dupBgmBtn.style.border = "1px solid #486581";
  #|     dupBgmBtn.style.cursor = "pointer";
  #|     dupBgmBtn.style.fontFamily = "monospace";
  #|     dupBgmBtn.style.fontSize = "15px";
  #|     bgmListActions.appendChild(dupBgmBtn);
  #|   }
  #|   if (dupBgmBtn.parentElement !== bgmListActions) {
  #|     bgmListActions.appendChild(dupBgmBtn);
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
  #|     delBgmBtn.style.padding = "5px 10px";
  #|     delBgmBtn.style.background = "#5c2b2b";
  #|     delBgmBtn.style.color = "#f6f7eb";
  #|     delBgmBtn.style.border = "1px solid #a04040";
  #|     delBgmBtn.style.cursor = "pointer";
  #|     delBgmBtn.style.fontFamily = "monospace";
  #|     delBgmBtn.style.fontSize = "15px";
  #|     bgmListActions.appendChild(delBgmBtn);
  #|   }
  #|   if (delBgmBtn.parentElement !== bgmListActions) {
  #|     bgmListActions.appendChild(delBgmBtn);
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
  #|     bgmControlsTop.appendChild(bgmAdvanced);
  #|   }
  #|   if (bgmAdvanced.parentElement !== bgmControlsTop) {
  #|     bgmControlsTop.appendChild(bgmAdvanced);
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
  #|       title.style.fontSize = "15px";
  #|       left.appendChild(title);
  #|       const hintEl = document.createElement("div");
  #|       hintEl.textContent = hint;
  #|       hintEl.style.fontFamily = "monospace";
  #|       hintEl.style.fontSize = "13px";
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
  #|     bgmControlsTop.appendChild(bgmControls);
  #|   }
  #|   if (bgmControls.parentElement !== bgmControlsTop) {
  #|     bgmControlsTop.appendChild(bgmControls);
  #|   }
  #|
  #|   const ensureButton = (id, label, onClick) => {
  #|     let button = document.getElementById(id);
  #|     if (!button) {
  #|       button = document.createElement("button");
  #|       button.id = id;
  #|       button.textContent = label;
  #|       button.style.padding = "8px 14px";
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
  #|   let sfxTitle = document.getElementById("moon8bit-sfx-title");
  #|   if (!sfxTitle) {
  #|     sfxTitle = document.createElement("div");
  #|     sfxTitle.id = "moon8bit-sfx-title";
  #|     sfxTitle.textContent = "SFX Editor";
  #|     sfxTitle.style.fontWeight = "600";
  #|     sfxTitle.style.fontFamily = "monospace";
  #|     sfxEditor.appendChild(sfxTitle);
  #|   }
  #|
  #|   let sfxHint = document.getElementById("moon8bit-sfx-hint");
  #|   if (!sfxHint) {
  #|     sfxHint = document.createElement("div");
  #|     sfxHint.id = "moon8bit-sfx-hint";
  #|     sfxHint.textContent = "Select SFX on the left, edit synth params on the right.";
  #|     sfxHint.style.fontFamily = "monospace";
  #|     sfxHint.style.fontSize = "15px";
  #|     sfxHint.style.color = "#9fb3c8";
  #|     sfxEditor.appendChild(sfxHint);
  #|   }
  #|
  #|   let sfxLayout = document.getElementById("moon8bit-sfx-layout");
  #|   if (!sfxLayout) {
  #|     sfxLayout = document.createElement("div");
  #|     sfxLayout.id = "moon8bit-sfx-layout";
  #|     sfxLayout.style.display = "flex";
  #|     sfxLayout.style.gap = "12px";
  #|     sfxLayout.style.alignItems = "stretch";
  #|     sfxLayout.style.minHeight = "360px";
  #|     sfxEditor.appendChild(sfxLayout);
  #|   }
  #|   if (sfxLayout.parentElement !== sfxEditor) {
  #|     sfxEditor.appendChild(sfxLayout);
  #|   }
  #|
  #|   let sfxListPane = document.getElementById("moon8bit-sfx-list-pane");
  #|   if (!sfxListPane) {
  #|     sfxListPane = document.createElement("div");
  #|     sfxListPane.id = "moon8bit-sfx-list-pane";
  #|     sfxListPane.style.width = "320px";
  #|     sfxListPane.style.flexShrink = "0";
  #|     sfxListPane.style.display = "grid";
  #|     sfxListPane.style.gridTemplateRows = "auto auto auto 1fr";
  #|     sfxListPane.style.gap = "8px";
  #|     sfxLayout.appendChild(sfxListPane);
  #|   }
  #|
  #|   let sfxListTitle = document.getElementById("moon8bit-sfx-list-title");
  #|   if (!sfxListTitle) {
  #|     sfxListTitle = document.createElement("div");
  #|     sfxListTitle.id = "moon8bit-sfx-list-title";
  #|     sfxListTitle.textContent = "All SFX";
  #|     sfxListTitle.style.fontFamily = "monospace";
  #|     sfxListTitle.style.fontSize = "18px";
  #|     sfxListTitle.style.fontWeight = "600";
  #|     sfxListPane.appendChild(sfxListTitle);
  #|   }
  #|
  #|   let sfxLegend = document.getElementById("moon8bit-sound-sfx-legend");
  #|   if (!sfxLegend) {
  #|     sfxLegend = document.createElement("div");
  #|     sfxLegend.id = "moon8bit-sound-sfx-legend";
  #|     sfxLegend.textContent = "Wave, F0/F1, ATK, DEC, VOL";
  #|     sfxLegend.style.fontFamily = "monospace";
  #|     sfxLegend.style.fontSize = "13px";
  #|     sfxLegend.style.color = "#9fb3c8";
  #|     sfxListPane.appendChild(sfxLegend);
  #|   }
  #|
  #|   let sfxListActions = document.getElementById("moon8bit-sfx-list-actions");
  #|   if (!sfxListActions) {
  #|     sfxListActions = document.createElement("div");
  #|     sfxListActions.id = "moon8bit-sfx-list-actions";
  #|     sfxListActions.style.display = "flex";
  #|     sfxListActions.style.gap = "8px";
  #|     sfxListActions.style.alignItems = "center";
  #|     sfxListPane.appendChild(sfxListActions);
  #|   }
  #|
  #|   let addSfxBtn = document.getElementById("moon8bit-sfx-add-btn");
  #|   if (!addSfxBtn) {
  #|     addSfxBtn = document.createElement("button");
  #|     addSfxBtn.id = "moon8bit-sfx-add-btn";
  #|     addSfxBtn.textContent = "+ SFX";
  #|     addSfxBtn.style.padding = "8px 14px";
  #|     addSfxBtn.style.background = "#1a3a1a";
  #|     addSfxBtn.style.color = "#f6f7eb";
  #|     addSfxBtn.style.border = "1px solid #4aa96c";
  #|     addSfxBtn.style.cursor = "pointer";
  #|     sfxListActions.appendChild(addSfxBtn);
  #|   }
  #|
  #|   let sfxList = document.getElementById("moon8bit-sfx-list");
  #|   if (!sfxList) {
  #|     sfxList = document.createElement("div");
  #|     sfxList.id = "moon8bit-sfx-list";
  #|     sfxList.style.display = "grid";
  #|     sfxList.style.gap = "6px";
  #|     sfxList.style.overflowY = "auto";
  #|     sfxList.style.minHeight = "0";
  #|     sfxList.style.paddingRight = "4px";
  #|     sfxListPane.appendChild(sfxList);
  #|   }
  #|
  #|   let sfxEditorPane = document.getElementById("moon8bit-sfx-editor-pane");
  #|   if (!sfxEditorPane) {
  #|     sfxEditorPane = document.createElement("div");
  #|     sfxEditorPane.id = "moon8bit-sfx-editor-pane";
  #|     sfxEditorPane.style.flex = "1";
  #|     sfxEditorPane.style.minWidth = "0";
  #|     sfxEditorPane.style.display = "grid";
  #|     sfxEditorPane.style.gridTemplateRows = "auto 1fr";
  #|     sfxEditorPane.style.gap = "8px";
  #|     sfxLayout.appendChild(sfxEditorPane);
  #|   }
  #|
  #|   let sfxEditorTitle = document.getElementById("moon8bit-sfx-editor-title");
  #|   if (!sfxEditorTitle) {
  #|     sfxEditorTitle = document.createElement("div");
  #|     sfxEditorTitle.id = "moon8bit-sfx-editor-title";
  #|     sfxEditorTitle.textContent = "Selected SFX";
  #|     sfxEditorTitle.style.fontFamily = "monospace";
  #|     sfxEditorTitle.style.fontSize = "18px";
  #|     sfxEditorTitle.style.fontWeight = "600";
  #|     sfxEditorPane.appendChild(sfxEditorTitle);
  #|   }
  #|
  #|   let sfxEditorHost = document.getElementById("moon8bit-sfx-editor-host");
  #|   if (!sfxEditorHost) {
  #|     sfxEditorHost = document.createElement("div");
  #|     sfxEditorHost.id = "moon8bit-sfx-editor-host";
  #|     sfxEditorHost.style.display = "grid";
  #|     sfxEditorHost.style.gap = "8px";
  #|     sfxEditorHost.style.minHeight = "0";
  #|     sfxEditorPane.appendChild(sfxEditorHost);
  #|   }
  #|
  #|   const renderSfxCard = (kind, title, onDelete, onDuplicate, onRename, host) => {
  #|     const profile = getSfxProfile(kind);
  #|     if (!profile) return;
  #|     const slug = soundKeyToId(kind);
  #|     const card = document.createElement("div");
  #|     card.id = `moon8bit-sfx-${slug}-card`;
  #|     card.style.display = "grid";
  #|     card.style.gridTemplateColumns = "180px 110px 1fr 1fr 1fr 1fr 1fr 72px 72px 72px";
  #|     card.style.gap = "6px";
  #|     card.style.alignItems = "start";
  #|     card.style.padding = "6px";
  #|     card.style.border = "1px solid #334e68";
  #|     card.style.background = "#0f1720";
  #|
  #|     const nameWrap = document.createElement("div");
  #|     nameWrap.style.display = "grid";
  #|     nameWrap.style.gap = "2px";
  #|     const nameLabel = document.createElement("div");
  #|     nameLabel.textContent = "Name";
  #|     nameLabel.style.fontFamily = "monospace";
  #|     nameLabel.style.fontSize = "13px";
  #|     nameLabel.style.color = "#9fb3c8";
  #|     nameWrap.appendChild(nameLabel);
  #|     const nameRow = document.createElement("div");
  #|     nameRow.style.display = "grid";
  #|     nameRow.style.gridTemplateColumns = "1fr auto";
  #|     nameRow.style.gap = "4px";
  #|     const nameInput = document.createElement("input");
  #|     nameInput.type = "text";
  #|     nameInput.value = kind;
  #|     nameInput.spellcheck = false;
  #|     nameInput.style.width = "100%";
  #|     nameInput.style.boxSizing = "border-box";
  #|     nameInput.style.fontFamily = "monospace";
  #|     nameInput.style.fontSize = "13px";
  #|     nameRow.appendChild(nameInput);
  #|     const renameBtn = document.createElement("button");
  #|     renameBtn.textContent = "Rename";
  #|     renameBtn.style.padding = "4px 8px";
  #|     renameBtn.style.background = "#274060";
  #|     renameBtn.style.color = "#f6f7eb";
  #|     renameBtn.style.border = "1px solid #486581";
  #|     renameBtn.style.cursor = "pointer";
  #|     renameBtn.style.fontFamily = "monospace";
  #|     renameBtn.style.fontSize = "12px";
  #|     const runRename = () => {
  #|       if (!onRename) return;
  #|       const ok = onRename(kind, String(nameInput.value || ""));
  #|       if (!ok) {
  #|         nameInput.value = kind;
  #|       }
  #|     };
  #|     renameBtn.addEventListener("click", runRename);
  #|     nameInput.addEventListener("keydown", (ev) => {
  #|       if (ev.key === "Enter") {
  #|         ev.preventDefault();
  #|         runRename();
  #|       }
  #|     });
  #|     nameRow.appendChild(renameBtn);
  #|     nameWrap.appendChild(nameRow);
  #|     if (title !== kind) {
  #|       const alias = document.createElement("div");
  #|       alias.textContent = `Label: ${title}`;
  #|       alias.style.fontFamily = "monospace";
  #|       alias.style.fontSize = "12px";
  #|       alias.style.color = "#9fb3c8";
  #|       nameWrap.appendChild(alias);
  #|     }
  #|     card.appendChild(nameWrap);
  #|
  #|     // Wave selector
  #|     const waveWrap = document.createElement("div");
  #|     waveWrap.style.display = "grid";
  #|     waveWrap.style.gap = "2px";
  #|     const waveLabel = document.createElement("div");
  #|     waveLabel.textContent = "Wave";
  #|     waveLabel.style.fontFamily = "monospace";
  #|     waveLabel.style.fontSize = "13px";
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
  #|     waveSelect.style.fontSize = "14px";
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
  #|       fieldLabel.style.fontSize = "13px";
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
  #|     testBtn.style.padding = "6px 12px";
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
  #|     delBtn.style.padding = "6px 10px";
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
  #|     dupBtn.style.padding = "6px 10px";
  #|     dupBtn.style.background = "#274060";
  #|     dupBtn.style.color = "#f6f7eb";
  #|     dupBtn.style.border = "1px solid #486581";
  #|     dupBtn.style.cursor = "pointer";
  #|     dupBtn.addEventListener("click", () => {
  #|       if (onDuplicate) onDuplicate(kind);
  #|     });
  #|     card.appendChild(dupBtn);
  #|
  #|     host.appendChild(card);
  #|   };
  #|
  #|   const BGM_PITCH_MIN = 48; // C3
  #|   const BGM_PITCH_MAX = 84; // C6
  #|   const BGM_ROLL_ROW = 16;
  #|   const BGM_ROLL_COL = 20;
  #|   const BGM_ROLL_MIN_STEPS = 16;
  #|
  #|   const renderBgmList = () => {
  #|     bgmList.innerHTML = "";
  #|     for (const bgm of audioState.bgms) {
  #|       const item = document.createElement("button");
  #|       item.type = "button";
  #|       item.textContent = bgm.name;
  #|       item.style.textAlign = "left";
  #|       item.style.padding = "8px 10px";
  #|       item.style.background = audioState.selectedBgmName === bgm.name ? "#2e8b57" : "#0f1720";
  #|       item.style.color = "#f6f7eb";
  #|       item.style.border = audioState.selectedBgmName === bgm.name ? "1px solid #6ee7b7" : "1px solid #334e68";
  #|       item.style.cursor = "pointer";
  #|       item.style.fontFamily = "monospace";
  #|       item.style.fontSize = "14px";
  #|       item.addEventListener("click", () => {
  #|         audioState.selectedBgmName = bgm.name;
  #|         syncPlaybackFromSelectedBgm();
  #|         syncBgmControlsFromState();
  #|       });
  #|       bgmList.appendChild(item);
  #|     }
  #|     if (audioState.bgms.length === 0) {
  #|       const note = document.createElement("div");
  #|       note.style.fontFamily = "monospace";
  #|       note.style.fontSize = "14px";
  #|       note.style.color = "#9fb3c8";
  #|       note.textContent = "No BGM defined.";
  #|       bgmList.appendChild(note);
  #|     }
  #|   };
  #|
  #|   const renderBgmPianoRoll = () => {
  #|     const bgm = getSelectedBgm();
  #|     const rows = BGM_PITCH_MAX - BGM_PITCH_MIN + 1;
  #|     const steps = Math.max(BGM_ROLL_MIN_STEPS, Array.isArray(bgm?.notes) ? bgm.notes.length : 0);
  #|     const rollW = steps * BGM_ROLL_COL;
  #|     const rollH = rows * BGM_ROLL_ROW;
  #|
  #|     bgmRoll.width = rollW;
  #|     bgmRoll.height = rollH;
  #|     bgmRollKeys.width = 52;
  #|     bgmRollKeys.height = rollH;
  #|     bgmRoll.style.width = `${rollW}px`;
  #|     bgmRoll.style.height = `${rollH}px`;
  #|     bgmRollKeys.style.width = "52px";
  #|     bgmRollKeys.style.height = `${rollH}px`;
  #|
  #|     const ctx = bgmRoll.getContext("2d");
  #|     const keyCtx = bgmRollKeys.getContext("2d");
  #|     if (!ctx || !keyCtx) return;
  #|
  #|     ctx.clearRect(0, 0, rollW, rollH);
  #|     for (let r = 0; r < rows; r += 1) {
  #|       const midi = BGM_PITCH_MAX - r;
  #|       const isBlack = [1, 3, 6, 8, 10].includes(midi % 12);
  #|       ctx.fillStyle = isBlack ? "#132033" : "#101820";
  #|       ctx.fillRect(0, r * BGM_ROLL_ROW, rollW, BGM_ROLL_ROW);
  #|     }
  #|     ctx.strokeStyle = "#1f2f46";
  #|     for (let x = 0; x <= steps; x += 1) {
  #|       ctx.beginPath();
  #|       ctx.moveTo(x * BGM_ROLL_COL + 0.5, 0);
  #|       ctx.lineTo(x * BGM_ROLL_COL + 0.5, rollH);
  #|       ctx.stroke();
  #|     }
  #|     for (let y = 0; y <= rows; y += 1) {
  #|       ctx.beginPath();
  #|       ctx.moveTo(0, y * BGM_ROLL_ROW + 0.5);
  #|       ctx.lineTo(rollW, y * BGM_ROLL_ROW + 0.5);
  #|       ctx.stroke();
  #|     }
  #|
  #|     if (bgm && Array.isArray(bgm.notes)) {
  #|       ctx.fillStyle = "#7f5af0";
  #|       for (let step = 0; step < bgm.notes.length; step += 1) {
  #|         const midi = Number(bgm.notes[step]);
  #|         if (!Number.isInteger(midi) || midi < BGM_PITCH_MIN || midi > BGM_PITCH_MAX) continue;
  #|         const row = BGM_PITCH_MAX - midi;
  #|         ctx.fillRect(
  #|           step * BGM_ROLL_COL + 1,
  #|           row * BGM_ROLL_ROW + 1,
  #|           BGM_ROLL_COL - 2,
  #|           BGM_ROLL_ROW - 2,
  #|         );
  #|       }
  #|     }
  #|
  #|     keyCtx.clearRect(0, 0, 52, rollH);
  #|     keyCtx.fillStyle = "#0f1720";
  #|     keyCtx.fillRect(0, 0, 52, rollH);
  #|     keyCtx.font = "11px ui-monospace, SFMono-Regular, Menlo, monospace";
  #|     keyCtx.textBaseline = "middle";
  #|     keyCtx.fillStyle = "#9fb3c8";
  #|     for (let r = 0; r < rows; r += 1) {
  #|       const midi = BGM_PITCH_MAX - r;
  #|       if (midi % 12 === 0) {
  #|         keyCtx.fillText(noteNameFromMidi(midi), 4, r * BGM_ROLL_ROW + BGM_ROLL_ROW / 2);
  #|       }
  #|     }
  #|   };
  #|
  #|   const writeRollCell = (evt, forceRest) => {
  #|     const bgm = getSelectedBgm();
  #|     if (!bgm) return;
  #|     const rect = bgmRoll.getBoundingClientRect();
  #|     const fx = (evt.clientX - rect.left) / Math.max(1, rect.width);
  #|     const fy = (evt.clientY - rect.top) / Math.max(1, rect.height);
  #|     const steps = Math.max(BGM_ROLL_MIN_STEPS, Array.isArray(bgm.notes) ? bgm.notes.length : 0);
  #|     const rows = BGM_PITCH_MAX - BGM_PITCH_MIN + 1;
  #|     const step = Math.max(0, Math.min(steps - 1, Math.floor(fx * steps)));
  #|     const row = Math.max(0, Math.min(rows - 1, Math.floor(fy * rows)));
  #|     const midi = BGM_PITCH_MAX - row;
  #|     const notes = Array.isArray(bgm.notes) ? bgm.notes.slice() : [];
  #|     while (notes.length <= step) notes.push(-1);
  #|     if (forceRest) {
  #|       notes[step] = -1;
  #|     } else {
  #|       notes[step] = notes[step] === midi ? -1 : midi;
  #|     }
  #|     bgm.notes = notes;
  #|     audioState.bgmNotes = notes.slice();
  #|     if (bgmNotesInput) {
  #|       bgmNotesInput.value = notes.map(noteNameFromMidi).join(" ");
  #|     }
  #|     markDirty();
  #|     renderBgmPianoRoll();
  #|   };
  #|   if (bgmRoll.dataset.bound !== "1") {
  #|     bgmRoll.dataset.bound = "1";
  #|     bgmRoll.addEventListener("pointerdown", (evt) => {
  #|       if (evt.button === 2) return;
  #|       writeRollCell(evt, false);
  #|     });
  #|     bgmRoll.addEventListener("contextmenu", (evt) => {
  #|       evt.preventDefault();
  #|       writeRollCell(evt, true);
  #|     });
  #|   }
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
  #|     if (bgmNameInput) {
  #|       bgmNameInput.value = bgm ? String(bgm.name) : "";
  #|       bgmNameInput.disabled = !defined;
  #|     }
  #|     if (bgmRenameBtn) {
  #|       bgmRenameBtn.disabled = !defined;
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
  #|     if (delBgmBtn) delBgmBtn.disabled = !defined;
  #|     if (bgmEditorTitle) {
  #|       bgmEditorTitle.textContent = bgm ? `Selected BGM: ${bgm.name}` : "Selected BGM";
  #|     }
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
  #|     renderBgmList();
  #|     renderBgmPianoRoll();
  #|   };
  #|
  #|   const refreshSoundEditorFromDsl = () => {
  #|     const events = parseSoundEventsFromDsl(textarea ? textarea.value : "");
  #|     syncBgmControlsFromState();
  #|     sfxList.innerHTML = "";
  #|     sfxEditorHost.innerHTML = "";
  #|     globalThis.__moon8bit_sound_events = events;
  #|
  #|     const eventLabelMap = new Map(events.map((e) => [e.key, e.label]));
  #|     const orderedKeys = [];
  #|     const seen = new Set();
  #|     for (const e of events) {
  #|       if (!seen.has(e.key) && getSfxProfile(e.key)) {
  #|         seen.add(e.key);
  #|         orderedKeys.push(e.key);
  #|       }
  #|     }
  #|     for (const key of Object.keys(audioState.sfx || {})) {
  #|       if (!seen.has(key)) {
  #|         seen.add(key);
  #|         orderedKeys.push(key);
  #|       }
  #|     }
  #|
  #|     if (!audioState.selectedSfxName || !getSfxProfile(audioState.selectedSfxName)) {
  #|       audioState.selectedSfxName = orderedKeys[0] || null;
  #|     }
  #|
  #|     const deleteSfx = (kind) => {
  #|       if (!confirm(`Delete SFX "${kind}"?`)) return;
  #|       delete audioState.sfx[kind];
  #|       if (audioState.selectedSfxName === kind) audioState.selectedSfxName = null;
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
  #|       audioState.selectedSfxName = name;
  #|       if (writeSoundToDsl(false)) {
  #|         markSaved();
  #|         refreshSoundEditorFromDsl();
  #|       }
  #|     };
  #|
  #|     const renameSfx = (from, toRaw) => {
  #|       const to = String(toRaw || "").trim().replace(/[^A-Za-z0-9_-]/g, "_");
  #|       if (!to) {
  #|         alert("Invalid name.");
  #|         return false;
  #|       }
  #|       if (to === from) {
  #|         return true;
  #|       }
  #|       if (audioState.sfx && audioState.sfx[to]) {
  #|         alert("Name already in use.");
  #|         return false;
  #|       }
  #|       const src = audioState.sfx && audioState.sfx[from] ? audioState.sfx[from] : null;
  #|       if (!src) return false;
  #|       audioState.sfx[to] = src;
  #|       delete audioState.sfx[from];
  #|       if (audioState.selectedSfxName === from) audioState.selectedSfxName = to;
  #|       clearTransientErrorsByPrefix(`sfx:${from}:`);
  #|       if (writeSoundToDsl(false)) {
  #|         markSaved();
  #|         refreshSoundEditorFromDsl();
  #|         return true;
  #|       }
  #|       return false;
  #|     };
  #|
  #|     orderedKeys.forEach((key) => {
  #|       const label = eventLabelMap.get(key) || key;
  #|       const item = document.createElement("button");
  #|       item.type = "button";
  #|       item.textContent = label;
  #|       item.style.textAlign = "left";
  #|       item.style.padding = "8px 10px";
  #|       item.style.background = audioState.selectedSfxName === key ? "#2e8b57" : "#0f1720";
  #|       item.style.color = "#f6f7eb";
  #|       item.style.border = audioState.selectedSfxName === key ? "1px solid #6ee7b7" : "1px solid #334e68";
  #|       item.style.cursor = "pointer";
  #|       item.style.fontFamily = "monospace";
  #|       item.style.fontSize = "14px";
  #|       item.addEventListener("click", () => {
  #|         audioState.selectedSfxName = key;
  #|         refreshSoundEditorFromDsl();
  #|       });
  #|       sfxList.appendChild(item);
  #|     });
  #|
  #|     if (audioState.selectedSfxName && getSfxProfile(audioState.selectedSfxName)) {
  #|       const key = audioState.selectedSfxName;
  #|       const label = eventLabelMap.get(key) || key;
  #|       renderSfxCard(key, label, deleteSfx, duplicateSfx, renameSfx, sfxEditorHost);
  #|     }
  #|
  #|     if (orderedKeys.length === 0) {
  #|       const note = document.createElement("div");
  #|       note.style.fontFamily = "monospace";
  #|       note.style.fontSize = "15px";
  #|       note.style.color = "#9fb3c8";
  #|       note.textContent = "No SFX defined. Click + SFX to add one.";
  #|       sfxEditorHost.appendChild(note);
  #|     }
  #|
  #|     updateSoundDirtyIndicator();
  #|     renderSoundValidation();
  #|   };
  #|
  #|   if (addSfxBtn.dataset.bound !== "1") {
  #|     addSfxBtn.dataset.bound = "1";
  #|     addSfxBtn.addEventListener("click", () => {
  #|       let name = prompt("New SFX name:", "sfx" + (Object.keys(audioState.sfx || {}).length + 1));
  #|       if (!name) return;
  #|       name = name.trim().replace(/[^A-Za-z0-9_-]/g, "_");
  #|       if (!name) { alert("Invalid name."); return; }
  #|       if (audioState.sfx && audioState.sfx[name]) { alert("Name already in use."); return; }
  #|       if (!audioState.sfx) audioState.sfx = {};
  #|       audioState.sfx[name] = { type: "square", attack: 0.003, decay: 0.10, volume: 0.07, f0: 520, f1: 360 };
  #|       audioState.selectedSfxName = name;
  #|       if (writeSoundToDsl(false)) {
  #|         markSaved();
  #|         refreshSoundEditorFromDsl();
  #|       }
  #|     });
  #|   }
  #|
  #|   if (textarea && !globalThis.__moon8bit_sound_bound) {
  #|     textarea.addEventListener("input", refreshSoundEditorFromDsl);
  #|     globalThis.__moon8bit_sound_bound = true;
  #|   }
  #|   globalThis.__moon8bit_sound_refresh = refreshSoundEditorFromDsl;
  #|   refreshSoundEditorFromDsl();
  #| }

///|
