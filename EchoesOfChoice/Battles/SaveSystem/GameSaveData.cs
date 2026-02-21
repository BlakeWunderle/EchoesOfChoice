using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles.SaveSystem
{
    public class GameSaveData
    {
        public string CurrentBattle { get; set; }
        public List<FighterSaveData> Party { get; set; } = new List<FighterSaveData>();
    }
}
