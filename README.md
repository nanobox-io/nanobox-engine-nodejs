# Node.js

This is a Node.js engine for running node apps with [Nanobox](http://nanobox.io).

## Usage
To use the Node.js engine, specify `nodejs` as your `engine` in your boxfile.yml

```yaml
run.config:
  engine: nodejs
```

## Build Process
When [running your app](https://docs.nanboox.io/cli/run/), this engine compiles code by doing the following:

- `yarn install`

## Configuration Options
This engine exposes configuration options through the [Boxfile](http://docs.nanobox.io/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox.

#### Overview of Boxfile Configuration Options
```yaml
run.config:
  engine: nodejs
  engine.config:
    runtime: nodejs-4.4
    dep_manager: yarn
    python_version: python-2.7
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
- nodejs-4.5
- nodejs-4.6
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
- nodejs-5.10
- nodejs-5.11
- nodejs-5.12
- nodejs-6.0
- nodejs-6.1
- nodejs-6.2
- nodejs-6.3
- nodejs-6.4
- nodejs-6.5
- nodejs-6.6
- nodejs-6.7
- nodejs-6.8
- nodejs-6.9
- nodejs-7.0
- iojs-2.3

```yaml
run.config:
  engine: nodejs
  engine.config:
    runtime: nodejs-6.2
```

---

#### dep_manager
Specifies whether the engine should use npm or yarn to fetch node modules. Defaults to `yarn`.

```yaml
run.config:
  engine.config:
    dep_manager: yarn
```

#### python_version
Specifies the version of Python to install with the following available values:

- python-2.7
- python-3.4
- python-3.5
- python-3.6 (Default)

```yaml
run.config:
  engine.config:
    python_version: python-2.7
```



---

## Help & Support
This is a generic (non-framework-specific) Node.js engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/pagodabox/nanobox-engine-nodejs/issues/new).
