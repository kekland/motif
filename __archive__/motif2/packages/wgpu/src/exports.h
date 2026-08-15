#ifndef EXPORTS_H
#define EXPORTS_H

#if defined(_WIN32)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT __attribute__((__visibility__("default"))) __attribute__((__used__))
#endif

#ifdef __cplusplus
#define EXTERNC extern "C"
#else
#define EXTERNC
#endif

#define FFI EXTERNC EXPORT

#endif  // EXPORTS_H