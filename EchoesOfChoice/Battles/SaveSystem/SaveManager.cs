using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;

namespace EchoesOfChoice.Battles.SaveSystem
{
    public static class SaveManager
    {
        private static readonly string SaveFilePath = Path.Combine(
            AppDomain.CurrentDomain.BaseDirectory, "savegame.json");

        private static readonly JsonSerializerOptions JsonOptions = new JsonSerializerOptions
        {
            WriteIndented = true
        };

        public static void Save(Battle nextBattle, List<BaseFighter> units)
        {
            try
            {
                var saveData = new GameSaveData
                {
                    CurrentBattle = BattleFactory.GetBattleName(nextBattle),
                    Party = units.Select(u => u.ToSaveData()).ToList()
                };

                var json = JsonSerializer.Serialize(saveData, JsonOptions);
                File.WriteAllText(SaveFilePath, json);
            }
            catch (Exception ex)
            {
                Console.WriteLine();
                Console.WriteLine($"Warning: Could not save your progress. ({ex.Message})");
            }
        }

        public static GameSaveData Load()
        {
            try
            {
                var json = File.ReadAllText(SaveFilePath);
                return JsonSerializer.Deserialize<GameSaveData>(json);
            }
            catch (Exception)
            {
                Console.WriteLine("Save file is corrupted or unreadable. It will be removed.");
                DeleteSave();
                return null;
            }
        }

        public static bool HasSaveFile()
        {
            return File.Exists(SaveFilePath);
        }

        public static void DeleteSave()
        {
            if (File.Exists(SaveFilePath))
            {
                File.Delete(SaveFilePath);
            }
        }
    }
}
