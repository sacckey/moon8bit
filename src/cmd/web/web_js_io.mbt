///|
extern "js" fn web_set_status(text : String) -> Unit =
  #| (text) => {
  #|   const id = "moon8bit-status";
  #|   let el = document.getElementById(id);
  #|   if (!el) {
  #|     el = document.createElement("div");
  #|     el.id = id;
  #|     el.style.fontFamily = "monospace";
  #|     el.style.color = "#d9e2ec";
  #|   }
  #|   const gamePanel = document.getElementById("moon8bit-tab-panel-game");
  #|   if (gamePanel) {
  #|     if (el.parentElement !== gamePanel) {
  #|       gamePanel.appendChild(el);
  #|     }
  #|   } else {
  #|     const root = document.getElementById("moon8bit-root");
  #|     if (root && el.parentElement !== root) {
  #|       root.appendChild(el);
  #|     } else if (!root && !el.parentElement) {
  #|       document.body.appendChild(el);
  #|     }
  #|   }
  #|   el.textContent = text;
  #| }

///|
extern "js" fn web_renderer_kind() -> String =
  #| () => String(globalThis.__moon8bit_renderer_kind || "pending")

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
  #|   if (globalThis.__moon8bit_sound_refresh) {
  #|     globalThis.__moon8bit_sound_refresh();
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
extern "js" fn web_apply_sound_bundle(
  sounds : Array[@lib.SoundDef],
  bgms : Array[@lib.BgmDef],
) -> Unit =
  #| (sounds, bgms) => {
  #|   const state = globalThis.__moon8bit_audio_state;
  #|   if (!state) return;
  #|
  #|   // Apply SFX profiles from sound blocks
  #|   state.sfx = {};
  #|   for (let i = 0; i < sounds.length; i++) {
  #|     const s = sounds[i];
  #|     state.sfx[s.name] = {
  #|       type: s.wave,
  #|       attack: s.attack,
  #|       decay: s.decay,
  #|       peak: s.peak,
  #|       f0: s.f0,
  #|       f1: s.f1,
  #|     };
  #|   }
  #|
  #|   // Apply BGM parameters from bgm block named "main", otherwise first.
  #|   let selectedBgm = null;
  #|   for (let i = 0; i < bgms.length; i++) {
  #|     if (bgms[i].name === "main") {
  #|       selectedBgm = bgms[i];
  #|       break;
  #|     }
  #|   }
  #|   if (!selectedBgm && bgms.length > 0) {
  #|     selectedBgm = bgms[0];
  #|   }
  #|   if (selectedBgm) {
  #|     const b = selectedBgm;
  #|     state.bgmWave = b.wave;
  #|     state.bgmVolume = b.volume;
  #|     state.bgmStepSec = b.step_sec;
  #|     state.bgmLoop = b.loop_;
  #|     state.bgmNotes = b.notes; // Array of MIDI numbers (-1 = rest)
  #|   }
  #|
  #|   // Refresh sound editor UI if available
  #|   if (globalThis.__moon8bit_sound_refresh_from_bundle) {
  #|     globalThis.__moon8bit_sound_refresh_from_bundle(sounds, bgms);
  #|   }
  #| }

///|
