# Node.js

This is a Node.js engine for running node apps with [Nanobox](http://nanobox.io).

## Usage
To use the Node.js engine, specify `nodejs` as your `engine` in your boxfile.yml

```
code.build:
  engine: nodejs
```

## Build Process
When [running a build](https://docs.nanboox.io/cli/build/), this engine compiles code by doing the following:

- `npm install`
- `npm prune`
- If the version of node has changed between deploys, the engine runs `npm rebuild`

## Configuration Options
This engine exposes configuration options through the [Boxfile](http://docs.nanobox.io/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox.

#### Overview of Boxfile Configuration Options
```yaml
code.build:
  config:
    runtime: nodejs-4.4
```

---

#### runtime
Specifies which Node.js runtime and version to use. The following runtimes are available:

- nodejs-0.8
- nodejs-0.10
- nodejs-0.12
- nodejs-4.0
- nodejs-4.1
- nodejs-4.2
- nodejs-4.3
- nodejs-4.4
- nodejs-5.0
- nodejs-5.1
- nodejs-5.2
- nodejs-5.3
- nodejs-5.4
- nodejs-5.5
- nodejs-5.6
- nodejs-5.7
- nodejs-5.8
- nodejs-5.9
- nodejs-6.0
- nodejs-6.1
- nodejs-6.2
- iojs-2.3

```yaml
code.build:
  config:
    runtime: nodejs-4.4
```

---

## Help & Support
This is a generic (non-framework-specific) Node.js engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/pagodabox/nanobox-engine-nodejs/issues/new).
