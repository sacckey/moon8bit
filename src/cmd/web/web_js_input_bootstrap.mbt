///|
extern "js" fn web_keys_down() -> Array[String] =
  #| () => {
  #|   if (!globalThis.__moon8bit_keys) return [];
  #|   return Array.from(globalThis.__moon8bit_keys);
  #| }

///|
extern "js" fn web_pointer_x() -> Int =
  #| () => {
  #|   const p = globalThis.__moon8bit_pointer || { x: 0 };
  #|   return Number.isFinite(p.x) ? (p.x | 0) : 0;
  #| }

///|
extern "js" fn web_pointer_y() -> Int =
  #| () => {
  #|   const p = globalThis.__moon8bit_pointer || { y: 0 };
  #|   return Number.isFinite(p.y) ? (p.y | 0) : 0;
  #| }

///|
extern "js" fn web_pointer_down() -> Bool =
  #| () => !!(globalThis.__moon8bit_pointer && globalThis.__moon8bit_pointer.down)

///|
extern "js" fn web_bootstrap_game(
  on_ok : (String, String, String, String) -> Unit,
  on_error : (String) -> Unit,
) -> Unit =
  #| (on_ok, on_error) => {
  #|   const fail = (msg) => {
  #|     try { on_error(String(msg)); } catch (_) {}
  #|   };
  #|
  #|   let gameId = "";
  #|   try {
  #|     const loc = globalThis.location;
  #|     const path = String((loc && loc.pathname) || "");
  #|     const m = path.match(/\/g\/([^\/?#]+)/);
  #|     if (m && m[1]) {
  #|       gameId = decodeURIComponent(m[1]);
  #|     } else {
  #|       const query = new URLSearchParams(String((loc && loc.search) || ""));
  #|       gameId = query.get("game") || "";
  #|     }
  #|   } catch (_) {
  #|     gameId = "";
  #|   }
  #|
  #|   if (!gameId) {
  #|     fail("Cannot determine game id from URL. Open /g/<game_id>/ path.");
  #|     return;
  #|   }
  #|
  #|   Promise.all([
  #|     fetch("./game_spec.json", { cache: "no-store" }),
  #|     fetch("./assets.dsl", { cache: "no-store" }),
  #|   ])
  #|     .then(async ([specResp, dslResp]) => {
  #|       if (!specResp.ok) {
  #|         throw new Error(`Failed to load game_spec.json: HTTP ${specResp.status}`);
  #|       }
  #|       if (!dslResp.ok) {
  #|         throw new Error(`Failed to load assets.dsl: HTTP ${dslResp.status}`);
  #|       }
  #|
  #|       const spec = await specResp.json();
  #|       const dslText = await dslResp.text();
  #|
  #|       const id = String((spec && spec.id) || "");
  #|       const title = String((spec && spec.title) || "");
  #|       const statusText = String((spec && spec.status_text) || "");
  #|       const exportFilename = String((spec && spec.export_filename) || "");
  #|
  #|       if (!id || !title || !statusText || !exportFilename) {
  #|         throw new Error("Invalid game_spec.json: id/title/status_text/export_filename are required.");
  #|       }
  #|       if (id !== gameId) {
  #|         throw new Error(`game_spec.json id mismatch: expected '${gameId}', got '${id}'.`);
  #|       }
  #|
  #|       try { on_ok(title, statusText, exportFilename, dslText); } catch (_) {}
  #|     })
  #|     .catch((err) => {
  #|       fail((err && err.message) ? err.message : String(err));
  #|     });
  #| }

///|
