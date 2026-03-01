using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Enemies;
namespace EchoesOfChoice.Battles
{
    public class CaveBattle : Battle
    {
        public CaveBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new FireWyrmling() { CharacterName = "Raysses" });
            Enemies.Add(new FrostWyrmling() { CharacterName = "Sythara" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new WildernessOutpost(Units);
            NextBattle.PreviousBattleName = GetType().Name;
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The wyrmlings crash to the ground and the cave falls silent. Nothing but the sound of gold coins sliding off their scales.");
            Console.WriteLine("Twin dragons, ancient and territorial. Not the source — but old creatures don't settle near nothing. Something stirred them. Something darker than treasure hunters.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("After entering the cave the adventurers notice gold everywhere. Coins, goblets, and jewels are heaped in massive mounds that glitter in the dim light.");
            Console.WriteLine("The cave begins to darken as a shadow larger than anything they've seen stretches across the walls.");
            Console.WriteLine($"A solemn voice speaks a grave warning before a fireball is shot in the direction of {Units[0].CharacterName}.");
        }
    }
}
