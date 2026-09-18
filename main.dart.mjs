// Compiles a dart2wasm-generated main module from `source` which can then
// be instantiated via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(
      await _compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm module from `bytes` which is then
// instantiable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

let _isCompileStreamingSupported;
async function _compileStreaming(source, builtins) {
  _isCompileStreamingSupported ??= WebAssembly.compileStreaming(
    new Response(
      new Uint8Array([0,97,115,109,1,0,0,0,1,4,1,96,0,0,2,23,1,14,119,97,115,109,58,106,115,45,115,116,114,105,110,103,4,99,97,115,116,0,0]),
      {headers: {'Content-Type': 'application/wasm'}},
    ),
    builtins,
  ).then(() => false, (e) => e instanceof WebAssembly.CompileError);
  if (await _isCompileStreamingSupported) {
    return WebAssembly.compileStreaming(source, builtins);
  }
  return WebAssembly.compile(await (await source).arrayBuffer(), builtins);
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
      AE: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      AF: (x0,x1) => { x0.className = x1 },
      AG: x0 => x0.clientX,
      AH: x0 => x0.height,
      AI: x0 => x0.offsetHeight,
      AJ: () => globalThis.window.ImageDecoder,
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
      BE: (x0,x1) => x0.removeProperty(x1),
      BF: (x0,x1) => { x0.tabIndex = x1 },
      BG: x0 => x0.changedTouches,
      BH: x0 => x0.clientHeight,
      BI: x0 => x0.offsetWidth,
      BJ: (x0,x1) => { x0.cursor = x1 },
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: x0 => x0.flags,
      CC: o => o instanceof Uint16Array,
      CD: x0 => x0.platform,
      CE: (x0,x1) => x0.appendChild(x1),
      CF: (x0,x1) => { x0.action = x1 },
      CG: x0 => x0.offsetY,
      CH: x0 => x0.innerWidth,
      CI: x0 => x0.stopPropagation(),
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
      DE: x0 => x0.debugShowSemanticsNodes,
      DF: (x0,x1) => { x0.method = x1 },
      DG: x0 => x0.offsetX,
      DH: x0 => x0.width,
      DI: x0 => x0.disabled,
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
      EE: (o, c) => o instanceof c,
      EF: (x0,x1) => { x0.noValidate = x1 },
      EG: x0 => x0.type,
      EH: x0 => x0.clientWidth,
      EI: (x0,x1) => { x0.min = x1 },
      EJ: (x0,x1) => x0.querySelector(x1),
      F: () => new Error().stack,
      FB: (a, i, v) => a[i] = v,
      FC: o => o instanceof Int16Array,
      FD: Date.now,
      FE: x0 => x0.vendor,
      FF: x0 => x0.isConnected,
      FG: x0 => x0.shiftKey,
      FH: (x0,x1) => x0.removeChild(x1),
      FI: (x0,x1) => { x0.max = x1 },
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
      GE: (x0,x1) => x0.createTextNode(x1),
      GF: x0 => x0.click(),
      GG: x0 => x0.disconnect(),
      GH: x0 => x0.firstChild,
      GI: (x0,x1) => { x0.disabled = x1 },
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
      HE: (x0,x1) => { x0.nonce = x1 },
      HF: (x0,x1) => x0.getElementsByClassName(x1),
      HG: x0 => new Intl.Locale(x0),
      HH: x0 => x0.viewConstraints,
      HI: (x0,x1) => { x0.scrollLeft = x1 },
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
      IE: x0 => x0.nonce,
      IF: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      IG: x0 => x0.region,
      IH: x0 => x0.hostElement,
      II: (x0,x1) => { x0.spellcheck = x1 },
      IJ: x0 => ({type: x0}),
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: Function.prototype.call.bind(String.prototype.toLowerCase),
      JC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      JD: (x0,x1) => x0.createElement(x1),
      JE: () => globalThis.window.flutterConfiguration,
      JF: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      JG: x0 => x0.script,
      JH: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      JI: (x0,x1) => { x0.disabled = x1 },
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
      KE: (x0,x1) => x0.attachShadow(x1),
      KF: (x0,x1) => x0.contains(x1),
      KG: x0 => x0.language,
      KH: x0 => ({runApp: x0}),
      KI: (x0,x1) => x0.transferFromImageBitmap(x1),
      KJ: x0 => globalThis.URL.createObjectURL(x0),
      L: o => o === undefined,
      LB: () => ({}),
      LC: Function.prototype.call.bind(DataView.prototype.getInt8),
      LD: x0 => x0.remove(),
      LE: x0 => x0.preventDefault(),
      LF: (s) => +s,
      LG: x0 => x0.languages,
      LH: () => typeof dartUseDateNowForTicks !== "undefined",
      LI: (x0,x1) => x0.getContext(x1),
      LJ: x0 => x0.devicePixelRatio,
      M: o => String(o),
      MB: (o, p, v) => o[p] = v,
      MC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      MD: (x0,x1) => x0.getPropertyValue(x1),
      ME: (x0,x1) => x0.contains(x1),
      MF: x0 => x0.target,
      MG: (x0,x1) => x0.observe(x1),
      MH: () => Date.now(),
      MI: (x0,x1) => { x0.height = x1 },
      MJ: () => globalThis.window,
      N: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      NB: () => [],
      NC: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      ND: (x0,x1) => x0.warn(x1),
      NE: (x0,x1) => x0.focus(x1),
      NF: (x0,x1) => x0.dispatchEvent(x1),
      NG: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      NH: () => 1000 * performance.now(),
      NI: (x0,x1) => { x0.width = x1 },
      NJ: (x0,x1,x2,x3) => x0.putImageData(x1,x2,x3),
      O: (x0,x1) => x0.didCreateEngineInitializer(x1),
      OB: b => !!b,
      OC: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      OD: x0 => x0.console,
      OE: (x0,x1) => x0.closest(x1),
      OF: (x0,x1) => x0.createEvent(x1),
      OG: x0 => new ResizeObserver(x0),
      OH: x0 => new Uint8Array(x0),
      OI: x0 => x0.height,
      OJ: x0 => x0.arrayBuffer(),
      P: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PB: x0 => new Int8Array(x0),
      PC: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      PD: (x0,x1) => { x0.id = x1 },
      PE: (x0,x1) => x0.getAttribute(x1),
      PF: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      PG: x0 => globalThis.parseFloat(x0),
      PH: (x0,x1,x2) => x0.slice(x1,x2),
      PI: x0 => x0.width,
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
      QE: x0 => x0.activeElement,
      QF: x0 => x0.readText(),
      QG: (x0,x1) => x0.getComputedStyle(x1),
      QH: (x0,x1) => x0.decode(x1),
      QI: x0 => x0.rasterEndMilliseconds,
      QJ: (x0,x1) => { x0.width = x1 },
      R: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      RB: x0 => new Uint8Array(x0),
      RC: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      RD: x0 => x0.unicode,
      RE: (x0,x1) => x0.add(x1),
      RF: x0 => x0.clipboard,
      RG: x0 => x0.documentElement,
      RH: (x0,x1) => x0.adoptText(x1),
      RI: x0 => x0.rasterStartMilliseconds,
      RJ: x0 => x0.convertToBlob(),
      S: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SB: x0 => new Uint8ClampedArray(x0),
      SC: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      SD: x0 => x0.index,
      SE: x0 => x0.classList,
      SF: (x0,x1) => x0.writeText(x1),
      SG: x0 => x0.computedStyleMap(),
      SH: x0 => x0.first(),
      SI: x0 => x0.imageBitmaps,
      SJ: (x0,x1,x2) => new ImageData(x0,x1,x2),
      T: x0 => new Promise(x0),
      TB: x0 => new Int16Array(x0),
      TC: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      TD: (x0,x1) => x0[x1],
      TE: x0 => x0.data,
      TF: x0 => x0.unlock(),
      TG: (x0,x1) => x0.get(x1),
      TH: x0 => x0.next(),
      TI: x0 => x0.canvasKitMaximumSurfaces,
      TJ: (x0,x1) => x0.getContext(x1),
      U: (x0,x1,x2) => x0.call(x1,x2),
      UB: x0 => new Uint16Array(x0),
      UC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      UD: (x0,x1) => x0.exec(x1),
      UE: x0 => x0.scrollTop,
      UF: (x0,x1) => x0.lock(x1),
      UG: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      UH: x0 => x0.current(),
      UI: (a, i) => a.splice(i, 1),
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
      VD: (x0,x1) => { x0.lastIndex = x1 },
      VE: (handle) => clearTimeout(handle),
      VF: x0 => x0.orientation,
      VG: x0 => x0.matches,
      VH: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      VI: a => a.pop(),
      VJ: x0 => x0.allocationSize(),
      W: x0 => new Array(x0),
      WB: x0 => new Int32Array(x0),
      WC: () => globalThis.window,
      WD: x0 => x0.dotAll,
      WE: (x0,x1) => x0.removeAttribute(x1),
      WF: (x0,x1) => x0.querySelector(x1),
      WG: (x0,x1) => x0.matchMedia(x1),
      WH: x0 => x0.v8BreakIterator,
      WI: (a, t) => a.concat(t),
      WJ: (x0,x1) => x0.copyTo(x1),
      X: o => [o],
      XB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      XC: x0 => x0.search,
      XD: x0 => x0.ignoreCase,
      XE: (x0,x1) => { x0.value = x1 },
      XF: (x0,x1) => { x0.content = x1 },
      XG: x0 => x0.matches,
      XH: () => globalThis.Intl,
      XI: x0 => new WeakRef(x0),
      XJ: (x0,x1) => x0.toDataURL(x1),
      Y: (o0, o1) => [o0, o1],
      YB: x0 => new Uint32Array(x0),
      YC: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      YD: x0 => x0.multiline,
      YE: (x0,x1) => { x0.value = x1 },
      YF: x0 => x0.head,
      YG: x0 => x0.timeStamp,
      YH: (x0,x1) => x0.segment(x1),
      YI: x0 => x0.deref(),
      YJ: (x0,x1,x2,x3) => x0.drawImage(x1,x2,x3),
      Z: (o0, o1, o2) => [o0, o1, o2],
      ZB: x0 => new Float32Array(x0),
      ZC: x0 => x0.location,
      ZD: (o, p, r) => o.replace(p, () => r),
      ZE: x0 => x0.value,
      ZF: (x0,x1) => { x0.name = x1 },
      ZG: (x0,x1) => x0.hasAttribute(x1),
      ZH: x0 => x0.index,
      ZI: () => globalThis.WeakRef,
      ZJ: x0 => x0.format,
      a: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      aB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      aC: x0 => x0.pathname,
      aD: (o, p, r) => o.replaceAll(p, () => r),
      aE: x0 => x0.selectionDirection,
      aF: (x0,x1) => { x0.title = x1 },
      aG: (x0,x1) => x0.getModifierState(x1),
      aH: x0 => x0.next(),
      aI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      aJ: (x0,x1,x2,x3,x4) => x0.getImageData(x1,x2,x3,x4),
      b: (x0,x1,x2) => { x0[x1] = x2 },
      bB: x0 => new Float64Array(x0),
      bC: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      bD: x0 => x0.length,
      bE: x0 => x0.selectionStart,
      bF: () => globalThis.document,
      bG: x0 => x0.buttons,
      bH: x0 => x0.value,
      bI: (a, s, e) => a.slice(s, e),
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
      cD: s => s.trim(),
      cE: x0 => x0.selectionEnd,
      cF: (x0,x1) => x0.vibrate(x1),
      cG: x0 => x0.ctrlKey,
      cH: x0 => x0.done,
      cI: x0 => x0.close(),
      cJ: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      d: (o, p) => o[p],
      dB: x0 => new ArrayBuffer(x0),
      dC: o => Object.keys(o),
      dD: (a, s) => a.join(s),
      dE: x0 => x0.value,
      dF: (o, p) => p in o,
      dG: x0 => x0.y,
      dH: (o, m, a) => o[m].apply(o, a),
      dI: (x0,x1,x2,x3,x4,x5) => x0.createImageBitmap(x1,x2,x3,x4,x5),
      dJ: x0 => x0.hostElement,
      e: () => globalThis,
      eB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      eC: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      eD: (x0,x1) => x0.error(x1),
      eE: x0 => x0.selectionDirection,
      eF: x0 => x0.arrayBuffer(),
      eG: x0 => x0.x,
      eH: x0 => x0.iterator,
      eI: (x0,x1) => x0.createImageBitmap(x1),
      eJ: x0 => x0.location,
      f: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fB: (x0,x1,x2) => new DataView(x0,x1,x2),
      fC: f => f.dartFunction,
      fD: () => globalThis.console,
      fE: x0 => x0.selectionStart,
      fF: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      fG: x0 => x0.offsetTop,
      fH: () => globalThis.Symbol,
      fI: x0 => new Blob(x0),
      fJ: (x0,x1) => x0.getModifierState(x1),
      g: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gB: (o, p) => o[p],
      gC: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gD: s => s.trimRight(),
      gE: x0 => x0.selectionEnd,
      gF: x0 => x0.status,
      gG: x0 => x0.scrollLeft,
      gH: (x0,x1) => new Intl.Segmenter(x0,x1),
      gI: x0 => x0.close(),
      gJ: x0 => x0.metaKey,
      h: (x0,x1) => ({addView: x0,removeView: x1}),
      hB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      hC: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      hD: (x0,x1) => x0.requestAnimationFrame(x1),
      hE: (x0,x1) => { x0.name = x1 },
      hF: (x0,x1) => x0.fetch(x1),
      hG: x0 => x0.offsetLeft,
      hH: x0 => x0.Segmenter,
      hI: x0 => x0.naturalHeight,
      hJ: x0 => x0.altKey,
      i: (string, token) => string.split(token),
      iB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      iC: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      iD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      iE: (x0,x1) => { x0.placeholder = x1 },
      iF: x0 => x0.content,
      iG: x0 => x0.offsetParent,
      iH: x0 => x0.buffer,
      iI: x0 => x0.naturalWidth,
      iJ: x0 => x0.ctrlKey,
      j: o => o instanceof Array,
      jB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      jC: (o, i) => o[i],
      jD: x0 => x0.now(),
      jE: (x0,x1) => { x0.autocomplete = x1 },
      jF: x0 => x0.document,
      jG: x0 => x0.deltaMode,
      jH: x0 => x0.wasmMemory,
      jI: (x0,x1) => { x0.src = x1 },
      jJ: x0 => x0.isComposing,
      k: (a, i) => a.push(i),
      kB: o => o.byteOffset,
      kC: o => o.length,
      kD: x0 => x0.performance,
      kE: (x0,x1) => { x0.type = x1 },
      kF: x0 => x0.language,
      kG: x0 => x0.deltaY,
      kH: () => globalThis.window._flutter_skwasmInstance,
      kI: x0 => x0.displayHeight,
      kJ: x0 => x0.code,
      l: (a, i) => a[i],
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
      lD: (x0,x1) => x0.unregister(x1),
      lE: (x0,x1) => { x0.name = x1 },
      lF: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      lG: x0 => x0.deltaX,
      lH: () => new TextDecoder(),
      lI: x0 => x0.displayWidth,
      lJ: x0 => x0.repeat,
      m: a => a.length,
      mB: (b, o) => new DataView(b, o),
      mC: x0 => x0.state,
      mD: () => globalThis.window.FinalizationRegistry,
      mE: (x0,x1) => { x0.placeholder = x1 },
      mF: (x0,x1) => x0.prepend(x1),
      mG: x0 => x0.wheelDeltaY,
      mH: (map, o, v) => map.set(o, v),
      mI: x0 => x0.duration,
      mJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      n: (string, times) => string.repeat(times),
      nB: (b, o, l) => new DataView(b, o, l),
      nC: x0 => x0.hash,
      nD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      nE: (x0,x1) => { x0.scrollTop = x1 },
      nF: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      nG: x0 => x0.wheelDeltaX,
      nH: (map, o) => map.get(o),
      nI: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      nJ: x0 => x0.length,
      o: (decoder, codeUnits) => decoder.decode(codeUnits),
      oB: Function.prototype.call.bind(DataView.prototype.getUint8),
      oC: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      oD: x0 => new window.FinalizationRegistry(x0),
      oE: x0 => x0.tagName,
      oF: (x0,x1) => x0.querySelector(x1),
      oG: x0 => x0.key,
      oH: () => new WeakMap(),
      oI: (x0,x1) => x0.decode(x1),
      oJ: x0 => x0.getReader(),
      p: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      pB: Function.prototype.call.bind(DataView.prototype.setUint8),
      pC: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pD: x0 => x0.scale,
      pE: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      pF: (x0,x1) => x0.querySelectorAll(x1),
      pG: x0 => x0.identifier,
      pH: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      pI: x0 => x0.image,
      pJ: x0 => x0.value,
      q: () => new TextDecoder("utf-8", {fatal: true}),
      qB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      qC: x0 => x0.state,
      qD: x0 => x0.visualViewport,
      qE: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      qF: x0 => x0.tabIndex,
      qG: x0 => x0.touches,
      qH: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      qI: x0 => x0.close(),
      qJ: x0 => x0.done,
      r: () => new TextDecoder("utf-8", {fatal: false}),
      rB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      rC: (x0,x1,x2) => x0.addEventListener(x1,x2),
      rD: x0 => x0.devicePixelRatio,
      rE: x0 => x0.visibilityState,
      rF: x0 => x0.parentNode,
      rG: x0 => x0.pressure,
      rH: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      rI: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      rJ: x0 => x0.read(),
      s: (l, r) => l === r,
      sB: (t, s) => t.set(s),
      sC: (x0,x1) => x0.go(x1),
      sD: (d, digits) => d.toFixed(digits),
      sE: x0 => x0.hasFocus(),
      sF: x0 => x0.clientY,
      sG: x0 => x0.tiltY,
      sH: x0 => x0.debugSkipFontRetryDelay,
      sI: x0 => new window.ImageDecoder(x0),
      sJ: x0 => x0.body,
      t: x0 => x0.random(),
      tB: Function.prototype.call.bind(DataView.prototype.setFloat32),
      tC: (x0,x1) => x0.append(x1),
      tD: x0 => x0.maxHeight,
      tE: x0 => x0.relatedTarget,
      tF: x0 => x0.clientX,
      tG: x0 => x0.tiltX,
      tH: (x0,x1,x2) => x0.set(x1,x2),
      tI: x0 => x0.name,
      tJ: x0 => x0.assetBase,
      u: o => o,
      uB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      uC: (x0,x1) => { x0.textContent = x1 },
      uD: x0 => x0.maxWidth,
      uE: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      uF: x0 => x0.getBoundingClientRect(),
      uG: x0 => x0.pointerType,
      uH: x0 => x0.fontFallbackBaseUrl,
      uI: x0 => x0.repetitionCount,
      uJ: x0 => x0.loader,
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
      vD: x0 => x0.minHeight,
      vE: x0 => x0.keyCode,
      vF: x0 => x0.bottom,
      vG: x0 => x0.pointerId,
      vH: (handle) => clearInterval(handle),
      vI: x0 => x0.frameCount,
      vJ: () => globalThis._flutter,
      w: () => globalThis.Math,
      wB: Function.prototype.call.bind(DataView.prototype.getUint32),
      wC: x0 => x0.parentElement,
      wD: x0 => x0.minWidth,
      wE: (x0,x1) => x0.scrollIntoView(x1),
      wF: x0 => x0.top,
      wG: x0 => x0.getCoalescedEvents(),
      wH: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      wI: x0 => x0.selectedTrack,
      x: s => s.toUpperCase(),
      xB: Function.prototype.call.bind(DataView.prototype.setUint32),
      xC: (x0,x1) => x0.querySelectorAll(x1),
      xD: x0 => x0.height,
      xE: x0 => x0.multiViewEnabled,
      xF: x0 => x0.right,
      xG: x0 => x0.blur(),
      xH: () => Date.now(),
      xI: x0 => x0.completed,
      y: Object.is,
      yB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      yC: (x0,x1) => x0.item(x1),
      yD: x0 => x0.width,
      yE: x0 => x0.parent,
      yF: x0 => x0.left,
      yG: x0 => x0.button,
      yH: (x0,x1,x2) => x0.insertBefore(x1,x2),
      yI: x0 => x0.ready,
      z: (x0,x1) => x0.test(x1),
      zB: Function.prototype.call.bind(DataView.prototype.getInt32),
      zC: x0 => x0.length,
      zD: x0 => x0.screen,
      zE: (x0,x1) => x0.replaceWith(x1),
      zF: x0 => x0.clientY,
      zG: x0 => x0.innerHeight,
      zH: x0 => x0.id,
      zI: x0 => x0.tracks,

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

    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
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
