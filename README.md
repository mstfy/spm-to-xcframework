# spm-to-xcframework

## What's it?
This little tool creates xcframework from SPM packages.

## Install
Just pull the package and build from the source with this command: `swift build -c release`. Then you will find it in `.build/release` folder. You can download a version from releases page too.

## How to use?

To create xcframework for a package run

```
./spm-to-xcframework YourPackageName --path path_to_your_package --output path_to_output
```
 This will compile and create xcframework from `YourPackage` and its dependencies. XCFrameworks can be found at `path_to_output/Build/xcframeworks` folder.
 
 `--path`: represents the path to spm package. If you omit this current directory is taken.
 `--output`: represents the output path where xcframeworks will be created. If omitted current directory is taken.
 `--enable-library-evolution`: This option enables library evolution for xcframeworks. With this they can be used with future swift compilers.
 `--platforms ios simulator`: Specifies which platforms will be supported by xcframeworks. For now only iphone and iphone simulator supported.

## Limitations
For now only the packages that has swift code supported. Binary packages and objective-c packages are not supported.
