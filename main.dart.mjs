// Compiles a dart2wasm-generated main module from `source` which can then
// be instantiated via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm module from `bytes` which is then
// instantiable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredModules` is a JS function that takes an array of module names
  //   matching wasm files produced by the dart2wasm compiler. It also takes a
  //   callback that should be invoked for each loaded module with 2 arguments:
  //   (1) the module name, (2) the loaded module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The callback
  //   returns a Promise that resolves when the module is instantiated.
  //   loadDeferredModules should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  // `loadDeferredId` is a JS function that takes load ID produced by the
  //   compiler when the `use-load-ids` option is passed. Each load ID maps to
  //   one or more wasm files as specified in the emitted JSON file. It also
  //   takes a callback that should be invoked for each loaded module with 2
  //   arguments: (1) the module name, (2) the loaded module in a format
  //   supported by `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  //   The callback returns a Promise that resolves when the module is
  //   instantiated.
  //   loadDeferredId should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  async instantiate(additionalImports, {loadDeferredModules, loadDeferredId} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + value;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            AB: o => o,
      AC: Function.prototype.call.bind(DataView.prototype.setInt32),
      AD: x0 => x0.userAgent,
      AE: (x0,x1) => { x0.nonce = x1 },
      AF: (x0,x1) => { x0.tabIndex = x1 },
      AG: x0 => x0.changedTouches,
      AH: x0 => x0.clientHeight,
      AI: x0 => x0.offsetWidth,
      AJ: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      B: s => printToConsole(s),
      BB: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      BC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      BD: x0 => x0.maxTouchPoints,
      BE: x0 => x0.nonce,
      BF: (x0,x1) => { x0.action = x1 },
      BG: x0 => x0.offsetY,
      BH: x0 => x0.innerWidth,
      BI: x0 => x0.stopPropagation(),
      BJ: (x0,x1) => { x0.cursor = x1 },
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: x0 => x0.flags,
      CC: o => o instanceof Uint16Array,
      CD: x0 => x0.platform,
      CE: () => globalThis.window.flutterConfiguration,
      CF: (x0,x1) => { x0.method = x1 },
      CG: x0 => x0.offsetX,
      CH: x0 => x0.width,
      CI: x0 => x0.disabled,
      CJ: x0 => x0.cursor,
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      DC: Function.prototype.call.bind(DataView.prototype.getUint16),
      DD: x0 => x0.navigator,
      DE: (x0,x1) => x0.attachShadow(x1),
      DF: (x0,x1) => { x0.noValidate = x1 },
      DG: x0 => x0.type,
      DH: x0 => x0.clientWidth,
      DI: (x0,x1) => { x0.min = x1 },
      DJ: x0 => x0.style,
      E: (exn) => {
        let stackString = exn.toString();
        let frames = stackString.split('\n');
        let drop = 4;
        if (frames[0].startsWith('Error')) {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      EB: o => o instanceof RegExp,
      EC: Function.prototype.call.bind(DataView.prototype.setUint16),
      ED: s => new Date(s * 1000).getTimezoneOffset() * 60,
      EE: x0 => x0.preventDefault(),
      EF: x0 => x0.isConnected,
      EG: x0 => x0.shiftKey,
      EH: (x0,x1) => x0.removeChild(x1),
      EI: (x0,x1) => { x0.max = x1 },
      EJ: (x0,x1) => x0.querySelector(x1),
      F: () => new Error().stack,
      FB: (a, i, v) => a[i] = v,
      FC: o => o instanceof Int16Array,
      FD: Date.now,
      FE: (x0,x1) => x0.contains(x1),
      FF: x0 => x0.click(),
      FG: x0 => x0.disconnect(),
      FH: x0 => x0.firstChild,
      FI: (x0,x1) => { x0.disabled = x1 },
      FJ: x0 => x0.body,
      G: s => JSON.stringify(s),
      GB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      GC: Function.prototype.call.bind(DataView.prototype.getInt16),
      GD: (x0,x1,x2) => x0.setAttribute(x1,x2),
      GE: (x0,x1) => x0.focus(x1),
      GF: (x0,x1) => x0.getElementsByClassName(x1),
      GG: x0 => new Intl.Locale(x0),
      GH: x0 => x0.viewConstraints,
      GI: (x0,x1) => { x0.scrollLeft = x1 },
      GJ: () => globalThis.document,
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI16ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      HC: Function.prototype.call.bind(DataView.prototype.setInt16),
      HD: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      HE: (x0,x1) => x0.closest(x1),
      HF: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      HG: x0 => x0.region,
      HH: x0 => x0.hostElement,
      HI: (x0,x1) => { x0.spellcheck = x1 },
      HJ: x0 => x0.pop(),
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      IC: o => o instanceof Uint8ClampedArray,
      ID: x0 => x0.style,
      IE: (x0,x1) => x0.getAttribute(x1),
      IF: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      IG: x0 => x0.script,
      IH: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      II: (x0,x1) => { x0.disabled = x1 },
      IJ: x0 => ({type: x0}),
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: Function.prototype.call.bind(String.prototype.toLowerCase),
      JC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      JD: (x0,x1) => x0.createElement(x1),
      JE: x0 => x0.activeElement,
      JF: (x0,x1) => x0.contains(x1),
      JG: x0 => x0.language,
      JH: x0 => ({runApp: x0}),
      JI: (x0,x1) => x0.transferFromImageBitmap(x1),
      JJ: (x0,x1) => new Blob(x0,x1),
      K: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      KB: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      KC: Function.prototype.call.bind(DataView.prototype.setInt8),
      KD: x0 => x0.body,
      KE: (x0,x1) => x0.add(x1),
      KF: (s) => +s,
      KG: x0 => x0.languages,
      KH: () => typeof dartUseDateNowForTicks !== "undefined",
      KI: (x0,x1) => x0.getContext(x1),
      KJ: x0 => globalThis.URL.createObjectURL(x0),
      L: o => o === undefined,
      LB: () => ({}),
      LC: Function.prototype.call.bind(DataView.prototype.getInt8),
      LD: x0 => x0.remove(),
      LE: x0 => x0.classList,
      LF: x0 => x0.target,
      LG: (x0,x1) => x0.observe(x1),
      LH: () => Date.now(),
      LI: (x0,x1) => { x0.height = x1 },
      LJ: x0 => x0.devicePixelRatio,
      M: o => String(o),
      MB: (o, p, v) => o[p] = v,
      MC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      MD: (x0,x1) => x0.getPropertyValue(x1),
      ME: x0 => x0.data,
      MF: (x0,x1) => x0.dispatchEvent(x1),
      MG: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      MH: () => 1000 * performance.now(),
      MI: (x0,x1) => { x0.width = x1 },
      MJ: () => globalThis.window,
      N: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      NB: () => [],
      NC: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      ND: (x0,x1) => x0.warn(x1),
      NE: x0 => x0.scrollTop,
      NF: (x0,x1) => x0.createEvent(x1),
      NG: x0 => new ResizeObserver(x0),
      NH: x0 => new Uint8Array(x0),
      NI: x0 => x0.height,
      NJ: (x0,x1,x2,x3) => x0.putImageData(x1,x2,x3),
      O: (x0,x1) => x0.didCreateEngineInitializer(x1),
      OB: b => !!b,
      OC: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      OD: x0 => x0.console,
      OE: (handle) => clearTimeout(handle),
      OF: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      OG: x0 => globalThis.parseFloat(x0),
      OH: (x0,x1,x2) => x0.slice(x1,x2),
      OI: x0 => x0.width,
      OJ: x0 => x0.arrayBuffer(),
      P: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PB: x0 => new Int8Array(x0),
      PC: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      PD: (x0,x1) => { x0.id = x1 },
      PE: (x0,x1) => x0.removeAttribute(x1),
      PF: x0 => x0.readText(),
      PG: (x0,x1) => x0.getComputedStyle(x1),
      PH: (x0,x1) => x0.decode(x1),
      PI: x0 => x0.rasterEndMilliseconds,
      PJ: (x0,x1) => { x0.height = x1 },
      Q: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      QB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      QC: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      QD: s => s.trimLeft(),
      QE: (x0,x1) => { x0.value = x1 },
      QF: x0 => x0.clipboard,
      QG: x0 => x0.documentElement,
      QH: (x0,x1) => x0.adoptText(x1),
      QI: x0 => x0.rasterStartMilliseconds,
      QJ: (x0,x1) => { x0.width = x1 },
      R: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      RB: x0 => new Uint8Array(x0),
      RC: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      RD: (o, p, r) => o.replaceAll(p, () => r),
      RE: (x0,x1) => { x0.value = x1 },
      RF: (x0,x1) => x0.writeText(x1),
      RG: x0 => x0.computedStyleMap(),
      RH: x0 => x0.first(),
      RI: x0 => x0.imageBitmaps,
      RJ: x0 => x0.convertToBlob(),
      S: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SB: x0 => new Uint8ClampedArray(x0),
      SC: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      SD: (x0,x1) => x0[x1],
      SE: x0 => x0.value,
      SF: x0 => x0.unlock(),
      SG: (x0,x1) => x0.get(x1),
      SH: x0 => x0.next(),
      SI: x0 => x0.canvasKitMaximumSurfaces,
      SJ: (x0,x1,x2) => new ImageData(x0,x1,x2),
      T: x0 => new Promise(x0),
      TB: x0 => new Int16Array(x0),
      TC: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      TD: x0 => x0.length,
      TE: x0 => x0.selectionDirection,
      TF: (x0,x1) => x0.lock(x1),
      TG: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      TH: x0 => x0.current(),
      TI: (a, i) => a.splice(i, 1),
      TJ: (x0,x1) => x0.getContext(x1),
      U: (x0,x1,x2) => x0.call(x1,x2),
      UB: x0 => new Uint16Array(x0),
      UC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      UD: (x0,x1) => x0.exec(x1),
      UE: x0 => x0.selectionStart,
      UF: x0 => x0.orientation,
      UG: x0 => x0.matches,
      UH: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      UI: a => a.pop(),
      UJ: (x0,x1) => new OffscreenCanvas(x0,x1),
      V: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      VB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI16ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      VC: x0 => x0.history,
      VD: s => s.trim(),
      VE: x0 => x0.selectionEnd,
      VF: (x0,x1) => x0.querySelector(x1),
      VG: (x0,x1) => x0.matchMedia(x1),
      VH: x0 => x0.v8BreakIterator,
      VI: (a, t) => a.concat(t),
      VJ: x0 => x0.allocationSize(),
      W: x0 => new Array(x0),
      WB: x0 => new Int32Array(x0),
      WC: () => globalThis.window,
      WD: (a, s) => a.join(s),
      WE: x0 => x0.value,
      WF: (x0,x1) => { x0.content = x1 },
      WG: x0 => x0.matches,
      WH: () => globalThis.Intl,
      WI: x0 => new WeakRef(x0),
      WJ: (x0,x1) => x0.copyTo(x1),
      X: o => [o],
      XB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      XC: x0 => x0.search,
      XD: (x0,x1) => x0.error(x1),
      XE: x0 => x0.selectionDirection,
      XF: x0 => x0.head,
      XG: x0 => x0.timeStamp,
      XH: (x0,x1) => x0.segment(x1),
      XI: x0 => x0.deref(),
      XJ: (x0,x1) => x0.toDataURL(x1),
      Y: (o0, o1) => [o0, o1],
      YB: x0 => new Uint32Array(x0),
      YC: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      YD: () => globalThis.console,
      YE: x0 => x0.selectionStart,
      YF: (x0,x1) => { x0.name = x1 },
      YG: (x0,x1) => x0.hasAttribute(x1),
      YH: x0 => x0.index,
      YI: () => globalThis.WeakRef,
      YJ: (x0,x1,x2,x3) => x0.drawImage(x1,x2,x3),
      Z: (o0, o1, o2) => [o0, o1, o2],
      ZB: x0 => new Float32Array(x0),
      ZC: x0 => x0.location,
      ZD: s => s.trimRight(),
      ZE: x0 => x0.selectionEnd,
      ZF: (x0,x1) => { x0.title = x1 },
      ZG: x0 => x0.buttons,
      ZH: x0 => x0.next(),
      ZI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      ZJ: x0 => x0.format,
      a: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      aB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      aC: x0 => x0.pathname,
      aD: (x0,x1) => x0.requestAnimationFrame(x1),
      aE: (x0,x1) => { x0.name = x1 },
      aF: () => globalThis.document,
      aG: x0 => x0.ctrlKey,
      aH: x0 => x0.value,
      aI: (a, s, e) => a.slice(s, e),
      aJ: (x0,x1,x2,x3,x4) => x0.getImageData(x1,x2,x3,x4),
      b: (x0,x1,x2) => { x0[x1] = x2 },
      bB: x0 => new Float64Array(x0),
      bC: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      bD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      bE: (x0,x1) => { x0.placeholder = x1 },
      bF: (x0,x1) => x0.vibrate(x1),
      bG: x0 => x0.y,
      bH: x0 => x0.done,
      bI: x0 => x0.close(),
      bJ: x0 => x0.data,
      c: o => o,
      cB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      cC: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      cD: x0 => x0.now(),
      cE: (x0,x1) => { x0.autocomplete = x1 },
      cF: (o, p) => p in o,
      cG: x0 => x0.x,
      cH: (o, m, a) => o[m].apply(o, a),
      cI: (x0,x1,x2,x3,x4,x5) => x0.createImageBitmap(x1,x2,x3,x4,x5),
      cJ: x0 => x0.hostElement,
      d: (o, p) => o[p],
      dB: x0 => new ArrayBuffer(x0),
      dC: o => Object.keys(o),
      dD: x0 => x0.performance,
      dE: (x0,x1) => { x0.type = x1 },
      dF: x0 => x0.arrayBuffer(),
      dG: x0 => x0.offsetTop,
      dH: x0 => x0.iterator,
      dI: (x0,x1) => x0.createImageBitmap(x1),
      dJ: x0 => x0.location,
      e: () => globalThis,
      eB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      eC: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      eD: (x0,x1) => x0.unregister(x1),
      eE: (x0,x1) => { x0.name = x1 },
      eF: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      eG: x0 => x0.scrollLeft,
      eH: () => globalThis.Symbol,
      eI: x0 => new Blob(x0),
      eJ: (x0,x1) => x0.getModifierState(x1),
      f: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fB: (x0,x1,x2) => new DataView(x0,x1,x2),
      fC: f => f.dartFunction,
      fD: () => globalThis.window.FinalizationRegistry,
      fE: (x0,x1) => { x0.placeholder = x1 },
      fF: x0 => x0.status,
      fG: x0 => x0.offsetLeft,
      fH: (x0,x1) => new Intl.Segmenter(x0,x1),
      fI: x0 => x0.close(),
      fJ: x0 => x0.metaKey,
      g: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gB: (o, p) => o[p],
      gC: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gE: (x0,x1) => { x0.scrollTop = x1 },
      gF: (x0,x1) => x0.fetch(x1),
      gG: x0 => x0.offsetParent,
      gH: x0 => x0.Segmenter,
      gI: x0 => x0.naturalHeight,
      gJ: x0 => x0.altKey,
      h: (x0,x1) => ({addView: x0,removeView: x1}),
      hB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      hC: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      hD: x0 => new window.FinalizationRegistry(x0),
      hE: x0 => x0.tagName,
      hF: x0 => x0.content,
      hG: x0 => x0.deltaMode,
      hH: x0 => x0.buffer,
      hI: x0 => x0.naturalWidth,
      hJ: x0 => x0.ctrlKey,
      i: (string, token) => string.split(token),
      iB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      iC: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      iD: x0 => x0.scale,
      iE: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      iF: x0 => x0.document,
      iG: x0 => x0.deltaY,
      iH: x0 => x0.wasmMemory,
      iI: (x0,x1) => { x0.src = x1 },
      iJ: x0 => x0.isComposing,
      j: o => o instanceof Array,
      jB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      jC: (o, i) => o[i],
      jD: x0 => x0.visualViewport,
      jE: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      jF: x0 => x0.language,
      jG: x0 => x0.deltaX,
      jH: () => globalThis.window._flutter_skwasmInstance,
      jI: x0 => x0.displayHeight,
      jJ: x0 => x0.code,
      k: (a, i) => a[i],
      kB: o => o.byteOffset,
      kC: o => o.length,
      kD: x0 => x0.devicePixelRatio,
      kE: x0 => x0.visibilityState,
      kF: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      kG: x0 => x0.wheelDeltaY,
      kH: () => new TextDecoder(),
      kI: x0 => x0.displayWidth,
      kJ: x0 => x0.repeat,
      l: a => a.length,
      lB: o => o.buffer,
      lC: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        if (o instanceof Promise) return 18;
        return 19;
      },
      lD: (d, digits) => d.toFixed(digits),
      lE: x0 => x0.hasFocus(),
      lF: (x0,x1) => x0.prepend(x1),
      lG: x0 => x0.wheelDeltaX,
      lH: (map, o, v) => map.set(o, v),
      lI: x0 => x0.duration,
      lJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      m: (string, times) => string.repeat(times),
      mB: (b, o) => new DataView(b, o),
      mC: x0 => x0.state,
      mD: x0 => x0.maxHeight,
      mE: x0 => x0.relatedTarget,
      mF: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      mG: x0 => x0.key,
      mH: (map, o) => map.get(o),
      mI: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      mJ: x0 => x0.length,
      n: (decoder, codeUnits) => decoder.decode(codeUnits),
      nB: (b, o, l) => new DataView(b, o, l),
      nC: x0 => x0.hash,
      nD: x0 => x0.maxWidth,
      nE: x0 => x0.index,
      nF: (x0,x1) => x0.querySelector(x1),
      nG: x0 => x0.identifier,
      nH: () => new WeakMap(),
      nI: (x0,x1) => x0.decode(x1),
      nJ: x0 => x0.getReader(),
      o: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      oB: Function.prototype.call.bind(DataView.prototype.getUint8),
      oC: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      oD: x0 => x0.minHeight,
      oE: x0 => x0.unicode,
      oF: (x0,x1) => x0.querySelectorAll(x1),
      oG: x0 => x0.touches,
      oH: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      oI: x0 => x0.image,
      oJ: x0 => x0.value,
      p: () => new TextDecoder("utf-8", {fatal: true}),
      pB: Function.prototype.call.bind(DataView.prototype.setUint8),
      pC: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pD: x0 => x0.minWidth,
      pE: (x0,x1) => { x0.lastIndex = x1 },
      pF: x0 => x0.tabIndex,
      pG: x0 => x0.pressure,
      pH: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      pI: x0 => x0.close(),
      pJ: x0 => x0.done,
      q: () => new TextDecoder("utf-8", {fatal: false}),
      qB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      qC: x0 => x0.state,
      qD: x0 => x0.height,
      qE: x0 => x0.dotAll,
      qF: x0 => x0.parentNode,
      qG: x0 => x0.tiltY,
      qH: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      qI: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      qJ: x0 => x0.read(),
      r: (a, i) => a.push(i),
      rB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      rC: (x0,x1,x2) => x0.addEventListener(x1,x2),
      rD: x0 => x0.width,
      rE: x0 => x0.ignoreCase,
      rF: x0 => x0.clientY,
      rG: x0 => x0.tiltX,
      rH: x0 => x0.debugSkipFontRetryDelay,
      rI: x0 => new window.ImageDecoder(x0),
      rJ: x0 => x0.body,
      s: (l, r) => l === r,
      sB: (t, s) => t.set(s),
      sC: (x0,x1) => x0.go(x1),
      sD: x0 => x0.screen,
      sE: x0 => x0.multiline,
      sF: x0 => x0.clientX,
      sG: x0 => x0.pointerType,
      sH: (x0,x1,x2) => x0.set(x1,x2),
      sI: x0 => x0.name,
      sJ: x0 => x0.assetBase,
      t: x0 => x0.random(),
      tB: Function.prototype.call.bind(DataView.prototype.setFloat32),
      tC: (x0,x1) => x0.append(x1),
      tD: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      tE: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      tF: x0 => x0.getBoundingClientRect(),
      tG: x0 => x0.pointerId,
      tH: x0 => x0.fontFallbackBaseUrl,
      tI: x0 => x0.repetitionCount,
      tJ: x0 => x0.loader,
      u: o => o,
      uB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      uC: (x0,x1) => { x0.textContent = x1 },
      uD: (x0,x1) => x0.removeProperty(x1),
      uE: x0 => x0.keyCode,
      uF: x0 => x0.bottom,
      uG: x0 => x0.getCoalescedEvents(),
      uH: (handle) => clearInterval(handle),
      uI: x0 => x0.frameCount,
      uJ: () => globalThis._flutter,
      v: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'number') return 1;
        return 2;
      },
      vB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      vC: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      vD: (x0,x1) => x0.appendChild(x1),
      vE: (x0,x1) => x0.scrollIntoView(x1),
      vF: x0 => x0.top,
      vG: (x0,x1) => x0.getModifierState(x1),
      vH: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      vI: x0 => x0.selectedTrack,
      w: () => globalThis.Math,
      wB: Function.prototype.call.bind(DataView.prototype.getUint32),
      wC: x0 => x0.parentElement,
      wD: x0 => x0.debugShowSemanticsNodes,
      wE: x0 => x0.multiViewEnabled,
      wF: x0 => x0.right,
      wG: x0 => x0.blur(),
      wH: () => Date.now(),
      wI: x0 => x0.completed,
      x: s => s.toUpperCase(),
      xB: Function.prototype.call.bind(DataView.prototype.setUint32),
      xC: (x0,x1) => x0.querySelectorAll(x1),
      xD: (o, c) => o instanceof c,
      xE: x0 => x0.parent,
      xF: x0 => x0.left,
      xG: x0 => x0.button,
      xH: (x0,x1,x2) => x0.insertBefore(x1,x2),
      xI: x0 => x0.ready,
      y: Object.is,
      yB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      yC: (x0,x1) => x0.item(x1),
      yD: x0 => x0.vendor,
      yE: (x0,x1) => x0.replaceWith(x1),
      yF: x0 => x0.clientY,
      yG: x0 => x0.innerHeight,
      yH: x0 => x0.id,
      yI: x0 => x0.tracks,
      z: (x0,x1) => x0.test(x1),
      zB: Function.prototype.call.bind(DataView.prototype.getInt32),
      zC: x0 => x0.length,
      zD: (x0,x1) => x0.createTextNode(x1),
      zE: (x0,x1) => { x0.className = x1 },
      zF: x0 => x0.clientX,
      zG: x0 => x0.height,
      zH: x0 => x0.offsetHeight,
      zI: () => globalThis.window.ImageDecoder,

    };

    const baseImports = {
      _: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      WebAssembly: {
        JSTag: WebAssembly.JSTag,
      },
      "": new Proxy({}, { get(_, prop) { return prop; } }),

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
