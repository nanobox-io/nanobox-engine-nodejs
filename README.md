# Node.js

This is a generic Node.js engine used to launch Node.js web and worker services when using [Nanobox](http://nanobox.io).

## App Detection
To detect a Node.js app, this engine looks for a `package.json`. If that exists, it then looks for a `server.js`.

## Build Process
- `npm install`
- `npm prune`
- If the version of node has changed between deploys, the engine runs `npm rebuild`

## Configuration Options
This engine exposes configuration options through the [Boxfile](http://docs.nanobox.io/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox.

#### Overview of Boxfile Configuration Options
```yaml
build:
  runtime: nodejs-0.12
```

---

#### runtime
Specifies which Node.js runtime and version to use. The following runtimes are available:

- nodejs-0.8
- nodejs-0.10
- nodejs-0.12
- nodejs-4.2
- iojs-2.3

```yaml
build:
  runtime: nodejs-0.12
```

---

## Help & Support
This is a generic (non-framework-specific) Node.js engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/pagodabox/nanobox-engine-nodejs/issues/new).