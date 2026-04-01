class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
function $bound_check(arr, index) {
  if (index < 0 || index >= arr.length) throw new Error("Index out of bounds");
}
function $compare_int(a, b) {
  return (a >= b) - (a <= b);
}
function Result$Err$0$(param0) {
  this._0 = param0;
}
Result$Err$0$.prototype.$tag = 0;
Result$Err$0$.prototype.$name = "Err";
function Result$Ok$0$(param0) {
  this._0 = param0;
}
Result$Ok$0$.prototype.$tag = 1;
Result$Ok$0$.prototype.$name = "Ok";
function Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(param0) {
  this._0 = param0;
}
Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError.prototype.$tag = 2;
Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError.prototype.$name = "moonbitlang/core/strconv.StrConvError.StrConvError";
const Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$IndexOutOfBounds = { $tag: 1, $name: "moonbitlang/core/builtin.CreatingViewError.IndexOutOfBounds" };
const Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex = { $tag: 0, $name: "moonbitlang/core/builtin.CreatingViewError.InvalidIndex" };
const _M0FP311moonbitlang4core7builtin19int__to__string__js = (x, radix) => {
  return x.toString(radix);
};
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
const _M0MP311moonbitlang4core7builtin7JSArray4push = (arr, val) => { arr.push(val); };
const _M0FP311moonbitlang4core7builtin23try__init__wasm__helper = function() {
  try {
    return new WebAssembly.Instance(new WebAssembly.Module(new Uint8Array([0, 97, 115, 109, 1, 0, 0, 0, 1, 13, 2, 96, 0, 1, 127, 96, 4, 127, 127, 127, 127, 1, 127, 3, 7, 6, 0, 1, 1, 1, 1, 1, 6, 6, 1, 127, 1, 65, 0, 11, 7, 50, 6, 3, 109, 117, 108, 0, 1, 5, 100, 105, 118, 95, 115, 0, 2, 5, 100, 105, 118, 95, 117, 0, 3, 5, 114, 101, 109, 95, 115, 0, 4, 5, 114, 101, 109, 95, 117, 0, 5, 8, 103, 101, 116, 95, 104, 105, 103, 104, 0, 0, 10, 191, 1, 6, 4, 0, 35, 0, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 126, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 127, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 128, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 129, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11, 36, 1, 1, 126, 32, 0, 173, 32, 1, 173, 66, 32, 134, 132, 32, 2, 173, 32, 3, 173, 66, 32, 134, 132, 130, 34, 4, 66, 32, 135, 167, 36, 0, 32, 4, 167, 11])), {}).exports;
  } catch (e) {
    return undefined;
  }
};
const _M0MP311moonbitlang4core7builtin7MyInt6411div__bigint = (a, b) => {
  const aVal = (BigInt(a.hi) << 32n) | BigInt(a.lo >>> 0);
  const bVal = (BigInt(b.hi) << 32n) | BigInt(b.lo >>> 0);
  const result = aVal / bVal;
  const lo = Number(result & 0xFFFFFFFFn);
  const hi = Number((result >> 32n) & 0xFFFFFFFFn);
  return { hi: hi | 0, lo: lo | 0 };
};
const _M0MP311moonbitlang4core7builtin7MyInt647compare = (a, b) => {
  const ahi = a.hi;
  const bhi = b.hi;
  if (ahi < bhi) {
    return -1;
  }
  if (ahi > bhi) {
    return 1;
  }
  const alo = a.lo >>> 0;
  const blo = b.lo >>> 0;
  if (alo < blo) {
    return -1;
  }
  if (alo > blo) {
    return 1;
  }
  return 0;
};
function Result$Err$1$(param0) {
  this._0 = param0;
}
Result$Err$1$.prototype.$tag = 0;
Result$Err$1$.prototype.$name = "Err";
function Result$Ok$1$(param0) {
  this._0 = param0;
}
Result$Ok$1$.prototype.$tag = 1;
Result$Ok$1$.prototype.$name = "Ok";
function Result$Err$2$(param0) {
  this._0 = param0;
}
Result$Err$2$.prototype.$tag = 0;
Result$Err$2$.prototype.$name = "Err";
function Result$Ok$2$(param0) {
  this._0 = param0;
}
Result$Ok$2$.prototype.$tag = 1;
Result$Ok$2$.prototype.$name = "Ok";
function Result$Err$3$(param0) {
  this._0 = param0;
}
Result$Err$3$.prototype.$tag = 0;
Result$Err$3$.prototype.$name = "Err";
function Result$Ok$3$(param0) {
  this._0 = param0;
}
Result$Ok$3$.prototype.$tag = 1;
Result$Ok$3$.prototype.$name = "Ok";
function Result$Err$4$(param0) {
  this._0 = param0;
}
Result$Err$4$.prototype.$tag = 0;
Result$Err$4$.prototype.$name = "Err";
function Result$Ok$4$(param0) {
  this._0 = param0;
}
Result$Ok$4$.prototype.$tag = 1;
Result$Ok$4$.prototype.$name = "Ok";
const $9223372036854775807L = { hi: 2147483647, lo: -1 };
const $10L = { hi: 0, lo: 10 };
const $1L = { hi: 0, lo: 1 };
const $16L = { hi: 0, lo: 16 };
const $_9223372036854775808L = { hi: -2147483648, lo: 0 };
const $0L = { hi: 0, lo: 0 };
function Result$Err$5$(param0) {
  this._0 = param0;
}
Result$Err$5$.prototype.$tag = 0;
Result$Err$5$.prototype.$name = "Err";
function Result$Ok$5$(param0) {
  this._0 = param0;
}
Result$Ok$5$.prototype.$tag = 1;
Result$Ok$5$.prototype.$name = "Ok";
function Result$Err$6$(param0) {
  this._0 = param0;
}
Result$Err$6$.prototype.$tag = 0;
Result$Err$6$.prototype.$name = "Err";
function Result$Ok$6$(param0) {
  this._0 = param0;
}
Result$Ok$6$.prototype.$tag = 1;
Result$Ok$6$.prototype.$name = "Ok";
function Result$Err$7$(param0) {
  this._0 = param0;
}
Result$Err$7$.prototype.$tag = 0;
Result$Err$7$.prototype.$name = "Err";
function Result$Ok$7$(param0) {
  this._0 = param0;
}
Result$Ok$7$.prototype.$tag = 1;
Result$Ok$7$.prototype.$name = "Ok";
function Result$Err$8$(param0) {
  this._0 = param0;
}
Result$Err$8$.prototype.$tag = 0;
Result$Err$8$.prototype.$name = "Err";
function Result$Ok$8$(param0) {
  this._0 = param0;
}
Result$Ok$8$.prototype.$tag = 1;
Result$Ok$8$.prototype.$name = "Ok";
function Result$Err$9$(param0) {
  this._0 = param0;
}
Result$Err$9$.prototype.$tag = 0;
Result$Err$9$.prototype.$name = "Err";
function Result$Ok$9$(param0) {
  this._0 = param0;
}
Result$Ok$9$.prototype.$tag = 1;
Result$Ok$9$.prototype.$name = "Ok";
const _M0FP47sacckey8moon8bit3cmd3web17web__init__canvas = (width, height, scale) => {
   let root = document.getElementById("moon8bit-root");
   if (!root) {
     root = document.createElement("div");
     root.id = "moon8bit-root";
     root.style.display = "grid";
     root.style.gap = "8px";
     root.style.justifyItems = "center";
     document.body.appendChild(root);
   }

   const id = "moon8bit-canvas";
   let canvas = document.getElementById(id);
   if (!canvas) {
     canvas = document.createElement("canvas");
     canvas.id = id;
     root.appendChild(canvas);
   }
   canvas.width = width;
   canvas.height = height;
   canvas.style.width = `${width * scale}px`;
   canvas.style.height = `${height * scale}px`;
   canvas.style.imageRendering = "pixelated";
   canvas.style.border = "2px solid #333";
   const ctx = canvas.getContext("2d", { alpha: false });
   if (!ctx) {
     throw new Error("2d context is unavailable");
   }
   ctx.imageSmoothingEnabled = false;
   globalThis.__moon8bit_ctx = ctx;
   globalThis.__moon8bit_keys = new Set();
   globalThis.addEventListener("keydown", (e) => {
     globalThis.__moon8bit_keys.add(e.code);
   });
   globalThis.addEventListener("keyup", (e) => {
     globalThis.__moon8bit_keys.delete(e.code);
   });

   let editor = document.getElementById("moon8bit-editor");
   if (!editor) {
     editor = document.createElement("div");
     editor.id = "moon8bit-editor";
     editor.style.display = "grid";
     editor.style.gap = "6px";
     editor.style.width = `${width * scale}px`;
     root.appendChild(editor);
   }

   let textarea = document.getElementById("moon8bit-dsl-input");
   if (!textarea) {
     textarea = document.createElement("textarea");
     textarea.id = "moon8bit-dsl-input";
     textarea.style.width = "100%";
     textarea.style.height = "160px";
     textarea.style.background = "#0f1720";
     textarea.style.color = "#d9e2ec";
     textarea.style.border = "1px solid #334e68";
     textarea.style.padding = "8px";
     textarea.style.fontFamily = "ui-monospace, SFMono-Regular, Menlo, monospace";
     textarea.style.fontSize = "12px";
     textarea.spellcheck = false;
     editor.appendChild(textarea);
   }

   let controls = document.getElementById("moon8bit-editor-controls");
   if (!controls) {
     controls = document.createElement("div");
     controls.id = "moon8bit-editor-controls";
     controls.style.display = "flex";
     controls.style.flexWrap = "wrap";
     controls.style.gap = "8px";
     controls.style.alignItems = "center";
     editor.appendChild(controls);
   }

   let button = document.getElementById("moon8bit-apply-btn");
   if (!button) {
     button = document.createElement("button");
     button.id = "moon8bit-apply-btn";
     button.textContent = "Apply DSL";
     button.style.padding = "6px 10px";
     button.style.background = "#274060";
     button.style.color = "#f6f7eb";
     button.style.border = "1px solid #486581";
     button.style.cursor = "pointer";
     controls.appendChild(button);
   }

   let exportButton = document.getElementById("moon8bit-export-btn");
   if (!exportButton) {
     exportButton = document.createElement("button");
     exportButton.id = "moon8bit-export-btn";
     exportButton.textContent = "Export DSL";
     exportButton.style.padding = "6px 10px";
     exportButton.style.background = "#486581";
     exportButton.style.color = "#f6f7eb";
     exportButton.style.border = "1px solid #627d98";
     exportButton.style.cursor = "pointer";
     controls.appendChild(exportButton);
   }

   let importButton = document.getElementById("moon8bit-import-btn");
   if (!importButton) {
     importButton = document.createElement("button");
     importButton.id = "moon8bit-import-btn";
     importButton.textContent = "Import DSL";
     importButton.style.padding = "6px 10px";
     importButton.style.background = "#486581";
     importButton.style.color = "#f6f7eb";
     importButton.style.border = "1px solid #627d98";
     importButton.style.cursor = "pointer";
     controls.appendChild(importButton);
   }

   let importInput = document.getElementById("moon8bit-import-input");
   if (!importInput) {
     importInput = document.createElement("input");
     importInput.id = "moon8bit-import-input";
     importInput.type = "file";
     importInput.accept = ".dsl,.txt,text/plain";
     importInput.style.display = "none";
     controls.appendChild(importInput);
   }

   let hint = document.getElementById("moon8bit-editor-hint");
   if (!hint) {
     hint = document.createElement("span");
     hint.id = "moon8bit-editor-hint";
     hint.textContent = "Ctrl/Cmd+Enter applies current DSL";
     hint.style.fontFamily = "monospace";
     hint.style.fontSize = "12px";
     hint.style.opacity = "0.8";
     controls.appendChild(hint);
   }

   let feedback = document.getElementById("moon8bit-editor-feedback");
   if (!feedback) {
     feedback = document.createElement("div");
     feedback.id = "moon8bit-editor-feedback";
     feedback.style.fontFamily = "monospace";
     feedback.style.fontSize = "12px";
     feedback.style.color = "#9fb3c8";
     editor.appendChild(feedback);
   }
 };
const _M0FP47sacckey8moon8bit3cmd3web14web__key__down = (code) => !!(globalThis.__moon8bit_keys && globalThis.__moon8bit_keys.has(code));
const _M0FP47sacckey8moon8bit3cmd3web10web__clear = (color) => {
   const ctx = globalThis.__moon8bit_ctx;
   if (!ctx) return;
   ctx.fillStyle = color;
   ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);
 };
const _M0FP47sacckey8moon8bit3cmd3web15web__fill__rect = (x, y, w, h, color) => {
   const ctx = globalThis.__moon8bit_ctx;
   if (!ctx) return;
   ctx.fillStyle = color;
   ctx.fillRect(x, y, w, h);
 };
const _M0FP47sacckey8moon8bit3cmd3web16web__set__status = (text) => {
   const id = "moon8bit-status";
   let el = document.getElementById(id);
   if (!el) {
     el = document.createElement("div");
     el.id = id;
     el.style.marginTop = "8px";
     el.style.fontFamily = "monospace";
     el.style.color = "#d9e2ec";
     const root = document.getElementById("moon8bit-root");
     if (root) {
       root.appendChild(el);
     } else {
       document.body.appendChild(el);
     }
   }
   el.textContent = text;
 };
const _M0FP47sacckey8moon8bit3cmd3web22web__get__editor__text = () => {
   const input = document.getElementById("moon8bit-dsl-input");
   return input ? input.value : "";
 };
const _M0FP47sacckey8moon8bit3cmd3web22web__set__editor__text = (text) => {
   const input = document.getElementById("moon8bit-dsl-input");
   if (input) {
     input.value = text;
   }
 };
const _M0FP47sacckey8moon8bit3cmd3web26web__set__editor__feedback = (text, is_error) => {
   const el = document.getElementById("moon8bit-editor-feedback");
   if (!el) return;
   el.textContent = text;
   el.style.color = is_error ? "#ef6f6c" : "#7bd389";
 };
const _M0FP47sacckey8moon8bit3cmd3web16web__bind__apply = (cb) => {
   globalThis.__moon8bit_apply_cb = cb;
   if (globalThis.__moon8bit_apply_bound) {
     return;
   }
   const button = document.getElementById("moon8bit-apply-btn");
   const input = document.getElementById("moon8bit-dsl-input");
   if (!button || !input) return;
   const run = () => {
     if (globalThis.__moon8bit_apply_cb) {
       globalThis.__moon8bit_apply_cb();
     }
   };
   button.addEventListener("click", run);
   input.addEventListener("keydown", (e) => {
     if ((e.ctrlKey || e.metaKey) && e.key === "Enter") {
       e.preventDefault();
       run();
     }
   });
   globalThis.__moon8bit_apply_bound = true;
 };
const _M0FP47sacckey8moon8bit3cmd3web17web__bind__export = (cb) => {
   globalThis.__moon8bit_export_cb = cb;
   if (globalThis.__moon8bit_export_bound) {
     return;
   }
   const button = document.getElementById("moon8bit-export-btn");
   if (!button) return;
   button.addEventListener("click", () => {
     if (globalThis.__moon8bit_export_cb) {
       globalThis.__moon8bit_export_cb();
     }
   });
   globalThis.__moon8bit_export_bound = true;
 };
const _M0FP47sacckey8moon8bit3cmd3web17web__bind__import = (cb) => {
   globalThis.__moon8bit_import_cb = cb;
   if (globalThis.__moon8bit_import_bound) {
     return;
   }
   const button = document.getElementById("moon8bit-import-btn");
   const input = document.getElementById("moon8bit-import-input");
   if (!button || !input) return;

   button.addEventListener("click", () => input.click());
   input.addEventListener("change", async () => {
     const file = input.files && input.files[0];
     if (!file) return;
     try {
       const text = await file.text();
       if (globalThis.__moon8bit_import_cb) {
         globalThis.__moon8bit_import_cb(text);
       }
     } catch (error) {
       console.error("moon8bit import failed", error);
     } finally {
       input.value = "";
     }
   });
   globalThis.__moon8bit_import_bound = true;
 };
const _M0FP47sacckey8moon8bit3cmd3web19web__download__text = (filename, text) => {
   const blob = new Blob([text], { type: "text/plain;charset=utf-8" });
   const url = URL.createObjectURL(blob);
   const link = document.createElement("a");
   link.href = url;
   link.download = filename;
   link.style.display = "none";
   document.body.appendChild(link);
   link.click();
   document.body.removeChild(link);
   URL.revokeObjectURL(url);
 };
const _M0FP47sacckey8moon8bit3cmd3web16web__start__loop = (cb, fps) => {
   const interval = Math.max(1, Math.floor(1000 / Math.max(1, fps)));
   setInterval(() => cb(), interval);
 };
