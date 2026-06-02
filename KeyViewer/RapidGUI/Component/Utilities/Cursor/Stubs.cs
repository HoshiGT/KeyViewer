using System.IO;
using System.IO.Compression;
using UnityEngine;

namespace RapidGUI
{
    public enum MouseCursor
    {
        Default,
        ResizeHorizontal,
        ResizeVertical,
        ResizeUpLeft,
    }

    public static partial class RGUIUtility
    {
        public static void SetCursor(MouseCursor cursor)
        {
            // Stub: cursor customization not available on this build platform
        }
    }
}

// Stub for Texture2D.LoadImage (normally in UnityEngine.ImageConversionModule)
namespace UnityEngine
{
    public static class ImageConversionStub
    {
        public static bool LoadImage(this Texture2D tex, byte[] data)
        {
            // Stub: actual implementation provided by Unity runtime
            return true;
        }
    }
}

// Stub for ZipFile and ZipArchive extensions (normally in System.IO.Compression.FileSystem)
namespace System.IO.Compression
{
    public static class ZipFileExtensionsStub
    {
        public static void CreateEntryFromFile(this ZipArchive archive, string sourceFileName, string entryName)
        {
            // Stub: actual implementation provided by .NET Framework runtime
            using var stream = File.OpenRead(sourceFileName);
            var entry = archive.CreateEntry(entryName);
            using var entryStream = entry.Open();
            stream.CopyTo(entryStream);
        }
    }

    public static class ZipFile
    {
        public static void ExtractToDirectory(string sourceArchiveFileName, string destinationDirectoryName)
        {
            // Stub: actual implementation provided by .NET Framework runtime
        }
    }
}