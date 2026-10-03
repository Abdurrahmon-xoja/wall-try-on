# Wall Try-On

Preview paint colours and wall textures on your own room, in the browser.

- **Live camera**: point the phone at a room, tap a wall, and it is painted live while you move. Live view shows colours; press **Freeze** to keep a still photo.
- **Photo**: take or choose a photo. Two AI models find the walls: one knows what is a wall, the other measures depth, so walls are split at corners and furniture in front of a wall is left alone even when it is the same colour. Tap a wall (or press **Find walls for me**) and pick a colour or texture: scanned plaster, microcement, brick, reclaimed brick, planks, sandstone, limestone, drawn stucco, linen, wallpaper, oak, or your own texture photo.
- Shadows, light and the light's colour from the photo are kept, so the new finish looks real. Choose a Matt, Satin or Gloss sheen. Textures are shown at their real size and follow each wall's 3D angle.

Open it at **https://abdurrahmon-xoja.github.io/wall-try-on/**. The camera needs `https://`, so live mode does not work from a local file.

## Files

| Path | What it is |
|---|---|
| `page.html` | The whole app (HTML, CSS, JS in one file). Also published as the claude.ai artifact. |
| `index.html` | `page.html` wrapped in a full HTML document for GitHub Pages. Rebuild it with `./build.sh` after every change to `page.html`. |
| `ai/segformer-b0-ade.b64.txt` | The wall-finding model, base64 text (claude.ai artifacts do not serve `.onnx` files). |
| `ai/depth-anything-v2-small-q8.onnx` | The depth model (int8). The claude.ai copy uses `ai/depth.b64.*.txt` chunks instead. |
| `ai/ort-wasm-simd.wasm` | ONNX Runtime Web 1.17.3, which runs both models. Its JS loader comes from jsDelivr. |
| `tex/<id>_c.jpg`, `tex/<id>_n.jpg`, `tex/<id>_t.jpg` | Scanned materials: colour (with ambient occlusion baked in), normal + roughness packed into one image, and a thumbnail. `tex/materials.json` lists their real sizes. |

## How it works

- **Walls in a photo**: a flood fill in Lab colour space that tolerates lighting (brightness may change a lot, colour only a little) and stops at edges. The AI's wall map blocks spills onto ceilings and furniture of the same colour.
- **AI**: SegFormer-B0 trained on ADE20K (150 classes, class 0 = wall), run in a Web Worker so the page stays responsive. If WebAssembly is blocked, the app falls back to colour and edges only.
- **Depth**: Depth Anything V2 Small gives relative inverse depth. On a flat surface that is a linear function of image position, so planes are fitted with RANSAC; pixels in front of the tapped wall's plane (furniture) or better explained by a differently angled plane (floor, the next wall) are cut, and a guided filter snaps the cut to edges in the photo. The wall's plane, with the floor used to fix the depth offset, gives the texture's perspective. Depth is skipped on the drawn sample room.
- **Live camera**: each frame is shrunk to ~384 px, the wall is found again starting from every point that was wall in the last frame, small separate patches are dropped, and the full video is recoloured on the GPU.
- **Rendering**: WebGL. Paint keeps each pixel's brightness relative to the wall's average and the light's colour from a blurred copy of the photo. Textures use normal and roughness maps lit from the photo's light direction; sheen controls how bright spots and bumps catch the light.

## Licences

- App code: written for this project.
- AI model: [nvidia/segformer-b0-finetuned-ade-512-512](https://huggingface.co/nvidia/segformer-b0-finetuned-ade-512-512) (ONNX conversion by [Xenova](https://huggingface.co/Xenova/segformer-b0-finetuned-ade-512-512)). [NVIDIA's SegFormer licence](https://github.com/NVlabs/SegFormer/blob/master/LICENSE) allows **non-commercial use only**. Replace the model before any commercial launch.
- Depth model: [Depth Anything V2 Small](https://huggingface.co/onnx-community/depth-anything-v2-small): Apache-2.0.
- Scanned textures: [Poly Haven](https://polyhaven.com) by Rob Tuytel and Dimitrios Savva: CC0.
- [ONNX Runtime Web](https://github.com/microsoft/onnxruntime): MIT.
