using HarmonyLib;
using KeyViewer.Core.Input;
using SkyHook;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEngine;

namespace KeyViewer.Patches;

[HarmonyPatch(typeof(scrController), "UpdateInput")]
public static class LimitNotRegisteredKeysPatch {
    private static readonly FieldInfo _unityKeysCacheField =
        typeof(KeysSetting).GetField("_unityKeysCache", BindingFlags.NonPublic | BindingFlags.Instance);
    private static readonly FieldInfo _asyncKeysCacheField =
        typeof(KeysSetting).GetField("_asyncKeysCache", BindingFlags.NonPublic | BindingFlags.Instance);
    private static bool _wasLimiting;

    public static void Prefix() {
        if(Main.Managers == null) return;

        bool anyLimit = Main.Managers.Values.Any(m => m.profile.LimitNotRegisteredKeys);
        var limiter = Persistence.keyLimiterKeys;

        if(!anyLimit) {
            if(_wasLimiting) {
                // Restore game's own key limiter by clearing our override (lazy-reload from PlayerPrefs)
                _unityKeysCacheField?.SetValue(limiter, null);
                _asyncKeysCacheField?.SetValue(limiter, null);
                _wasLimiting = false;
            }
            return;
        }

        _wasLimiting = true;

        var unityKeys = new HashSet<KeyCode>();
        // r145 (2026/06) changed KeysSetting._asyncKeysCache from HashSet<KeyLabel> to
        // HashSet<ushort> holding native key codes (it's matched against AsyncKeyCode.key).
        var asyncKeys = new HashSet<ushort>();

        foreach(var manager in Main.Managers.Values) {
            if(!manager.profile.LimitNotRegisteredKeys) continue;
            foreach(var config in manager.profile.Keys) {
                if(string.IsNullOrEmpty(config.DummyName)) {
                    unityKeys.Add(config.Code);
                    var label = AsyncInputCompat.Convert(config.Code);
                    if(label != KeyLabel.Unknown) {
                        ushort native = SkyHookKeyMapper.KeyLabelToNativeKeyCode(label);
                        if(native != ushort.MaxValue)
                            asyncKeys.Add(native);
                    }
                }
            }
        }

        _unityKeysCacheField?.SetValue(limiter, unityKeys);
        _asyncKeysCacheField?.SetValue(limiter, asyncKeys);
    }
}
