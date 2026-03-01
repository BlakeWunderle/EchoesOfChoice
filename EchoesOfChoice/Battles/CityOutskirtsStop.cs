using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace EchoesOfChoice.Battles
{
    public class CityOutskirtsStop : Battle
    {
        public CityOutskirtsStop(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            IsFinalBattle = false;
            IsTownStop = true;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new ReturnToCityStreetBattle(Units);
        }

        public override void PostBattleInteraction() { }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The party reaches the outskirts of the city. Something is wrong.");
            Console.WriteLine("Smoke rises from the market district and the streets are too quiet. No merchants calling out, no children running between the stalls.");
            Console.WriteLine("An old armory sits abandoned near the gate, its door hanging open. Inside, racks of weapons and armor gather dust — but not all of it.");
            Console.WriteLine("Each member of the party finds equipment that suits them perfectly, as if it were waiting for them.");

            var newUnits = new List<BaseFighter>();

            foreach (var unit in Units)
            {
                Console.WriteLine();
                Console.WriteLine($"{unit.CharacterName} the {unit.CharacterType} finds: ");
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
            Console.WriteLine("The city skyline looks wrong. Dark shapes move on the walls. Whatever happened here, it happened fast.");
        }
    }
}
