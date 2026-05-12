#!/usr/bin/env python3

from _common import exec_cmd

exec_cmd('dart run ffigen --config ffigen.webgpu.yaml')
exec_cmd('dart run ffigen --config ffigen.wgpu-native.yaml')
exec_cmd('dart run ffigen --config ffigen.darwin.yaml')