///|
extern "js" fn web_render_frame(
  pixels : Array[Int],
  width : Int,
  height : Int,
  colors : Array[String],
) -> Unit =
  #| (pixels, width, height, colors) => {
  #|   // --- palette cache ---
  #|   // Build or refresh a Uint8Array[256*4] RGBA cache from the color strings.
  #|   // We compare a simple hash so we only rebuild when the palette changes.
  #|   const paletteLen = colors.length;
  #|   let paletteHash = paletteLen;
  #|   for (let i = 0; i < paletteLen; i++) paletteHash = (paletteHash * 31 + (colors[i].charCodeAt(1) || 0)) | 0;
  #|
  #|   if (!globalThis.__moon8bit_palette_rgba || globalThis.__moon8bit_palette_hash !== paletteHash) {
  #|     const rgba = new Uint8Array(256 * 4);
  #|     for (let i = 0; i < paletteLen && i < 256; i++) {
  #|       const hex = colors[i].replace("#", "");
  #|       rgba[i * 4 + 0] = parseInt(hex.slice(0, 2), 16);
  #|       rgba[i * 4 + 1] = parseInt(hex.slice(2, 4), 16);
  #|       rgba[i * 4 + 2] = parseInt(hex.slice(4, 6), 16);
  #|       rgba[i * 4 + 3] = 255;
  #|     }
  #|     // color index -1 means transparent — use index 0 color
  #|     globalThis.__moon8bit_palette_rgba = rgba;
  #|     globalThis.__moon8bit_palette_hash = paletteHash;
  #|   }
  #|   const paletteRgba = globalThis.__moon8bit_palette_rgba;
  #|
  #|   // --- build pixel buffer ---
  #|   const n = width * height;
  #|   if (!globalThis.__moon8bit_pixel_buf || globalThis.__moon8bit_pixel_buf.length !== n * 4) {
  #|     globalThis.__moon8bit_pixel_buf = new Uint8Array(n * 4);
  #|     globalThis.__moon8bit_pixel_buf_clamped = new Uint8ClampedArray(globalThis.__moon8bit_pixel_buf.buffer);
  #|   }
  #|   const buf = globalThis.__moon8bit_pixel_buf;
  #|   for (let i = 0; i < n; i++) {
  #|     const idx = pixels[i] < 0 ? 0 : pixels[i];
  #|     const base = (idx & 0xFF) * 4;
  #|     const dst = i * 4;
  #|     buf[dst]     = paletteRgba[base];
  #|     buf[dst + 1] = paletteRgba[base + 1];
  #|     buf[dst + 2] = paletteRgba[base + 2];
  #|     buf[dst + 3] = paletteRgba[base + 3];
  #|   }
  #|
  #|   // --- dispatch to active renderer ---
  #|   if (globalThis.__moon8bit_render_fn) {
  #|     globalThis.__moon8bit_render_fn(buf, width, height);
  #|   }
  #| }

