# Wall Try-On

Preview paint colours and wall textures on your own room, in the browser.

- **Live camera**: point the phone at a room, tap a wall, and it is painted live while you move. Live view shows colours; press **Freeze** to keep a still photo.
- **Photo**: take or choose a photo. An AI model finds the walls; tap one (or press **Find walls for me**) and pick a colour or texture (plaster, stucco, microcement, linen, wallpaper, brick, oak, travertine, or your own texture photo).
- Shadows and light from the photo are kept, so the new finish looks real. Textures follow the wall's perspective.

Open it at **https://abdurrahmon-xoja.github.io/wall-try-on/**. The camera needs `https://`, so live mode does not work from a local file.

## Files

| Path | What it is |
|---|---|
| `page.html` | The whole app (HTML, CSS, JS in one file). Also published as the claude.ai artifact. |
| `index.html` | `page.html` wrapped in a full HTML document for GitHub Pages. Rebuild it with `./build.sh` after every change to `page.html`. |
| `ai/segformer-b0-ade.b64.txt` | The wall-finding model, base64 text (claude.ai artifacts do not serve `.onnx` files). |
| `ai/ort-wasm-simd.wasm` | ONNX Runtime Web 1.17.3, which runs the model. Its JS loader comes from jsDelivr. |

## How it works

- **Walls in a photo**: a flood fill in Lab colour space that tolerates lighting (brightness may change a lot, colour only a little) and stops at edges. The AI's wall map blocks spills onto ceilings and furniture of the same colour.
- **AI**: SegFormer-B0 trained on ADE20K (150 classes, class 0 = wall), run in a Web Worker so the page stays responsive. If WebAssembly is blocked, the app falls back to colour and edges only.
- **Live camera**: each frame is shrunk to ~384 px, the wall is found again starting from every point that was wall in the last frame, small separate patches are dropped, and the full video is recoloured on the GPU.
- **Rendering**: WebGL. Paint keeps each pixel's brightness relative to the wall's average, and textures get a normal map lit from the photo's light direction.

## Licences

- App code: written for this project.
- AI model: [nvidia/segformer-b0-finetuned-ade-512-512](https://huggingface.co/nvidia/segformer-b0-finetuned-ade-512-512) (ONNX conversion by [Xenova](https://huggingface.co/Xenova/segformer-b0-finetuned-ade-512-512)). [NVIDIA's SegFormer licence](https://github.com/NVlabs/SegFormer/blob/master/LICENSE) allows **non-commercial use only**. Replace the model before any commercial launch.
- [ONNX Runtime Web](https://github.com/microsoft/onnxruntime): MIT.
