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
            AB: x0 => new Int16Array(x0),
      AC: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      AD: (x0,x1,x2) => x0.setAttribute(x1,x2),
      AE: x0 => x0.matches,
      AF: s => s.toUpperCase(),
      AG: x0 => x0.iterator,
      AH: x0 => x0.selectionDirection,
      AI: o => Object.keys(o),
      AJ: () => globalThis.window.ImageDecoder,
      AK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      B: s => printToConsole(s),
      BB: x0 => new Uint16Array(x0),
      BC: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      BD: x0 => x0.getBoundingClientRect(),
      BE: (x0,x1) => x0.matchMedia(x1),
      BF: (x0,x1) => x0.test(x1),
      BG: () => globalThis.Symbol,
      BH: x0 => x0.selectionStart,
      BI: x0 => x0.state,
      BJ: x0 => x0.cursor,
      BK: x0 => x0.length,
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI16ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      CC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      CD: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      CE: x0 => x0.matches,
      CF: (x0,x1) => x0[x1],
      CG: (x0,x1) => new Intl.Segmenter(x0,x1),
      CH: x0 => x0.selectionEnd,
      CI: x0 => x0.hash,
      CJ: (x0,x1) => { x0.cursor = x1 },
      CK: x0 => x0.getReader(),
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: x0 => new Int32Array(x0),
      DC: (x0,x1) => x0.querySelector(x1),
      DD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      DE: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      DF: x0 => x0.length,
      DG: x0 => x0.Segmenter,
      DH: x0 => x0.selectionDirection,
      DI: x0 => x0.state,
      DJ: x0 => x0.style,
      DK: x0 => x0.value,
      E: (exn) => {
        let stackString = exn.toString();
        let frames = stackString.split('\n');
        let drop = 4;
        if (frames[0].startsWith('Error')) {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      EB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      EC: (x0,x1) => x0.item(x1),
      ED: Date.now,
      EE: f => f.dartFunction,
      EF: (x0,x1) => x0.exec(x1),
      EG: x0 => x0.buffer,
      EH: x0 => x0.selectionStart,
      EI: (x0,x1) => x0.go(x1),
      EJ: x0 => x0.body,
      EK: x0 => x0.done,
      F: () => new Error().stack,
      FB: x0 => new Uint32Array(x0),
      FC: x0 => x0.length,
      FD: (handle) => clearTimeout(handle),
      FE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      FF: x0 => x0.flags,
      FG: x0 => x0.wasmMemory,
      FH: x0 => x0.selectionEnd,
      FI: (x0,x1) => x0.querySelectorAll(x1),
      FJ: () => globalThis.document,
      FK: x0 => x0.read(),
      G: s => JSON.stringify(s),
      GB: x0 => new Float32Array(x0),
      GC: (x0,x1) => x0.querySelectorAll(x1),
      GD: (x0,x1) => x0.closest(x1),
      GE: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      GF: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      GG: () => globalThis.window._flutter_skwasmInstance,
      GH: (x0,x1) => { x0.name = x1 },
      GI: x0 => x0.click(),
      GJ: x0 => x0.pop(),
      GK: x0 => x0.body,
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      HC: (x0,x1) => x0.getAttribute(x1),
      HD: x0 => x0.bottom,
      HE: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      HF: o => o instanceof RegExp,
      HG: () => new TextDecoder(),
      HH: (x0,x1) => { x0.placeholder = x1 },
      HI: (x0,x1) => x0.getElementsByClassName(x1),
      HJ: x0 => ({type: x0}),
      HK: x0 => x0.assetBase,
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: x0 => new Float64Array(x0),
      IC: x0 => x0.remove(),
      ID: x0 => x0.top,
      IE: (o, i) => o[i],
      IF: (a, s) => a.join(s),
      IG: (map, o, v) => map.set(o, v),
      IH: (x0,x1) => { x0.autocomplete = x1 },
      II: (x0,x1) => x0.dispatchEvent(x1),
      IJ: (x0,x1) => new Blob(x0,x1),
      IK: x0 => x0.loader,
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      JC: (x0,x1) => x0.appendChild(x1),
      JD: x0 => x0.right,
      JE: o => o.length,
      JF: (x0,x1) => x0.error(x1),
      JG: (map, o) => map.get(o),
      JH: (x0,x1) => { x0.name = x1 },
      JI: (x0,x1) => x0.createEvent(x1),
      JJ: x0 => globalThis.URL.createObjectURL(x0),
      JK: () => globalThis._flutter,
      K: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      KB: x0 => new ArrayBuffer(x0),
      KC: (x0,x1) => x0.append(x1),
      KD: x0 => x0.left,
      KE: o => {
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
      KF: () => globalThis.console,
      KG: () => new WeakMap(),
      KH: (x0,x1) => { x0.placeholder = x1 },
      KI: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      KJ: x0 => x0.devicePixelRatio,
      L: o => o === undefined,
      LB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      LC: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      LD: x0 => x0.clientY,
      LE: x0 => x0.language,
      LF: s => s.trimRight(),
      LG: (d, digits) => d.toFixed(digits),
      LH: (x0,x1) => { x0.spellcheck = x1 },
      LI: x0 => x0.readText(),
      LJ: () => globalThis.window,
      M: o => String(o),
      MB: (x0,x1,x2) => new DataView(x0,x1,x2),
      MC: x0 => x0.style,
      MD: x0 => x0.clientX,
      ME: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      MF: x0 => x0.blur(),
      MG: x0 => x0.maxHeight,
      MH: (x0,x1) => { x0.disabled = x1 },
      MI: x0 => x0.clipboard,
      MJ: (x0,x1,x2,x3) => x0.putImageData(x1,x2,x3),
      N: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      NB: (o, p) => o[p],
      NC: x0 => x0.debugShowSemanticsNodes,
      ND: x0 => x0.changedTouches,
      NE: () => globalThis.window.FinalizationRegistry,
      NF: x0 => x0.button,
      NG: x0 => x0.maxWidth,
      NH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      NI: (x0,x1) => x0.writeText(x1),
      NJ: x0 => x0.arrayBuffer(),
      O: (x0,x1) => x0.didCreateEngineInitializer(x1),
      OB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      OC: o => o,
      OD: x0 => x0.offsetY,
      OE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      OF: x0 => x0.innerHeight,
      OG: x0 => x0.minHeight,
      OH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      OI: x0 => x0.unlock(),
      OJ: (x0,x1) => { x0.height = x1 },
      P: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      PC: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      PD: x0 => x0.offsetX,
      PE: x0 => new window.FinalizationRegistry(x0),
      PF: x0 => x0.innerWidth,
      PG: x0 => x0.minWidth,
      PH: x0 => x0.data,
      PI: (x0,x1) => x0.lock(x1),
      PJ: (x0,x1) => { x0.width = x1 },
      Q: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      QB: o => o.byteOffset,
      QC: (x0,x1) => x0.warn(x1),
      QD: x0 => x0.type,
      QE: (x0,x1) => x0.unregister(x1),
      QF: x0 => x0.height,
      QG: o => o.byteLength,
      QH: x0 => x0.index,
      QI: x0 => x0.orientation,
      QJ: x0 => x0.convertToBlob(),
      R: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      RB: o => o.buffer,
      RC: x0 => x0.console,
      RD: x0 => x0.maxTouchPoints,
      RE: (x0,x1) => x0.contains(x1),
      RF: x0 => x0.width,
      RG: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      RH: x0 => x0.unicode,
      RI: (x0,x1) => x0.querySelector(x1),
      RJ: (x0,x1,x2) => new ImageData(x0,x1,x2),
      S: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SB: Function.prototype.call.bind(DataView.prototype.getUint8),
      SC: () => globalThis.window,
      SD: x0 => x0.platform,
      SE: (s) => +s,
      SF: x0 => x0.clientHeight,
      SG: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      SH: (x0,x1) => { x0.lastIndex = x1 },
      SI: (x0,x1) => { x0.title = x1 },
      SJ: (x0,x1) => x0.getContext(x1),
      T: x0 => new Promise(x0),
      TB: (b, o) => new DataView(b, o),
      TC: (o, c) => o instanceof c,
      TD: x0 => x0.body,
      TE: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      TF: x0 => x0.clientWidth,
      TG: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      TH: x0 => x0.dotAll,
      TI: (x0,x1) => x0.vibrate(x1),
      TJ: (x0,x1) => new OffscreenCanvas(x0,x1),
      U: (x0,x1,x2) => x0.call(x1,x2),
      UB: (b, o, l) => new DataView(b, o, l),
      UC: (string, token) => string.split(token),
      UD: () => globalThis.document,
      UE: s => s.trim(),
      UF: (x0,x1) => { x0.content = x1 },
      UG: x0 => x0.debugSkipFontRetryDelay,
      UH: x0 => x0.ignoreCase,
      UI: x0 => x0.content,
      UJ: x0 => x0.allocationSize(),
      V: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      VB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      VC: o => o instanceof Array,
      VD: (x0,x1,x2) => x0.addEventListener(x1,x2),
      VE: x0 => x0.classList,
      VF: (x0,x1) => { x0.name = x1 },
      VG: x0 => x0.status,
      VH: x0 => x0.multiline,
      VI: x0 => x0.document,
      VJ: (x0,x1) => x0.copyTo(x1),
      W: x0 => new Array(x0),
      WB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      WC: (a, i) => a[i],
      WD: x0 => x0.hasFocus(),
      WE: x0 => x0.preventDefault(),
      WF: x0 => x0.head,
      WG: (x0,x1,x2) => x0.set(x1,x2),
      WH: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      WI: (a, t) => a.concat(t),
      WJ: (x0,x1) => x0.toDataURL(x1),
      X: o => [o],
      XB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      XC: a => a.length,
      XD: x0 => x0.relatedTarget,
      XE: x0 => x0.parent,
      XF: (x0,x1) => x0.removeChild(x1),
      XG: x0 => x0.arrayBuffer(),
      XH: x0 => x0.keyCode,
      XI: x0 => new WeakRef(x0),
      XJ: (x0,x1,x2,x3) => x0.drawImage(x1,x2,x3),
      Y: (o0, o1) => [o0, o1],
      YB: (t, s) => t.set(s),
      YC: x0 => x0.userAgent,
      YD: x0 => x0.shiftKey,
      YE: x0 => x0.timeStamp,
      YF: x0 => x0.firstChild,
      YG: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      YH: (x0,x1) => x0.scrollIntoView(x1),
      YI: x0 => x0.deref(),
      YJ: x0 => x0.format,
      Z: (o0, o1, o2) => [o0, o1, o2],
      ZB: Function.prototype.call.bind(DataView.prototype.setFloat32),
      ZC: x0 => x0.navigator,
      ZD: (decoder, codeUnits) => decoder.decode(codeUnits),
      ZE: (x0,x1) => x0.hasAttribute(x1),
      ZF: x0 => x0.viewConstraints,
      ZG: (x0,x1) => x0.fetch(x1),
      ZH: x0 => x0.multiViewEnabled,
      ZI: () => globalThis.WeakRef,
      ZJ: (x0,x1,x2,x3,x4) => x0.getImageData(x1,x2,x3,x4),
      a: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      aB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      aC: Function.prototype.call.bind(String.prototype.toLowerCase),
      aD: () => new TextDecoder("utf-8", {fatal: true}),
      aE: x0 => x0.buttons,
      aF: x0 => x0.hostElement,
      aG: x0 => x0.fontFallbackBaseUrl,
      aH: (x0,x1) => x0.replaceWith(x1),
      aI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      aJ: x0 => x0.data,
      b: (x0,x1,x2) => { x0[x1] = x2 },
      bB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      bC: Object.is,
      bD: () => new TextDecoder("utf-8", {fatal: false}),
      bE: x0 => x0.ctrlKey,
      bF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      bG: (handle) => clearInterval(handle),
      bH: (x0,x1) => { x0.className = x1 },
      bI: (a, s, e) => a.slice(s, e),
      bJ: x0 => x0.protocol,
      c: o => o,
      cB: Function.prototype.call.bind(DataView.prototype.getUint32),
      cC: x0 => x0.vendor,
      cD: (a, i, v) => a[i] = v,
      cE: x0 => x0.y,
      cF: x0 => ({runApp: x0}),
      cG: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      cH: (x0,x1) => { x0.action = x1 },
      cI: x0 => x0.close(),
      cJ: (x0,x1,x2) => x0.close(x1,x2),
      d: (o, p) => o[p],
      dB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      dC: (x0,x1) => x0.createTextNode(x1),
      dD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      dE: x0 => x0.x,
      dF: () => typeof dartUseDateNowForTicks !== "undefined",
      dG: () => Date.now(),
      dH: (x0,x1) => { x0.method = x1 },
      dI: (x0,x1,x2,x3,x4,x5) => x0.createImageBitmap(x1,x2,x3,x4,x5),
      dJ: x0 => x0.close(),
      e: () => globalThis,
      eB: Function.prototype.call.bind(DataView.prototype.getInt32),
      eC: (x0,x1) => { x0.id = x1 },
      eD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI16ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      eE: x0 => x0.scrollTop,
      eF: () => Date.now(),
      eG: (x0,x1) => x0.removeProperty(x1),
      eH: (x0,x1) => { x0.noValidate = x1 },
      eI: (x0,x1) => x0.createImageBitmap(x1),
      eJ: (x0,x1) => x0.send(x1),
      f: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      fC: (x0,x1) => { x0.nonce = x1 },
      fD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      fE: x0 => x0.offsetTop,
      fF: () => 1000 * performance.now(),
      fG: (x0,x1,x2) => x0.insertBefore(x1,x2),
      fH: (x0,x1) => x0.transferFromImageBitmap(x1),
      fI: x0 => new Blob(x0),
      fJ: () => new Array(),
      g: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gB: o => o instanceof Uint16Array,
      gC: x0 => x0.nonce,
      gD: x0 => x0.visibilityState,
      gE: x0 => x0.scrollLeft,
      gF: (x0,x1) => x0.requestAnimationFrame(x1),
      gG: x0 => x0.parentElement,
      gH: (x0,x1) => x0.getContext(x1),
      gI: x0 => x0.close(),
      gJ: (x0,x1) => new WebSocket(x0,x1),
      h: (x0,x1) => ({addView: x0,removeView: x1}),
      hB: Function.prototype.call.bind(DataView.prototype.getUint16),
      hC: () => globalThis.window.flutterConfiguration,
      hD: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      hE: x0 => x0.offsetLeft,
      hF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hG: (x0,x1) => x0.removeAttribute(x1),
      hH: (x0,x1) => { x0.height = x1 },
      hI: x0 => x0.naturalHeight,
      hJ: x0 => x0.reason,
      i: (l, r) => l === r,
      iB: o => o instanceof Int16Array,
      iC: (x0,x1) => x0.attachShadow(x1),
      iD: x0 => x0.disconnect(),
      iE: x0 => x0.offsetParent,
      iF: x0 => x0.now(),
      iG: x0 => x0.id,
      iH: (x0,x1) => { x0.width = x1 },
      iI: x0 => x0.naturalWidth,
      iJ: x0 => x0.code,
      j: x0 => x0.random(),
      jB: Function.prototype.call.bind(DataView.prototype.getInt16),
      jC: (x0,x1) => x0.createElement(x1),
      jD: x0 => new Intl.Locale(x0),
      jE: (o, p, r) => o.replaceAll(p, () => r),
      jF: x0 => x0.performance,
      jG: x0 => x0.isConnected,
      jH: x0 => x0.height,
      jI: (x0,x1) => { x0.src = x1 },
      jJ: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      k: o => o,
      kB: o => o instanceof Uint8ClampedArray,
      kC: x0 => x0.scale,
      kD: x0 => x0.region,
      kE: x0 => x0.deltaMode,
      kF: x0 => new Uint8Array(x0),
      kG: x0 => x0.offsetHeight,
      kH: x0 => x0.width,
      kI: x0 => x0.displayHeight,
      kJ: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      l: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'number') return 1;
        return 2;
      },
      lB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      lC: x0 => x0.visualViewport,
      lD: x0 => x0.script,
      lE: x0 => x0.deltaY,
      lF: (x0,x1,x2) => x0.slice(x1,x2),
      lG: x0 => x0.offsetWidth,
      lH: x0 => x0.rasterEndMilliseconds,
      lI: x0 => x0.displayWidth,
      lJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      m: () => globalThis.Math,
      mB: Function.prototype.call.bind(DataView.prototype.setInt32),
      mC: x0 => x0.devicePixelRatio,
      mD: x0 => x0.language,
      mE: x0 => x0.deltaX,
      mF: (x0,x1) => x0.decode(x1),
      mG: (x0,x1) => { x0.tabIndex = x1 },
      mH: x0 => x0.rasterStartMilliseconds,
      mI: x0 => x0.duration,
      mJ: (o, t) => typeof o === t,
      n: (x0,x1) => x0.prepend(x1),
      nB: Function.prototype.call.bind(DataView.prototype.setUint32),
      nC: x0 => x0.height,
      nD: x0 => x0.languages,
      nE: x0 => x0.wheelDeltaY,
      nF: (x0,x1) => x0.adoptText(x1),
      nG: x0 => x0.stopPropagation(),
      nH: x0 => x0.imageBitmaps,
      nI: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      nJ: x0 => x0.data,
      o: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      oB: Function.prototype.call.bind(DataView.prototype.setInt16),
      oC: x0 => x0.width,
      oD: (x0,x1) => x0.observe(x1),
      oE: x0 => x0.wheelDeltaX,
      oF: x0 => x0.first(),
      oG: x0 => x0.value,
      oH: x0 => x0.canvasKitMaximumSurfaces,
      oI: (x0,x1) => x0.decode(x1),
      oJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      p: b => !!b,
      pB: Function.prototype.call.bind(DataView.prototype.setUint16),
      pC: x0 => x0.screen,
      pD: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      pE: x0 => x0.key,
      pF: x0 => x0.next(),
      pG: x0 => x0.disabled,
      pH: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      pI: x0 => x0.image,
      pJ: x0 => x0.readyState,
      q: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qB: Function.prototype.call.bind(DataView.prototype.setUint8),
      qC: (string, times) => string.repeat(times),
      qD: x0 => new ResizeObserver(x0),
      qE: x0 => x0.identifier,
      qF: x0 => x0.current(),
      qG: (x0,x1) => { x0.type = x1 },
      qH: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      qI: x0 => x0.close(),
      qJ: (x0,x1) => { x0.binaryType = x1 },
      r: (x0,x1) => x0.focus(x1),
      rB: Function.prototype.call.bind(DataView.prototype.setInt8),
      rC: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      rD: (x0,x1) => x0.getPropertyValue(x1),
      rE: x0 => x0.touches,
      rF: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      rG: (x0,x1) => { x0.min = x1 },
      rH: (a, i) => a.splice(i, 1),
      rI: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      rJ: x0 => x0.hostElement,
      s: () => ({}),
      sB: Function.prototype.call.bind(DataView.prototype.getInt8),
      sC: x0 => x0.tabIndex,
      sD: x0 => globalThis.parseFloat(x0),
      sE: x0 => x0.pressure,
      sF: x0 => x0.v8BreakIterator,
      sG: (x0,x1) => { x0.max = x1 },
      sH: a => a.pop(),
      sI: x0 => new window.ImageDecoder(x0),
      sJ: x0 => x0.location,
      t: (o, p, v) => o[p] = v,
      tB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      tC: (x0,x1) => x0.contains(x1),
      tD: (x0,x1) => x0.getComputedStyle(x1),
      tE: x0 => x0.tiltY,
      tF: () => globalThis.Intl,
      tG: (x0,x1) => { x0.value = x1 },
      tH: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      tI: x0 => x0.name,
      tJ: (x0,x1) => x0.getModifierState(x1),
      u: () => [],
      uB: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      uC: x0 => x0.activeElement,
      uD: x0 => x0.documentElement,
      uE: x0 => x0.tiltX,
      uF: (x0,x1) => x0.segment(x1),
      uG: (x0,x1) => { x0.disabled = x1 },
      uH: x0 => x0.history,
      uI: x0 => x0.repetitionCount,
      uJ: x0 => x0.metaKey,
      v: (a, i) => a.push(i),
      vB: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      vC: x0 => x0.parentNode,
      vD: x0 => x0.computedStyleMap(),
      vE: x0 => x0.pointerType,
      vF: x0 => x0.index,
      vG: (x0,x1) => { x0.scrollTop = x1 },
      vH: x0 => x0.search,
      vI: x0 => x0.frameCount,
      vJ: x0 => x0.altKey,
      w: x0 => new Int8Array(x0),
      wB: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      wC: x0 => x0.tagName,
      wD: (x0,x1) => x0.get(x1),
      wE: x0 => x0.pointerId,
      wF: x0 => x0.next(),
      wG: (x0,x1) => { x0.scrollLeft = x1 },
      wH: x0 => x0.location,
      wI: x0 => x0.selectedTrack,
      wJ: x0 => x0.ctrlKey,
      x: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      xB: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      xC: x0 => x0.target,
      xD: (o, p) => p in o,
      xE: x0 => x0.getCoalescedEvents(),
      xF: x0 => x0.value,
      xG: (x0,x1) => x0.add(x1),
      xH: x0 => x0.pathname,
      xI: x0 => x0.completed,
      xJ: x0 => x0.isComposing,
      y: x0 => new Uint8Array(x0),
      yB: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      yC: x0 => x0.clientY,
      yD: (x0,x1) => { x0.textContent = x1 },
      yE: (x0,x1) => x0.getModifierState(x1),
      yF: x0 => x0.done,
      yG: (x0,x1) => { x0.value = x1 },
      yH: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      yI: x0 => x0.ready,
      yJ: x0 => x0.code,
      z: x0 => new Uint8ClampedArray(x0),
      zB: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      zC: x0 => x0.clientX,
      zD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      zE: s => s.trimLeft(),
      zF: (o, m, a) => o[m].apply(o, a),
      zG: x0 => x0.value,
      zH: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      zI: x0 => x0.tracks,
      zJ: x0 => x0.repeat,

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
