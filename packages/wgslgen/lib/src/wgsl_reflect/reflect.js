#!/usr/bin/env node

const fs = require('fs')
const reflect = require('./wgsl_reflect.module')

const printHelp = () => {
  console.log('Usage:')
  console.log('  source: reflect.js "wgsl-code"')
  console.log('  file: reflect.js -f "path/to/file.wgsl"')
  console.log('  help: reflect.js -h')
  console.log('')
  console.log('  resulting json is printed to stdout')
  process.exit(0)
}

const main = () => {
  const argv = process.argv.slice(2)
  try {
    let source = null;

    if (argv.length == 0) printHelp();
    if (argv[0] === '-h') printHelp();
    if (argv[0] === '-f') {
      if (argv.length < 2) printHelp();

      const filePath = argv[1];
      if (!fs.existsSync(filePath)) {
        console.error(`File not found: ${filePath}`)
        process.exit(1)
      }

      source = fs.readFileSync(filePath, 'utf-8')
    }
    else {
      source = argv[0]
    }

    if (!source) printHelp();
    const result = new reflect.WgslReflect(source)

    result.functions.forEach((f) => {
      f.calls = [];
      f.resources = f.resources.map((r) => ({ name: r.name, group: r.group, binding: r.binding }))
    })

    const cleanVariables = (vars) => {
      vars.forEach((v) => {
        if (v.relations) v.relations = v.relations.map((r) => { return r.name })
      })
    }

    cleanVariables(result.uniforms)
    cleanVariables(result.storage)
    cleanVariables(result.textures)
    cleanVariables(result.samplers)
    cleanVariables(result.immediates)

    const visited = new Set()
    const appendTypeInfo = (obj) => {
      if (!obj || typeof obj !== 'object') return;
      if (visited.has(obj)) return;
      visited.add(obj)

      if (obj && typeof obj === 'object') {
        if ('isArray' in obj) obj._isArray = obj.isArray
        if ('isStruct' in obj) obj._isStruct = obj.isStruct
        if ('isTemplate' in obj) obj._isTemplate = obj.isTemplate
        if ('isPointer' in obj) obj._isPointer = obj.isPointer

        for (const key in obj) {
          if (obj.hasOwnProperty(key)) {
            appendTypeInfo(obj[key])
          }
        }
      }
    }

    appendTypeInfo(result)
    console.log(JSON.stringify(result, null, 2))
  }

  catch (e) {
    console.error(e)
    printHelp()
  }
}

main()