const _M0FP095_40moonbitlang_2fcore_2fbuiltin_2eStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger = { method_0: _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger13write__string, method_1: _M0IP016_24default__implP311moonbitlang4core7builtin6Logger16write__substringGRP311moonbitlang4core7builtin13StringBuilderE, method_2: _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view, method_3: _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__char };
const _M0FP311moonbitlang4core7builtin21trim_2e_2abind_7c6206 = "\t\n\r ";
const _M0FP311moonbitlang4core7builtin19wasm__helper__cache = { tried: false, exports: undefined };
const _M0FP311moonbitlang4core7strconv14base__err__str = "invalid base";
const _M0FP311moonbitlang4core7strconv15range__err__str = "value out of range";
const _M0FP311moonbitlang4core7strconv16syntax__err__str = "invalid syntax";
const _M0FP311moonbitlang4core7strconv36parse__int64_2einner_2e_2abind_7c603 = "";
const _M0FP27sacckey8moon8bit11input__none = { flap: false, reset: false };
const _M0FP47sacckey8moon8bit3cmd3web6config = _M0FP27sacckey8moon8bit23default__engine__config();
const _M0FP311moonbitlang4core7builtin33brute__force__find_2econstr_2f279 = 0;
const _M0FP311moonbitlang4core7builtin43boyer__moore__horspool__find_2econstr_2f265 = 0;
const _M0FP47sacckey8moon8bit3cmd3web15initial__bundle = _M0FP27sacckey8moon8bit20load__sample__assets();
const _M0FP47sacckey8moon8bit3cmd3web12palette__ref = _M0FP311moonbitlang4core3ref3newGRP27sacckey8moon8bit7PaletteE(_M0FP47sacckey8moon8bit3cmd3web15initial__bundle.palette);
const _M0FP47sacckey8moon8bit3cmd3web10frame__ref = _M0FP311moonbitlang4core3ref3newGiE(0);
const _M0FP47sacckey8moon8bit3cmd3web16reset__prev__ref = _M0FP311moonbitlang4core3ref3newGbE(false);
const _M0FP47sacckey8moon8bit3cmd3web15flap__prev__ref = _M0FP311moonbitlang4core3ref3newGbE(false);
const _M0FP47sacckey8moon8bit3cmd3web13initial__game = _M0FP27sacckey8moon8bit12engine__initGRP27sacckey8moon8bit13DriftbirdGameE(_M0FP27sacckey8moon8bit20new__driftbird__game(_M0FP47sacckey8moon8bit3cmd3web15initial__bundle), _M0FP47sacckey8moon8bit3cmd3web6config);
const _M0FP47sacckey8moon8bit3cmd3web10state__ref = _M0FP311moonbitlang4core3ref3newGRP27sacckey8moon8bit13DriftbirdGameE(_M0FP47sacckey8moon8bit3cmd3web13initial__game);
const _M0FP47sacckey8moon8bit3cmd3web14display__scale = Math.imul(_M0FP47sacckey8moon8bit3cmd3web6config.scale, 2) | 0;
function _M0FP311moonbitlang4core5abort5abortGuE(msg) {
  $panic();
}
function _M0FP311moonbitlang4core5abort5abortGRP311moonbitlang4core6string10StringViewE(msg) {
  return $panic();
}
function _M0FP311moonbitlang4core5abort5abortGOiE(msg) {
  return $panic();
}
function _M0FP311moonbitlang4core7builtin5abortGuE(string, loc) {
  _M0FP311moonbitlang4core5abort5abortGuE(`${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(string)}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core6string10StringViewE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGRP311moonbitlang4core6string10StringViewE(`${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(string)}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0FP311moonbitlang4core7builtin5abortGOiE(string, loc) {
  return _M0FP311moonbitlang4core5abort5abortGOiE(`${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(string)}\n  at ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(loc)}\n`);
}
function _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(size_hint) {
  return { val: "" };
}
function _M0MP311moonbitlang4core7builtin13StringBuilder10to__string(self) {
  return self.val;
}
function _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__char(self, ch) {
  const _bind = self;
  _bind.val = `${_bind.val}${String.fromCodePoint(ch)}`;
}
function _M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(self) {
  return _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGkE(self, 55296) && _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGkE(self, 56319);
}
function _M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(self) {
  return _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGkE(self, 56320) && _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGkE(self, 57343);
}
function _M0FP311moonbitlang4core7builtin32code__point__of__surrogate__pair(leading, trailing) {
  return (((Math.imul(leading - 55296 | 0, 1024) | 0) + trailing | 0) - 56320 | 0) + 65536 | 0;
}
function _M0MP311moonbitlang4core6uint166UInt1616unsafe__to__char(self) {
  return self;
}
function _M0MP311moonbitlang4core6string6String16unsafe__char__at(self, index) {
  const c1 = self.charCodeAt(index);
  if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c1)) {
    const c2 = self.charCodeAt(index + 1 | 0);
    return _M0FP311moonbitlang4core7builtin32code__point__of__surrogate__pair(c1, c2);
  } else {
    return _M0MP311moonbitlang4core6uint166UInt1616unsafe__to__char(c1);
  }
}
function _M0MP311moonbitlang4core5array5Array2atGiE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core5array5Array2atGsE(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function _M0MP311moonbitlang4core7builtin13SourceLocRepr5parse(repr) {
  const _bind = { str: repr, start: 0, end: repr.length };
  const _data = _M0MP311moonbitlang4core6string10StringView4data(_bind);
  const _start = _M0MP311moonbitlang4core6string10StringView13start__offset(_bind);
  const _end = _start + _M0MP311moonbitlang4core6string10StringView6length(_bind) | 0;
  let _cursor = _start;
  let accept_state = -1;
  let match_end = -1;
  let match_tag_saver_0 = -1;
  let match_tag_saver_1 = -1;
  let match_tag_saver_2 = -1;
  let match_tag_saver_3 = -1;
  let match_tag_saver_4 = -1;
  let tag_0 = -1;
  let tag_1 = -1;
  let tag_1_1 = -1;
  let tag_1_2 = -1;
  let tag_3 = -1;
  let tag_2 = -1;
  let tag_2_1 = -1;
  let tag_4 = -1;
  _L: {
    if (_cursor < _end) {
      const next_char = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
      _cursor = _cursor + 1 | 0;
      if (next_char === 64) {
        _L$2: while (true) {
          tag_0 = _cursor;
          if (_cursor < _end) {
            const next_char$2 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
            _cursor = _cursor + 1 | 0;
            if (next_char$2 === 58) {
              if (_cursor < _end) {
                _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                _cursor = _cursor + 1 | 0;
                let _tmp = 0;
                _L$3: while (true) {
                  const dispatch_15 = _tmp;
                  _L$4: {
                    _L$5: {
                      switch (dispatch_15) {
                        case 3: {
                          tag_1_2 = tag_1_1;
                          tag_1_1 = tag_1;
                          tag_1 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const next_char$3 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 58) {
                                if (next_char$3 < 48) {
                                  break _L$6;
                                } else {
                                  tag_1 = _cursor;
                                  tag_2_1 = tag_2;
                                  tag_2 = _cursor;
                                  tag_3 = _cursor;
                                  if (_cursor < _end) {
                                    _L$7: {
                                      const next_char$4 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                                      _cursor = _cursor + 1 | 0;
                                      if (next_char$4 < 48) {
                                        if (next_char$4 === 45) {
                                          break _L$4;
                                        } else {
                                          break _L$7;
                                        }
                                      } else {
                                        if (next_char$4 > 57) {
                                          if (next_char$4 < 59) {
                                            _tmp = 3;
                                            continue _L$3;
                                          } else {
                                            break _L$7;
                                          }
                                        } else {
                                          _tmp = 6;
                                          continue _L$3;
                                        }
                                      }
                                    }
                                    _tmp = 0;
                                    continue _L$3;
                                  } else {
                                    break _L;
                                  }
                                }
                              } else {
                                if (next_char$3 > 58) {
                                  break _L$6;
                                } else {
                                  _tmp = 1;
                                  continue _L$3;
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L;
                          }
                        }
                        case 2: {
                          tag_1 = _cursor;
                          tag_2 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const next_char$3 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 58) {
                                if (next_char$3 < 48) {
                                  break _L$6;
                                } else {
                                  _tmp = 2;
                                  continue _L$3;
                                }
                              } else {
                                if (next_char$3 > 58) {
                                  break _L$6;
                                } else {
                                  _tmp = 3;
                                  continue _L$3;
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L;
                          }
                        }
                        case 0: {
                          tag_1 = _cursor;
                          if (_cursor < _end) {
                            const next_char$3 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                            _cursor = _cursor + 1 | 0;
                            if (next_char$3 === 58) {
                              _tmp = 1;
                              continue _L$3;
                            } else {
                              _tmp = 0;
                              continue _L$3;
                            }
                          } else {
                            break _L;
                          }
                        }
                        case 4: {
                          tag_1 = _cursor;
                          tag_4 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const next_char$3 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 58) {
                                if (next_char$3 < 48) {
                                  break _L$6;
                                } else {
                                  _tmp = 4;
                                  continue _L$3;
                                }
                              } else {
                                if (next_char$3 > 58) {
                                  break _L$6;
                                } else {
                                  tag_1_2 = tag_1_1;
                                  tag_1_1 = tag_1;
                                  tag_1 = _cursor;
                                  if (_cursor < _end) {
                                    _L$7: {
                                      const next_char$4 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                                      _cursor = _cursor + 1 | 0;
                                      if (next_char$4 < 58) {
                                        if (next_char$4 < 48) {
                                          break _L$7;
                                        } else {
                                          tag_1 = _cursor;
                                          tag_2_1 = tag_2;
                                          tag_2 = _cursor;
                                          if (_cursor < _end) {
                                            _L$8: {
                                              const next_char$5 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                                              _cursor = _cursor + 1 | 0;
                                              if (next_char$5 < 58) {
                                                if (next_char$5 < 48) {
                                                  break _L$8;
                                                } else {
                                                  _tmp = 5;
                                                  continue _L$3;
                                                }
                                              } else {
                                                if (next_char$5 > 58) {
                                                  break _L$8;
                                                } else {
                                                  _tmp = 3;
                                                  continue _L$3;
                                                }
                                              }
                                            }
                                            _tmp = 0;
                                            continue _L$3;
                                          } else {
                                            break _L$5;
                                          }
                                        }
                                      } else {
                                        if (next_char$4 > 58) {
                                          break _L$7;
                                        } else {
                                          _tmp = 1;
                                          continue _L$3;
                                        }
                                      }
                                    }
                                    _tmp = 0;
                                    continue _L$3;
                                  } else {
                                    break _L;
                                  }
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L;
                          }
                        }
                        case 5: {
                          tag_1 = _cursor;
                          tag_2 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const next_char$3 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 58) {
                                if (next_char$3 < 48) {
                                  break _L$6;
                                } else {
                                  _tmp = 5;
                                  continue _L$3;
                                }
                              } else {
                                if (next_char$3 > 58) {
                                  break _L$6;
                                } else {
                                  _tmp = 3;
                                  continue _L$3;
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L$5;
                          }
                        }
                        case 6: {
                          tag_1 = _cursor;
                          tag_2 = _cursor;
                          tag_3 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const next_char$3 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 48) {
                                if (next_char$3 === 45) {
                                  break _L$4;
                                } else {
                                  break _L$6;
                                }
                              } else {
                                if (next_char$3 > 57) {
                                  if (next_char$3 < 59) {
                                    _tmp = 3;
                                    continue _L$3;
                                  } else {
                                    break _L$6;
                                  }
                                } else {
                                  _tmp = 6;
                                  continue _L$3;
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L;
                          }
                        }
                        case 1: {
                          tag_1_1 = tag_1;
                          tag_1 = _cursor;
                          if (_cursor < _end) {
                            _L$6: {
                              const next_char$3 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                              _cursor = _cursor + 1 | 0;
                              if (next_char$3 < 58) {
                                if (next_char$3 < 48) {
                                  break _L$6;
                                } else {
                                  _tmp = 2;
                                  continue _L$3;
                                }
                              } else {
                                if (next_char$3 > 58) {
                                  break _L$6;
                                } else {
                                  _tmp = 1;
                                  continue _L$3;
                                }
                              }
                            }
                            _tmp = 0;
                            continue _L$3;
                          } else {
                            break _L;
                          }
                        }
                        default: {
                          break _L;
                        }
                      }
                    }
                    tag_1 = tag_1_2;
                    tag_2 = tag_2_1;
                    match_tag_saver_0 = tag_0;
                    match_tag_saver_1 = tag_1;
                    match_tag_saver_2 = tag_2;
                    match_tag_saver_3 = tag_3;
                    match_tag_saver_4 = tag_4;
                    accept_state = 0;
                    match_end = _cursor;
                    break _L;
                  }
                  tag_1_1 = tag_1_2;
                  tag_1 = _cursor;
                  tag_2 = tag_2_1;
                  if (_cursor < _end) {
                    _L$5: {
                      const next_char$3 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                      _cursor = _cursor + 1 | 0;
                      if (next_char$3 < 58) {
                        if (next_char$3 < 48) {
                          break _L$5;
                        } else {
                          _tmp = 4;
                          continue;
                        }
                      } else {
                        if (next_char$3 > 58) {
                          break _L$5;
                        } else {
                          _tmp = 1;
                          continue;
                        }
                      }
                    }
                    _tmp = 0;
                    continue;
                  } else {
                    break _L;
                  }
                }
              } else {
                break _L;
              }
            } else {
              continue;
            }
          } else {
            break _L;
          }
        }
      } else {
        break _L;
      }
    } else {
      break _L;
    }
  }
  if (accept_state === 0) {
    let start_line;
    let _try_err;
    _L$2: {
      _L$3: {
        const _bind$2 = _M0MP311moonbitlang4core6string6String3sub(_data, match_tag_saver_1 + 1 | 0, match_tag_saver_2);
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          start_line = _ok._0;
        } else {
          const _err = _bind$2;
          _try_err = _err._0;
          break _L$3;
        }
        break _L$2;
      }
      start_line = $panic();
    }
    let start_column;
    let _try_err$2;
    _L$3: {
      _L$4: {
        const _bind$2 = _M0MP311moonbitlang4core6string6String3sub(_data, match_tag_saver_2 + 1 | 0, match_tag_saver_3);
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          start_column = _ok._0;
        } else {
          const _err = _bind$2;
          _try_err$2 = _err._0;
          break _L$4;
        }
        break _L$3;
      }
      start_column = $panic();
    }
    let pkg;
    let _try_err$3;
    _L$4: {
      _L$5: {
        const _bind$2 = _M0MP311moonbitlang4core6string6String3sub(_data, _start + 1 | 0, match_tag_saver_0);
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          pkg = _ok._0;
        } else {
          const _err = _bind$2;
          _try_err$3 = _err._0;
          break _L$5;
        }
        break _L$4;
      }
      pkg = $panic();
    }
    let filename;
    let _try_err$4;
    _L$5: {
      _L$6: {
        const _bind$2 = _M0MP311moonbitlang4core6string6String3sub(_data, match_tag_saver_0 + 1 | 0, match_tag_saver_1);
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          filename = _ok._0;
        } else {
          const _err = _bind$2;
          _try_err$4 = _err._0;
          break _L$6;
        }
        break _L$5;
      }
      filename = $panic();
    }
    let end_line;
    let _try_err$5;
    _L$6: {
      _L$7: {
        const _bind$2 = _M0MP311moonbitlang4core6string6String3sub(_data, match_tag_saver_3 + 1 | 0, match_tag_saver_4);
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          end_line = _ok._0;
        } else {
          const _err = _bind$2;
          _try_err$5 = _err._0;
          break _L$7;
        }
        break _L$6;
      }
      end_line = $panic();
    }
    let end_column;
    let _try_err$6;
    _L$7: {
      _L$8: {
        const _bind$2 = _M0MP311moonbitlang4core6string6String3sub(_data, match_tag_saver_4 + 1 | 0, match_end);
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          end_column = _ok._0;
        } else {
          const _err = _bind$2;
          _try_err$6 = _err._0;
          break _L$8;
        }
        break _L$7;
      }
      end_column = $panic();
    }
    return { pkg: pkg, filename: filename, start_line: start_line, start_column: start_column, end_line: end_line, end_column: end_column };
  } else {
    return $panic();
  }
}
function _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger13write__string(self, str) {
  const _bind = self;
  _bind.val = `${_bind.val}${str}`;
}
function _M0MP311moonbitlang4core7builtin7MyInt647to__int(self) {
  return self.lo;
}
function _M0IP311moonbitlang4core6uint166UInt16P311moonbitlang4core7builtin2Eq5equal(self, that) {
  return self === that;
}
function _M0IP311moonbitlang4core6uint166UInt16P311moonbitlang4core7builtin2Eq10not__equal(self, that) {
  return self !== that;
}
function _M0IP311moonbitlang4core6uint166UInt16P311moonbitlang4core7builtin7Compare7compare(self, that) {
  return $compare_int(self, that);
}
function _M0MP311moonbitlang4core7builtin7MyInt649from__int(value) {
  return { hi: value >> 31 & -1, lo: value | 0 };
}
function _M0MP311moonbitlang4core3int3Int9to__int64(self) {
  return _M0MP311moonbitlang4core7builtin7MyInt649from__int(self);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGsE(x, y) {
  return !(x === y);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGRP311moonbitlang4core6string10StringViewE(x, y) {
  return !_M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin2Eq5equal(x, y);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGlE(x, y) {
  return _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin7Compare7compare(x, y) < 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__gtGlE(x, y) {
  return _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin7Compare7compare(x, y) > 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGkE(x, y) {
  return _M0IP311moonbitlang4core6uint166UInt16P311moonbitlang4core7builtin7Compare7compare(x, y) <= 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGlE(x, y) {
  return _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin7Compare7compare(x, y) <= 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGkE(x, y) {
  return _M0IP311moonbitlang4core6uint166UInt16P311moonbitlang4core7builtin7Compare7compare(x, y) >= 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGlE(x, y) {
  return _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin7Compare7compare(x, y) >= 0;
}
function _M0MP311moonbitlang4core6string6String11sub_2einner(self, start, end) {
  const len = self.length;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    const _end = _Some;
    end$2 = _end < 0 ? len + _end | 0 : _end;
  }
  const start$2 = start < 0 ? len + start | 0 : start;
  if (start$2 >= 0 && (start$2 <= end$2 && end$2 <= len)) {
    if (start$2 < len && _M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(self.charCodeAt(start$2))) {
      return new Result$Err$0$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex);
    }
    if (end$2 < len && _M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(self.charCodeAt(end$2))) {
      return new Result$Err$0$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex);
    }
    return new Result$Ok$0$({ str: self, start: start$2, end: end$2 });
  } else {
    return new Result$Err$0$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$IndexOutOfBounds);
  }
}
function _M0MP311moonbitlang4core6string6String3sub(self, start$46$opt, end) {
  let start;
  if (start$46$opt === undefined) {
    start = 0;
  } else {
    const _Some = start$46$opt;
    start = _Some;
  }
  return _M0MP311moonbitlang4core6string6String11sub_2einner(self, start, end);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin6Logger16write__substringGRP311moonbitlang4core7builtin13StringBuilderE(self, value, start, len) {
  let _tmp;
  let _try_err;
  _L: {
    _L$2: {
      const _bind = _M0MP311moonbitlang4core6string6String11sub_2einner(value, start, start + len | 0);
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _tmp = _ok._0;
      } else {
        const _err = _bind;
        _try_err = _err._0;
        break _L$2;
      }
      break _L;
    }
    _tmp = $panic();
  }
  _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view(self, _tmp);
}
function _M0MP311moonbitlang4core6string10StringView4data(self) {
  return self.str;
}
function _M0MP311moonbitlang4core6string10StringView6length(self) {
  return self.end - self.start | 0;
}
function _M0MP311moonbitlang4core6string10StringView13start__offset(self) {
  return self.start;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(self) {
  const logger = _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(0);
  _M0IP311moonbitlang4core3int3IntP311moonbitlang4core7builtin4Show6output(self, { self: logger, method_table: _M0FP095_40moonbitlang_2fcore_2fbuiltin_2eStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
  return _M0MP311moonbitlang4core7builtin13StringBuilder10to__string(logger);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGRP311moonbitlang4core7builtin9SourceLocE(self) {
  const logger = _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(0);
  _M0IP311moonbitlang4core7builtin9SourceLocP311moonbitlang4core7builtin4Show6output(self, { self: logger, method_table: _M0FP095_40moonbitlang_2fcore_2fbuiltin_2eStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
  return _M0MP311moonbitlang4core7builtin13StringBuilder10to__string(logger);
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGcE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGsE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGRP311moonbitlang4core6string10StringViewE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core7builtin4Iter4nextGUicEE(self) {
  const _func = self;
  return _func();
}
function _M0MP311moonbitlang4core3int3Int18to__string_2einner(self, radix) {
  return _M0FP311moonbitlang4core7builtin19int__to__string__js(self, radix);
}
function _M0MP311moonbitlang4core6string10StringView11unsafe__get(self, index) {
  return self.str.charCodeAt(self.start + index | 0);
}
function _M0MP311moonbitlang4core7builtin4Iter3newGcE(f) {
  return f;
}
function _M0MP311moonbitlang4core7builtin4Iter3newGRP311moonbitlang4core6string10StringViewE(f) {
  return f;
}
function _M0MP311moonbitlang4core6string10StringView12view_2einner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = _M0MP311moonbitlang4core6string10StringView6length(self);
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  return start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= _M0MP311moonbitlang4core6string10StringView6length(self)) ? { str: self.str, start: self.start + start_offset | 0, end: self.start + end_offset$2 | 0 } : _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core6string10StringViewE("Invalid index for View", "@moonbitlang/core/builtin:stringview.mbt:113:5-113:36");
}
function _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(self) {
  return self.str.substring(self.start, self.end);
}
function _M0MP311moonbitlang4core6string10StringView4iter(self) {
  const start = self.start;
  const end = self.end;
  const index = { val: start };
  return _M0MP311moonbitlang4core7builtin4Iter3newGcE(() => {
    if (index.val < end) {
      const c1 = self.str.charCodeAt(index.val);
      if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c1) && (index.val + 1 | 0) < self.end) {
        const c2 = self.str.charCodeAt(index.val + 1 | 0);
        if (_M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(c2)) {
          index.val = index.val + 2 | 0;
          return _M0FP311moonbitlang4core7builtin32code__point__of__surrogate__pair(c1, c2);
        }
      }
      index.val = index.val + 1 | 0;
      return _M0MP311moonbitlang4core6uint166UInt1616unsafe__to__char(c1);
    } else {
      return -1;
    }
  });
}
function _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin2Eq5equal(self, other) {
  const len = _M0MP311moonbitlang4core6string10StringView6length(self);
  if (len === _M0MP311moonbitlang4core6string10StringView6length(other)) {
    if (self.str === other.str && self.start === other.start) {
      return true;
    }
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        if (_M0IP311moonbitlang4core6uint166UInt16P311moonbitlang4core7builtin2Eq5equal(self.str.charCodeAt(self.start + i | 0), other.str.charCodeAt(other.start + i | 0))) {
        } else {
          return false;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return true;
  } else {
    return false;
  }
}
function _M0MP311moonbitlang4core6string6String12view_2einner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  return start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= self.length) ? { str: self, start: start_offset, end: end_offset$2 } : _M0FP311moonbitlang4core7builtin5abortGRP311moonbitlang4core6string10StringViewE("Invalid index for View", "@moonbitlang/core/builtin:stringview.mbt:399:5-399:36");
}
function _M0MP311moonbitlang4core5array9ArrayView6lengthGsE(self) {
  return self.end - self.start | 0;
}
function _M0MP311moonbitlang4core6string6String24char__length__eq_2einner(self, len, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  let _tmp = start_offset;
  let _tmp$2 = 0;
  while (true) {
    const index = _tmp;
    const count = _tmp$2;
    if (index < end_offset$2 && count < len) {
      const c1 = self.charCodeAt(index);
      if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c1) && (index + 1 | 0) < end_offset$2) {
        const c2 = self.charCodeAt(index + 1 | 0);
        if (_M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(c2)) {
          _tmp = index + 2 | 0;
          _tmp$2 = count + 1 | 0;
          continue;
        } else {
          _M0FP311moonbitlang4core7builtin5abortGuE("invalid surrogate pair", "@moonbitlang/core/builtin:string.mbt:424:9-424:40");
        }
      }
      _tmp = index + 1 | 0;
      _tmp$2 = count + 1 | 0;
      continue;
    } else {
      return count === len && index === end_offset$2;
    }
  }
}
function _M0MP311moonbitlang4core6string6String24char__length__ge_2einner(self, len, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  let _tmp = start_offset;
  let _tmp$2 = 0;
  while (true) {
    const index = _tmp;
    const count = _tmp$2;
    if (index < end_offset$2 && count < len) {
      const c1 = self.charCodeAt(index);
      if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c1) && (index + 1 | 0) < end_offset$2) {
        const c2 = self.charCodeAt(index + 1 | 0);
        if (_M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(c2)) {
          _tmp = index + 2 | 0;
          _tmp$2 = count + 1 | 0;
          continue;
        } else {
          _M0FP311moonbitlang4core7builtin5abortGuE("invalid surrogate pair", "@moonbitlang/core/builtin:string.mbt:452:9-452:40");
        }
      }
      _tmp = index + 1 | 0;
      _tmp$2 = count + 1 | 0;
      continue;
    } else {
      return count >= len;
    }
  }
}
function _M0MP311moonbitlang4core6string6String31offset__of__nth__char__backward(self, n, start_offset, end_offset) {
  let char_count = 0;
  let utf16_offset = end_offset;
  while (true) {
    if ((utf16_offset - 1 | 0) >= start_offset && char_count < n) {
      const c = self.charCodeAt(utf16_offset - 1 | 0);
      if (_M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(c)) {
        utf16_offset = utf16_offset - 2 | 0;
      } else {
        utf16_offset = utf16_offset - 1 | 0;
      }
      char_count = char_count + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return char_count < n || utf16_offset < start_offset ? undefined : utf16_offset;
}
function _M0MP311moonbitlang4core6string6String30offset__of__nth__char__forward(self, n, start_offset, end_offset) {
  if (start_offset >= 0 && start_offset <= end_offset) {
    let utf16_offset = start_offset;
    let char_count = 0;
    while (true) {
      if (utf16_offset < end_offset && char_count < n) {
        const c = self.charCodeAt(utf16_offset);
        if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c)) {
          utf16_offset = utf16_offset + 2 | 0;
        } else {
          utf16_offset = utf16_offset + 1 | 0;
        }
        char_count = char_count + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return char_count < n || utf16_offset >= end_offset ? undefined : utf16_offset;
  } else {
    return _M0FP311moonbitlang4core7builtin5abortGOiE("Invalid start index", "@moonbitlang/core/builtin:string.mbt:327:5-327:33");
  }
}
function _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(self, i, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  return i >= 0 ? _M0MP311moonbitlang4core6string6String30offset__of__nth__char__forward(self, i, start_offset, end_offset$2) : _M0MP311moonbitlang4core6string6String31offset__of__nth__char__backward(self, -i | 0, start_offset, end_offset$2);
}
function _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view(self, str) {
  const _bind = self;
  _bind.val = `${_bind.val}${_M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(str)}`;
}
function _M0FP311moonbitlang4core7builtin28boyer__moore__horspool__find(haystack, needle) {
  const haystack_len = _M0MP311moonbitlang4core6string10StringView6length(haystack);
  const needle_len = _M0MP311moonbitlang4core6string10StringView6length(needle);
  if (needle_len > 0) {
    if (haystack_len >= needle_len) {
      const skip_table = $make_array_len_and_init(256, needle_len);
      const _end4308 = needle_len - 1 | 0;
      let _tmp = 0;
      while (true) {
        const i = _tmp;
        if (i < _end4308) {
          const _tmp$2 = _M0MP311moonbitlang4core6string10StringView11unsafe__get(needle, i) & 255;
          $bound_check(skip_table, _tmp$2);
          skip_table[_tmp$2] = (needle_len - 1 | 0) - i | 0;
          _tmp = i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      let _tmp$2 = 0;
      while (true) {
        const i = _tmp$2;
        if (i <= (haystack_len - needle_len | 0)) {
          const _end4314 = needle_len - 1 | 0;
          let _tmp$3 = 0;
          while (true) {
            const j = _tmp$3;
            if (j <= _end4314) {
              if (_M0IP311moonbitlang4core6uint166UInt16P311moonbitlang4core7builtin2Eq10not__equal(_M0MP311moonbitlang4core6string10StringView11unsafe__get(haystack, i + j | 0), _M0MP311moonbitlang4core6string10StringView11unsafe__get(needle, j))) {
                break;
              }
              _tmp$3 = j + 1 | 0;
              continue;
            } else {
              return i;
            }
          }
          const _tmp$4 = _M0MP311moonbitlang4core6string10StringView11unsafe__get(haystack, (i + needle_len | 0) - 1 | 0) & 255;
          $bound_check(skip_table, _tmp$4);
          _tmp$2 = i + skip_table[_tmp$4] | 0;
          continue;
        } else {
          break;
        }
      }
      return undefined;
    } else {
      return undefined;
    }
  } else {
    return _M0FP311moonbitlang4core7builtin43boyer__moore__horspool__find_2econstr_2f265;
  }
}
function _M0FP311moonbitlang4core7builtin18brute__force__find(haystack, needle) {
  const haystack_len = _M0MP311moonbitlang4core6string10StringView6length(haystack);
  const needle_len = _M0MP311moonbitlang4core6string10StringView6length(needle);
  if (needle_len > 0) {
    if (haystack_len >= needle_len) {
      const needle_first = _M0MP311moonbitlang4core6string10StringView11unsafe__get(needle, 0);
      const forward_len = haystack_len - needle_len | 0;
      let i = 0;
      while (true) {
        if (i <= forward_len) {
          while (true) {
            if (i <= forward_len && _M0IP311moonbitlang4core6uint166UInt16P311moonbitlang4core7builtin2Eq10not__equal(_M0MP311moonbitlang4core6string10StringView11unsafe__get(haystack, i), needle_first)) {
              i = i + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          if (i <= forward_len) {
            let _tmp = 1;
            while (true) {
              const j = _tmp;
              if (j < needle_len) {
                if (_M0IP311moonbitlang4core6uint166UInt16P311moonbitlang4core7builtin2Eq10not__equal(_M0MP311moonbitlang4core6string10StringView11unsafe__get(haystack, i + j | 0), _M0MP311moonbitlang4core6string10StringView11unsafe__get(needle, j))) {
                  break;
                }
                _tmp = j + 1 | 0;
                continue;
              } else {
                return i;
              }
            }
            i = i + 1 | 0;
          }
          continue;
        } else {
          break;
        }
      }
      return undefined;
    } else {
      return undefined;
    }
  } else {
    return _M0FP311moonbitlang4core7builtin33brute__force__find_2econstr_2f279;
  }
}
function _M0MP311moonbitlang4core6string10StringView4find(self, str) {
  return _M0MP311moonbitlang4core6string10StringView6length(str) <= 4 ? _M0FP311moonbitlang4core7builtin18brute__force__find(self, str) : _M0FP311moonbitlang4core7builtin28boyer__moore__horspool__find(self, str);
}
function _M0MP311moonbitlang4core6string6String4find(self, str) {
  return _M0MP311moonbitlang4core6string10StringView4find({ str: self, start: 0, end: self.length }, str);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP27sacckey8moon8bit6SpriteE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP27sacckey8moon8bit7TilemapE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGsE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGiE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core5array5Array4pushGRP27sacckey8moon8bit8ColliderE(self, value) {
  _M0MP311moonbitlang4core7builtin7JSArray4push(self, value);
}
function _M0MP311moonbitlang4core6string10StringView14contains__char(self, c) {
  const len = _M0MP311moonbitlang4core6string10StringView6length(self);
  if (len > 0) {
    const c$2 = c;
    if (c$2 <= 65535) {
      let _tmp = 0;
      while (true) {
        const i = _tmp;
        if (i < len) {
          if (_M0MP311moonbitlang4core6string10StringView11unsafe__get(self, i) === c$2) {
            return true;
          }
          _tmp = i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
    } else {
      if (len >= 2) {
        const adj = c$2 - 65536 | 0;
        const high = 55296 + (adj >> 10) | 0;
        const low = 56320 + (adj & 1023) | 0;
        let i = 0;
        while (true) {
          if (i < (len - 1 | 0)) {
            if (_M0MP311moonbitlang4core6string10StringView11unsafe__get(self, i) === high) {
              i = i + 1 | 0;
              if (_M0MP311moonbitlang4core6string10StringView11unsafe__get(self, i) === low) {
                return true;
              }
            }
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
      } else {
        return false;
      }
    }
    return false;
  } else {
    return false;
  }
}
function _M0MP311moonbitlang4core6string10StringView19trim__start_2einner(self, chars) {
  let _tmp = self;
  while (true) {
    const _param = _tmp;
    if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(_param.str, 0, _param.start, _param.end)) {
      return _param;
    } else {
      const _c = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 0, _param.start, _param.end));
      const _tmp$2 = _param.str;
      const _bind = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, 1, _param.start, _param.end);
      let _tmp$3;
      if (_bind === undefined) {
        _tmp$3 = _param.end;
      } else {
        const _Some = _bind;
        _tmp$3 = _Some;
      }
      const _x = { str: _tmp$2, start: _tmp$3, end: _param.end };
      if (_M0MP311moonbitlang4core6string10StringView14contains__char(chars, _c)) {
        _tmp = _x;
        continue;
      } else {
        return _param;
      }
    }
  }
}
function _M0MP311moonbitlang4core6string10StringView17trim__end_2einner(self, chars) {
  let _tmp = self;
  while (true) {
    const _param = _tmp;
    if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(_param.str, 0, _param.start, _param.end)) {
      return _param;
    } else {
      const _c = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, -1, _param.start, _param.end));
      const _x = { str: _param.str, start: _param.start, end: _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param.str, -1, _param.start, _param.end) };
      if (_M0MP311moonbitlang4core6string10StringView14contains__char(chars, _c)) {
        _tmp = _x;
        continue;
      } else {
        return _param;
      }
    }
  }
}
function _M0MP311moonbitlang4core6string10StringView12trim_2einner(self, chars) {
  return _M0MP311moonbitlang4core6string10StringView17trim__end_2einner(_M0MP311moonbitlang4core6string10StringView19trim__start_2einner(self, chars), chars);
}
function _M0MP311moonbitlang4core6string6String12trim_2einner(self, chars) {
  return _M0MP311moonbitlang4core6string10StringView12trim_2einner({ str: self, start: 0, end: self.length }, chars);
}
function _M0MP311moonbitlang4core6string6String4trim(self, chars$46$opt) {
  let chars;
  if (chars$46$opt === undefined) {
    chars = { str: _M0FP311moonbitlang4core7builtin21trim_2e_2abind_7c6206, start: 0, end: _M0FP311moonbitlang4core7builtin21trim_2e_2abind_7c6206.length };
  } else {
    const _Some = chars$46$opt;
    chars = _Some;
  }
  return _M0MP311moonbitlang4core6string6String12trim_2einner(self, chars);
}
function _M0MP311moonbitlang4core6string6String4iter(self) {
  const len = self.length;
  const index = { val: 0 };
  return _M0MP311moonbitlang4core7builtin4Iter3newGcE(() => {
    if (index.val < len) {
      const c1 = self.charCodeAt(index.val);
      if (_M0MP311moonbitlang4core6uint166UInt1622is__leading__surrogate(c1) && (index.val + 1 | 0) < len) {
        const c2 = self.charCodeAt(index.val + 1 | 0);
        if (_M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(c2)) {
          const c = _M0FP311moonbitlang4core7builtin32code__point__of__surrogate__pair(c1, c2);
          index.val = index.val + 2 | 0;
          return c;
        }
      }
      index.val = index.val + 1 | 0;
      return _M0MP311moonbitlang4core6uint166UInt1616unsafe__to__char(c1);
    } else {
      return -1;
    }
  });
}
function _M0MP311moonbitlang4core7builtin4Iter3mapGRP311moonbitlang4core6string10StringViewsE(self, f) {
  return () => {
    const _bind = _M0MP311moonbitlang4core7builtin4Iter4nextGRP311moonbitlang4core6string10StringViewE(self);
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _x = _Some;
      return f(_x);
    }
  };
}
function _M0MP311moonbitlang4core7builtin4Iter3mapGcRP311moonbitlang4core6string10StringViewE(self, f) {
  return () => {
    const _bind = _M0MP311moonbitlang4core7builtin4Iter4nextGcE(self);
    if (_bind === -1) {
      return undefined;
    } else {
      const _Some = _bind;
      const _x = _Some;
      return f(_x);
    }
  };
}
function _M0IP311moonbitlang4core4char4CharP311moonbitlang4core7builtin4Show10to__string(self) {
  return String.fromCodePoint(self);
}
function _M0MP311moonbitlang4core6string10StringView5split(self, sep) {
  const sep_len = _M0MP311moonbitlang4core6string10StringView6length(sep);
  if (sep_len === 0) {
    return _M0MP311moonbitlang4core7builtin4Iter3mapGcRP311moonbitlang4core6string10StringViewE(_M0MP311moonbitlang4core6string10StringView4iter(self), (c) => _M0MP311moonbitlang4core6string6String12view_2einner(_M0IP311moonbitlang4core4char4CharP311moonbitlang4core7builtin4Show10to__string(c), 0, undefined));
  }
  const remaining = { val: self };
  return _M0MP311moonbitlang4core7builtin4Iter3newGRP311moonbitlang4core6string10StringViewE(() => {
    const _bind = remaining.val;
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _view = _Some;
      const _bind$2 = _M0MP311moonbitlang4core6string10StringView4find(_view, sep);
      if (_bind$2 === undefined) {
        remaining.val = undefined;
        return _view;
      } else {
        const _Some$2 = _bind$2;
        const _end = _Some$2;
        remaining.val = _M0MP311moonbitlang4core6string10StringView12view_2einner(_view, _end + sep_len | 0, undefined);
        return _M0MP311moonbitlang4core6string10StringView12view_2einner(_view, 0, _end);
      }
    }
  });
}
function _M0MP311moonbitlang4core6string6String5split(self, sep) {
  return _M0MP311moonbitlang4core6string10StringView5split({ str: self, start: 0, end: self.length }, sep);
}
function _M0MP311moonbitlang4core7builtin4Iter9to__arrayGsE(self) {
  const result = [];
  while (true) {
    const _bind = _M0MP311moonbitlang4core7builtin4Iter4nextGsE(self);
    if (_bind === undefined) {
      break;
    } else {
      const _Some = _bind;
      const _x = _Some;
      _M0MP311moonbitlang4core5array5Array4pushGsE(result, _x);
      continue;
    }
  }
  return result;
}
function _M0MP311moonbitlang4core6string6String12replace__all(self, old, new_) {
  const len = self.length;
  const buf = _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(len);
  const old_len = _M0MP311moonbitlang4core6string10StringView6length(old);
  const new$2 = _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(new_);
  if (old_len === 0) {
    _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger13write__string(buf, new$2);
    const _it = _M0MP311moonbitlang4core6string6String4iter(self);
    while (true) {
      const _bind = _M0MP311moonbitlang4core7builtin4Iter4nextGcE(_it);
      if (_bind === -1) {
        break;
      } else {
        const _Some = _bind;
        const _c = _Some;
        _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__char(buf, _c);
        _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger13write__string(buf, new$2);
        continue;
      }
    }
    return _M0MP311moonbitlang4core7builtin13StringBuilder10to__string(buf);
  } else {
    const first_end = _M0MP311moonbitlang4core6string6String4find(self, old);
    if (first_end === undefined) {
      return self;
    } else {
      const _Some = first_end;
      const _end = _Some;
      let _tmp = { str: self, start: 0, end: self.length };
      let _tmp$2 = _end;
      while (true) {
        const view = _tmp;
        const end = _tmp$2;
        const seg = _M0MP311moonbitlang4core6string10StringView12view_2einner(view, 0, end);
        _M0IP016_24default__implP311moonbitlang4core7builtin6Logger16write__substringGRP311moonbitlang4core7builtin13StringBuilderE(buf, _M0MP311moonbitlang4core6string10StringView4data(seg), _M0MP311moonbitlang4core6string10StringView13start__offset(seg), _M0MP311moonbitlang4core6string10StringView6length(seg));
        _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger13write__string(buf, new$2);
        if ((end + old_len | 0) <= len) {
          const next_view = _M0MP311moonbitlang4core6string10StringView12view_2einner(view, end + old_len | 0, undefined);
          const _bind = _M0MP311moonbitlang4core6string10StringView4find(next_view, old);
          if (_bind === undefined) {
            _M0IP016_24default__implP311moonbitlang4core7builtin6Logger16write__substringGRP311moonbitlang4core7builtin13StringBuilderE(buf, _M0MP311moonbitlang4core6string10StringView4data(next_view), _M0MP311moonbitlang4core6string10StringView13start__offset(next_view), _M0MP311moonbitlang4core6string10StringView6length(next_view));
            break;
          } else {
            const _Some$2 = _bind;
            const _next_end = _Some$2;
            _tmp = next_view;
            _tmp$2 = _next_end;
            continue;
          }
        } else {
          break;
        }
      }
      return _M0MP311moonbitlang4core7builtin13StringBuilder10to__string(buf);
    }
  }
}
function _M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin12ToStringView16to__string__view(self) {
  return { str: self, start: 0, end: self.length };
}
function _M0MP311moonbitlang4core7builtin4Iter5iter2GcE(self) {
  const i = { val: 0 };
  return () => {
    const _bind = _M0MP311moonbitlang4core7builtin4Iter4nextGcE(self);
    if (_bind === -1) {
      return undefined;
    } else {
      const _Some = _bind;
      const _elem = _Some;
      const result = { _0: i.val, _1: _elem };
      i.val = i.val + 1 | 0;
      return result;
    }
  };
}
function _M0MP311moonbitlang4core6string6String5iter2(self) {
  return _M0MP311moonbitlang4core7builtin4Iter5iter2GcE(_M0MP311moonbitlang4core6string6String4iter(self));
}
function _M0IP311moonbitlang4core3int3IntP311moonbitlang4core7builtin4Show6output(self, logger) {
  logger.method_table.method_0(logger.self, _M0MP311moonbitlang4core3int3Int18to__string_2einner(self, 10));
}
function _M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(self) {
  return self;
}
function _M0MP311moonbitlang4core5array5Array4makeGiE(len, elem) {
  const arr = new Array(len);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < len) {
      arr[i] = elem;
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return arr;
}
function _M0MP311moonbitlang4core5array5Array3setGiE(self, index, value) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    self[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MP311moonbitlang4core7builtin4Iter6filterGsE(self, f) {
  return () => {
    while (true) {
      const _bind = _M0MP311moonbitlang4core7builtin4Iter4nextGsE(self);
      if (_bind === undefined) {
        return undefined;
      } else {
        const _Some = _bind;
        const _x = _Some;
        if (f(_x)) {
          return _x;
        }
        continue;
      }
    }
  };
}
function _M0MP311moonbitlang4core7builtin5Iter24nextGicE(self) {
  return _M0MP311moonbitlang4core7builtin4Iter4nextGUicEE(self);
}
function _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(self, idx) {
  return self.charCodeAt(idx);
}
function _M0MP311moonbitlang4core7builtin7MyInt6411add__hi__lo(self, bhi, blo) {
  const _ahi = self.hi;
  const _alo = self.lo;
  const lo = _alo + blo | 0;
  const s = lo >> 31;
  const as_ = _alo >> 31;
  const bs = blo >> 31;
  const c = (as_ & bs | ~s & (as_ ^ bs)) & 1;
  const hi = (_ahi + bhi | 0) + c | 0;
  return { hi: hi, lo: lo };
}
function _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Add3add(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt6411add__hi__lo(self, other.hi, other.lo);
}
function _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Sub3sub(self, other) {
  return other.lo === 0 ? { hi: self.hi - other.hi | 0, lo: self.lo } : _M0MP311moonbitlang4core7builtin7MyInt6411add__hi__lo(self, ~other.hi, ~other.lo + 1 | 0);
}
function _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Mul3mul(self, other) {
  const _ahi = self.hi;
  const _alo = self.lo;
  const _bhi = other.hi;
  const _blo = other.lo;
  const ahi = _ahi;
  const alo = _alo;
  const bhi = _bhi;
  const blo = _blo;
  const a48 = ahi >>> 16 | 0;
  const a32 = ahi & 65535;
  const a16 = alo >>> 16 | 0;
  const a00 = alo & 65535;
  const b48 = bhi >>> 16 | 0;
  const b32 = bhi & 65535;
  const b16 = blo >>> 16 | 0;
  const b00 = blo & 65535;
  const c00 = Math.imul(a00, b00) | 0;
  const c16 = c00 >>> 16 | 0;
  const c00$2 = c00 & 65535;
  const c16$2 = (c16 >>> 0) + ((Math.imul(a16, b00) | 0) >>> 0) | 0;
  const c32 = c16$2 >>> 16 | 0;
  const c16$3 = c16$2 & 65535;
  const c16$4 = (c16$3 >>> 0) + ((Math.imul(a00, b16) | 0) >>> 0) | 0;
  const c32$2 = (c32 >>> 0) + ((c16$4 >>> 16 | 0) >>> 0) | 0;
  const c16$5 = c16$4 & 65535;
  const c32$3 = (c32$2 >>> 0) + ((Math.imul(a32, b00) | 0) >>> 0) | 0;
  const c48 = c32$3 >>> 16 | 0;
  const c32$4 = c32$3 & 65535;
  const c32$5 = (c32$4 >>> 0) + ((Math.imul(a16, b16) | 0) >>> 0) | 0;
  const c48$2 = (c48 >>> 0) + ((c32$5 >>> 16 | 0) >>> 0) | 0;
  const c32$6 = c32$5 & 65535;
  const c32$7 = (c32$6 >>> 0) + ((Math.imul(a00, b32) | 0) >>> 0) | 0;
  const c48$3 = (c48$2 >>> 0) + ((c32$7 >>> 16 | 0) >>> 0) | 0;
  const c32$8 = c32$7 & 65535;
  const c48$4 = (((((((c48$3 >>> 0) + ((Math.imul(a48, b00) | 0) >>> 0) | 0) >>> 0) + ((Math.imul(a32, b16) | 0) >>> 0) | 0) >>> 0) + ((Math.imul(a16, b32) | 0) >>> 0) | 0) >>> 0) + ((Math.imul(a00, b48) | 0) >>> 0) | 0;
  const c48$5 = c48$4 & 65535;
  return { hi: c48$5 << 16 | c32$8, lo: c16$5 << 16 | c00$2 };
}
function _M0FP311moonbitlang4core7builtin29try__get__int64__wasm__helper() {
  if (_M0FP311moonbitlang4core7builtin19wasm__helper__cache.tried) {
    const _bind = _M0FP311moonbitlang4core7builtin19wasm__helper__cache.exports;
    return !(_bind === undefined);
  }
  _M0FP311moonbitlang4core7builtin19wasm__helper__cache.tried = true;
  _M0FP311moonbitlang4core7builtin19wasm__helper__cache.exports = _M0FP311moonbitlang4core7builtin23try__init__wasm__helper();
  const _bind = _M0FP311moonbitlang4core7builtin19wasm__helper__cache.exports;
  return !(_bind === undefined);
}
function _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Div3div(self, other) {
  if (!(other.hi === 0 && other.lo === 0)) {
    if (!_M0FP311moonbitlang4core7builtin29try__get__int64__wasm__helper()) {
      return _M0MP311moonbitlang4core7builtin7MyInt6411div__bigint(self, other);
    }
    const _bind = _M0FP311moonbitlang4core7builtin19wasm__helper__cache.exports;
    if (_bind === undefined) {
      return $panic();
    } else {
      const _Some = _bind;
      const _exports = _Some;
      const _ahi = self.hi;
      const _alo = self.lo;
      const _bhi = other.hi;
      const _blo = other.lo;
      const _func = _exports.div_s;
      const lo = _func(_alo, _ahi, _blo, _bhi);
      const _func$2 = _exports.get_high;
      const hi = _func$2();
      return { hi: hi, lo: lo };
    }
  } else {
    return $panic();
  }
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(self, other) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Add3add(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Sub3sub(self, other) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Sub3sub(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Mul3mul(self, other) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Mul3mul(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div(self, other) {
  return _M0IP311moonbitlang4core7builtin7MyInt64P311moonbitlang4core7builtin3Div3div(self, other);
}
function _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin7Compare7compare(self, other) {
  return _M0MP311moonbitlang4core7builtin7MyInt647compare(self, other);
}
function _M0MP311moonbitlang4core5int645Int647to__int(self) {
  return _M0MP311moonbitlang4core7builtin7MyInt647to__int(self);
}
function _M0MP311moonbitlang4core6double6Double7to__int(self) {
  return self !== self ? 0 : self >= 2147483647 ? 2147483647 : self <= -2147483648 ? -2147483648 : self | 0;
}
function _M0MP311moonbitlang4core6double6Double9from__int(i) {
  return i + 0;
}
function _M0IP311moonbitlang4core7builtin13SourceLocReprP311moonbitlang4core7builtin4Show6output(self, logger) {
  const pkg = self.pkg;
  const _data = _M0MP311moonbitlang4core6string10StringView4data(pkg);
  const _start = _M0MP311moonbitlang4core6string10StringView13start__offset(pkg);
  const _end = _start + _M0MP311moonbitlang4core6string10StringView6length(pkg) | 0;
  let _cursor = _start;
  let accept_state = -1;
  let match_end = -1;
  let match_tag_saver_0 = -1;
  let tag_0 = -1;
  let _bind;
  _L: {
    _L$2: {
      _L$3: while (true) {
        if (_cursor < _end) {
          const next_char = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
          _cursor = _cursor + 1 | 0;
          if (next_char === 47) {
            _L$4: while (true) {
              tag_0 = _cursor;
              if (_cursor < _end) {
                const next_char$2 = _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                _cursor = _cursor + 1 | 0;
                if (next_char$2 === 47) {
                  while (true) {
                    if (_cursor < _end) {
                      _M0MP311moonbitlang4core6string6String20unsafe__charcode__at(_data, _cursor);
                      _cursor = _cursor + 1 | 0;
                      continue;
                    } else {
                      match_tag_saver_0 = tag_0;
                      accept_state = 0;
                      match_end = _cursor;
                      break _L$2;
                    }
                  }
                } else {
                  continue;
                }
              } else {
                break _L$2;
              }
            }
          } else {
            continue;
          }
        } else {
          break _L$2;
        }
      }
      break _L;
    }
    if (accept_state === 0) {
      let package_name;
      let _try_err;
      _L$3: {
        _L$4: {
          const _bind$2 = _M0MP311moonbitlang4core6string6String3sub(_data, match_tag_saver_0 + 1 | 0, match_end);
          if (_bind$2.$tag === 1) {
            const _ok = _bind$2;
            package_name = _ok._0;
          } else {
            const _err = _bind$2;
            _try_err = _err._0;
            break _L$4;
          }
          break _L$3;
        }
        package_name = $panic();
      }
      let module_name;
      let _try_err$2;
      _L$4: {
        _L$5: {
          const _bind$2 = _M0MP311moonbitlang4core6string6String3sub(_data, _start, match_tag_saver_0);
          if (_bind$2.$tag === 1) {
            const _ok = _bind$2;
            module_name = _ok._0;
          } else {
            const _err = _bind$2;
            _try_err$2 = _err._0;
            break _L$5;
          }
          break _L$4;
        }
        module_name = $panic();
      }
      _bind = { _0: module_name, _1: package_name };
    } else {
      _bind = { _0: pkg, _1: undefined };
    }
  }
  const _module_name = _bind._0;
  const _package_name = _bind._1;
  if (_package_name === undefined) {
  } else {
    const _Some = _package_name;
    const _pkg_name = _Some;
    logger.method_table.method_2(logger.self, _pkg_name);
    logger.method_table.method_3(logger.self, 47);
  }
  logger.method_table.method_2(logger.self, self.filename);
  logger.method_table.method_3(logger.self, 58);
  logger.method_table.method_2(logger.self, self.start_line);
  logger.method_table.method_3(logger.self, 58);
  logger.method_table.method_2(logger.self, self.start_column);
  logger.method_table.method_3(logger.self, 45);
  logger.method_table.method_2(logger.self, self.end_line);
  logger.method_table.method_3(logger.self, 58);
  logger.method_table.method_2(logger.self, self.end_column);
  logger.method_table.method_3(logger.self, 64);
  logger.method_table.method_2(logger.self, _module_name);
}
function _M0IP311moonbitlang4core7builtin9SourceLocP311moonbitlang4core7builtin4Show6output(self, logger) {
  _M0IP311moonbitlang4core7builtin13SourceLocReprP311moonbitlang4core7builtin4Show6output(_M0MP311moonbitlang4core7builtin13SourceLocRepr5parse(self), logger);
}
function _M0MP311moonbitlang4core5array9ArrayView4joinGsE(self, separator) {
  if ((self.end - self.start | 0) === 0) {
    return "";
  } else {
    const _hd = self.buf[self.start];
    const _bind = self.buf;
    const _bind$2 = 1 + self.start | 0;
    const _bind$3 = self.end;
    const _x = { buf: _bind, start: _bind$2, end: _bind$3 };
    const hd = _M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin12ToStringView16to__string__view(_hd);
    let size_hint = _M0MP311moonbitlang4core6string10StringView6length(hd);
    const _len = _M0MP311moonbitlang4core5array9ArrayView6lengthGsE(_x);
    let _tmp = 0;
    while (true) {
      const _i = _tmp;
      if (_i < _len) {
        const s = _bind[_bind$2 + _i | 0];
        size_hint = size_hint + (_M0MP311moonbitlang4core6string10StringView6length(_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin12ToStringView16to__string__view(s)) + _M0MP311moonbitlang4core6string10StringView6length(separator) | 0) | 0;
        _tmp = _i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    size_hint = size_hint << 1;
    const buf = _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(size_hint);
    _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view(buf, hd);
    if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(separator.str, 0, separator.start, separator.end)) {
      const _len$2 = _M0MP311moonbitlang4core5array9ArrayView6lengthGsE(_x);
      let _tmp$2 = 0;
      while (true) {
        const _i = _tmp$2;
        if (_i < _len$2) {
          const s = _bind[_bind$2 + _i | 0];
          const s$2 = _M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin12ToStringView16to__string__view(s);
          _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view(buf, s$2);
          _tmp$2 = _i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
    } else {
      const _len$2 = _M0MP311moonbitlang4core5array9ArrayView6lengthGsE(_x);
      let _tmp$2 = 0;
      while (true) {
        const _i = _tmp$2;
        if (_i < _len$2) {
          const s = _bind[_bind$2 + _i | 0];
          const s$2 = _M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin12ToStringView16to__string__view(s);
          _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view(buf, separator);
          _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view(buf, s$2);
          _tmp$2 = _i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
    }
    return _M0MP311moonbitlang4core7builtin13StringBuilder10to__string(buf);
  }
}
function _M0MP311moonbitlang4core5array5Array4joinGsE(self, separator) {
  return _M0MP311moonbitlang4core5array9ArrayView4joinGsE({ buf: self, start: 0, end: self.length }, separator);
}
function _M0FP311moonbitlang4core7strconv9base__errGUiRP311moonbitlang4core6string10StringViewbEE() {
  return new Result$Err$1$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv14base__err__str));
}
function _M0FP311moonbitlang4core7strconv25check__and__consume__base(view, base) {
  if (base === 0) {
    _L: {
      let rest;
      _L$2: {
        let rest$2;
        _L$3: {
          let rest$3;
          _L$4: {
            if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(view.str, 2, view.start, view.end)) {
              const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(view.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 0, view.start, view.end));
              if (_x === 48) {
                const _x$2 = _M0MP311moonbitlang4core6string6String16unsafe__char__at(view.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 1, view.start, view.end));
                switch (_x$2) {
                  case 120: {
                    const _tmp = view.str;
                    const _bind = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$2;
                    if (_bind === undefined) {
                      _tmp$2 = view.end;
                    } else {
                      const _Some = _bind;
                      _tmp$2 = _Some;
                    }
                    const _x$3 = { str: _tmp, start: _tmp$2, end: view.end };
                    rest$3 = _x$3;
                    break _L$4;
                  }
                  case 88: {
                    const _tmp$3 = view.str;
                    const _bind$2 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$4;
                    if (_bind$2 === undefined) {
                      _tmp$4 = view.end;
                    } else {
                      const _Some = _bind$2;
                      _tmp$4 = _Some;
                    }
                    const _x$4 = { str: _tmp$3, start: _tmp$4, end: view.end };
                    rest$3 = _x$4;
                    break _L$4;
                  }
                  case 111: {
                    const _tmp$5 = view.str;
                    const _bind$3 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$6;
                    if (_bind$3 === undefined) {
                      _tmp$6 = view.end;
                    } else {
                      const _Some = _bind$3;
                      _tmp$6 = _Some;
                    }
                    const _x$5 = { str: _tmp$5, start: _tmp$6, end: view.end };
                    rest$2 = _x$5;
                    break _L$3;
                  }
                  case 79: {
                    const _tmp$7 = view.str;
                    const _bind$4 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$8;
                    if (_bind$4 === undefined) {
                      _tmp$8 = view.end;
                    } else {
                      const _Some = _bind$4;
                      _tmp$8 = _Some;
                    }
                    const _x$6 = { str: _tmp$7, start: _tmp$8, end: view.end };
                    rest$2 = _x$6;
                    break _L$3;
                  }
                  case 98: {
                    const _tmp$9 = view.str;
                    const _bind$5 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$10;
                    if (_bind$5 === undefined) {
                      _tmp$10 = view.end;
                    } else {
                      const _Some = _bind$5;
                      _tmp$10 = _Some;
                    }
                    const _x$7 = { str: _tmp$9, start: _tmp$10, end: view.end };
                    rest = _x$7;
                    break _L$2;
                  }
                  case 66: {
                    const _tmp$11 = view.str;
                    const _bind$6 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$12;
                    if (_bind$6 === undefined) {
                      _tmp$12 = view.end;
                    } else {
                      const _Some = _bind$6;
                      _tmp$12 = _Some;
                    }
                    const _x$8 = { str: _tmp$11, start: _tmp$12, end: view.end };
                    rest = _x$8;
                    break _L$2;
                  }
                  default: {
                    break _L;
                  }
                }
              } else {
                break _L;
              }
            } else {
              break _L;
            }
          }
          return new Result$Ok$1$({ _0: 16, _1: rest$3, _2: true });
        }
        return new Result$Ok$1$({ _0: 8, _1: rest$2, _2: true });
      }
      return new Result$Ok$1$({ _0: 2, _1: rest, _2: true });
    }
    return new Result$Ok$1$({ _0: 10, _1: view, _2: false });
  } else {
    _L: {
      let rest;
      _L$2: {
        let rest$2;
        _L$3: {
          let rest$3;
          _L$4: {
            if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(view.str, 2, view.start, view.end)) {
              const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(view.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 0, view.start, view.end));
              if (_x === 48) {
                const _x$2 = _M0MP311moonbitlang4core6string6String16unsafe__char__at(view.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 1, view.start, view.end));
                switch (_x$2) {
                  case 120: {
                    const _tmp = view.str;
                    const _bind = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$2;
                    if (_bind === undefined) {
                      _tmp$2 = view.end;
                    } else {
                      const _Some = _bind;
                      _tmp$2 = _Some;
                    }
                    const _x$3 = { str: _tmp, start: _tmp$2, end: view.end };
                    if (base === 16) {
                      rest$3 = _x$3;
                      break _L$4;
                    } else {
                      break _L;
                    }
                  }
                  case 88: {
                    const _tmp$3 = view.str;
                    const _bind$2 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$4;
                    if (_bind$2 === undefined) {
                      _tmp$4 = view.end;
                    } else {
                      const _Some = _bind$2;
                      _tmp$4 = _Some;
                    }
                    const _x$4 = { str: _tmp$3, start: _tmp$4, end: view.end };
                    if (base === 16) {
                      rest$3 = _x$4;
                      break _L$4;
                    } else {
                      break _L;
                    }
                  }
                  case 111: {
                    const _tmp$5 = view.str;
                    const _bind$3 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$6;
                    if (_bind$3 === undefined) {
                      _tmp$6 = view.end;
                    } else {
                      const _Some = _bind$3;
                      _tmp$6 = _Some;
                    }
                    const _x$5 = { str: _tmp$5, start: _tmp$6, end: view.end };
                    if (base === 8) {
                      rest$2 = _x$5;
                      break _L$3;
                    } else {
                      break _L;
                    }
                  }
                  case 79: {
                    const _tmp$7 = view.str;
                    const _bind$4 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$8;
                    if (_bind$4 === undefined) {
                      _tmp$8 = view.end;
                    } else {
                      const _Some = _bind$4;
                      _tmp$8 = _Some;
                    }
                    const _x$6 = { str: _tmp$7, start: _tmp$8, end: view.end };
                    if (base === 8) {
                      rest$2 = _x$6;
                      break _L$3;
                    } else {
                      break _L;
                    }
                  }
                  case 98: {
                    const _tmp$9 = view.str;
                    const _bind$5 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$10;
                    if (_bind$5 === undefined) {
                      _tmp$10 = view.end;
                    } else {
                      const _Some = _bind$5;
                      _tmp$10 = _Some;
                    }
                    const _x$7 = { str: _tmp$9, start: _tmp$10, end: view.end };
                    if (base === 2) {
                      rest = _x$7;
                      break _L$2;
                    } else {
                      break _L;
                    }
                  }
                  case 66: {
                    const _tmp$11 = view.str;
                    const _bind$6 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(view.str, 2, view.start, view.end);
                    let _tmp$12;
                    if (_bind$6 === undefined) {
                      _tmp$12 = view.end;
                    } else {
                      const _Some = _bind$6;
                      _tmp$12 = _Some;
                    }
                    const _x$8 = { str: _tmp$11, start: _tmp$12, end: view.end };
                    if (base === 2) {
                      rest = _x$8;
                      break _L$2;
                    } else {
                      break _L;
                    }
                  }
                  default: {
                    break _L;
                  }
                }
              } else {
                break _L;
              }
            } else {
              break _L;
            }
          }
          return new Result$Ok$1$({ _0: 16, _1: rest$3, _2: true });
        }
        return new Result$Ok$1$({ _0: 8, _1: rest$2, _2: true });
      }
      return new Result$Ok$1$({ _0: 2, _1: rest, _2: true });
    }
    return base >= 2 && base <= 36 ? new Result$Ok$1$({ _0: base, _1: view, _2: false }) : _M0FP311moonbitlang4core7strconv9base__errGUiRP311moonbitlang4core6string10StringViewbEE();
  }
}
function _M0FP311moonbitlang4core7strconv10range__errGuE() {
  return new Result$Err$2$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv15range__err__str));
}
function _M0FP311moonbitlang4core7strconv10range__errGlE() {
  return new Result$Err$3$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv15range__err__str));
}
function _M0FP311moonbitlang4core7strconv11syntax__errGiE() {
  return new Result$Err$4$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv16syntax__err__str));
}
function _M0FP311moonbitlang4core7strconv11syntax__errGlE() {
  return new Result$Err$3$(new Error$moonbitlang$47$core$47$strconv$46$StrConvError$46$StrConvError(_M0FP311moonbitlang4core7strconv16syntax__err__str));
}
function _M0FP311moonbitlang4core7strconv19overflow__threshold(base, neg) {
  return !neg ? (base === 10 ? _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($9223372036854775807L, $10L), $1L) : base === 16 ? _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($9223372036854775807L, $16L), $1L) : _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($9223372036854775807L, _M0MP311moonbitlang4core3int3Int9to__int64(base)), $1L)) : base === 10 ? _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($_9223372036854775808L, $10L) : base === 16 ? _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($_9223372036854775808L, $16L) : _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Div3div($_9223372036854775808L, _M0MP311moonbitlang4core3int3Int9to__int64(base));
}
function _M0FP311moonbitlang4core7strconv20parse__int64_2einner(str, base) {
  if (_M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGRP311moonbitlang4core6string10StringViewE(str, { str: _M0FP311moonbitlang4core7strconv36parse__int64_2einner_2e_2abind_7c603, start: 0, end: _M0FP311moonbitlang4core7strconv36parse__int64_2einner_2e_2abind_7c603.length })) {
    let _bind;
    let rest;
    _L: {
      _L$2: {
        const _bind$2 = _M0MP311moonbitlang4core6string10StringView12view_2einner(str, 0, undefined);
        if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_bind$2.str, 1, _bind$2.start, _bind$2.end)) {
          const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_bind$2.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$2.str, 0, _bind$2.start, _bind$2.end));
          switch (_x) {
            case 43: {
              const _tmp = _bind$2.str;
              const _bind$3 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
              let _tmp$2;
              if (_bind$3 === undefined) {
                _tmp$2 = _bind$2.end;
              } else {
                const _Some = _bind$3;
                _tmp$2 = _Some;
              }
              const _x$2 = { str: _tmp, start: _tmp$2, end: _bind$2.end };
              _bind = { _0: false, _1: _x$2 };
              break;
            }
            case 45: {
              const _tmp$3 = _bind$2.str;
              const _bind$4 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
              let _tmp$4;
              if (_bind$4 === undefined) {
                _tmp$4 = _bind$2.end;
              } else {
                const _Some = _bind$4;
                _tmp$4 = _Some;
              }
              const _x$3 = { str: _tmp$3, start: _tmp$4, end: _bind$2.end };
              _bind = { _0: true, _1: _x$3 };
              break;
            }
            default: {
              rest = _bind$2;
              break _L$2;
            }
          }
        } else {
          rest = _bind$2;
          break _L$2;
        }
        break _L;
      }
      _bind = { _0: false, _1: rest };
    }
    const _neg = _bind._0;
    const _rest = _bind._1;
    const _bind$2 = _M0FP311moonbitlang4core7strconv25check__and__consume__base(_rest, base);
    let _bind$3;
    if (_bind$2.$tag === 1) {
      const _ok = _bind$2;
      _bind$3 = _ok._0;
    } else {
      return _bind$2;
    }
    const _num_base = _bind$3._0;
    const _rest$2 = _bind$3._1;
    const _allow_underscore = _bind$3._2;
    const overflow_threshold = _M0FP311moonbitlang4core7strconv19overflow__threshold(_num_base, _neg);
    let has_digit;
    if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_rest$2.str, 1, _rest$2.start, _rest$2.end)) {
      const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_rest$2.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_rest$2.str, 0, _rest$2.start, _rest$2.end));
      if (_x >= 48 && _x <= 57) {
        has_digit = true;
      } else {
        if (_x >= 97 && _x <= 122) {
          has_digit = true;
        } else {
          if (_x >= 65 && _x <= 90) {
            has_digit = true;
          } else {
            if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_rest$2.str, 2, _rest$2.start, _rest$2.end)) {
              if (_x === 95) {
                const _x$2 = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_rest$2.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_rest$2.str, 1, _rest$2.start, _rest$2.end));
                has_digit = _x$2 >= 48 && _x$2 <= 57 ? true : _x$2 >= 97 && _x$2 <= 122 ? true : _x$2 >= 65 && _x$2 <= 90;
              } else {
                has_digit = false;
              }
            } else {
              has_digit = false;
            }
          }
        }
      }
    } else {
      has_digit = false;
    }
    if (has_digit) {
      let _tmp;
      let _tmp$2 = _rest$2;
      let _tmp$3 = $0L;
      let _tmp$4 = _allow_underscore;
      while (true) {
        const _param_0 = _tmp$2;
        const _param_1 = _tmp$3;
        const _param_2 = _tmp$4;
        let acc;
        let rest$2;
        let c;
        _L$2: {
          if (_M0MP311moonbitlang4core6string6String24char__length__eq_2einner(_param_0.str, 1, _param_0.start, _param_0.end)) {
            const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param_0.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 0, _param_0.start, _param_0.end));
            if (_x === 95) {
              const _bind$4 = _M0FP311moonbitlang4core7strconv11syntax__errGlE();
              if (_bind$4.$tag === 1) {
                const _ok = _bind$4;
                _tmp = _ok._0;
                break;
              } else {
                return _bind$4;
              }
            } else {
              const _tmp$5 = _param_0.str;
              const _bind$4 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
              let _tmp$6;
              if (_bind$4 === undefined) {
                _tmp$6 = _param_0.end;
              } else {
                const _Some = _bind$4;
                _tmp$6 = _Some;
              }
              const _x$2 = { str: _tmp$5, start: _tmp$6, end: _param_0.end };
              acc = _param_1;
              rest$2 = _x$2;
              c = _x;
              break _L$2;
            }
          } else {
            if (_M0MP311moonbitlang4core6string6String24char__length__ge_2einner(_param_0.str, 1, _param_0.start, _param_0.end)) {
              const _x = _M0MP311moonbitlang4core6string6String16unsafe__char__at(_param_0.str, _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 0, _param_0.start, _param_0.end));
              if (_x === 95) {
                if (_param_2 === false) {
                  const _bind$4 = _M0FP311moonbitlang4core7strconv11syntax__errGlE();
                  if (_bind$4.$tag === 1) {
                    const _ok = _bind$4;
                    _tmp = _ok._0;
                    break;
                  } else {
                    return _bind$4;
                  }
                } else {
                  const _tmp$5 = _param_0.str;
                  const _bind$4 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
                  let _tmp$6;
                  if (_bind$4 === undefined) {
                    _tmp$6 = _param_0.end;
                  } else {
                    const _Some = _bind$4;
                    _tmp$6 = _Some;
                  }
                  const _x$2 = { str: _tmp$5, start: _tmp$6, end: _param_0.end };
                  _tmp$2 = _x$2;
                  _tmp$4 = false;
                  continue;
                }
              } else {
                const _tmp$5 = _param_0.str;
                const _bind$4 = _M0MP311moonbitlang4core6string6String29offset__of__nth__char_2einner(_param_0.str, 1, _param_0.start, _param_0.end);
                let _tmp$6;
                if (_bind$4 === undefined) {
                  _tmp$6 = _param_0.end;
                } else {
                  const _Some = _bind$4;
                  _tmp$6 = _Some;
                }
                const _x$2 = { str: _tmp$5, start: _tmp$6, end: _param_0.end };
                acc = _param_1;
                rest$2 = _x$2;
                c = _x;
                break _L$2;
              }
            } else {
              _tmp = _param_1;
              break;
            }
          }
        }
        const c$2 = c;
        let d;
        if (c$2 >= 48 && c$2 <= 57) {
          d = c$2 - 48 | 0;
        } else {
          if (c$2 >= 97 && c$2 <= 122) {
            d = c$2 + -87 | 0;
          } else {
            if (c$2 >= 65 && c$2 <= 90) {
              d = c$2 + -55 | 0;
            } else {
              const _bind$4 = _M0FP311moonbitlang4core7strconv11syntax__errGiE();
              if (_bind$4.$tag === 1) {
                const _ok = _bind$4;
                d = _ok._0;
              } else {
                return _bind$4;
              }
            }
          }
        }
        if (d < _num_base) {
          if (_neg) {
            if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGlE(acc, overflow_threshold)) {
              const next_acc = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Sub3sub(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Mul3mul(acc, _M0MP311moonbitlang4core3int3Int9to__int64(_num_base)), _M0MP311moonbitlang4core3int3Int9to__int64(d));
              if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGlE(next_acc, acc)) {
                _tmp$2 = rest$2;
                _tmp$3 = next_acc;
                _tmp$4 = true;
                continue;
              } else {
                const _bind$4 = _M0FP311moonbitlang4core7strconv10range__errGlE();
                if (_bind$4.$tag === 1) {
                  const _ok = _bind$4;
                  _tmp = _ok._0;
                  break;
                } else {
                  return _bind$4;
                }
              }
            } else {
              const _bind$4 = _M0FP311moonbitlang4core7strconv10range__errGlE();
              if (_bind$4.$tag === 1) {
                const _ok = _bind$4;
                _tmp = _ok._0;
                break;
              } else {
                return _bind$4;
              }
            }
          } else {
            if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGlE(acc, overflow_threshold)) {
              const next_acc = _M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Add3add(_M0IP311moonbitlang4core5int645Int64P311moonbitlang4core7builtin3Mul3mul(acc, _M0MP311moonbitlang4core3int3Int9to__int64(_num_base)), _M0MP311moonbitlang4core3int3Int9to__int64(d));
              if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGlE(next_acc, acc)) {
                _tmp$2 = rest$2;
                _tmp$3 = next_acc;
                _tmp$4 = true;
                continue;
              } else {
                const _bind$4 = _M0FP311moonbitlang4core7strconv10range__errGlE();
                if (_bind$4.$tag === 1) {
                  const _ok = _bind$4;
                  _tmp = _ok._0;
                  break;
                } else {
                  return _bind$4;
                }
              }
            } else {
              const _bind$4 = _M0FP311moonbitlang4core7strconv10range__errGlE();
              if (_bind$4.$tag === 1) {
                const _ok = _bind$4;
                _tmp = _ok._0;
                break;
              } else {
                return _bind$4;
              }
            }
          }
        } else {
          const _bind$4 = _M0FP311moonbitlang4core7strconv11syntax__errGlE();
          if (_bind$4.$tag === 1) {
            const _ok = _bind$4;
            _tmp = _ok._0;
            break;
          } else {
            return _bind$4;
          }
        }
      }
      return new Result$Ok$3$(_tmp);
    } else {
      return _M0FP311moonbitlang4core7strconv11syntax__errGlE();
    }
  } else {
    return _M0FP311moonbitlang4core7strconv11syntax__errGlE();
  }
}
function _M0FP311moonbitlang4core7strconv18parse__int_2einner(str, base) {
  const _bind = _M0FP311moonbitlang4core7strconv20parse__int64_2einner(str, base);
  let n;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    n = _ok._0;
  } else {
    return _bind;
  }
  if (_M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__ltGlE(n, _M0MP311moonbitlang4core3int3Int9to__int64(-2147483648)) || _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__gtGlE(n, _M0MP311moonbitlang4core3int3Int9to__int64(2147483647))) {
    const _bind$2 = _M0FP311moonbitlang4core7strconv10range__errGuE();
    if (_bind$2.$tag === 1) {
      const _ok = _bind$2;
      _ok._0;
    } else {
      return _bind$2;
    }
  }
  return new Result$Ok$4$(_M0MP311moonbitlang4core5int645Int647to__int(n));
}
function _M0FP311moonbitlang4core3ref3newGiE(x) {
  return { val: x };
}
function _M0FP311moonbitlang4core3ref3newGRP27sacckey8moon8bit13DriftbirdGameE(x) {
  return { val: x };
}
function _M0FP311moonbitlang4core3ref3newGRP27sacckey8moon8bit7PaletteE(x) {
  return { val: x };
}
function _M0FP311moonbitlang4core3ref3newGbE(x) {
  return { val: x };
}
function _M0FP27sacckey8moon8bit3errGRP27sacckey8moon8bit11AssetBundleE(line, message) {
  return new Result$Err$5$({ line: line, message: message });
}
function _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7PaletteiEE(line, message) {
  return new Result$Err$6$({ line: line, message: message });
}
function _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit6SpriteiEE(line, message) {
  return new Result$Err$7$({ line: line, message: message });
}
function _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7TilemapiEE(line, message) {
  return new Result$Err$8$({ line: line, message: message });
}
function _M0FP27sacckey8moon8bit3errGiE(line, message) {
  return new Result$Err$9$({ line: line, message: message });
}
function _M0FP27sacckey8moon8bit19is__ignorable__line(line) {
  return line.length === 0 ? true : _M0IP311moonbitlang4core6uint166UInt16P311moonbitlang4core7builtin2Eq5equal(line.charCodeAt(0), 35);
}
function _M0FP27sacckey8moon8bit15normalize__line(line) {
  return _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(_M0MP311moonbitlang4core6string6String4trim(line, undefined));
}
function _M0FP27sacckey8moon8bit16palette__default() {
  return { name: "retro16", colors: ["#101820", "#1f4068", "#2e8b57", "#f2aa4c", "#e94f37", "#8f6f4f", "#f6f7eb", "#7f5af0"] };
}
function _M0FP27sacckey8moon8bit17parse__int__token(token, line, field) {
  let _try_err;
  _L: {
    const _bind = _M0FP311moonbitlang4core7strconv18parse__int_2einner({ str: token, start: 0, end: token.length }, 0);
    let _tmp;
    if (_bind.$tag === 1) {
      const _ok = _bind;
      _tmp = _ok._0;
    } else {
      const _err = _bind;
      _try_err = _err._0;
      break _L;
    }
    return new Result$Ok$9$(_tmp);
  }
  return _M0FP27sacckey8moon8bit3errGiE(line, `invalid integer for ${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(field)}: ${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(token)}`);
}
function _M0FP27sacckey8moon8bit9split__ws(line) {
  const _bind = " ";
  return _M0MP311moonbitlang4core7builtin4Iter9to__arrayGsE(_M0MP311moonbitlang4core7builtin4Iter6filterGsE(_M0MP311moonbitlang4core7builtin4Iter3mapGRP311moonbitlang4core6string10StringViewsE(_M0MP311moonbitlang4core6string6String5split(line, { str: _bind, start: 0, end: _bind.length }), _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string), (token) => _M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGsE(token, "")));
}
function _M0FP27sacckey8moon8bit21parse__palette__block(lines, header, start_line_index) {
  const header_line = start_line_index + 1 | 0;
  if (header.length !== 2) {
    return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7PaletteiEE(header_line, "palette header must be: palette <name>");
  }
  const colors = [];
  const name = _M0MP311moonbitlang4core5array5Array2atGsE(header, 1);
  const cursor = { val: start_line_index + 1 | 0 };
  while (true) {
    if (cursor.val < lines.length) {
      const raw = _M0FP27sacckey8moon8bit15normalize__line(_M0MP311moonbitlang4core5array5Array2atGsE(lines, cursor.val));
      const line_no = cursor.val + 1 | 0;
      if (_M0FP27sacckey8moon8bit19is__ignorable__line(raw)) {
        cursor.val = cursor.val + 1 | 0;
        continue;
      }
      if (raw === "end") {
        return new Result$Ok$6$({ _0: { name: name, colors: colors }, _1: cursor.val + 1 | 0 });
      }
      const tokens = _M0FP27sacckey8moon8bit9split__ws(raw);
      if (tokens.length !== 3 || _M0IP016_24default__implP311moonbitlang4core7builtin2Eq10not__equalGsE(_M0MP311moonbitlang4core5array5Array2atGsE(tokens, 0), "color")) {
        return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7PaletteiEE(line_no, "palette row must be: color <index> <hex>");
      }
      let idx;
      let e;
      _L: {
        _L$2: {
          const _bind = _M0FP27sacckey8moon8bit17parse__int__token(_M0MP311moonbitlang4core5array5Array2atGsE(tokens, 1), line_no, "palette index");
          if (_bind.$tag === 1) {
            const _Ok = _bind;
            const _v = _Ok._0;
            idx = _v;
          } else {
            const _Err = _bind;
            const _e = _Err._0;
            e = _e;
            break _L$2;
          }
          break _L;
        }
        return new Result$Err$6$(e);
      }
      if (idx < 0 || idx > 255) {
        return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7PaletteiEE(line_no, "palette index must be in 0..255");
      }
      if (idx !== colors.length) {
        return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7PaletteiEE(line_no, `palette index must be sequential: expected ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(colors.length)}, got ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(idx)}`);
      }
      _M0MP311moonbitlang4core5array5Array4pushGsE(colors, _M0MP311moonbitlang4core5array5Array2atGsE(tokens, 2));
      cursor.val = cursor.val + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7PaletteiEE(header_line, "palette block is missing `end`");
}
function _M0FP27sacckey8moon8bit21decode__pixel__symbol(ch) {
  return ch === 46 ? -1 : ch >= 48 && ch <= 57 ? ch - 48 | 0 : ch >= 97 && ch <= 102 ? (10 + ch | 0) - 97 | 0 : ch >= 65 && ch <= 70 ? (10 + ch | 0) - 65 | 0 : undefined;
}
function _M0FP27sacckey8moon8bit20parse__sprite__block(lines, header, start_line_index) {
  const header_line = start_line_index + 1 | 0;
  if (header.length !== 4) {
    return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit6SpriteiEE(header_line, "sprite header must be: sprite <name> <width> <height>");
  }
  let width;
  let e;
  _L: {
    _L$2: {
      const _bind = _M0FP27sacckey8moon8bit17parse__int__token(_M0MP311moonbitlang4core5array5Array2atGsE(header, 2), header_line, "sprite width");
      if (_bind.$tag === 1) {
        const _Ok = _bind;
        const _v = _Ok._0;
        width = _v;
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$2;
      }
      break _L;
    }
    return new Result$Err$7$(e);
  }
  let height;
  let e$2;
  _L$2: {
    _L$3: {
      const _bind = _M0FP27sacckey8moon8bit17parse__int__token(_M0MP311moonbitlang4core5array5Array2atGsE(header, 3), header_line, "sprite height");
      if (_bind.$tag === 1) {
        const _Ok = _bind;
        const _v = _Ok._0;
        height = _v;
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e$2 = _e;
        break _L$3;
      }
      break _L$2;
    }
    return new Result$Err$7$(e$2);
  }
  if (width <= 0 || height <= 0) {
    return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit6SpriteiEE(header_line, "sprite width/height must be positive");
  }
  const pixels = [];
  const row_count = { val: 0 };
  const cursor = { val: start_line_index + 1 | 0 };
  while (true) {
    if (cursor.val < lines.length) {
      const raw = _M0FP27sacckey8moon8bit15normalize__line(_M0MP311moonbitlang4core5array5Array2atGsE(lines, cursor.val));
      const line_no = cursor.val + 1 | 0;
      if (_M0FP27sacckey8moon8bit19is__ignorable__line(raw)) {
        cursor.val = cursor.val + 1 | 0;
        continue;
      }
      if (raw === "end") {
        if (row_count.val !== height) {
          return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit6SpriteiEE(line_no, `sprite ${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(_M0MP311moonbitlang4core5array5Array2atGsE(header, 1))} expects ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(height)} rows, got ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(row_count.val)}`);
        }
        return new Result$Ok$7$({ _0: { name: _M0MP311moonbitlang4core5array5Array2atGsE(header, 1), width: width, height: height, pixels: pixels }, _1: cursor.val + 1 | 0 });
      }
      if (row_count.val >= height) {
        return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit6SpriteiEE(line_no, "sprite has too many rows");
      }
      if (raw.length !== width) {
        return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit6SpriteiEE(line_no, `sprite row width mismatch: expected ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(width)}, got ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(raw.length)}`);
      }
      const _it = _M0MP311moonbitlang4core6string6String5iter2(raw);
      while (true) {
        let ch;
        _L$3: {
          const _bind = _M0MP311moonbitlang4core7builtin5Iter24nextGicE(_it);
          if (_bind === undefined) {
            break;
          } else {
            const _Some = _bind;
            const _x = _Some;
            const _ch = _x._1;
            ch = _ch;
            break _L$3;
          }
        }
        let value;
        const _bind = _M0FP27sacckey8moon8bit21decode__pixel__symbol(ch);
        if (_bind === undefined) {
          return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit6SpriteiEE(line_no, `unsupported sprite symbol: ${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(_M0IP311moonbitlang4core4char4CharP311moonbitlang4core7builtin4Show10to__string(ch))} (use .,0-9,a-f)`);
        } else {
          const _Some = _bind;
          const _v = _Some;
          value = _v;
        }
        _M0MP311moonbitlang4core5array5Array4pushGiE(pixels, value);
        continue;
      }
      row_count.val = row_count.val + 1 | 0;
      cursor.val = cursor.val + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit6SpriteiEE(header_line, "sprite block is missing `end`");
}
function _M0FP27sacckey8moon8bit21parse__tilemap__block(lines, header, start_line_index) {
  const header_line = start_line_index + 1 | 0;
  if (header.length !== 4) {
    return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7TilemapiEE(header_line, "tilemap header must be: tilemap <name> <width> <height>");
  }
  let width;
  let e;
  _L: {
    _L$2: {
      const _bind = _M0FP27sacckey8moon8bit17parse__int__token(_M0MP311moonbitlang4core5array5Array2atGsE(header, 2), header_line, "tilemap width");
      if (_bind.$tag === 1) {
        const _Ok = _bind;
        const _v = _Ok._0;
        width = _v;
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$2;
      }
      break _L;
    }
    return new Result$Err$8$(e);
  }
  let height;
  let e$2;
  _L$2: {
    _L$3: {
      const _bind = _M0FP27sacckey8moon8bit17parse__int__token(_M0MP311moonbitlang4core5array5Array2atGsE(header, 3), header_line, "tilemap height");
      if (_bind.$tag === 1) {
        const _Ok = _bind;
        const _v = _Ok._0;
        height = _v;
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e$2 = _e;
        break _L$3;
      }
      break _L$2;
    }
    return new Result$Err$8$(e$2);
  }
  if (width <= 0 || height <= 0) {
    return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7TilemapiEE(header_line, "tilemap width/height must be positive");
  }
  const tiles = [];
  const row_count = { val: 0 };
  const cursor = { val: start_line_index + 1 | 0 };
  while (true) {
    if (cursor.val < lines.length) {
      const raw = _M0FP27sacckey8moon8bit15normalize__line(_M0MP311moonbitlang4core5array5Array2atGsE(lines, cursor.val));
      const line_no = cursor.val + 1 | 0;
      if (_M0FP27sacckey8moon8bit19is__ignorable__line(raw)) {
        cursor.val = cursor.val + 1 | 0;
        continue;
      }
      if (raw === "end") {
        if (row_count.val !== height) {
          return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7TilemapiEE(line_no, `tilemap ${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(_M0MP311moonbitlang4core5array5Array2atGsE(header, 1))} expects ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(height)} rows, got ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(row_count.val)}`);
        }
        return new Result$Ok$8$({ _0: { name: _M0MP311moonbitlang4core5array5Array2atGsE(header, 1), width: width, height: height, tiles: tiles }, _1: cursor.val + 1 | 0 });
      }
      if (row_count.val >= height) {
        return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7TilemapiEE(line_no, "tilemap has too many rows");
      }
      const row_tokens = _M0FP27sacckey8moon8bit9split__ws(raw);
      if (row_tokens.length !== width) {
        return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7TilemapiEE(line_no, `tilemap row width mismatch: expected ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(width)}, got ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(row_tokens.length)}`);
      }
      const _arr = row_tokens;
      const _len = _arr.length;
      let _tmp = 0;
      while (true) {
        const _i = _tmp;
        if (_i < _len) {
          const token = _arr[_i];
          let value;
          let e$3;
          _L$3: {
            _L$4: {
              const _bind = _M0FP27sacckey8moon8bit17parse__int__token(token, line_no, "tile id");
              if (_bind.$tag === 1) {
                const _Ok = _bind;
                const _v = _Ok._0;
                value = _v;
              } else {
                const _Err = _bind;
                const _e = _Err._0;
                e$3 = _e;
                break _L$4;
              }
              break _L$3;
            }
            return new Result$Err$8$(e$3);
          }
          if (value < 0) {
            return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7TilemapiEE(line_no, "tile id must be >= 0");
          }
          _M0MP311moonbitlang4core5array5Array4pushGiE(tiles, value);
          _tmp = _i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      row_count.val = row_count.val + 1 | 0;
      cursor.val = cursor.val + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0FP27sacckey8moon8bit3errGURP27sacckey8moon8bit7TilemapiEE(header_line, "tilemap block is missing `end`");
}
function _M0FP27sacckey8moon8bit18parse__assets__dsl(input) {
  const _bind = "\r\n";
  const _tmp = { str: _bind, start: 0, end: _bind.length };
  const _bind$2 = "\n";
  const _tmp$2 = _M0MP311moonbitlang4core6string6String12replace__all(input, _tmp, { str: _bind$2, start: 0, end: _bind$2.length });
  const _bind$3 = "\r";
  const _tmp$3 = { str: _bind$3, start: 0, end: _bind$3.length };
  const _bind$4 = "\n";
  const normalized = _M0MP311moonbitlang4core6string6String12replace__all(_tmp$2, _tmp$3, { str: _bind$4, start: 0, end: _bind$4.length });
  const _bind$5 = "\n";
  const lines = _M0MP311moonbitlang4core7builtin4Iter9to__arrayGsE(_M0MP311moonbitlang4core7builtin4Iter3mapGRP311moonbitlang4core6string10StringViewsE(_M0MP311moonbitlang4core6string6String5split(normalized, { str: _bind$5, start: 0, end: _bind$5.length }), _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string));
  const palette = { val: undefined };
  const sprites = [];
  const tilemaps = [];
  const cursor = { val: 0 };
  while (true) {
    if (cursor.val < lines.length) {
      const raw = _M0FP27sacckey8moon8bit15normalize__line(_M0MP311moonbitlang4core5array5Array2atGsE(lines, cursor.val));
      if (_M0FP27sacckey8moon8bit19is__ignorable__line(raw)) {
        cursor.val = cursor.val + 1 | 0;
        continue;
      }
      const tokens = _M0FP27sacckey8moon8bit9split__ws(raw);
      if (tokens.length === 0) {
        cursor.val = cursor.val + 1 | 0;
        continue;
      }
      const _bind$6 = _M0MP311moonbitlang4core5array5Array2atGsE(tokens, 0);
      switch (_bind$6) {
        case "palette": {
          const _bind$7 = palette.val;
          if (_bind$7 === undefined) {
          } else {
            return _M0FP27sacckey8moon8bit3errGRP27sacckey8moon8bit11AssetBundleE(cursor.val + 1 | 0, "palette can only be defined once");
          }
          let parsed;
          let e;
          _L: {
            _L$2: {
              const _bind$8 = _M0FP27sacckey8moon8bit21parse__palette__block(lines, tokens, cursor.val);
              if (_bind$8.$tag === 1) {
                const _Ok = _bind$8;
                const _v = _Ok._0;
                parsed = _v;
              } else {
                const _Err = _bind$8;
                const _e = _Err._0;
                e = _e;
                break _L$2;
              }
              break _L;
            }
            return new Result$Err$5$(e);
          }
          palette.val = parsed._0;
          cursor.val = parsed._1;
          break;
        }
        case "sprite": {
          let parsed$2;
          let e$2;
          _L$2: {
            _L$3: {
              const _bind$8 = _M0FP27sacckey8moon8bit20parse__sprite__block(lines, tokens, cursor.val);
              if (_bind$8.$tag === 1) {
                const _Ok = _bind$8;
                const _v = _Ok._0;
                parsed$2 = _v;
              } else {
                const _Err = _bind$8;
                const _e = _Err._0;
                e$2 = _e;
                break _L$3;
              }
              break _L$2;
            }
            return new Result$Err$5$(e$2);
          }
          _M0MP311moonbitlang4core5array5Array4pushGRP27sacckey8moon8bit6SpriteE(sprites, parsed$2._0);
          cursor.val = parsed$2._1;
          break;
        }
        case "tilemap": {
          let parsed$3;
          let e$3;
          _L$3: {
            _L$4: {
              const _bind$8 = _M0FP27sacckey8moon8bit21parse__tilemap__block(lines, tokens, cursor.val);
              if (_bind$8.$tag === 1) {
                const _Ok = _bind$8;
                const _v = _Ok._0;
                parsed$3 = _v;
              } else {
                const _Err = _bind$8;
                const _e = _Err._0;
                e$3 = _e;
                break _L$4;
              }
              break _L$3;
            }
            return new Result$Err$5$(e$3);
          }
          _M0MP311moonbitlang4core5array5Array4pushGRP27sacckey8moon8bit7TilemapE(tilemaps, parsed$3._0);
          cursor.val = parsed$3._1;
          break;
        }
        default: {
          return _M0FP27sacckey8moon8bit3errGRP27sacckey8moon8bit11AssetBundleE(cursor.val + 1 | 0, `unknown directive: ${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(_M0MP311moonbitlang4core5array5Array2atGsE(tokens, 0))}`);
        }
      }
      continue;
    } else {
      break;
    }
  }
  let _tmp$4;
  const _bind$6 = palette.val;
  if (_bind$6 === undefined) {
    _tmp$4 = _M0FP27sacckey8moon8bit16palette__default();
  } else {
    const _Some = _bind$6;
    const _p = _Some;
    _tmp$4 = _p;
  }
  return new Result$Ok$5$({ palette: _tmp$4, sprites: sprites, tilemaps: tilemaps });
}
function _M0FP27sacckey8moon8bit23default__engine__config() {
  return { width: 64, height: 48, fps: 30, scale: 4, palette: _M0FP27sacckey8moon8bit16palette__default() };
}
function _M0FP27sacckey8moon8bit21default__bird__sprite() {
  return { name: "bird", width: 5, height: 3, pixels: [-1, 6, 6, 6, -1, 6, 4, 6, 4, 6, -1, 6, 6, 6, -1] };
}
function _M0FP27sacckey8moon8bit19sample__assets__dsl() {
  const _tmp = ["# moon8bit asset DSL v1", "palette dawn", "color 0 #0f1a20", "color 1 #274060", "color 2 #2e8b57", "color 3 #f2aa4c", "color 4 #e94f37", "color 5 #8f6f4f", "color 6 #f6f7eb", "end", "", "sprite bird 5 3", ".666.", "64646", ".666.", "end", "", "tilemap bg 8 6", "0 0 0 0 0 0 0 0", "0 0 1 0 0 1 0 0", "0 0 0 0 0 0 0 0", "0 0 0 0 0 0 0 0", "0 0 0 0 0 0 0 0", "1 0 0 1 0 0 1 0", "end", "", "tilemap ground 8 2", "5 5 5 5 5 5 5 5", "3 3 3 3 3 3 3 3", "end"];
  const _bind = "\n";
  return _M0MP311moonbitlang4core5array5Array4joinGsE(_tmp, { str: _bind, start: 0, end: _bind.length });
}
function _M0FP27sacckey8moon8bit20load__sample__assets() {
  const _bind = _M0FP27sacckey8moon8bit18parse__assets__dsl(_M0FP27sacckey8moon8bit19sample__assets__dsl());
  if (_bind.$tag === 1) {
    const _Ok = _bind;
    const _bundle = _Ok._0;
    return _bundle;
  } else {
    return { palette: _M0FP27sacckey8moon8bit16palette__default(), sprites: [_M0FP27sacckey8moon8bit21default__bird__sprite()], tilemaps: [] };
  }
}
function _M0FP27sacckey8moon8bit20new__driftbird__game(bundle) {
  return { bundle: bundle, bird_x: 8, bird_y: 0, bird_vy: 0, pipe_x: 0, pipe_gap_y: 0, pipe_width: 0, gap_height: 0, score: 0, tick: 0, terrain_offset: 0, is_started: false, is_over: false, last_hit_tag: undefined, pipe_scored: false };
}
function _M0FP27sacckey8moon8bit13make__context(config, input, frame) {
  let dt_ms;
  if (config.fps <= 0) {
    dt_ms = 16;
  } else {
    if (config.fps === 0) {
      $panic();
    }
    dt_ms = 1000 / config.fps | 0;
  }
  return { config: config, input: input, frame: frame, dt_ms: dt_ms };
}
function _M0FP27sacckey8moon8bit12engine__initGRP27sacckey8moon8bit13DriftbirdGameE(initial, config) {
  const context = _M0FP27sacckey8moon8bit13make__context(config, _M0FP27sacckey8moon8bit11input__none, 0);
  return _M0IP27sacckey8moon8bit13DriftbirdGameP27sacckey8moon8bit4Game4init(initial, context);
}
function _M0FP27sacckey8moon8bit12engine__stepGRP27sacckey8moon8bit13DriftbirdGameE(game, config, input, frame) {
  const context = _M0FP27sacckey8moon8bit13make__context(config, input, frame);
  const next = _M0IP27sacckey8moon8bit13DriftbirdGameP27sacckey8moon8bit4Game6update(game, context);
  const rendered = _M0IP27sacckey8moon8bit13DriftbirdGameP27sacckey8moon8bit4Game4draw(next, context);
  return { _0: next, _1: rendered };
}
function _M0FP27sacckey8moon8bit12input__state(flap, reset) {
  return { flap: flap, reset: reset };
}
function _M0FP27sacckey8moon8bit13clamp__double(value, min_value, max_value) {
  return value < min_value ? min_value : value > max_value ? max_value : value;
}
function _M0FP27sacckey8moon8bit14floor__to__int(value) {
  const truncated = _M0MP311moonbitlang4core6double6Double7to__int(value);
  const truncated_double = _M0MP311moonbitlang4core6double6Double9from__int(truncated);
  return value < truncated_double ? truncated - 1 | 0 : truncated;
}
function _M0FP27sacckey8moon8bit11bird__y__px(game) {
  return _M0FP27sacckey8moon8bit14floor__to__int(game.bird_y);
}
function _M0FP27sacckey8moon8bit12next__gap__y(seed, config, gap_height) {
  const ground_y = config.height - 2 | 0;
  const min_gap_top = 5;
  const max_gap_top = (ground_y - gap_height | 0) - 3 | 0;
  if (max_gap_top <= min_gap_top) {
    return min_gap_top;
  }
  const span = (max_gap_top - min_gap_top | 0) + 1 | 0;
  const mixed = (Math.imul(seed, 37) | 0) + 17 | 0;
  const non_negative = mixed < 0 ? -mixed | 0 : mixed;
  if (span === 0) {
    $panic();
  }
  return min_gap_top + (non_negative % span | 0) | 0;
}
function _M0FP27sacckey8moon8bit16reset__driftbird(game, config) {
  game.bird_x = 8;
  if (2 === 0) {
    $panic();
  }
  game.bird_y = _M0MP311moonbitlang4core6double6Double9from__int(config.height / 2 | 0);
  game.bird_vy = 0;
  game.pipe_width = 5;
  game.gap_height = 11;
  game.pipe_x = config.width + 4 | 0;
  game.pipe_gap_y = _M0FP27sacckey8moon8bit12next__gap__y(11, config, game.gap_height);
  game.score = 0;
  game.tick = 0;
  game.terrain_offset = 0;
  game.is_started = false;
  game.is_over = false;
  game.last_hit_tag = undefined;
  game.pipe_scored = false;
  return game;
}
function _M0FP27sacckey8moon8bit10bird__rect(game) {
  return { x: game.bird_x, y: _M0FP27sacckey8moon8bit11bird__y__px(game), w: 5, h: 3 };
}
function _M0MP27sacckey8moon8bit5Frame10set__pixel(self, x, y, color) {
  if (x < 0 || (x >= self.width || (y < 0 || y >= self.height))) {
    return undefined;
  }
  const idx = (Math.imul(y, self.width) | 0) + x | 0;
  _M0MP311moonbitlang4core5array5Array3setGiE(self.pixels, idx, color);
}
function _M0FP27sacckey8moon8bit4pset(frame, x, y, color) {
  _M0MP27sacckey8moon8bit5Frame10set__pixel(frame, x, y, color);
}
function _M0FP27sacckey8moon8bit8tile__at(tilemap, x, y) {
  if (x < 0 || (x >= tilemap.width || (y < 0 || y >= tilemap.height))) {
    return undefined;
  } else {
    const idx = (Math.imul(y, tilemap.width) | 0) + x | 0;
    return _M0MP311moonbitlang4core5array5Array2atGiE(tilemap.tiles, idx);
  }
}
function _M0FP27sacckey8moon8bit30draw__scrolling__tilemap__rows(frame, tilemap, scroll_x, start_y, screen_width, rows) {
  if (tilemap.width <= 0 || (tilemap.height <= 0 || rows <= 0)) {
    return undefined;
  }
  const _start345 = 0;
  const _end346 = rows;
  let _tmp = _start345;
  while (true) {
    const row = _tmp;
    if (row < _end346) {
      if (tilemap.height === 0) {
        $panic();
      }
      const tile_y = row % tilemap.height | 0;
      const _start351 = 0;
      const _end352 = screen_width;
      let _tmp$2 = _start351;
      while (true) {
        const x = _tmp$2;
        if (x < _end352) {
          if (tilemap.width === 0) {
            $panic();
          }
          const tile_x = (x + scroll_x | 0) % tilemap.width | 0;
          let color;
          const _bind = _M0FP27sacckey8moon8bit8tile__at(tilemap, tile_x, tile_y);
          if (_bind === undefined) {
            color = 3;
          } else {
            const _Some = _bind;
            const _v = _Some;
            color = _v;
          }
          _M0FP27sacckey8moon8bit4pset(frame, x, start_y + row | 0, color);
          _tmp$2 = x + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = row + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP27sacckey8moon8bit8collider(tag, rect) {
  return { tag: tag, rect: rect };
}
function _M0FP27sacckey8moon8bit13collider__box(tag, x, y, w, h) {
  return _M0FP27sacckey8moon8bit8collider(tag, { x: x, y: y, w: w, h: h });
}
function _M0FP27sacckey8moon8bit15pipe__colliders(game, config) {
  const ground_y = config.height - 2 | 0;
  const colliders = [];
  _M0MP311moonbitlang4core5array5Array4pushGRP27sacckey8moon8bit8ColliderE(colliders, _M0FP27sacckey8moon8bit13collider__box("pipe_top", game.pipe_x, 0, game.pipe_width, game.pipe_gap_y));
  const bottom_y = game.pipe_gap_y + game.gap_height | 0;
  const bottom_h = ground_y - bottom_y | 0;
  if (bottom_h > 0) {
    _M0MP311moonbitlang4core5array5Array4pushGRP27sacckey8moon8bit8ColliderE(colliders, _M0FP27sacckey8moon8bit13collider__box("pipe_bottom", game.pipe_x, bottom_y, game.pipe_width, bottom_h));
  }
  return colliders;
}
function _M0FP27sacckey8moon8bit16rect__intersects(a, b) {
  const a_right = a.x + a.w | 0;
  const a_bottom = a.y + a.h | 0;
  const b_right = b.x + b.w | 0;
  const b_bottom = b.y + b.h | 0;
  return a.x < b_right && (a_right > b.x && (a.y < b_bottom && a_bottom > b.y));
}
function _M0FP27sacckey8moon8bit20collider__intersects(a, b) {
  return a.rect.w <= 0 || (a.rect.h <= 0 || (b.rect.w <= 0 || b.rect.h <= 0)) ? false : _M0FP27sacckey8moon8bit16rect__intersects(a.rect, b.rect);
}
function _M0FP27sacckey8moon8bit20collider__first__hit(target, others) {
  const _arr = others;
  const _len = _arr.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const other = _arr[_i];
      if (_M0FP27sacckey8moon8bit20collider__intersects(target, other)) {
        return other;
      }
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FP27sacckey8moon8bit22detect__collision__tag(game, config) {
  const ground_y = config.height - 2 | 0;
  const bird = _M0FP27sacckey8moon8bit10bird__rect(game);
  const bird_top = _M0FP27sacckey8moon8bit11bird__y__px(game);
  if (game.bird_y < 0) {
    return "ceiling";
  }
  if ((bird_top + bird.h | 0) > ground_y) {
    return "ground";
  }
  const bird_collider = _M0FP27sacckey8moon8bit8collider("bird", bird);
  const obstacles = _M0FP27sacckey8moon8bit15pipe__colliders(game, config);
  let hit;
  _L: {
    const _bind = _M0FP27sacckey8moon8bit20collider__first__hit(bird_collider, obstacles);
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _hit = _Some;
      hit = _hit;
      break _L;
    }
  }
  return hit.tag;
}
function _M0MP27sacckey8moon8bit13DriftbirdGame5score(self) {
  return self.score;
}
function _M0MP27sacckey8moon8bit13DriftbirdGame8is__over(self) {
  return self.is_over;
}
function _M0MP27sacckey8moon8bit13DriftbirdGame11is__started(self) {
  return self.is_started;
}
function _M0MP27sacckey8moon8bit13DriftbirdGame14last__hit__tag(self) {
  return self.last_hit_tag;
}
function _M0FP27sacckey8moon8bit13step__running(game, ctx) {
  const flap_impulse = -2.5;
  const gravity_up = 0.42;
  const gravity_base_down = 0.16;
  const gravity_down_gain = 0.04;
  const gravity_down_max = 0.28;
  const min_vy = -2.35;
  const max_vy = 4.8;
  if (ctx.input.flap) {
    game.bird_vy = flap_impulse;
  }
  const g = game.bird_vy < 0 ? gravity_up : _M0FP27sacckey8moon8bit13clamp__double(gravity_base_down + game.bird_vy * gravity_down_gain, gravity_base_down, gravity_down_max);
  game.bird_vy = _M0FP27sacckey8moon8bit13clamp__double(game.bird_vy + g, min_vy, max_vy);
  game.bird_y = game.bird_y + game.bird_vy;
  game.pipe_x = game.pipe_x - 1 | 0;
  if (!game.pipe_scored && (game.pipe_x + game.pipe_width | 0) < game.bird_x) {
    game.score = game.score + 1 | 0;
    game.pipe_scored = true;
  }
  if ((game.pipe_x + game.pipe_width | 0) < 0) {
    game.pipe_x = ctx.config.width + 6 | 0;
    game.pipe_gap_y = _M0FP27sacckey8moon8bit12next__gap__y(game.tick + 97 | 0, ctx.config, game.gap_height);
    game.pipe_scored = false;
  }
  if (ctx.config.width === 0) {
    $panic();
  }
  game.terrain_offset = (game.terrain_offset + 1 | 0) % ctx.config.width | 0;
  game.tick = game.tick + 1 | 0;
  let tag;
  _L: {
    _L$2: {
      const _bind = _M0FP27sacckey8moon8bit22detect__collision__tag(game, ctx.config);
      if (_bind === undefined) {
      } else {
        const _Some = _bind;
        const _tag = _Some;
        tag = _tag;
        break _L$2;
      }
      break _L;
    }
    game.last_hit_tag = tag;
    game.is_over = true;
  }
  return game;
}
function _M0IP27sacckey8moon8bit13DriftbirdGameP27sacckey8moon8bit4Game4init(self, ctx) {
  return _M0FP27sacckey8moon8bit16reset__driftbird(self, ctx.config);
}
function _M0IP27sacckey8moon8bit13DriftbirdGameP27sacckey8moon8bit4Game6update(self, ctx) {
  if (ctx.input.reset) {
    return _M0FP27sacckey8moon8bit16reset__driftbird(self, ctx.config);
  }
  if (self.is_over) {
    if (!ctx.input.flap) {
      return self;
    }
    const restarted = _M0FP27sacckey8moon8bit16reset__driftbird(self, ctx.config);
    restarted.is_started = true;
    return _M0FP27sacckey8moon8bit13step__running(restarted, ctx);
  }
  if (!self.is_started) {
    if (!ctx.input.flap) {
      return self;
    }
    self.is_started = true;
  }
  return _M0FP27sacckey8moon8bit13step__running(self, ctx);
}
function _M0FP27sacckey8moon8bit12find__sprite(bundle, name) {
  const _arr = bundle.sprites;
  const _len = _arr.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const sprite = _arr[_i];
      if (sprite.name === name) {
        return sprite;
      }
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FP27sacckey8moon8bit13find__tilemap(bundle, name) {
  const _arr = bundle.tilemaps;
  const _len = _arr.length;
  let _tmp = 0;
  while (true) {
    const _i = _tmp;
    if (_i < _len) {
      const tilemap = _arr[_i];
      if (tilemap.name === name) {
        return tilemap;
      }
      _tmp = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0MP27sacckey8moon8bit5Frame10draw__rect(self, x, y, w, h, color) {
  const _start184 = y;
  const _end185 = y + h | 0;
  let _tmp = _start184;
  while (true) {
    const py = _tmp;
    if (py < _end185) {
      const _start189 = x;
      const _end190 = x + w | 0;
      let _tmp$2 = _start189;
      while (true) {
        const px = _tmp$2;
        if (px < _end190) {
          _M0MP27sacckey8moon8bit5Frame10set__pixel(self, px, py, color);
          _tmp$2 = px + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = py + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP27sacckey8moon8bit4rect(frame, x, y, w, h, color) {
  _M0MP27sacckey8moon8bit5Frame10draw__rect(frame, x, y, w, h, color);
}
function _M0MP27sacckey8moon8bit5Frame4blit(self, sprite, x, y) {
  const _start166 = 0;
  const _end167 = sprite.height;
  let _tmp = _start166;
  while (true) {
    const sy = _tmp;
    if (sy < _end167) {
      const _start171 = 0;
      const _end172 = sprite.width;
      let _tmp$2 = _start171;
      while (true) {
        const sx = _tmp$2;
        if (sx < _end172) {
          const idx = (Math.imul(sy, sprite.width) | 0) + sx | 0;
          const color = _M0MP311moonbitlang4core5array5Array2atGiE(sprite.pixels, idx);
          if (color >= 0) {
            _M0MP27sacckey8moon8bit5Frame10set__pixel(self, x + sx | 0, y + sy | 0, color);
          }
          _tmp$2 = sx + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = sy + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP27sacckey8moon8bit3spr(frame, sprite, x, y) {
  _M0MP27sacckey8moon8bit5Frame4blit(frame, sprite, x, y);
}
function _M0MP27sacckey8moon8bit5Frame11new_2einner(width, height, fill) {
  return { width: width, height: height, pixels: _M0MP311moonbitlang4core5array5Array4makeGiE(Math.imul(width, height) | 0, fill) };
}
function _M0IP27sacckey8moon8bit13DriftbirdGameP27sacckey8moon8bit4Game4draw(self, ctx) {
  const frame = _M0MP27sacckey8moon8bit5Frame11new_2einner(ctx.config.width, ctx.config.height, 0);
  const ground_rows = ctx.config.height >= 2 ? 2 : ctx.config.height;
  const ground_y = ctx.config.height - ground_rows | 0;
  const background_rows = ground_y > 0 ? ground_y : 0;
  let tilemap;
  _L: {
    _L$2: {
      const _bind = _M0FP27sacckey8moon8bit13find__tilemap(self.bundle, "bg");
      if (_bind === undefined) {
        const _start294 = 0;
        const _end295 = ctx.config.width;
        let _tmp = _start294;
        while (true) {
          const x = _tmp;
          if (x < _end295) {
            if (7 === 0) {
              $panic();
            }
            if (((x + self.terrain_offset | 0) % 7 | 0) === 0) {
              _M0FP27sacckey8moon8bit4pset(frame, x, 1, 1);
            }
            if (11 === 0) {
              $panic();
            }
            if (((x + self.terrain_offset | 0) % 11 | 0) === 0) {
              _M0FP27sacckey8moon8bit4pset(frame, x, 3, 1);
            }
            _tmp = x + 1 | 0;
            continue;
          } else {
            break;
          }
        }
      } else {
        const _Some = _bind;
        const _tilemap = _Some;
        tilemap = _tilemap;
        break _L$2;
      }
      break _L;
    }
    if (2 === 0) {
      $panic();
    }
    _M0FP27sacckey8moon8bit30draw__scrolling__tilemap__rows(frame, tilemap, self.terrain_offset / 2 | 0, 0, ctx.config.width, background_rows);
  }
  let tilemap$2;
  _L$2: {
    _L$3: {
      const _bind = _M0FP27sacckey8moon8bit13find__tilemap(self.bundle, "ground");
      if (_bind === undefined) {
        _M0FP27sacckey8moon8bit4rect(frame, 0, ground_y, ctx.config.width, ground_rows, 3);
      } else {
        const _Some = _bind;
        const _tilemap = _Some;
        tilemap$2 = _tilemap;
        break _L$3;
      }
      break _L$2;
    }
    _M0FP27sacckey8moon8bit30draw__scrolling__tilemap__rows(frame, tilemap$2, self.terrain_offset, ground_y, ctx.config.width, ground_rows);
  }
  _M0FP27sacckey8moon8bit4rect(frame, self.pipe_x, 0, self.pipe_width, self.pipe_gap_y, 2);
  const bottom_y = self.pipe_gap_y + self.gap_height | 0;
  const bottom_h = ground_y - bottom_y | 0;
  if (bottom_h > 0) {
    _M0FP27sacckey8moon8bit4rect(frame, self.pipe_x, bottom_y, self.pipe_width, bottom_h, 2);
  }
  let sprite;
  const _bind = _M0FP27sacckey8moon8bit12find__sprite(self.bundle, "bird");
  if (_bind === undefined) {
    sprite = _M0FP27sacckey8moon8bit21default__bird__sprite();
  } else {
    const _Some = _bind;
    const _found = _Some;
    sprite = _found;
  }
  _M0FP27sacckey8moon8bit3spr(frame, sprite, self.bird_x, _M0FP27sacckey8moon8bit11bird__y__px(self));
  if (!self.is_started) {
    _M0FP27sacckey8moon8bit4rect(frame, 0, 0, ctx.config.width, 1, 6);
  } else {
    if (self.is_over) {
      _M0FP27sacckey8moon8bit4rect(frame, 0, 0, ctx.config.width, 1, 4);
    }
  }
  return frame;
}
function _M0FP47sacckey8moon8bit3cmd3web14palette__color(index) {
  const palette = _M0FP47sacckey8moon8bit3cmd3web12palette__ref.val;
  return index >= 0 && index < palette.colors.length ? _M0MP311moonbitlang4core5array5Array2atGsE(palette.colors, index) : "#101820";
}
function _M0FP47sacckey8moon8bit3cmd3web11poll__input() {
  const flap_down = _M0FP47sacckey8moon8bit3cmd3web14web__key__down("Space") || _M0FP47sacckey8moon8bit3cmd3web14web__key__down("ArrowUp");
  const flap = flap_down && !_M0FP47sacckey8moon8bit3cmd3web15flap__prev__ref.val;
  _M0FP47sacckey8moon8bit3cmd3web15flap__prev__ref.val = flap_down;
  const reset_down = _M0FP47sacckey8moon8bit3cmd3web14web__key__down("KeyR");
  const reset = reset_down && !_M0FP47sacckey8moon8bit3cmd3web16reset__prev__ref.val;
  _M0FP47sacckey8moon8bit3cmd3web16reset__prev__ref.val = reset_down;
  return _M0FP27sacckey8moon8bit12input__state(flap, reset);
}
function _M0FP47sacckey8moon8bit3cmd3web11draw__frame(frame) {
  _M0FP47sacckey8moon8bit3cmd3web10web__clear(_M0FP47sacckey8moon8bit3cmd3web14palette__color(0));
  const _start14 = 0;
  const _end15 = frame.height;
  let _tmp = _start14;
  while (true) {
    const y = _tmp;
    if (y < _end15) {
      const _start19 = 0;
      const _end20 = frame.width;
      let _tmp$2 = _start19;
      while (true) {
        const x = _tmp$2;
        if (x < _end20) {
          const color = _M0MP311moonbitlang4core5array5Array2atGiE(frame.pixels, (Math.imul(y, frame.width) | 0) + x | 0);
          if (color >= 0) {
            _M0FP47sacckey8moon8bit3cmd3web15web__fill__rect(x, y, 1, 1, _M0FP47sacckey8moon8bit3cmd3web14palette__color(color));
          }
          _tmp$2 = x + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = y + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP47sacckey8moon8bit3cmd3web4tick() {
  const frame_index = _M0FP47sacckey8moon8bit3cmd3web10frame__ref.val;
  const input = _M0FP47sacckey8moon8bit3cmd3web11poll__input();
  let next;
  let rendered;
  _L: {
    const _bind = _M0FP27sacckey8moon8bit12engine__stepGRP27sacckey8moon8bit13DriftbirdGameE(_M0FP47sacckey8moon8bit3cmd3web10state__ref.val, _M0FP47sacckey8moon8bit3cmd3web6config, input, frame_index);
    const _next = _bind._0;
    const _rendered = _bind._1;
    next = _next;
    rendered = _rendered;
    break _L;
  }
  _M0FP47sacckey8moon8bit3cmd3web10state__ref.val = next;
  _M0FP47sacckey8moon8bit3cmd3web10frame__ref.val = frame_index + 1 | 0;
  _M0FP47sacckey8moon8bit3cmd3web11draw__frame(rendered);
  let hit_tag;
  const _bind = _M0MP27sacckey8moon8bit13DriftbirdGame14last__hit__tag(next);
  if (_bind === undefined) {
    hit_tag = "-";
  } else {
    const _Some = _bind;
    const _v = _Some;
    hit_tag = _v;
  }
  if (!_M0MP27sacckey8moon8bit13DriftbirdGame11is__started(next)) {
    _M0FP47sacckey8moon8bit3cmd3web16web__set__status(`moon8bit driftbird demo  PRESS SPACE TO START  score=${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(_M0MP27sacckey8moon8bit13DriftbirdGame5score(next))}  frame=${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(_M0FP47sacckey8moon8bit3cmd3web10frame__ref.val)}  hit=${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(hit_tag)}  reset=R`);
    return;
  } else {
    if (_M0MP27sacckey8moon8bit13DriftbirdGame8is__over(next)) {
      _M0FP47sacckey8moon8bit3cmd3web16web__set__status(`moon8bit driftbird demo  GAME OVER - PRESS SPACE TO RESTART  score=${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(_M0MP27sacckey8moon8bit13DriftbirdGame5score(next))}  frame=${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(_M0FP47sacckey8moon8bit3cmd3web10frame__ref.val)}  hit=${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(hit_tag)}  reset=R`);
      return;
    } else {
      _M0FP47sacckey8moon8bit3cmd3web16web__set__status(`moon8bit driftbird demo  score=${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(_M0MP27sacckey8moon8bit13DriftbirdGame5score(next))}  frame=${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(_M0FP47sacckey8moon8bit3cmd3web10frame__ref.val)}  hit=${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(hit_tag)}  reset=R`);
      return;
    }
  }
}
function _M0FP47sacckey8moon8bit3cmd3web16apply__dsl__text(dsl_text) {
  let bundle;
  let err;
  _L: {
    _L$2: {
      const _bind = _M0FP27sacckey8moon8bit18parse__assets__dsl(dsl_text);
      if (_bind.$tag === 1) {
        const _Ok = _bind;
        const _parsed = _Ok._0;
        bundle = _parsed;
      } else {
        const _Err = _bind;
        const _err = _Err._0;
        err = _err;
        break _L$2;
      }
      break _L;
    }
    _M0FP47sacckey8moon8bit3cmd3web26web__set__editor__feedback(`Parse error at line ${_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(err.line)}: ${_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(err.message)}`, true);
    return undefined;
  }
  _M0FP47sacckey8moon8bit3cmd3web10state__ref.val = _M0FP27sacckey8moon8bit12engine__initGRP27sacckey8moon8bit13DriftbirdGameE(_M0FP27sacckey8moon8bit20new__driftbird__game(bundle), _M0FP47sacckey8moon8bit3cmd3web6config);
  _M0FP47sacckey8moon8bit3cmd3web12palette__ref.val = bundle.palette;
  _M0FP47sacckey8moon8bit3cmd3web10frame__ref.val = 0;
  _M0FP47sacckey8moon8bit3cmd3web26web__set__editor__feedback("Applied DSL successfully", false);
  _M0FP47sacckey8moon8bit3cmd3web4tick();
}
function _M0FP47sacckey8moon8bit3cmd3web9on__apply() {
  _M0FP47sacckey8moon8bit3cmd3web16apply__dsl__text(_M0FP47sacckey8moon8bit3cmd3web22web__get__editor__text());
}
function _M0FP47sacckey8moon8bit3cmd3web10on__export() {
  const current = _M0FP47sacckey8moon8bit3cmd3web22web__get__editor__text();
  _M0FP47sacckey8moon8bit3cmd3web19web__download__text("moon8bit_assets.dsl", current);
  _M0FP47sacckey8moon8bit3cmd3web26web__set__editor__feedback("Exported DSL as moon8bit_assets.dsl", false);
}
function _M0FP47sacckey8moon8bit3cmd3web10on__import(dsl_text) {
  _M0FP47sacckey8moon8bit3cmd3web22web__set__editor__text(dsl_text);
  _M0FP47sacckey8moon8bit3cmd3web16apply__dsl__text(dsl_text);
}
(() => {
  _M0FP47sacckey8moon8bit3cmd3web17web__init__canvas(_M0FP47sacckey8moon8bit3cmd3web6config.width, _M0FP47sacckey8moon8bit3cmd3web6config.height, _M0FP47sacckey8moon8bit3cmd3web14display__scale);
  _M0FP47sacckey8moon8bit3cmd3web22web__set__editor__text(_M0FP27sacckey8moon8bit19sample__assets__dsl());
  _M0FP47sacckey8moon8bit3cmd3web16web__bind__apply(_M0FP47sacckey8moon8bit3cmd3web9on__apply);
  _M0FP47sacckey8moon8bit3cmd3web17web__bind__export(_M0FP47sacckey8moon8bit3cmd3web10on__export);
  _M0FP47sacckey8moon8bit3cmd3web17web__bind__import(_M0FP47sacckey8moon8bit3cmd3web10on__import);
  _M0FP47sacckey8moon8bit3cmd3web9on__apply();
  _M0FP47sacckey8moon8bit3cmd3web16web__start__loop(_M0FP47sacckey8moon8bit3cmd3web4tick, _M0FP47sacckey8moon8bit3cmd3web6config.fps);
})();
//# sourceMappingURL=web.js.map
