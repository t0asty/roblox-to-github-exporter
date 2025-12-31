# 📦 Roblox Place Exporter (Lune CLI)

A small command-line tool that converts a **Roblox `.rbxl/.rbxlx` place file** into a **Git-friendly folder structure**.

✔ Extracts full hierarchy  
✔ Exports scripts as `.lua`  
✔ Exports instances as `.rbxmx`  
✔ Mirrors folders 1:1  
✔ Works on any place file  
✔ Perfect for version control / team workflows  

Built with **Lune** and **@lune/roblox**.

---

## ✨ Features

* 🔍 **Full folder structure mirroring**
* 📜 **Scripts exported as clean `.lua` files**
* 🧩 **Models & objects exported as `.rbxmx`**
* 🗄️ **Handles all services (Workspace, ReplicatedStorage, SSS, etc.)**
* 🧵 **Recursive exporter with safe filenames**
* 🧪 **Simple CLI interface**
* 🧭 **Cross-platform (Mac / Windows / Linux)**

---

## 📥 Installation

### 1. Install Lune

If you haven't installed Lune yet:

```bash
curl -fsSL https://lune.rocks/install.sh | sh
```

Or see: [https://lune-org.github.io/docs/](https://lune-org.github.io/docs/)

### 2. Clone this repository

```bash
git clone https://github.com/t0asty/roblox-to-github-exporter.git
cd roblox-place-exporter
```

### 3. Install Lua dependencies

```bash
lune install
```

This will set up `@lune/fs` and `@lune/roblox`.

---

## 🚀 Usage

Export a Roblox place file:

```bash
lune run export_game.luau path/to/place.rbxl output-directory
```

### Examples

```bash
# Simple default usage
lune run export_game.luau mygame.rbxl output

# Exported into ./exported if output is omitted
lune run export_game.luau obby.rbxl

# Both optional (uses defaults)
lune run export_game.luau
```

### Help

```bash
lune run export_game.luau --help
```

---

## 📁 Output Structure

Example of what gets generated:

```
exported/
  Workspace.rbxmx
  Workspace/
    Checkpoints/
      CheckpointModel.rbxmx
    Scripts/
      SpawnHandler.lua
  ReplicatedStorage/
    Utils/
      Timer.lua
  ServerScriptService/
    EnemySpawner.lua
```

### Rules

| Roblox Instance Type     | Export Format     |
| ------------------------ | ----------------- |
| `Script`                 | `name.lua`        |
| `LocalScript`            | `name.lua`        |
| `ModuleScript`           | `name.lua`        |
| Any instance w/ children | Folder + `.rbxmx` |
| Any other instance       | `name.rbxmx`      |
| `DataModel` (`game`)     | 🚫 Not serialized |

---

## 🧠 How It Works

* Lune loads the `.rbxl` file as binary
* The place is deserialized into a Roblox DataModel
* The exporter walks each service recursively:

  * Scripts → write `.lua` source
  * Folders/models → create directories
  * Other instances → write `.rbxmx`
* All names are sanitized for safe filesystem usage
* The complete structure is mirrored for Git

---

## 📜 License

Apache 2.0 — free to use and modify.

---

## 🤝 Contributing

PRs welcome!
Feel free to open issues for new features — e.g.:

* inverse importer (folder → roblox place)
* export Terrain separately
* add JSON metadata per instance
* add watch mode