///|
extern "js" fn web_init_gpu(width : Int, height : Int) -> Unit =
  #| (width, height) => {
  #|   const canvas = document.getElementById("moon8bit-canvas");
  #|   if (!canvas) return;
  #|   const applyCanvasSize = (w, h) => {
  #|     if (canvas.width !== w) canvas.width = w;
  #|     if (canvas.height !== h) canvas.height = h;
  #|     globalThis.__moon8bit_logical_width = w;
  #|     globalThis.__moon8bit_logical_height = h;
  #|     if (globalThis.__moon8bit_resize_canvas) {
  #|       globalThis.__moon8bit_resize_canvas();
  #|     }
  #|   };
  #|
  #|   const init2dFallback = () => {
  #|     const ctx2d = canvas.getContext("2d", { alpha: false });
  #|     if (!ctx2d) return;
  #|     ctx2d.imageSmoothingEnabled = false;
  #|     globalThis.__moon8bit_ctx = ctx2d;
  #|     globalThis.__moon8bit_renderer_kind = "2d";
  #|     globalThis.__moon8bit_render_fn = (pixelBuf, w, h) => {
  #|       applyCanvasSize(w, h);
  #|       const clamped = new Uint8ClampedArray(
  #|         pixelBuf.buffer,
  #|         pixelBuf.byteOffset,
  #|         pixelBuf.byteLength,
  #|       );
  #|       const imgData = new ImageData(clamped, w, h);
  #|       ctx2d.putImageData(imgData, 0, 0);
  #|     };
  #|   };
  #|
  #|   applyCanvasSize(width, height);
  #|
  #|   if (!navigator.gpu) {
  #|     init2dFallback();
  #|     return;
  #|   }
  #|
  #|   const initWebGPU = async () => {
  #|     try {
  #|       const adapter = await navigator.gpu.requestAdapter();
  #|       if (!adapter) {
  #|         init2dFallback();
  #|         return;
  #|       }
  #|
  #|       const device = await adapter.requestDevice();
  #|       if (!device) {
  #|         init2dFallback();
  #|         return;
  #|       }
  #|
  #|       // Handle device lost — fall back to Canvas2D
  #|       device.lost.then(() => {
  #|         init2dFallback();
  #|       });
  #|
  #|       const context = canvas.getContext("webgpu");
  #|       if (!context) {
  #|         init2dFallback();
  #|         return;
  #|       }
  #|
  #|       const format = navigator.gpu.getPreferredCanvasFormat();
  #|       const sampler = device.createSampler({
  #|         magFilter: "nearest",
  #|         minFilter: "nearest",
  #|         addressModeU: "clamp-to-edge",
  #|         addressModeV: "clamp-to-edge",
  #|       });
  #|
  #|       // Full-screen triangle shader
  #|       const shaderSrc = `
  #|         @group(0) @binding(0) var tex: texture_2d<f32>;
  #|         @group(0) @binding(1) var samp: sampler;
  #|
  #|         struct VSOut { @builtin(position) pos: vec4f, @location(0) uv: vec2f };
  #|
  #|         @vertex fn vs(@builtin(vertex_index) vi: u32) -> VSOut {
  #|           var pos = array<vec2f,3>(
  #|             vec2f(-1.0, -1.0),
  #|             vec2f( 3.0, -1.0),
  #|             vec2f(-1.0,  3.0),
  #|           );
  #|           var uv = array<vec2f,3>(
  #|             vec2f(0.0, 1.0),
  #|             vec2f(2.0, 1.0),
  #|             vec2f(0.0,-1.0),
  #|           );
  #|           var out: VSOut;
  #|           out.pos = vec4f(pos[vi], 0.0, 1.0);
  #|           out.uv  = uv[vi];
  #|           return out;
  #|         }
  #|
  #|         @fragment fn fs(in: VSOut) -> @location(0) vec4f {
  #|           return textureSample(tex, samp, in.uv);
  #|         }
  #|       `;
  #|
  #|       const shader = device.createShaderModule({ code: shaderSrc });
  #|       const pipeline = device.createRenderPipeline({
  #|         layout: "auto",
  #|         vertex:   { module: shader, entryPoint: "vs" },
  #|         fragment: { module: shader, entryPoint: "fs",
  #|                     targets: [{ format }] },
  #|         primitive: { topology: "triangle-list" },
  #|       });
  #|
  #|       let texW = 0;
  #|       let texH = 0;
  #|       let texture = null;
  #|       let bindGroup = null;
  #|       let uploadBuffer = null;
  #|       let bytesPerRow = 0;
  #|       let staging = null;
  #|
  #|       const ensureResources = (w, h) => {
  #|         if (w === texW && h === texH) return;
  #|         texW = w;
  #|         texH = h;
  #|         applyCanvasSize(w, h);
  #|         context.configure({ device, format, alphaMode: "opaque" });
  #|
  #|         texture = device.createTexture({
  #|           size: [w, h],
  #|           format: "rgba8unorm",
  #|           usage: GPUTextureUsage.TEXTURE_BINDING | GPUTextureUsage.COPY_DST,
  #|         });
  #|
  #|         bindGroup = device.createBindGroup({
  #|           layout: pipeline.getBindGroupLayout(0),
  #|           entries: [
  #|             { binding: 0, resource: texture.createView() },
  #|             { binding: 1, resource: sampler },
  #|           ],
  #|         });
  #|
  #|         bytesPerRow = Math.ceil((w * 4) / 256) * 256;
  #|         uploadBuffer = device.createBuffer({
  #|           size: bytesPerRow * h,
  #|           usage: GPUBufferUsage.COPY_SRC | GPUBufferUsage.COPY_DST,
  #|         });
  #|         staging = new Uint8Array(bytesPerRow * h);
  #|       };
  #|
  #|       // Render function — called every frame
  #|       globalThis.__moon8bit_render_fn = (pixelBuf, w, h) => {
  #|         ensureResources(w, h);
  #|         for (let row = 0; row < h; row++) {
  #|           const src0 = row * w * 4;
  #|           const src1 = src0 + w * 4;
  #|           staging.set(pixelBuf.subarray(src0, src1), row * bytesPerRow);
  #|         }
  #|
  #|         device.queue.writeBuffer(uploadBuffer, 0, staging);
  #|
  #|         const encoder = device.createCommandEncoder();
  #|         encoder.copyBufferToTexture(
  #|           { buffer: uploadBuffer, bytesPerRow, rowsPerImage: h },
  #|           { texture },
  #|           [w, h],
  #|         );
  #|
  #|         const pass = encoder.beginRenderPass({
  #|           colorAttachments: [{
  #|             view: context.getCurrentTexture().createView(),
  #|             loadOp: "clear",
  #|             storeOp: "store",
  #|             clearValue: { r: 0, g: 0, b: 0, a: 1 },
  #|           }],
  #|         });
  #|         pass.setPipeline(pipeline);
  #|         pass.setBindGroup(0, bindGroup);
  #|         pass.draw(3);
  #|         pass.end();
  #|         device.queue.submit([encoder.finish()]);
  #|       };
  #|       globalThis.__moon8bit_renderer_kind = "webgpu";
  #|
  #|     } catch (_) {
  #|       // requestAdapter / requestDevice failed — stay on Canvas2D
  #|       init2dFallback();
  #|     }
  #|   };
  #|
  #|   initWebGPU();
  #| }
