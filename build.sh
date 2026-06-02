#!/bin/bash
set -e

cd /home/hoshi/adofaimods/KeyViewer-src

GAME_MANAGED="/home/hoshi/adofaimods/A Dance of Fire and Ice/A Dance of Fire and Ice_Data/Managed"
NET461_LIB="/home/hoshi/.dotnet/sdk/9.0.314/Microsoft/Microsoft.NET.Build.Extensions/net461/lib"
MONO_LIB="/usr/lib/mono/4.5"
DOTNET="/home/hoshi/.dotnet"
CSC="$DOTNET/sdk/9.0.314/Roslyn/bincore/csc.dll"
export PATH="$DOTNET:$PATH"

# Output
OUTPUT="bin/KeyViewer.dll"
mkdir -p bin

# Source files (exclude Cursor.cs and CursorData.cs)
SRC=$(find KeyViewer -name "*.cs" ! -name "Stubs.cs" | sort)

# References
REFS=(
  "$MONO_LIB/mscorlib.dll"
  "$GAME_MANAGED/netstandard.dll"
  "$GAME_MANAGED/System.dll"
  "$GAME_MANAGED/System.Core.dll"
  "$GAME_MANAGED/System.Drawing.dll"
  "$GAME_MANAGED/System.Data.dll"
  "$GAME_MANAGED/System.Xml.dll"
  "$GAME_MANAGED/System.Xml.Linq.dll"
  "$GAME_MANAGED/System.IO.Compression.dll"
  "$GAME_MANAGED/System.IO.Compression.FileSystem.dll"
  "$GAME_MANAGED/System.Net.Http.dll"
  "$GAME_MANAGED/System.Runtime.Serialization.dll"
  "$GAME_MANAGED/UnityEngine.dll"
  "$GAME_MANAGED/UnityEngine.CoreModule.dll"
  "$GAME_MANAGED/UnityEngine.IMGUIModule.dll"
  "$GAME_MANAGED/UnityEngine.UI.dll"
  "$GAME_MANAGED/UnityEngine.UIModule.dll"
  "$GAME_MANAGED/UnityEngine.TextRenderingModule.dll"
  "$GAME_MANAGED/UnityEngine.ImageConversionModule.dll"
  "$GAME_MANAGED/UnityEngine.AssetBundleModule.dll"
  "$GAME_MANAGED/UnityEngine.AudioModule.dll"
  "$GAME_MANAGED/UnityEngine.AnimationModule.dll"
  "$GAME_MANAGED/UnityEngine.InputLegacyModule.dll"
  "$GAME_MANAGED/UnityEngine.InputModule.dll"
  "$GAME_MANAGED/UnityEngine.JSONSerializeModule.dll"
  "$GAME_MANAGED/UnityEngine.PhysicsModule.dll"
  "$GAME_MANAGED/UnityEngine.Physics2DModule.dll"
  "$GAME_MANAGED/UnityEngine.ParticleSystemModule.dll"
  "$GAME_MANAGED/UnityEngine.SharedInternalsModule.dll"
  "$GAME_MANAGED/UnityEngine.ScreenCaptureModule.dll"
  "$GAME_MANAGED/UnityEngine.SpriteMaskModule.dll"
  "$GAME_MANAGED/UnityEngine.SpriteShapeModule.dll"
  "$GAME_MANAGED/UnityEngine.StreamingModule.dll"
  "$GAME_MANAGED/UnityEngine.SubsystemsModule.dll"
  "$GAME_MANAGED/UnityEngine.TerrainModule.dll"
  "$GAME_MANAGED/UnityEngine.TerrainPhysicsModule.dll"
  "$GAME_MANAGED/UnityEngine.TextCoreFontEngineModule.dll"
  "$GAME_MANAGED/UnityEngine.TextCoreTextEngineModule.dll"
  "$GAME_MANAGED/UnityEngine.TilemapModule.dll"
  "$GAME_MANAGED/UnityEngine.TLSModule.dll"
  "$GAME_MANAGED/UnityEngine.UIElementsModule.dll"
  "$GAME_MANAGED/UnityEngine.UmbraModule.dll"
  "$GAME_MANAGED/UnityEngine.UnityAnalyticsModule.dll"
  "$GAME_MANAGED/UnityEngine.UnityConnectModule.dll"
  "$GAME_MANAGED/UnityEngine.UnityCurlModule.dll"
  "$GAME_MANAGED/UnityEngine.UnityTestProtocolModule.dll"
  "$GAME_MANAGED/UnityEngine.UnityWebRequestModule.dll"
  "$GAME_MANAGED/UnityEngine.UnityWebRequestAssetBundleModule.dll"
  "$GAME_MANAGED/UnityEngine.UnityWebRequestAudioModule.dll"
  "$GAME_MANAGED/UnityEngine.UnityWebRequestTextureModule.dll"
  "$GAME_MANAGED/UnityEngine.UnityWebRequestWWWModule.dll"
  "$GAME_MANAGED/UnityEngine.VehiclesModule.dll"
  "$GAME_MANAGED/UnityEngine.VFXModule.dll"
  "$GAME_MANAGED/UnityEngine.VideoModule.dll"
  "$GAME_MANAGED/UnityEngine.VRModule.dll"
  "$GAME_MANAGED/UnityEngine.WindModule.dll"
  "$GAME_MANAGED/UnityEngine.XRModule.dll"
  "$GAME_MANAGED/UnityEngine.VirtualTexturingModule.dll"
  "$GAME_MANAGED/Unity.TextMeshPro.dll"
  "$GAME_MANAGED/Assembly-CSharp.dll"
  "$GAME_MANAGED/Assembly-CSharp-firstpass.dll"
  "$GAME_MANAGED/DemiLib.dll"
  "$GAME_MANAGED/DOTween.dll"
  "$GAME_MANAGED/DOTweenPro.dll"
  "$GAME_MANAGED/Newtonsoft.Json.dll"
  "$GAME_MANAGED/RDTools.dll"
  "$GAME_MANAGED/SkyHook.Unity.dll"
  "$GAME_MANAGED/Unity.Addressables.dll"
  "$GAME_MANAGED/Unity.ResourceManager.dll"
  "$GAME_MANAGED/Unity.ScriptableBuildPipeline.dll"
  "$GAME_MANAGED/Unity.MemoryProfiler.dll"
  "$GAME_MANAGED/UnityFileDialog.dll"
  "$GAME_MANAGED/UnityModManager/UnityModManager.dll"
  "$GAME_MANAGED/UnityModManager/0Harmony.dll"
  "/home/hoshi/adofaimods/Keyviewer/lib/NCalc.dll"
  "$GAME_MANAGED/UnityEngine.AccessibilityModule.dll"
  "$GAME_MANAGED/UnityEngine.AIModule.dll"
  "$GAME_MANAGED/UnityEngine.AndroidJNIModule.dll"
  "$GAME_MANAGED/UnityEngine.ARModule.dll"
  "$GAME_MANAGED/UnityEngine.ClothModule.dll"
  "$GAME_MANAGED/UnityEngine.ClusterInputModule.dll"
  "$GAME_MANAGED/UnityEngine.ClusterRendererModule.dll"
  "$GAME_MANAGED/UnityEngine.CrashReportingModule.dll"
  "$GAME_MANAGED/UnityEngine.DirectorModule.dll"
  "$GAME_MANAGED/UnityEngine.DSPGraphModule.dll"
  "$GAME_MANAGED/UnityEngine.GameCenterModule.dll"
  "$GAME_MANAGED/UnityEngine.GIModule.dll"
  "$GAME_MANAGED/UnityEngine.GridModule.dll"
  "$GAME_MANAGED/UnityEngine.HotReloadModule.dll"
  "$GAME_MANAGED/UnityEngine.LocalizationModule.dll"
  "$GAME_MANAGED/UnityEngine.NVIDIAModule.dll"
  "$GAME_MANAGED/UnityEngine.PerformanceReportingModule.dll"
  "$GAME_MANAGED/UnityEngine.ProfilerModule.dll"
  "$GAME_MANAGED/UnityEngine.RuntimeInitializeOnLoadManagerInitializerModule.dll"
)

# Build ref args as a response file
RSP_FILE="build.rsp"
{
  echo "-nostdlib+"
  echo "-langversion:preview"
  echo "-target:library"
  echo "-out:$OUTPUT"
  echo "-optimize+"
  echo "-define:TRACE"
  echo "-unsafe+"
  echo "-nowarn:CS1701,CS1702,CS0436"
  for ref in "${REFS[@]}"; do
    if [ -f "$ref" ]; then
      echo "-r:\"$ref\""
    fi
  done
  for src in $SRC; do
    echo "\"$src\""
  done
} > "$RSP_FILE"

echo "=== Building KeyViewer.dll ==="
echo "Source files: $(echo "$SRC" | wc -l)"
echo "References: $(echo "${REFS[@]}" | wc -w)"

dotnet exec "$CSC" "@$RSP_FILE" 2>&1

EXIT=$?
if [ $EXIT -eq 0 ]; then
  echo "=== Build SUCCESS ==="
  ls -la "$OUTPUT"
else
  echo "=== Build FAILED (exit $EXIT) ==="
  exit $EXIT
fi