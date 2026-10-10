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
            AB: x0 => new Uint8Array(x0),
      AC: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      AD: x0 => x0.target,
      AE: (o, p) => p in o,
      AF: x0 => x0.key,
      AG: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      AH: x0 => x0.selectionEnd,
      AI: () => Date.now(),
      AJ: x0 => x0.completed,
      AK: () => globalThis.FinalizationRegistry,
      AL: x0 => x0.read(),
      AM: x0 => globalThis.Number(x0),
      AN: x0 => x0.rawSql,
      AO: (x0,x1) => x0.sqlite3_errmsg(x1),
      AP: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      AQ: (x0,x1) => x0.postMessage(x1),
      AR: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      AS: x0 => x0.name,
      B: s => printToConsole(s),
      BB: x0 => new Uint8ClampedArray(x0),
      BC: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      BD: x0 => x0.clientY,
      BE: (x0,x1) => { x0.textContent = x1 },
      BF: x0 => x0.identifier,
      BG: x0 => x0.v8BreakIterator,
      BH: x0 => x0.value,
      BI: (a, t) => a.concat(t),
      BJ: x0 => x0.ready,
      BK: (x0,x1) => x0._motif_paragraph_destroy(x1),
      BL: (x0,x1) => x0.getType(x1),
      BM: x0 => x0.r,
      BN: x0 => x0.rawParameters,
      BO: (x0,x1) => x0.sqlite3_error_offset(x1),
      BP: (x0,x1) => { x0.onabort = x1 },
      BQ: (x0,x1) => ({a: x0,b: x1}),
      BR: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      BS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: x0 => new Int16Array(x0),
      CC: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      CD: x0 => x0.clientX,
      CE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      CF: x0 => x0.touches,
      CG: () => globalThis.Intl,
      CH: x0 => x0.selectionDirection,
      CI: (x0,x1,x2) => x0.insertBefore(x1,x2),
      CJ: x0 => x0.tracks,
      CK: (x0,x1) => x0._motif_paragraph_builder_build(x1),
      CL: x0 => x0.arrayBuffer(),
      CM: x0 => x0.v,
      CN: x0 => x0.rawKind,
      CO: (x0,x1) => x0.sqlite3_extended_errcode(x1),
      CP: (x0,x1,x2,x3,x4,x5,x6,x7) => ({c: x0,n: x1,v: x2,r: x3,x: x4,y: x5,i: x6,t: x7}),
      CQ: x0 => new BroadcastChannel(x0),
      CR: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2) { return wasmFunction(f,arguments.length,x0,x1,x2) }),
      CS: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: x0 => new Uint16Array(x0),
      DC: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      DD: (x0,x1,x2) => x0.setAttribute(x1,x2),
      DE: x0 => x0.matches,
      DF: x0 => x0.pressure,
      DG: (x0,x1) => x0.segment(x1),
      DH: x0 => x0.selectionStart,
      DI: x0 => x0.id,
      DJ: () => globalThis.window.ImageDecoder,
      DK: (x0,x1) => x0._motif_paragraph_builder_pop_style(x1),
      DL: x0 => x0.text(),
      DM: x0 => x0.n,
      DN: x0 => x0.r,
      DO: (x0,x1) => x0.sqlite3_close_v2(x1),
      DP: (x0,x1) => x0.sqlite3_step(x1),
      DQ: x0 => x0.name,
      DR: () => globalThis.WebAssembly,
      DS: x0 => x0.files,
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
        const getValue = dartInstance.exports.$wasmI16ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      EC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      ED: x0 => x0.getBoundingClientRect(),
      EE: (x0,x1) => x0.matchMedia(x1),
      EF: x0 => x0.tiltY,
      EG: x0 => x0.index,
      EH: x0 => x0.selectionEnd,
      EI: x0 => x0.offsetHeight,
      EJ: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      EK: (x0,x1) => x0._free(x1),
      EL: x0 => x0.types,
      EM: x0 => x0.c,
      EN: x0 => x0.i,
      EO: (x0,x1,x2) => x0.sqlite3_extended_result_codes(x1,x2),
      EP: (x0,x1,x2) => x0.sqlite3_bind_null(x1,x2),
      EQ: x0 => x0.parameterTypes,
      ER: x0 => x0.href,
      ES: (x0,x1) => { x0.display = x1 },
      F: () => new Error().stack,
      FB: x0 => new Int32Array(x0),
      FC: (x0,x1) => x0.querySelector(x1),
      FD: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      FE: x0 => x0.matches,
      FF: x0 => x0.tiltX,
      FG: x0 => x0.next(),
      FH: (x0,x1) => { x0.name = x1 },
      FI: x0 => x0.offsetWidth,
      FJ: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      FK: (x0,x1) => x0._malloc(x1),
      FL: x0 => x0.clipboard,
      FM: x0 => x0.y,
      FN: x0 => x0.i,
      FO: (x0,x1) => x0.dart_sqlite3_free(x1),
      FP: (x0,x1,x2,x3,x4) => x0.dart_sqlite3_bind_blob(x1,x2,x3,x4),
      FQ: x0 => x0.parameters,
      FR: x0 => x0.u,
      FS: (x0,x1) => { x0.accept = x1 },
      G: s => JSON.stringify(s),
      GB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      GC: (x0,x1) => x0.item(x1),
      GD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      GE: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      GF: x0 => x0.pointerType,
      GG: x0 => x0.value,
      GH: (x0,x1) => { x0.placeholder = x1 },
      GI: x0 => x0.stopPropagation(),
      GJ: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      GK: (x0,x1,x2) => x0._motif_paragraph_builder_add_text(x1,x2),
      GL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      GM: x0 => x0.x,
      GN: (o, a) => o == a,
      GO: (x0,x1,x2,x3,x4) => x0.sqlite3_open_v2(x1,x2,x3,x4),
      GP: (x0,x1,x2,x3,x4) => x0.dart_sqlite3_bind_text(x1,x2,x3,x4),
      GQ: x0 => x0.parameters,
      GR: x0 => x0.lockName,
      GS: (x0,x1) => { x0.multiple = x1 },
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: x0 => new Uint32Array(x0),
      HC: x0 => x0.length,
      HD: Date.now,
      HE: f => f.dartFunction,
      HF: x0 => x0.pointerId,
      HG: x0 => x0.done,
      HH: (x0,x1) => { x0.autocomplete = x1 },
      HI: x0 => x0.disabled,
      HJ: x0 => x0.pop(),
      HK: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      HL: (x0,x1,x2) => x0.addEventListener(x1,x2),
      HM: x0 => x0.e,
      HN: (x0,x1,x2,x3) => ({r: x0,i: x1,d: x2,t: x3}),
      HO: (x0,x1) => x0.dart_sqlite3_malloc(x1),
      HP: (x0,x1,x2,x3) => x0.sqlite3_bind_double(x1,x2,x3),
      HQ: x0 => x0.rawSql,
      HR: () => new MessageChannel(),
      HS: (x0,x1) => { x0.draggable = x1 },
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: x0 => new Float32Array(x0),
      IC: (x0,x1) => x0.querySelectorAll(x1),
      ID: (handle) => clearTimeout(handle),
      IE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      IF: x0 => x0.getCoalescedEvents(),
      IG: (o, m, a) => o[m].apply(o, a),
      IH: (x0,x1) => { x0.type = x1 },
      II: (x0,x1) => { x0.min = x1 },
      IJ: () => new AbortController(),
      IK: x0 => x0.buffer,
      IL: x0 => x0.preventDefault(),
      IM: x0 => x0.r,
      IN: (x0,x1) => x0.postMessage(x1),
      IO: x0 => x0.sqlite3_initialize(),
      IP: (x0,x1,x2,x3) => x0.sqlite3_bind_int64(x1,x2,x3),
      IQ: x0 => x0.requireTransaction,
      IR: (x0,x1) => ({port: x0,lockName: x1}),
      IS: (x0,x1) => { x0.type = x1 },
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      JC: (x0,x1) => x0.getAttribute(x1),
      JD: (x0,x1) => x0.closest(x1),
      JE: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      JF: (x0,x1) => x0.getModifierState(x1),
      JG: x0 => x0.iterator,
      JH: (x0,x1) => { x0.name = x1 },
      JI: (x0,x1) => { x0.max = x1 },
      JJ: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      JK: x0 => x0.HEAPU8,
      JL: (x0,x1) => x0.item(x1),
      JM: x0 => x0.s,
      JN: (x0,x1,x2) => x0.open(x1,x2),
      JO: (x0,x1,x2,x3) => x0.dart_sqlite3_register_vfs(x1,x2,x3),
      JP: (x0,x1) => x0.sqlite3_bind_parameter_count(x1),
      JQ: x0 => x0.z,
      JR: x0 => x0.port1,
      JS: x0 => x0.length,
      K: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      KB: x0 => new Float64Array(x0),
      KC: x0 => x0.remove(),
      KD: x0 => x0.bottom,
      KE: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      KF: s => s.trimLeft(),
      KG: () => globalThis.Symbol,
      KH: (x0,x1) => { x0.placeholder = x1 },
      KI: (x0,x1) => { x0.disabled = x1 },
      KJ: (x0,x1) => globalThis.fetch(x0,x1),
      KK: (x0,x1,x2) => x0._motif_paragraph_builder_push_style(x1,x2),
      KL: (x0,x1) => x0.getData(x1),
      KM: x0 => x0.t,
      KN: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      KO: (x0,x1) => x0.getRandomValues(x1),
      KP: (x0,x1) => x0.sqlite3_stmt_isexplain(x1),
      KQ: x0 => x0.o,
      KR: x0 => x0.port2,
      KS: x0 => x0.getReader(),
      L: o => o === undefined,
      LB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      LC: (x0,x1) => x0.appendChild(x1),
      LD: x0 => x0.top,
      LE: (o, i) => o[i],
      LF: s => s.toUpperCase(),
      LG: (x0,x1) => new Intl.Segmenter(x0,x1),
      LH: (x0,x1) => { x0.scrollTop = x1 },
      LI: (x0,x1) => { x0.scrollLeft = x1 },
      LJ: (x0,x1) => x0.get(x1),
      LK: (x0,x1) => x0._motif_paragraph_builder_destroy(x1),
      LL: x0 => x0.type,
      LM: (x0,x1,x2) => x0.postMessage(x1,x2),
      LN: x0 => x0.close(),
      LO: () => globalThis.crypto,
      LP: (x0,x1,x2,x3,x4,x5,x6) => x0.sqlite3_prepare_v3(x1,x2,x3,x4,x5,x6),
      LQ: x0 => x0.a,
      LR: () => new EventTarget(),
      LS: x0 => x0.value,
      M: o => String(o),
      MB: x0 => new ArrayBuffer(x0),
      MC: (x0,x1) => x0.append(x1),
      MD: x0 => x0.right,
      ME: o => o.length,
      MF: (x0,x1) => x0[x1],
      MG: x0 => x0.Segmenter,
      MH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      MI: (x0,x1) => { x0.spellcheck = x1 },
      MJ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2) { return wasmFunction(f,arguments.length,x0,x1,x2) }),
      MK: (x0,x1,x2) => x0._motif_paragraph_builder_create(x1,x2),
      ML: x0 => x0.length,
      MM: (x0,x1) => x0.push(x1),
      MN: x0 => x0.error,
      MO: l => new DataView(new ArrayBuffer(l)),
      MP: (x0,x1,x2,x3,x4,x5) => x0.sqlite3_exec(x1,x2,x3,x4,x5),
      MQ: x0 => x0.c,
      MR: x0 => ({data: x0}),
      MS: x0 => x0.done,
      N: () => globalThis.Promise.resolve(),
      NB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      NC: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      ND: x0 => x0.left,
      NE: o => {
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
      NF: x0 => x0.length,
      NG: x0 => x0.buffer,
      NH: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      NI: (x0,x1) => { x0.disabled = x1 },
      NJ: (x0,x1) => x0.forEach(x1),
      NK: (x0,x1,x2) => x0._motif_text_style_set_font_style(x1,x2),
      NL: x0 => x0.files,
      NM: x0 => x0.r,
      NN: x0 => x0.result,
      NO: (x0,x1,x2) => x0.transaction(x1,x2),
      NP: (x0,x1) => { x0.y = x1 },
      NQ: x0 => x0.s,
      NR: (x0,x1) => new MessageEvent(x0,x1),
      NS: x0 => x0.read(),
      O: (x0,x1) => x0.then(x1),
      OB: (x0,x1,x2) => new DataView(x0,x1,x2),
      OC: x0 => x0.style,
      OD: x0 => x0.clientY,
      OE: x0 => x0.language,
      OF: (x0,x1) => x0.exec(x1),
      OG: x0 => x0.wasmMemory,
      OH: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      OI: (x0,x1) => x0.transferFromImageBitmap(x1),
      OJ: x0 => x0.name,
      OK: (x0,x1,x2,x3) => x0.setValue(x1,x2,x3),
      OL: x0 => x0.clipboardData,
      OM: () => globalThis.ArrayBuffer,
      ON: (x0,x1) => { x0.onupgradeneeded = x1 },
      OO: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      OP: (x0,x1) => x0.sqlite3_last_insert_rowid(x1),
      OQ: x0 => x0.d,
      OR: x0 => new SharedWorker(x0),
      OS: x0 => x0.body,
      P: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      PB: (o, p) => o[p],
      PC: x0 => x0.debugShowSemanticsNodes,
      PD: x0 => x0.clientX,
      PE: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      PF: x0 => x0.index,
      PG: () => globalThis.window._flutter_skwasmInstance,
      PH: x0 => x0.keyCode,
      PI: (x0,x1) => x0.getContext(x1),
      PJ: x0 => x0.statusText,
      PK: (x0,x1,x2) => x0._motif_text_style_set_letter_spacing(x1,x2),
      PL: x0 => x0.target,
      PM: x0 => x0.r,
      PN: x0 => x0.abort(),
      PO: x0 => x0.commit(),
      PP: (x0,x1) => { x0.x = x1 },
      PQ: (x0,x1) => globalThis.fetch(x0,x1),
      PR: x0 => x0.port,
      PS: x0 => x0.assetBase,
      Q: (x0,x1) => x0.didCreateEngineInitializer(x1),
      QB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      QC: o => o,
      QD: x0 => x0.changedTouches,
      QE: () => globalThis.window.FinalizationRegistry,
      QF: x0 => x0.flags,
      QG: () => new TextDecoder(),
      QH: (x0,x1) => x0.scrollIntoView(x1),
      QI: (x0,x1) => { x0.height = x1 },
      QJ: x0 => x0.url,
      QK: (x0,x1,x2) => x0._motif_text_style_set_height(x1,x2),
      QL: x0 => new ClipboardItem(x0),
      QM: x0 => x0.v,
      QN: x0 => x0.transaction,
      QO: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      QP: (x0,x1) => { x0.i = x1 },
      QQ: (x0,x1) => x0.sqlite3session_delete(x1),
      QR: x0 => ({name: x0}),
      QS: x0 => x0.loader,
      R: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      RB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      RC: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      RD: x0 => x0.offsetY,
      RE: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      RF: (a, s) => a.join(s),
      RG: (map, o, v) => map.set(o, v),
      RH: x0 => x0.multiViewEnabled,
      RI: (x0,x1) => { x0.width = x1 },
      RJ: x0 => x0.status,
      RK: (x0,x1,x2,x3) => x0._motif_text_style_set_font_families(x1,x2,x3),
      RL: (x0,x1) => x0.write(x1),
      RM: x0 => x0.b,
      RN: x0 => x0.name,
      RO: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      RP: x0 => globalThis.Number(x0),
      RQ: (x0,x1) => x0.sqlite3changeset_finalize(x1),
      RR: (x0,x1) => new Worker(x0,x1),
      RS: () => globalThis._flutter,
      S: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      SB: o => o.byteOffset,
      SC: (x0,x1) => x0.warn(x1),
      SD: x0 => x0.offsetX,
      SE: x0 => new window.FinalizationRegistry(x0),
      SF: (x0,x1) => x0.error(x1),
      SG: (map, o) => map.get(o),
      SH: (x0,x1) => x0.replaceWith(x1),
      SI: x0 => x0.height,
      SJ: x0 => x0.getReader(),
      SK: (x0,x1,x2) => x0._motif_text_style_set_font_size(x1,x2),
      SL: (o, p, v) => o[p] = v,
      SM: x0 => x0.port,
      SN: x0 => x0.kind,
      SO: (x0,x1) => { x0.onerror = x1 },
      SP: x0 => globalThis.Number.isSafeInteger(x0),
      SQ: x0 => x0.exports,
      SR: (x0,x1,x2) => x0.postMessage(x1,x2),
      T: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      TB: o => o.buffer,
      TC: x0 => x0.console,
      TD: x0 => x0.type,
      TE: (x0,x1) => x0.unregister(x1),
      TF: () => globalThis.console,
      TG: () => new WeakMap(),
      TH: (x0,x1) => { x0.className = x1 },
      TI: x0 => x0.width,
      TJ: x0 => x0.read(),
      TK: (x0,x1) => x0._motif_text_style_destroy(x1),
      TL: (x0,x1,x2) => new Float32Array(x0,x1,x2),
      TM: x0 => x0.r,
      TN: () => globalThis.Symbol.asyncIterator,
      TO: x0 => new DOMException(x0),
      TP: (x0,x1,x2) => x0.setUint8(x1,x2),
      TQ: x0 => x0.call(),
      TR: (x0,x1,x2) => ({d: x0,i: x1,t: x2}),
      U: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      UB: Function.prototype.call.bind(DataView.prototype.getUint8),
      UC: () => globalThis.window,
      UD: x0 => x0.maxTouchPoints,
      UE: (x0,x1) => x0.contains(x1),
      UF: s => s.trimRight(),
      UG: (d, digits) => d.toFixed(digits),
      UH: (x0,x1) => { x0.tabIndex = x1 },
      UI: x0 => x0.rasterEndMilliseconds,
      UJ: x0 => x0.value,
      UK: x0 => x0._motif_text_style_create(),
      UL: x0 => x0.buffer,
      UM: (x0,x1) => { x0.i = x1 },
      UN: x0 => x0.next(),
      UO: x0 => x0.error,
      UP: (x0,x1) => x0.transfer(x1),
      UQ: x0 => x0.instance,
      UR: (x0,x1,x2) => ({d: x0,i: x1,t: x2}),
      V: x0 => new Promise(x0),
      VB: (b, o) => new DataView(b, o),
      VC: (o, c) => o instanceof c,
      VD: x0 => x0.platform,
      VE: (s) => +s,
      VF: x0 => x0.blur(),
      VG: x0 => x0.maxHeight,
      VH: (x0,x1) => { x0.action = x1 },
      VI: x0 => x0.rasterStartMilliseconds,
      VJ: x0 => x0.done,
      VK: (x0,x1,x2) => x0._motif_paragraph_style_set_ellipsis(x1,x2),
      VL: x0 => x0.HEAPF32,
      VM: (x0,x1,x2,x3,x4,x5,x6,x7,x8) => ({s: x0,p: x1,v: x2,z: x3,r: x4,c: x5,i: x6,d: x7,t: x8}),
      VN: x0 => x0.value,
      VO: (x0,x1) => { x0.onabort = x1 },
      VP: (x0,x1,x2) => x0.slice(x1,x2),
      VQ: (x0,x1,x2) => x0.instantiateStreaming(x1,x2),
      VR: (x0,x1) => x0.getFileHandle(x1),
      W: (x0,x1,x2) => x0.call(x1,x2),
      WB: (b, o, l) => new DataView(b, o, l),
      WC: (string, token) => string.split(token),
      WD: x0 => x0.body,
      WE: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      WF: x0 => x0.button,
      WG: x0 => x0.maxWidth,
      WH: (x0,x1) => { x0.method = x1 },
      WI: x0 => x0.imageBitmaps,
      WJ: x0 => x0.cancel(),
      WK: (x0,x1,x2) => x0._motif_paragraph_style_set_alignment(x1,x2),
      WL: (x0,x1,x2) => x0.getValue(x1,x2),
      WM: x0 => globalThis.BigInt(x0),
      WN: x0 => x0.done,
      WO: (x0,x1) => { x0.oncomplete = x1 },
      WP: (x0,x1,x2) => x0.sqlite3_column_name(x1,x2),
      WQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      WR: x0 => x0.hostElement,
      X: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      XB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      XC: o => o instanceof Array,
      XD: () => globalThis.document,
      XE: s => s.trim(),
      XF: x0 => x0.innerHeight,
      XG: x0 => x0.minHeight,
      XH: (x0,x1) => { x0.noValidate = x1 },
      XI: x0 => x0.canvasKitMaximumSurfaces,
      XJ: x0 => x0.body,
      XK: (x0,x1,x2) => x0._motif_paragraph_style_set_apply_rounding_hack(x1,x2),
      XL: (x0,x1,x2) => x0._motif_paragraph_get_glyph_path(x1,x2),
      XM: (x0,x1,x2) => ({i: x0,d: x1,t: x2}),
      XN: x0 => ({create: x0}),
      XO: (x0,x1) => x0.objectStore(x1),
      XP: (x0,x1,x2) => x0.sqlite3_column_blob(x1,x2),
      XQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      XR: x0 => x0.location,
      Y: x0 => new Array(x0),
      YB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      YC: (a, i) => a[i],
      YD: (x0,x1,x2) => x0.addEventListener(x1,x2),
      YE: x0 => x0.classList,
      YF: x0 => x0.innerWidth,
      YG: x0 => x0.minWidth,
      YH: x0 => x0.isConnected,
      YI: (a, i) => a.splice(i, 1),
      YJ: x0 => x0.headers,
      YK: (x0,x1) => x0._motif_paragraph_style_destroy(x1),
      YL: (x0,x1) => x0._motif_paragraph_get_glyph_metrics(x1),
      YM: (x0,x1,x2,x3) => ({rawKind: x0,rawSql: x1,rawParameters: x2,typeInfo: x3}),
      YN: (x0,x1,x2) => x0.getDirectoryHandle(x1,x2),
      YO: (x0,x1) => x0.openCursor(x1),
      YP: (x0,x1,x2) => x0.sqlite3_column_bytes(x1,x2),
      YQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2,x3,x4) { return wasmFunction(f,arguments.length,x0,x1,x2,x3,x4) }),
      YR: (x0,x1) => x0.getModifierState(x1),
      Z: o => [o],
      ZB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      ZC: a => a.length,
      ZD: x0 => x0.hasFocus(),
      ZE: x0 => x0.preventDefault(),
      ZF: x0 => x0.height,
      ZG: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      ZH: x0 => x0.click(),
      ZI: a => a.pop(),
      ZJ: x0 => x0.signal,
      ZK: x0 => x0._motif_paragraph_style_create(),
      ZL: (x0,x1) => x0._motif_paragraph_get_glyph_metrics_count(x1),
      ZM: (x0,x1,x2,x3,x4) => ({r: x0,z: x1,i: x2,d: x3,t: x4}),
      ZN: x0 => x0.getDirectory(),
      ZO: () => globalThis.Blob,
      ZP: (x0,x1,x2) => x0.sqlite3_column_text(x1,x2),
      ZQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2) { return wasmFunction(f,arguments.length,x0,x1,x2) }),
      ZR: x0 => x0.metaKey,
      a: (o0, o1) => [o0, o1],
      aB: (t, s) => t.set(s),
      aC: (x0,x1) => x0.test(x1),
      aD: x0 => x0.relatedTarget,
      aE: x0 => x0.parent,
      aF: x0 => x0.width,
      aG: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      aH: (x0,x1) => x0.getElementsByClassName(x1),
      aI: x0 => new WeakRef(x0),
      aJ: (a, i) => a.splice(i, 1)[0],
      aK: (x0,x1,x2,x3,x4,x5) => x0._motif_font_provider_add(x1,x2,x3,x4,x5),
      aL: (x0,x1) => x0._motif_font_provider_destroy(x1),
      aM: (x0,x1) => ({rawKind: x0,name: x1}),
      aN: x0 => x0.storage,
      aO: x0 => x0.value,
      aP: (x0,x1,x2) => x0.sqlite3_column_double(x1,x2),
      aQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2,x3) { return wasmFunction(f,arguments.length,x0,x1,x2,x3) }),
      aR: x0 => x0.altKey,
      b: (o0, o1, o2) => [o0, o1, o2],
      bB: Function.prototype.call.bind(DataView.prototype.setFloat32),
      bC: x0 => x0.userAgent,
      bD: x0 => x0.shiftKey,
      bE: x0 => x0.timeStamp,
      bF: x0 => x0.clientHeight,
      bG: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      bH: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      bI: x0 => x0.deref(),
      bJ: x0 => new Blob(x0),
      bK: (x0,x1) => { x0.cursor = x1 },
      bL: (x0,x1) => x0.unregister(x1),
      bM: (x0,x1,x2,x3) => ({z: x0,i: x1,d: x2,t: x3}),
      bN: () => globalThis.navigator,
      bO: x0 => x0.key,
      bP: (x0,x1,x2) => x0.sqlite3_column_int64(x1,x2),
      bQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2,x3) { return wasmFunction(f,arguments.length,x0,x1,x2,x3) }),
      bR: x0 => x0.ctrlKey,
      c: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      cB: Function.prototype.call.bind(DataView.prototype.getFloat32),
      cC: x0 => x0.navigator,
      cD: (decoder, codeUnits) => decoder.decode(codeUnits),
      cE: (x0,x1) => x0.hasAttribute(x1),
      cF: x0 => x0.clientWidth,
      cG: o => o.byteLength,
      cH: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      cI: () => globalThis.WeakRef,
      cJ: () => new FileReader(),
      cK: x0 => x0.cursor,
      cL: x0 => x0._motif_font_provider_create(),
      cM: (x0,x1,x2) => ({i: x0,d: x1,t: x2}),
      cN: (x0,x1) => x0.open(x1),
      cO: x0 => x0.continue(),
      cP: (x0,x1,x2) => x0.sqlite3_column_type(x1,x2),
      cQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2) { return wasmFunction(f,arguments.length,x0,x1,x2) }),
      cR: x0 => x0.isComposing,
      d: (x0,x1,x2) => { x0[x1] = x2 },
      dB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      dC: Function.prototype.call.bind(String.prototype.toLowerCase),
      dD: () => new TextDecoder("utf-8", {fatal: true}),
      dE: x0 => x0.buttons,
      dF: (x0,x1) => { x0.content = x1 },
      dG: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      dH: (x0,x1) => x0.dispatchEvent(x1),
      dI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      dJ: (x0,x1) => x0.readAsArrayBuffer(x1),
      dK: x0 => x0.style,
      dL: () => globalThis.skiaReady,
      dM: (x0,x1,x2,x3) => ({a: x0,i: x1,d: x2,t: x3}),
      dN: (x0,x1) => x0.deleteDatabase(x1),
      dO: (x0,x1) => globalThis.IDBKeyRange.bound(x0,x1),
      dP: (x0,x1) => x0.set(x1),
      dQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      dR: x0 => x0.code,
      e: o => o,
      eB: Function.prototype.call.bind(DataView.prototype.getUint32),
      eC: Object.is,
      eD: () => new TextDecoder("utf-8", {fatal: false}),
      eE: x0 => x0.ctrlKey,
      eF: (x0,x1) => { x0.name = x1 },
      eG: x0 => x0.history,
      eH: (x0,x1) => x0.createEvent(x1),
      eI: (a, s, e) => a.slice(s, e),
      eJ: x0 => x0.result,
      eK: (x0,x1) => x0.querySelector(x1),
      eL: x0 => x0.protocol,
      eM: x0 => x0.d,
      eN: x0 => ({recursive: x0}),
      eO: x0 => x0.length,
      eP: (x0,x1) => x0.sqlite3_column_count(x1),
      eQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      eR: x0 => x0.repeat,
      f: (o, p) => o[p],
      fB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      fC: x0 => x0.vendor,
      fD: (a, i, v) => a[i] = v,
      fE: x0 => x0.y,
      fF: x0 => x0.head,
      fG: x0 => x0.search,
      fH: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      fI: x0 => x0.close(),
      fJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fK: x0 => x0.body,
      fL: (x0,x1,x2) => x0.close(x1,x2),
      fM: (x0,x1,x2,x3) => ({a: x0,i: x1,d: x2,t: x3}),
      fN: (x0,x1,x2) => x0.removeEntry(x1,x2),
      fO: (x0,x1) => x0.get(x1),
      fP: x0 => x0.s,
      fQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      g: () => globalThis,
      gB: Function.prototype.call.bind(DataView.prototype.getInt32),
      gC: (x0,x1) => x0.createTextNode(x1),
      gD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      gE: x0 => x0.x,
      gF: (x0,x1) => x0.removeChild(x1),
      gG: x0 => x0.location,
      gH: x0 => x0.readText(),
      gI: (x0,x1,x2,x3,x4,x5) => x0.createImageBitmap(x1,x2,x3,x4,x5),
      gJ: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      gK: () => globalThis.document,
      gL: (x0,x1) => x0.close(x1),
      gM: (x0,x1,x2,x3) => ({a: x0,i: x1,d: x2,t: x3}),
      gN: (x0,x1) => x0.createSyncAccessHandle(x1),
      gO: (x0,x1) => x0.index(x1),
      gP: x0 => x0.r,
      gQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2,x3) { return wasmFunction(f,arguments.length,x0,x1,x2,x3) }),
      gR: x0 => x0.userAgent,
      h: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      hC: (x0,x1) => { x0.id = x1 },
      hD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI16ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      hE: x0 => x0.scrollTop,
      hF: x0 => x0.firstChild,
      hG: x0 => x0.pathname,
      hH: x0 => x0.clipboard,
      hI: (x0,x1) => x0.createImageBitmap(x1),
      hJ: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      hK: x0 => ({type: x0}),
      hL: x0 => x0.close(),
      hM: x0 => x0.r,
      hN: x0 => x0.createSyncAccessHandle(),
      hO: x0 => x0.openKeyCursor(),
      hP: x0 => x0.p,
      hQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2,x3) { return wasmFunction(f,arguments.length,x0,x1,x2,x3) }),
      hR: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      i: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      iB: o => o instanceof Uint16Array,
      iC: (x0,x1) => { x0.nonce = x1 },
      iD: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      iE: x0 => x0.offsetTop,
      iF: x0 => x0.viewConstraints,
      iG: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      iH: (x0,x1) => x0.writeText(x1),
      iI: x0 => new Blob(x0),
      iJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      iK: (x0,x1) => new Blob(x0,x1),
      iL: (x0,x1) => x0.send(x1),
      iM: x0 => x0.u,
      iN: x0 => ({mode: x0}),
      iO: x0 => x0.primaryKey,
      iP: (x0,x1) => x0.sqlite3_get_autocommit(x1),
      iQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      iR: (x0,x1) => x0.getItem(x1),
      j: (x0,x1) => ({addView: x0,removeView: x1}),
      jB: Function.prototype.call.bind(DataView.prototype.getUint16),
      jC: x0 => x0.nonce,
      jD: x0 => x0.visibilityState,
      jE: x0 => x0.scrollLeft,
      jF: x0 => x0.hostElement,
      jG: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      jH: x0 => x0.unlock(),
      jI: x0 => x0.close(),
      jJ: () => new XMLHttpRequest(),
      jK: x0 => globalThis.URL.createObjectURL(x0),
      jL: () => new Array(),
      jM: x0 => x0.k,
      jN: x0 => ({create: x0}),
      jO: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      jP: x0 => x0.c,
      jQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      jR: x0 => x0.localStorage,
      k: (l, r) => l === r,
      kB: o => o instanceof Int16Array,
      kC: () => globalThis.window.flutterConfiguration,
      kD: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      kE: x0 => x0.offsetLeft,
      kF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      kG: o => Object.keys(o),
      kH: (x0,x1) => x0.lock(x1),
      kI: x0 => x0.naturalHeight,
      kJ: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      kK: x0 => x0.devicePixelRatio,
      kL: (x0,x1) => new WebSocket(x0,x1),
      kM: (x0,x1,x2,x3,x4,x5,x6,x7) => ({u: x0,d: x1,s: x2,o: x3,a: x4,c: x5,i: x6,t: x7}),
      kN: (x0,x1,x2) => x0.getFileHandle(x1,x2),
      kO: x0 => ({autoIncrement: x0}),
      kP: x0 => x0.z,
      kQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      kR: (x0,x1) => x0.key(x1),
      l: x0 => x0.random(),
      lB: Function.prototype.call.bind(DataView.prototype.getInt16),
      lC: (x0,x1) => x0.attachShadow(x1),
      lD: x0 => x0.disconnect(),
      lE: x0 => x0.offsetParent,
      lF: x0 => ({runApp: x0}),
      lG: x0 => x0.state,
      lH: x0 => x0.orientation,
      lI: x0 => x0.naturalWidth,
      lJ: x0 => x0.send(),
      lK: (x0,x1,x2,x3) => x0.putImageData(x1,x2,x3),
      lL: x0 => x0.reason,
      lM: x0 => x0.aborted,
      lN: x0 => x0.d,
      lO: (x0,x1,x2) => x0.createObjectStore(x1,x2),
      lP: (x0,x1) => ({name: x0,length: x1}),
      lQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      lR: x0 => x0.length,
      m: o => o,
      mB: o => o instanceof Uint8ClampedArray,
      mC: (x0,x1) => x0.createElement(x1),
      mD: x0 => new Intl.Locale(x0),
      mE: (o, p, r) => o.replace(p, () => r),
      mF: () => typeof dartUseDateNowForTicks !== "undefined",
      mG: x0 => x0.hash,
      mH: (x0,x1) => x0.querySelector(x1),
      mI: (x0,x1) => { x0.src = x1 },
      mJ: x0 => x0.type,
      mK: x0 => x0.arrayBuffer(),
      mL: x0 => x0.code,
      mM: x0 => x0.start(),
      mN: (x0,x1) => x0.dart_sqlite3_unregister_vfs(x1),
      mO: x0 => ({unique: x0}),
      mP: (x0,x1) => x0.update(x1),
      mQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      mR: (x0,x1,x2) => x0.setItem(x1,x2),
      n: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'number') return 1;
        return 2;
      },
      nB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      nC: x0 => x0.scale,
      nD: x0 => x0.region,
      nE: (x0,x1) => { x0.lastIndex = x1 },
      nF: () => Date.now(),
      nG: x0 => x0.state,
      nH: (x0,x1) => { x0.title = x1 },
      nI: x0 => x0.displayHeight,
      nJ: x0 => x0.response,
      nK: (x0,x1) => { x0.height = x1 },
      nL: (o, t) => typeof o === t,
      nM: (x0,x1) => x0.postMessage(x1),
      nN: (x0,x1) => x0.sqlite3_finalize(x1),
      nO: (x0,x1,x2,x3) => x0.createIndex(x1,x2,x3),
      nP: x0 => x0.name,
      nQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      nR: x0 => x0.baseURI,
      o: () => globalThis.Math,
      oB: Function.prototype.call.bind(DataView.prototype.setInt32),
      oC: x0 => x0.visualViewport,
      oD: x0 => x0.script,
      oE: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      oF: () => 1000 * performance.now(),
      oG: (x0,x1) => x0.go(x1),
      oH: (x0,x1) => x0.vibrate(x1),
      oI: x0 => x0.displayWidth,
      oJ: (x0,x1) => { x0.responseType = x1 },
      oK: (x0,x1) => { x0.width = x1 },
      oL: x0 => x0.data,
      oM: x0 => ({steal: x0}),
      oN: (x0,x1) => x0.sqlite3_reset(x1),
      oO: (x0,x1) => x0.createObjectStore(x1),
      oP: x0 => globalThis.IDBKeyRange.only(x0),
      oQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      oR: x0 => x0.document,
      p: (x0,x1) => x0.prepend(x1),
      pB: Function.prototype.call.bind(DataView.prototype.setUint32),
      pC: x0 => x0.devicePixelRatio,
      pD: x0 => x0.language,
      pE: o => o instanceof RegExp,
      pF: (x0,x1) => x0.requestAnimationFrame(x1),
      pG: x0 => x0.parentElement,
      pH: x0 => x0.arrayBuffer(),
      pI: x0 => x0.duration,
      pJ: x0 => x0.vendor,
      pK: x0 => x0.convertToBlob(),
      pL: x0 => x0.readyState,
      pM: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      pN: (x0,x1) => ({d: x0,t: x1}),
      pO: x0 => x0.oldVersion,
      pP: (x0,x1,x2) => x0.put(x1,x2),
      pQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2) { return wasmFunction(f,arguments.length,x0,x1,x2) }),
      pR: (x0,x1) => x0.createElement(x1),
      q: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      qB: Function.prototype.call.bind(DataView.prototype.setInt16),
      qC: x0 => x0.height,
      qD: x0 => x0.languages,
      qE: x0 => x0.dotAll,
      qF: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qG: (x0,x1) => x0.querySelectorAll(x1),
      qH: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      qI: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      qJ: x0 => x0.navigator,
      qK: (x0,x1,x2) => new ImageData(x0,x1,x2),
      qL: (x0,x1) => { x0.binaryType = x1 },
      qM: x0 => x0.close(),
      qN: (x0,x1,x2) => x0.dart_sqlite3_commits(x1,x2),
      qO: () => globalThis.indexedDB,
      qP: (x0,x1) => x0.getKey(x1),
      qQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      qR: (o, a) => o + a,
      r: b => !!b,
      rB: Function.prototype.call.bind(DataView.prototype.setUint16),
      rC: x0 => x0.width,
      rD: (x0,x1) => x0.observe(x1),
      rE: x0 => x0.unicode,
      rF: x0 => x0.now(),
      rG: (x0,x1) => x0.removeProperty(x1),
      rH: x0 => x0.status,
      rI: (x0,x1) => x0.decode(x1),
      rJ: () => globalThis.window,
      rK: (x0,x1) => x0.getContext(x1),
      rL: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      rM: (x0,x1) => { x0.signal = x1 },
      rN: x0 => x0.getSize(),
      rO: (x0,x1) => new URL(x0,x1),
      rP: (x0,x1) => x0.delete(x1),
      rQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      rR: x0 => x0.children,
      s: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      sB: Function.prototype.call.bind(DataView.prototype.setUint8),
      sC: x0 => x0.screen,
      sD: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      sE: x0 => x0.ignoreCase,
      sF: x0 => x0.performance,
      sG: (x0,x1) => x0.add(x1),
      sH: (x0,x1) => x0.fetch(x1),
      sI: x0 => x0.image,
      sJ: x0 => globalThis.fetch(x0),
      sK: (x0,x1) => new OffscreenCanvas(x0,x1),
      sL: (x0,x1,x2,x3) => x0.request(x1,x2,x3),
      sM: () => globalThis.navigator,
      sN: (x0,x1) => x0.truncate(x1),
      sO: x0 => x0.pathname,
      sP: (x0,x1) => x0.put(x1),
      sQ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      sR: (x0,x1) => { x0.id = x1 },
      t: (x0,x1) => x0.focus(x1),
      tB: Function.prototype.call.bind(DataView.prototype.setInt8),
      tC: (string, times) => string.repeat(times),
      tD: x0 => new ResizeObserver(x0),
      tE: x0 => x0.multiline,
      tF: x0 => new Uint8Array(x0),
      tG: x0 => x0.data,
      tH: x0 => x0.content,
      tI: x0 => x0.close(),
      tJ: x0 => x0.arrayBuffer(),
      tK: x0 => x0.allocationSize(),
      tL: x0 => x0.locks,
      tM: x0 => x0.error,
      tN: x0 => ({at: x0}),
      tO: x0 => x0.a,
      tP: x0 => x0.flush(),
      tQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2,x3,x4) { return wasmFunction(f,arguments.length,x0,x1,x2,x3,x4) }),
      tR: x0 => x0.click(),
      u: () => ({}),
      uB: Function.prototype.call.bind(DataView.prototype.getInt8),
      uC: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      uD: (x0,x1) => x0.getPropertyValue(x1),
      uE: (o, p, r) => o.replaceAll(p, () => r),
      uF: (x0,x1,x2) => x0.slice(x1,x2),
      uG: (x0,x1) => x0.removeAttribute(x1),
      uH: x0 => x0.document,
      uI: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      uJ: (x0,x1) => x0._motif_paragraph_get_height(x1),
      uK: (x0,x1) => x0.copyTo(x1),
      uL: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      uM: x0 => x0.abort(),
      uN: (x0,x1) => x0.write(x1),
      uO: x0 => x0.d,
      uP: (x0,x1) => x0.read(x1),
      uQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2,x3) { return wasmFunction(f,arguments.length,x0,x1,x2,x3) }),
      uR: (x0,x1) => x0.removeChild(x1),
      v: (o, p, v) => o[p] = v,
      vB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      vC: x0 => x0.tabIndex,
      vD: x0 => globalThis.parseFloat(x0),
      vE: x0 => x0.deltaMode,
      vF: (x0,x1) => x0.decode(x1),
      vG: (x0,x1) => { x0.value = x1 },
      vH: x0 => x0.debugSkipFontRetryDelay,
      vI: x0 => new window.ImageDecoder(x0),
      vJ: (x0,x1) => x0._motif_paragraph_get_max_intrinsic_width(x1),
      vK: (x0,x1) => x0.toDataURL(x1),
      vL: (o,s,v) => o[s] = v,
      vM: x0 => x0.i,
      vN: (x0,x1,x2) => x0.write(x1,x2),
      vO: (x0,x1) => ({d: x0,t: x1}),
      vP: (x0,x1,x2) => x0.read(x1,x2),
      vQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2,x3) { return wasmFunction(f,arguments.length,x0,x1,x2,x3) }),
      vR: x0 => x0.firstChild,
      w: () => [],
      wB: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      wC: (x0,x1) => x0.contains(x1),
      wD: (x0,x1) => x0.getComputedStyle(x1),
      wE: x0 => x0.deltaY,
      wF: (x0,x1) => x0.adoptText(x1),
      wG: (x0,x1) => { x0.value = x1 },
      wH: (x0,x1,x2) => x0.set(x1,x2),
      wI: x0 => x0.name,
      wJ: (x0,x1,x2) => x0._motif_paragraph_layout(x1,x2),
      wK: (x0,x1,x2,x3) => x0.drawImage(x1,x2,x3),
      wL: () => Symbol("jsBoxedDartObjectProperty"),
      wM: (x0,x1) => x0.error(x1),
      wN: (x0,x1,x2) => x0.dart_sqlite3_updates(x1,x2),
      wO: (x0,x1,x2) => x0.dart_sqlite3_rollbacks(x1,x2),
      wP: x0 => x0.f,
      wQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2,x3) { return wasmFunction(f,arguments.length,x0,x1,x2,x3) }),
      wR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      x: (a, i) => a.push(i),
      xB: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      xC: x0 => x0.activeElement,
      xD: x0 => x0.documentElement,
      xE: x0 => x0.deltaX,
      xF: x0 => x0.first(),
      xG: x0 => x0.value,
      xH: x0 => x0.fontFallbackBaseUrl,
      xI: x0 => x0.repetitionCount,
      xJ: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      xK: x0 => x0.format,
      xL: (x0,x1) => x0.call(x1),
      xM: (x0,x1,x2,x3,x4) => ({e: x0,s: x1,r: x2,i: x3,t: x4}),
      xN: x0 => x0.close(),
      xO: (x0,x1,x2,x3,x4) => ({k: x0,u: x1,r: x2,d: x3,t: x4}),
      xP: x0 => x0.f,
      xQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      xR: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      y: x0 => new Int8Array(x0),
      yB: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      yC: x0 => x0.parentNode,
      yD: x0 => x0.computedStyleMap(),
      yE: x0 => x0.wheelDeltaY,
      yF: x0 => x0.next(),
      yG: x0 => x0.selectionDirection,
      yH: (handle) => clearInterval(handle),
      yI: x0 => x0.frameCount,
      yJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      yK: (x0,x1,x2,x3,x4) => x0.getImageData(x1,x2,x3,x4),
      yL: () => globalThis.navigator,
      yM: () => globalThis.console,
      yN: x0 => x0.buffer,
      yO: (x0,x1,x2) => ({r: x0,i: x1,t: x2}),
      yP: x0 => x0.b,
      yQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      yR: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      z: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      zB: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      zC: x0 => x0.tagName,
      zD: (x0,x1) => x0.get(x1),
      zE: x0 => x0.wheelDeltaX,
      zF: x0 => x0.current(),
      zG: x0 => x0.selectionStart,
      zH: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      zI: x0 => x0.selectedTrack,
      zJ: x0 => new FinalizationRegistry(x0),
      zK: x0 => x0.data,
      zL: x0 => ({rawKind: x0}),
      zM: (x0,x1,x2) => ({r: x0,i: x1,t: x2}),
      zN: (x0,x1) => x0.sqlite3_errstr(x1),
      zO: x0 => x0.z,
      zP: x0 => x0.a,
      zQ: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1,x2,x3,x4) { return wasmFunction(f,arguments.length,x0,x1,x2,x3,x4) }),
      zR: x0 => x0.size,

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
