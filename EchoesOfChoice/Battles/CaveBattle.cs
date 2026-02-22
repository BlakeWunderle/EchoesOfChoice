using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Enemies;
using System.Linq;

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
            Console.WriteLine("The dragon crashes to the ground and the cave falls silent. Nothing but the sound of gold coins sliding off the beast's scales.");
            Console.WriteLine("With the hoard laid bare, each adventurer digs through the treasure and finds something that calls to them.");
            var newUnits = new List<BaseFighter>();

            foreach (var unit in Units)
            {
                Console.WriteLine();
                Console.WriteLine($"{unit.CharacterName} the {unit.CharacterType} pulls something from the hoard: ");
                foreach (var upgradeItem in unit.UpgradeItems)
                {
                    Console.WriteLine(upgradeItem);
                }
                UpgradeItemEnum item;
                while (true)
                {
                    Console.WriteLine("Which item will you take? Type your option and press enter.");
                    var line = (Console.ReadLine() ?? "").ToLower().Trim();
                    var match = unit.UpgradeItems.FirstOrDefault(x => x.ToString().ToLower() == line);
                    if (line.Length > 0 && unit.UpgradeItems.Any(x => x.ToString().ToLower() == line))
                    {
                        item = match;
                        break;
                    }
                    Console.WriteLine("That's not a valid item. Try again.");
                }

                var newUnit = unit.UpgradeClass(item);
                newUnit.IncreaseLevel();

                Console.WriteLine($"{newUnit.CharacterName} is now a {newUnit.CharacterType}!");
                newUnits.Add(newUnit);
            }

            Units = newUnits;
            Console.WriteLine();
            Console.WriteLine("Twin dragons, ancient and territorial. Not the source — but old creatures don't settle near nothing. Something stirred them. Something darker than treasure hunters.");
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
