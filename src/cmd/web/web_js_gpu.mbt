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
  #|     return;
  #|   }
  #|
  #|   // Renderer not yet ready — use Canvas2D as immediate fallback.
  #|   const ctx2d = globalThis.__moon8bit_ctx;
  #|   if (!ctx2d) return;
  #|   const imgData = new ImageData(globalThis.__moon8bit_pixel_buf_clamped, width, height);
  #|   ctx2d.putImageData(imgData, 0, 0);
  #|   const scale = (ctx2d.canvas.width / width) | 0;
  #|   if (scale > 1) {
  #|     ctx2d.drawImage(ctx2d.canvas, 0, 0, width, height, 0, 0, width * scale, height * scale);
  #|   }
  #| }

///|
extern "js" fn web_init_gpu(width : Int, height : Int) -> Unit =
  #| (width, height) => {
  #|   if (!navigator.gpu) return;  // WebGPU not available
  #|
  #|   const initWebGPU = async () => {
  #|     try {
  #|       const adapter = await navigator.gpu.requestAdapter();
  #|       if (!adapter) return;
  #|
  #|       const device = await adapter.requestDevice();
  #|
  #|       // Handle device lost — fall back to Canvas2D
  #|       device.lost.then(() => {
  #|         globalThis.__moon8bit_render_fn = null;
  #|       });
  #|
  #|       const canvas = document.getElementById("moon8bit-canvas");
  #|       if (!canvas) return;
  #|
  #|       // Re-configure canvas for WebGPU
  #|       const gpuCanvas = canvas;
  #|       const context = gpuCanvas.getContext("webgpu");
  #|       if (!context) return;
  #|
  #|       const format = navigator.gpu.getPreferredCanvasFormat();
  #|       context.configure({ device, format, alphaMode: "opaque" });
  #|
  #|       // Texture: game framebuffer (pixel-index -> RGBA already resolved on CPU)
  #|       const texture = device.createTexture({
  #|         size: [width, height],
  #|         format: "rgba8unorm",
  #|         usage: GPUTextureUsage.TEXTURE_BINDING | GPUTextureUsage.COPY_DST,
  #|       });
  #|
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
  #|       const bindGroup = device.createBindGroup({
  #|         layout: pipeline.getBindGroupLayout(0),
  #|         entries: [
  #|           { binding: 0, resource: texture.createView() },
  #|           { binding: 1, resource: sampler },
  #|         ],
  #|       });
  #|
  #|       // Upload buffer: CPU writes RGBA pixels here, then copies to texture
  #|       const bytesPerRow = Math.ceil(width * 4 / 256) * 256;
  #|       const uploadBuffer = device.createBuffer({
  #|         size: bytesPerRow * height,
  #|         usage: GPUBufferUsage.COPY_SRC | GPUBufferUsage.MAP_WRITE,
  #|         mappedAtCreation: false,
  #|       });
  #|
  #|       // Render function — called every frame
  #|       globalThis.__moon8bit_render_fn = (pixelBuf, w, h) => {
  #|         uploadBuffer.mapAsync(GPUMapMode.WRITE).then(() => {
  #|           const dst = new Uint8Array(uploadBuffer.getMappedRange());
  #|           // Copy row-by-row to respect bytesPerRow alignment
  #|           for (let row = 0; row < h; row++) {
  #|             dst.set(pixelBuf.subarray(row * w * 4, (row + 1) * w * 4), row * bytesPerRow);
  #|           }
  #|           uploadBuffer.unmap();
  #|
  #|           const encoder = device.createCommandEncoder();
  #|           encoder.copyBufferToTexture(
  #|             { buffer: uploadBuffer, bytesPerRow, rowsPerImage: h },
  #|             { texture },
  #|             [w, h],
  #|           );
  #|           const pass = encoder.beginRenderPass({
  #|             colorAttachments: [{
  #|               view: context.getCurrentTexture().createView(),
  #|               loadOp: "clear",
  #|               storeOp: "store",
  #|               clearValue: { r: 0, g: 0, b: 0, a: 1 },
  #|             }],
  #|           });
  #|           pass.setPipeline(pipeline);
  #|           pass.setBindGroup(0, bindGroup);
  #|           pass.draw(3);
  #|           pass.end();
  #|           device.queue.submit([encoder.finish()]);
  #|         });
  #|       };
  #|
  #|     } catch (_) {
  #|       // requestAdapter / requestDevice failed — stay on Canvas2D
  #|       globalThis.__moon8bit_render_fn = null;
  #|     }
  #|   };
  #|
  #|   initWebGPU();
  #| }
