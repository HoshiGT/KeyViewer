using HarmonyLib;
using KeyViewer.Core.Input;
using SkyHook;
using System.Collections.Generic;
using UnityEngine;

namespace KeyViewer.Patches;

// The limit is enforced at the input counting sinks (RDInputType_*.Main*) instead of
// injecting Persistence.keyLimiterKeys caches from a scrController.UpdateInput prefix:
// scrConductor only calls UpdateInput while async input is active, so the old cache
// injection silently stopped working whenever async input was turned off. Filtering
// the counted keys directly also avoids depending on SkyHook native key code
// round-trips and leaves the game's own key limiter setting untouched.
public static class LimitNotRegisteredKeysPatch {
    private static readonly HashSet<KeyCode> _codes = [];
    private static readonly HashSet<KeyLabel> _labels = [];
    private static bool _active;
    private static int _refreshedFrame = -1;
    private static string _lastLog;

    [HarmonyPatch(typeof(RDInputType_Keyboard), nameof(RDInputType_Keyboard.MainIgnoreActive))]
    private static class KeyboardMainPatch {
        public static void Postfix(RDInputType_Keyboard __instance, ButtonState state, ref int __result)
            => Filter(__instance, state, ref __result);
    }

    [HarmonyPatch(typeof(RDInputType_AsyncKeyboard), nameof(RDInputType_AsyncKeyboard.Main))]
    private static class AsyncKeyboardMainPatch {
        public static void Postfix(RDInputType_AsyncKeyboard __instance, ButtonState state, ref int __result)
            => Filter(__instance, state, ref __result);
    }

    private static void Filter(RDInputType input, ButtonState state, ref int result) {
        if(Time.frameCount != _refreshedFrame) {
            _refreshedFrame = Time.frameCount;
            Refresh();
        }
        // With no registered keys, pass everything through like the game's own limiter
        // does on an empty key set, so a keyless profile can't lock the player out.
        if(!_active || result <= 0 || _codes.Count == 0) return;
        // Same gate as RDInput.useKeyLimiter, but null-safe.
        var controller = scrController.instance;
        if(controller == null || !controller.gameworld) return;
        var pauseMenu = controller.pauseMenu;
        if(pauseMenu != null && pauseMenu.isActiveAndEnabled) return;
        // Main() returned result > 0, so input was active and the state count is the
        // real per-state list, never the dummy one.
        var stateCount = state switch {
            ButtonState.WentDown => input.pressCount,
            ButtonState.IsDown => input.heldCount,
            ButtonState.WentUp => input.releaseCount,
            _ => input.isReleaseCount,
        };
        if(stateCount?.keys == null) return;
        if(stateCount.keys.RemoveAll(NotRegistered) > 0)
            result = stateCount.keys.Count;
    }

    private static bool NotRegistered(AnyKeyCode any) {
        if(any.value is KeyCode code) return !_codes.Contains(code);
        if(any.value is AsyncKeyCode asyncCode) return !_labels.Contains(asyncCode.label);
        return false;
    }

    private static void Refresh() {
        _active = false;
        _codes.Clear();
        _labels.Clear();
        if(Main.Managers == null) return;
        foreach(var manager in Main.Managers.Values) {
            if(!manager.profile.LimitNotRegisteredKeys) continue;
            _active = true;
            foreach(var config in manager.profile.Keys) {
                if(!string.IsNullOrEmpty(config.DummyName)) continue;
                _codes.Add(config.Code);
                var label = AsyncInputCompat.Convert(config.Code);
                if(label != KeyLabel.Unknown) _labels.Add(label);
            }
        }
        string log = _active ? $"active, keys: [{string.Join(", ", _codes)}]" : "inactive";
        if(log != _lastLog) {
            _lastLog = log;
            Main.Logger.Log($"LimitNotRegisteredKeys {log}");
        }
    }
}
