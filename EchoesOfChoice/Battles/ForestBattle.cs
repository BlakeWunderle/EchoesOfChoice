using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;
using System.Linq;

namespace EchoesOfChoice.Battles
{
    public class ForestBattle : Battle
    {
        public ForestBattle(List<BaseFighter> units) : base(units)
        {
            
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Bear() { CharacterName = "Koda" });
            Enemies.Add(new BearCub() { CharacterName = "Bramble" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new ForestWaypoint(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("While walking through the woods the adventurers stumble upon what looks like an old house. They knock.");
            Console.WriteLine("No answer, but the door comes slightly ajar. They enter and begin looking around.");
            Console.WriteLine("Inside, each of them finds a dusty chest tucked against the walls. The locks are rusted but give way easily.");
            Console.WriteLine("Each chest holds relics of a past adventurer. Time to pick something useful.");
            var newUnits = new List<BaseFighter>();

            foreach (var unit in Units)
            {
                Console.WriteLine();
                Console.WriteLine($"{unit.CharacterName} the {unit.CharacterType} opens their chest and finds: ");
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
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Upon making it to the forest the party looks to set up their camp. They get a fire going, make supper and pitch their tents.");
            Console.WriteLine("After telling stories of past adventures, the party passes out for the night. Before going to bed though everyone forgot to hang up the food.");
            Console.WriteLine("After drifting off to sleep they hear something intruding in the camp. A mother bear and her cub have come looking for an easy meal.");
        }
    }
}
