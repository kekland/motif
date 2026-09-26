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
            AB: x0 => new Int16Array(x0),
      AC: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      AD: x0 => x0.clientX,
      AE: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      AF: x0 => x0.touches,
      AG: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      AH: x0 => x0.selectionDirection,
      AI: x0 => x0.id,
      AJ: x0 => x0.ready,
      AK: (x0,x1) => x0.openCursor(x1),
      AL: (x0,x1,x2) => x0._motif_paragraph_builder_create(x1,x2),
      AM: x0 => x0.body,
      B: s => printToConsole(s),
      BB: x0 => new Uint16Array(x0),
      BC: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      BD: (x0,x1,x2) => x0.addEventListener(x1,x2),
      BE: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      BF: x0 => x0.pressure,
      BG: x0 => x0.v8BreakIterator,
      BH: x0 => x0.selectionStart,
      BI: x0 => x0.offsetHeight,
      BJ: x0 => x0.tracks,
      BK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      BL: (x0,x1) => x0._motif_paragraph_style_destroy(x1),
      BM: x0 => x0.headers,
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI16ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      CC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      CD: (x0,x1,x2) => x0.setAttribute(x1,x2),
      CE: (o, i) => o[i],
      CF: x0 => x0.tiltY,
      CG: () => globalThis.Intl,
      CH: x0 => x0.selectionEnd,
      CI: x0 => x0.offsetWidth,
      CJ: () => globalThis.window.ImageDecoder,
      CK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      CL: x0 => x0._motif_paragraph_style_create(),
      CM: x0 => x0.signal,
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: x0 => new Int32Array(x0),
      DC: (x0,x1) => x0.querySelector(x1),
      DD: x0 => x0.hasFocus(),
      DE: o => o.length,
      DF: x0 => x0.tiltX,
      DG: (x0,x1) => x0.segment(x1),
      DH: (x0,x1) => { x0.name = x1 },
      DI: x0 => x0.stopPropagation(),
      DJ: (x0,x1) => x0.postMessage(x1),
      DK: x0 => x0.continue(),
      DL: (x0,x1,x2,x3) => x0._motif_text_style_set_font_families(x1,x2,x3),
      DM: x0 => x0.close(),
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
      ED: (x0,x1) => x0.closest(x1),
      EE: o => {
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
      EF: x0 => x0.pointerType,
      EG: x0 => x0.index,
      EH: (x0,x1) => { x0.placeholder = x1 },
      EI: x0 => x0.disabled,
      EJ: x0 => new BroadcastChannel(x0),
      EK: x0 => x0.primaryKey,
      EL: (x0,x1,x2,x3) => x0.setValue(x1,x2,x3),
      EM: x0 => x0.delete(),
      F: () => new Error().stack,
      FB: x0 => new Uint32Array(x0),
      FC: x0 => x0.length,
      FD: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      FE: x0 => x0.language,
      FF: x0 => x0.pointerId,
      FG: x0 => x0.next(),
      FH: (x0,x1) => { x0.autocomplete = x1 },
      FI: (x0,x1) => { x0.min = x1 },
      FJ: x0 => x0.message,
      FK: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      FL: (x0,x1) => x0._motif_text_style_destroy(x1),
      FM: x0 => x0.openCursor(),
      G: s => JSON.stringify(s),
      GB: x0 => new Float32Array(x0),
      GC: (x0,x1) => x0.querySelectorAll(x1),
      GD: (handle) => clearTimeout(handle),
      GE: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      GF: x0 => x0.getCoalescedEvents(),
      GG: x0 => x0.value,
      GH: (x0,x1) => { x0.type = x1 },
      GI: (x0,x1) => { x0.max = x1 },
      GJ: x0 => x0.name,
      GK: (a, i) => a.splice(i, 1)[0],
      GL: x0 => x0._motif_text_style_create(),
      GM: (x0,x1) => { x0.onmessage = x1 },
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      HC: (x0,x1) => x0.getAttribute(x1),
      HD: x0 => x0.maxTouchPoints,
      HE: () => globalThis.window.FinalizationRegistry,
      HF: s => s.trimLeft(),
      HG: x0 => x0.done,
      HH: (x0,x1) => { x0.name = x1 },
      HI: (x0,x1) => { x0.disabled = x1 },
      HJ: (x0,x1) => x0.put(x1),
      HK: (x0,x1) => { x0.cursor = x1 },
      HL: (x0,x1) => x0.UTF8ToString(x1),
      HM: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: x0 => new Float64Array(x0),
      IC: x0 => x0.remove(),
      ID: x0 => x0.platform,
      IE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      IF: s => s.toUpperCase(),
      IG: (o, m, a) => o[m].apply(o, a),
      IH: (x0,x1) => { x0.placeholder = x1 },
      II: (x0,x1) => { x0.scrollLeft = x1 },
      IJ: (x0,x1,x2) => x0.put(x1,x2),
      IK: x0 => x0.cursor,
      IL: (x0,x1,x2,x3) => x0._motif_font_provider_family_name(x1,x2,x3),
      IM: (x0,x1,x2) => x0.open(x1,x2),
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      JC: (x0,x1) => x0.appendChild(x1),
      JD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      JE: x0 => new window.FinalizationRegistry(x0),
      JF: (x0,x1) => x0[x1],
      JG: x0 => x0.iterator,
      JH: (x0,x1) => { x0.scrollTop = x1 },
      JI: (x0,x1) => { x0.spellcheck = x1 },
      JJ: x0 => x0.getTime(),
      JK: x0 => x0.style,
      JL: (x0,x1) => x0._motif_font_provider_family_count(x1),
      JM: (x0,x1) => x0.open(x1),
      K: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      KB: x0 => new ArrayBuffer(x0),
      KC: (x0,x1) => x0.append(x1),
      KD: Date.now,
      KE: (x0,x1) => x0.unregister(x1),
      KF: x0 => x0.length,
      KG: () => globalThis.Symbol,
      KH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      KI: (x0,x1) => { x0.disabled = x1 },
      KJ: x0 => globalThis.Object.keys(x0),
      KK: (x0,x1) => x0.querySelector(x1),
      KL: (x0,x1,x2) => new Float32Array(x0,x1,x2),
      KM: x0 => x0.name,
      L: o => o === undefined,
      LB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      LC: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      LD: (x0,x1) => x0.contains(x1),
      LE: x0 => x0.preventDefault(),
      LF: (x0,x1) => x0.exec(x1),
      LG: (x0,x1) => new Intl.Segmenter(x0,x1),
      LH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      LI: (x0,x1) => x0.transferFromImageBitmap(x1),
      LJ: x0 => x0.length,
      LK: x0 => x0.body,
      LL: x0 => x0.buffer,
      LM: (x0,x1) => ({unique: x0,multiEntry: x1}),
      M: o => String(o),
      MB: (x0,x1,x2) => new DataView(x0,x1,x2),
      MC: x0 => x0.style,
      MD: (decoder, codeUnits) => decoder.decode(codeUnits),
      ME: x0 => x0.parent,
      MF: x0 => x0.index,
      MG: x0 => x0.Segmenter,
      MH: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      MI: (x0,x1) => x0.getContext(x1),
      MJ: (o) => Array.isArray(o) || o instanceof Array,
      MK: () => globalThis.document,
      ML: x0 => x0.HEAPF32,
      MM: (x0,x1,x2,x3) => x0.createIndex(x1,x2,x3),
      N: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      NB: (o, p) => o[p],
      NC: x0 => x0.debugShowSemanticsNodes,
      ND: () => new TextDecoder("utf-8", {fatal: true}),
      NE: x0 => x0.timeStamp,
      NF: x0 => x0.flags,
      NG: x0 => x0.buffer,
      NH: x0 => x0.keyCode,
      NI: (x0,x1) => { x0.height = x1 },
      NJ: (o, t) => typeof o === t,
      NK: x0 => x0.pop(),
      NL: (x0,x1,x2) => x0.getValue(x1,x2),
      NM: (x0,x1) => ({keyPath: x0,autoIncrement: x1}),
      O: (x0,x1) => x0.didCreateEngineInitializer(x1),
      OB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      OC: o => o,
      OD: () => new TextDecoder("utf-8", {fatal: false}),
      OE: (x0,x1) => x0.hasAttribute(x1),
      OF: (a, s) => a.join(s),
      OG: x0 => x0.wasmMemory,
      OH: (x0,x1) => x0.scrollIntoView(x1),
      OI: (x0,x1) => { x0.width = x1 },
      OJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      OK: x0 => ({type: x0}),
      OL: (x0,x1,x2) => x0._motif_paragraph_get_glyph_path(x1,x2),
      OM: (x0,x1,x2) => x0.createObjectStore(x1,x2),
      P: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      PC: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      PD: (a, i, v) => a[i] = v,
      PE: x0 => x0.type,
      PF: (x0,x1) => x0.error(x1),
      PG: () => globalThis.window._flutter_skwasmInstance,
      PH: x0 => x0.multiViewEnabled,
      PI: x0 => x0.height,
      PJ: (x0,x1) => { x0.onerror = x1 },
      PK: (x0,x1) => new Blob(x0,x1),
      PL: (x0,x1) => x0._motif_paragraph_get_glyph_metrics(x1),
      PM: x0 => x0.oldVersion,
      Q: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      QB: o => o.byteOffset,
      QC: (x0,x1) => x0.warn(x1),
      QD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      QE: (x0,x1) => x0.getModifierState(x1),
      QF: () => globalThis.console,
      QG: () => new TextDecoder(),
      QH: (x0,x1) => x0.replaceWith(x1),
      QI: x0 => x0.width,
      QJ: x0 => x0.message,
      QK: x0 => globalThis.URL.createObjectURL(x0),
      QL: (x0,x1) => x0._motif_paragraph_get_glyph_metrics_count(x1),
      QM: x0 => x0.target,
      R: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      RB: o => o.buffer,
      RC: x0 => x0.console,
      RD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI16ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      RE: x0 => x0.buttons,
      RF: s => s.trimRight(),
      RG: (map, o, v) => map.set(o, v),
      RH: (x0,x1) => { x0.className = x1 },
      RI: x0 => x0.rasterEndMilliseconds,
      RJ: x0 => x0.error,
      RK: x0 => x0.devicePixelRatio,
      RL: (x0,x1,x2,x3,x4,x5) => x0._motif_font_provider_add(x1,x2,x3,x4,x5),
      RM: (x0,x1) => x0.deleteDatabase(x1),
      S: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SB: Function.prototype.call.bind(DataView.prototype.getUint8),
      SC: () => globalThis.window,
      SD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      SE: x0 => x0.ctrlKey,
      SF: x0 => x0.blur(),
      SG: (map, o) => map.get(o),
      SH: (x0,x1) => { x0.tabIndex = x1 },
      SI: x0 => x0.rasterStartMilliseconds,
      SJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      SK: () => globalThis.window,
      SL: (x0,x1) => x0._motif_font_provider_destroy(x1),
      SM: x0 => x0.indexedDB,
      T: x0 => new Promise(x0),
      TB: (b, o) => new DataView(b, o),
      TC: (o, c) => o instanceof c,
      TD: (s) => +s,
      TE: x0 => x0.getBoundingClientRect(),
      TF: x0 => x0.button,
      TG: () => new WeakMap(),
      TH: (x0,x1) => { x0.action = x1 },
      TI: x0 => x0.imageBitmaps,
      TJ: (x0,x1) => { x0.onsuccess = x1 },
      TK: (x0,x1,x2,x3) => x0.putImageData(x1,x2,x3),
      TL: x0 => x0._motif_font_provider_create(),
      TM: () => globalThis.skiaReady,
      U: (x0,x1,x2) => x0.call(x1,x2),
      UB: (b, o, l) => new DataView(b, o, l),
      UC: (string, token) => string.split(token),
      UD: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      UE: x0 => x0.y,
      UF: (x0,x1) => x0.prepend(x1),
      UG: (d, digits) => d.toFixed(digits),
      UH: (x0,x1) => { x0.method = x1 },
      UI: x0 => x0.canvasKitMaximumSurfaces,
      UJ: x0 => x0.result,
      UK: x0 => x0.arrayBuffer(),
      UL: (x0,x1) => x0.getRandomValues(x1),
      UM: x0 => x0.hostElement,
      V: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      VB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      VC: o => o instanceof Array,
      VD: s => s.trim(),
      VE: x0 => x0.x,
      VF: x0 => x0.parentElement,
      VG: x0 => x0.maxHeight,
      VH: (x0,x1) => { x0.noValidate = x1 },
      VI: x0 => x0.cancel(),
      VJ: x0 => new Date(x0),
      VK: (x0,x1) => { x0.height = x1 },
      VL: () => globalThis.crypto,
      VM: x0 => x0.location,
      W: x0 => new Array(x0),
      WB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      WC: (a, i) => a[i],
      WD: x0 => x0.classList,
      WE: x0 => x0.top,
      WF: x0 => x0.innerHeight,
      WG: x0 => x0.maxWidth,
      WH: x0 => x0.click(),
      WI: x0 => x0.name,
      WJ: (o, p, v) => o[p] = v,
      WK: (x0,x1) => { x0.width = x1 },
      WL: l => new DataView(new ArrayBuffer(l)),
      WM: (x0,x1) => x0.getModifierState(x1),
      X: o => [o],
      XB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      XC: a => a.length,
      XD: x0 => x0.relatedTarget,
      XE: x0 => x0.left,
      XF: x0 => x0.innerWidth,
      XG: x0 => x0.minHeight,
      XH: (x0,x1) => x0.getElementsByClassName(x1),
      XI: (a, i) => a.splice(i, 1),
      XJ: (x0,x1) => x0.add(x1),
      XK: x0 => x0.convertToBlob(),
      XL: x0 => x0.protocol,
      XM: x0 => x0.metaKey,
      Y: (o0, o1) => [o0, o1],
      YB: (t, s) => t.set(s),
      YC: (x0,x1) => x0.test(x1),
      YD: x0 => x0.shiftKey,
      YE: x0 => x0.scrollTop,
      YF: x0 => x0.height,
      YG: x0 => x0.minWidth,
      YH: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      YI: a => a.pop(),
      YJ: (x0,x1) => x0.delete(x1),
      YK: (x0,x1,x2) => new ImageData(x0,x1,x2),
      YL: (x0,x1,x2) => x0.close(x1,x2),
      YM: x0 => x0.altKey,
      Z: (o0, o1, o2) => [o0, o1, o2],
      ZB: Function.prototype.call.bind(DataView.prototype.setFloat32),
      ZC: x0 => x0.userAgent,
      ZD: x0 => x0.body,
      ZE: x0 => x0.offsetTop,
      ZF: x0 => x0.width,
      ZG: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      ZH: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      ZI: x0 => new WeakRef(x0),
      ZJ: (x0,x1) => globalThis.IDBKeyRange.lowerBound(x0,x1),
      ZK: (x0,x1) => x0.getContext(x1),
      ZL: x0 => x0.close(),
      ZM: x0 => x0.ctrlKey,
      a: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      aB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      aC: x0 => x0.navigator,
      aD: x0 => x0.visibilityState,
      aE: x0 => x0.scrollLeft,
      aF: x0 => x0.clientHeight,
      aG: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      aH: (x0,x1) => x0.dispatchEvent(x1),
      aI: x0 => x0.deref(),
      aJ: (x0,x1) => globalThis.IDBKeyRange.upperBound(x0,x1),
      aK: (x0,x1) => new OffscreenCanvas(x0,x1),
      aL: (x0,x1) => x0.send(x1),
      aM: x0 => x0.isComposing,
      b: (x0,x1,x2) => { x0[x1] = x2 },
      bB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      bC: Function.prototype.call.bind(String.prototype.toLowerCase),
      bD: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      bE: x0 => x0.offsetLeft,
      bF: x0 => x0.clientWidth,
      bG: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      bH: (x0,x1) => x0.createEvent(x1),
      bI: () => globalThis.WeakRef,
      bJ: (x0,x1) => x0.getKey(x1),
      bK: x0 => x0.allocationSize(),
      bL: () => new Array(),
      bM: x0 => x0.code,
      c: o => o,
      cB: Function.prototype.call.bind(DataView.prototype.getUint32),
      cC: Object.is,
      cD: x0 => x0.disconnect(),
      cE: x0 => x0.offsetParent,
      cF: x0 => x0.isConnected,
      cG: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      cH: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      cI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      cJ: (x0,x1) => x0.index(x1),
      cK: (x0,x1) => x0.copyTo(x1),
      cL: (x0,x1) => new WebSocket(x0,x1),
      cM: x0 => x0.repeat,
      d: (o, p) => o[p],
      dB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      dC: x0 => x0.vendor,
      dD: x0 => new Intl.Locale(x0),
      dE: x0 => x0.offsetY,
      dF: x0 => x0.head,
      dG: x0 => x0.history,
      dH: x0 => x0.readText(),
      dI: (a, s, e) => a.slice(s, e),
      dJ: x0 => x0.multiEntry,
      dK: (x0,x1) => x0.toDataURL(x1),
      dL: x0 => x0.reason,
      dM: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      e: () => globalThis,
      eB: Function.prototype.call.bind(DataView.prototype.getInt32),
      eC: (x0,x1) => x0.createTextNode(x1),
      eD: x0 => x0.region,
      eE: x0 => x0.offsetX,
      eF: (x0,x1) => { x0.content = x1 },
      eG: x0 => x0.search,
      eH: x0 => x0.clipboard,
      eI: x0 => x0.close(),
      eJ: x0 => x0.unique,
      eK: (x0,x1,x2,x3) => x0.drawImage(x1,x2,x3),
      eL: x0 => x0.code,
      eM: x0 => x0.userAgent,
      f: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      fC: (x0,x1) => { x0.id = x1 },
      fD: x0 => x0.script,
      fE: (o, p, r) => o.replace(p, () => r),
      fF: (x0,x1) => { x0.name = x1 },
      fG: x0 => x0.location,
      fH: (x0,x1) => x0.writeText(x1),
      fI: (x0,x1,x2,x3,x4,x5) => x0.createImageBitmap(x1,x2,x3,x4,x5),
      fJ: x0 => x0.keyPath,
      fK: x0 => x0.format,
      fL: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      fM: x0 => x0.navigator,
      g: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gB: o => o instanceof Uint16Array,
      gC: (x0,x1) => { x0.nonce = x1 },
      gD: x0 => x0.language,
      gE: (x0,x1) => { x0.lastIndex = x1 },
      gF: (x0,x1) => x0.removeChild(x1),
      gG: x0 => x0.pathname,
      gH: x0 => x0.unlock(),
      gI: (x0,x1) => x0.createImageBitmap(x1),
      gJ: x0 => x0.name,
      gK: (x0,x1,x2,x3,x4) => x0.getImageData(x1,x2,x3,x4),
      gL: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      gM: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      h: (x0,x1) => ({addView: x0,removeView: x1}),
      hB: Function.prototype.call.bind(DataView.prototype.getUint16),
      hC: x0 => x0.nonce,
      hD: x0 => x0.languages,
      hE: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      hF: x0 => x0.firstChild,
      hG: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      hH: (x0,x1) => x0.lock(x1),
      hI: x0 => new Blob(x0),
      hJ: (x0,x1) => x0.get(x1),
      hK: x0 => x0.data,
      hL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hM: x0 => x0.baseURI,
      i: (l, r) => l === r,
      iB: o => o instanceof Int16Array,
      iC: () => globalThis.window.flutterConfiguration,
      iD: (x0,x1) => x0.observe(x1),
      iE: o => o instanceof RegExp,
      iF: x0 => x0.viewConstraints,
      iG: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      iH: x0 => x0.orientation,
      iI: x0 => x0.close(),
      iJ: (x0,x1) => x0.objectStore(x1),
      iK: (x0,x1) => x0._motif_paragraph_get_height(x1),
      iL: x0 => x0.data,
      iM: x0 => x0.document,
      j: x0 => x0.random(),
      jB: Function.prototype.call.bind(DataView.prototype.getInt16),
      jC: (x0,x1) => x0.attachShadow(x1),
      jD: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      jE: x0 => x0.dotAll,
      jF: x0 => x0.hostElement,
      jG: o => Object.keys(o),
      jH: (x0,x1) => x0.querySelector(x1),
      jI: x0 => x0.naturalHeight,
      jJ: x0 => x0.autoIncrement,
      jK: (x0,x1) => x0._motif_paragraph_get_max_intrinsic_width(x1),
      jL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      jM: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      k: o => o,
      kB: o => o instanceof Uint8ClampedArray,
      kC: (x0,x1) => x0.createElement(x1),
      kD: x0 => new ResizeObserver(x0),
      kE: x0 => x0.unicode,
      kF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      kG: x0 => x0.state,
      kH: (x0,x1) => { x0.title = x1 },
      kI: x0 => x0.naturalWidth,
      kJ: x0 => x0.keyPath,
      kK: (x0,x1,x2) => x0._motif_paragraph_layout(x1,x2),
      kL: x0 => x0.readyState,
      kM: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
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
      lC: x0 => x0.scale,
      lD: (x0,x1) => x0.getPropertyValue(x1),
      lE: x0 => x0.ignoreCase,
      lF: x0 => ({runApp: x0}),
      lG: x0 => x0.hash,
      lH: (x0,x1) => x0.vibrate(x1),
      lI: (x0,x1) => { x0.src = x1 },
      lJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      lK: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      lL: (x0,x1) => { x0.binaryType = x1 },
      lM: x0 => x0.extraAssets,
      m: () => globalThis.Math,
      mB: Function.prototype.call.bind(DataView.prototype.setInt32),
      mC: x0 => x0.visualViewport,
      mD: x0 => globalThis.parseFloat(x0),
      mE: x0 => x0.multiline,
      mF: () => typeof dartUseDateNowForTicks !== "undefined",
      mG: x0 => x0.state,
      mH: x0 => x0.arrayBuffer(),
      mI: x0 => x0.displayHeight,
      mJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      mK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      mL: x0 => x0.abort(),
      mM: x0 => x0.fontManifest,
      n: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      nB: Function.prototype.call.bind(DataView.prototype.setUint32),
      nC: x0 => x0.devicePixelRatio,
      nD: (x0,x1) => x0.getComputedStyle(x1),
      nE: (o, p, r) => o.replaceAll(p, () => r),
      nF: () => Date.now(),
      nG: (x0,x1) => x0.go(x1),
      nH: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      nI: x0 => x0.displayWidth,
      nJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      nK: x0 => new FinalizationRegistry(x0),
      nL: () => new AbortController(),
      nM: x0 => x0.assetManifest,
      o: b => !!b,
      oB: Function.prototype.call.bind(DataView.prototype.setInt16),
      oC: x0 => x0.height,
      oD: x0 => x0.documentElement,
      oE: x0 => x0.deltaMode,
      oF: () => 1000 * performance.now(),
      oG: (x0,x1) => x0.querySelectorAll(x1),
      oH: x0 => x0.status,
      oI: x0 => x0.duration,
      oJ: (x0,x1) => { x0.oncomplete = x1 },
      oK: () => globalThis.FinalizationRegistry,
      oL: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      oM: x0 => x0.buildConfig,
      p: () => globalThis.document,
      pB: Function.prototype.call.bind(DataView.prototype.setUint16),
      pC: x0 => x0.width,
      pD: x0 => x0.computedStyleMap(),
      pE: x0 => x0.deltaY,
      pF: (x0,x1) => x0.requestAnimationFrame(x1),
      pG: (x0,x1) => x0.removeProperty(x1),
      pH: (x0,x1) => x0.fetch(x1),
      pI: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      pJ: (x0,x1) => { x0.onabort = x1 },
      pK: (x0,x1) => x0._motif_paragraph_destroy(x1),
      pL: (x0,x1) => globalThis.fetch(x0,x1),
      pM: x0 => x0.length,
      q: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qB: Function.prototype.call.bind(DataView.prototype.setUint8),
      qC: x0 => x0.screen,
      qD: (x0,x1) => x0.get(x1),
      qE: x0 => x0.deltaX,
      qF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qG: (x0,x1) => x0.add(x1),
      qH: x0 => x0.content,
      qI: (x0,x1) => x0.decode(x1),
      qJ: (x0,x1) => { x0.onerror = x1 },
      qK: (x0,x1) => x0._motif_paragraph_builder_build(x1),
      qL: (x0,x1) => x0.get(x1),
      qM: x0 => x0.getReader(),
      r: (x0,x1) => x0.focus(x1),
      rB: Function.prototype.call.bind(DataView.prototype.setInt8),
      rC: (string, times) => string.repeat(times),
      rD: (o, p) => p in o,
      rE: x0 => x0.wheelDeltaY,
      rF: x0 => x0.now(),
      rG: x0 => x0.data,
      rH: x0 => x0.document,
      rI: x0 => x0.image,
      rJ: x0 => x0.error,
      rK: (x0,x1) => x0._motif_paragraph_builder_pop_style(x1),
      rL: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2) { return wasmFunction(f,arguments.length,x0,x1,x2) }),
      rM: x0 => x0.value,
      s: () => ({}),
      sB: Function.prototype.call.bind(DataView.prototype.getInt8),
      sC: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      sD: (x0,x1) => { x0.textContent = x1 },
      sE: x0 => x0.wheelDeltaX,
      sF: x0 => x0.performance,
      sG: (x0,x1) => x0.removeAttribute(x1),
      sH: x0 => x0.debugSkipFontRetryDelay,
      sI: x0 => x0.close(),
      sJ: x0 => x0.name,
      sK: (x0,x1) => x0._free(x1),
      sL: (x0,x1) => x0.forEach(x1),
      sM: x0 => x0.done,
      t: (o, p, v) => o[p] = v,
      tB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      tC: x0 => x0.tabIndex,
      tD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      tE: x0 => x0.bottom,
      tF: x0 => new Uint8Array(x0),
      tG: (x0,x1) => { x0.value = x1 },
      tH: (x0,x1,x2) => x0.set(x1,x2),
      tI: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      tJ: (x0,x1) => x0.item(x1),
      tK: (x0,x1,x2) => x0._motif_paragraph_builder_add_text(x1,x2),
      tL: x0 => x0.statusText,
      tM: x0 => x0.read(),
      u: () => [],
      uB: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      uC: (x0,x1) => x0.contains(x1),
      uD: x0 => x0.matches,
      uE: x0 => x0.right,
      uF: (x0,x1,x2) => x0.slice(x1,x2),
      uG: (x0,x1) => { x0.value = x1 },
      uH: x0 => x0.fontFallbackBaseUrl,
      uI: x0 => new window.ImageDecoder(x0),
      uJ: x0 => x0.length,
      uK: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      uL: x0 => x0.url,
      uM: x0 => x0.body,
      v: (a, i) => a.push(i),
      vB: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      vC: x0 => x0.activeElement,
      vD: (x0,x1) => x0.matchMedia(x1),
      vE: x0 => x0.clientY,
      vF: (x0,x1) => x0.decode(x1),
      vG: x0 => x0.value,
      vH: (handle) => clearInterval(handle),
      vI: x0 => x0.name,
      vJ: x0 => x0.objectStoreNames,
      vK: x0 => x0.buffer,
      vL: x0 => x0.status,
      vM: x0 => x0.assetBase,
      w: x0 => new Int8Array(x0),
      wB: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      wC: x0 => x0.parentNode,
      wD: x0 => x0.matches,
      wE: x0 => x0.clientX,
      wF: (x0,x1) => x0.adoptText(x1),
      wG: x0 => x0.selectionDirection,
      wH: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      wI: x0 => x0.repetitionCount,
      wJ: (x0,x1,x2) => x0.transaction(x1,x2),
      wK: x0 => x0.HEAPU8,
      wL: x0 => x0.getReader(),
      wM: x0 => x0.loader,
      x: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      xB: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      xC: x0 => x0.tagName,
      xD: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      xE: x0 => x0.changedTouches,
      xF: x0 => x0.first(),
      xG: x0 => x0.selectionStart,
      xH: () => Date.now(),
      xI: x0 => x0.frameCount,
      xJ: x0 => x0.key,
      xK: (x0,x1) => x0._malloc(x1),
      xL: x0 => x0.read(),
      xM: () => globalThis._flutter,
      y: x0 => new Uint8Array(x0),
      yB: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      yC: x0 => x0.target,
      yD: f => f.dartFunction,
      yE: x0 => x0.key,
      yF: x0 => x0.next(),
      yG: x0 => x0.selectionEnd,
      yH: (a, t) => a.concat(t),
      yI: x0 => x0.selectedTrack,
      yJ: x0 => x0.value,
      yK: (x0,x1,x2) => x0._motif_paragraph_builder_push_style(x1,x2),
      yL: x0 => x0.value,
      z: x0 => new Uint8ClampedArray(x0),
      zB: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      zC: x0 => x0.clientY,
      zD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      zE: x0 => x0.identifier,
      zF: x0 => x0.current(),
      zG: x0 => x0.value,
      zH: (x0,x1,x2) => x0.insertBefore(x1,x2),
      zI: x0 => x0.completed,
      zJ: x0 => x0.openCursor(),
      zK: (x0,x1) => x0._motif_paragraph_builder_destroy(x1),
      zL: x0 => x0.done,

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
