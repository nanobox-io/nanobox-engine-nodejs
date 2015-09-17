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

##### `runtime`
Specifies which Node.js runtime and version to use. The following runtimes are available:

- nodejs-0.8
- nodejs-0.10
- nodejs-0.12
- iojs-2.3

```yaml
build:
  runtime: nodejs-0.12
```