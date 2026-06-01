<img src = "kv4.png" width="37.5%" height="37.5%">

# ⌨️ KeyViewer
KeyViewer is a mod that displays the key viewer in ADOFAI in-game.

Originally made by [c3nb](https://github.com/c3nb), and maintained by Square3ang & kkitut
([original repo](https://github.com/square3ang/KeyViewer), now archived).

---

## 🔧 Unity 6 compatibility fix (this fork)

After ADOFAI updated to **Unity 6 (engine 6000.3.x)**, KeyViewer 4.13.1 crashed on load with
`MissingFieldException: RDString.AvailableLanguages`. This fork fixes compatibility with the
latest game version:

- **`RDString.AvailableLanguages`** changed from a static *field* to a *property* → fixed by rebuild.
- **`StandaloneFileBrowser` / `ExtensionFilter`** (native open/save dialog) were removed from the game
  → migrated to the game's new **`UnityFileDialog.FileBrowser`** API (Import / Export Profile now work again).

No behavioural changes otherwise. Original credits and the GPLv3 license are unchanged.

### Building

Requires the .NET SDK. The project compiles directly against the game's `Managed` assemblies:

```bash
dotnet build KeyViewer/KeyViewer.csproj -c Release \
  -p:Managed="/path/to/A Dance of Fire and Ice/A Dance of Fire and Ice_Data/Managed"
```

The output `KeyViewer.dll` goes next to `Info.json`, `KeyViewer.assets`, `lib/NCalc.dll` and `lang/` in
`Mods/KeyViewer/`.

---

# ⚖️  Licenses
[AdofaiTweaks](https://github.com/PizzaLovers007/AdofaiTweaks) is licensed under the MIT License.  
[RapidGUI](https://github.com/fuqunaga/RapidGUI) is licensed under the MIT License.  

# 🌐 Translations are welcome!

You can freely adapt the meaning to fit the style and culture of each language.

* 📝 Literal translation is not required. Additional explanations are allowed.
* 📂 Translation files are located in `/KeyViewer/MiscFiles/lang/`.

If you are adding a new language instead of updating an existing one, you can refer to the official English or Korean translations.  
➡️ Please use a pull request!
