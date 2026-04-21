CanvasKitInit({ locateFile: (file) => 'https://unpkg.com/canvaskit-wasm@latest/bin/' + file }).then((ck) => {
  window.CanvasKitInstance = ck
  console.log('CanvasKit loaded');
});