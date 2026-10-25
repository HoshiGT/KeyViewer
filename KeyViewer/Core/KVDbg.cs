using UnityEngine;

namespace KeyViewer.Core;

/// <summary>临时诊断: 去重日志 (连续相同消息只记一次)。</summary>
public static class KVDbg {
    static string last;
    public static void Log(string msg) {
        if(msg == last) return;
        last = msg;
        Debug.Log("[KVDbg] " + msg);
    }
}
