using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Enemies;
using System.Linq;

namespace EchoesOfChoice.Battles
{
    public class BeachBattle : Battle
    {
        public BeachBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Captain() { CharacterName = "Greybeard" });
            Enemies.Add(new Pirate() { CharacterName = "Flint" });
            Enemies.Add(new Pirate() { CharacterName = "Bonny" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            Console.WriteLine();
            Console.WriteLine("Leaving the shipwreck behind the adventurers spot two paths along the coastline.");
            Console.WriteLine("  - To the North, a winding trail leads inland where faint laughter and music drift through the trees.");
            Console.WriteLine("  - To the South, a fog-covered path disappears into rolling hills. The air smells of damp earth and something old.");

            while (NextBattle == null)
            {
                Console.WriteLine("Please type 'North' or 'South' and press enter.");
                var nextBattle = (Console.ReadLine() ?? "").ToLower().Trim();

                switch (nextBattle)
                {
                    case "north": NextBattle = new BoxBattle(Units); break;
                    case "south": NextBattle = new CemeteryBattle(Units); break;
                    default:
                        Console.WriteLine("That's not a valid direction. Try again.");
                        break;
                }
            }
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("With the pirate crew defeated the adventurers claim the ship's hold for themselves.");
            Console.WriteLine("Among the crates and barrels each of them finds something worth keeping.");
            var newUnits = new List<BaseFighter>();

            foreach (var unit in Units)
            {
                Console.WriteLine();
                Console.WriteLine($"{unit.CharacterName} the {unit.CharacterType} rummages through the hold and finds: ");
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
            Console.WriteLine("The beach opens up and a wrecked ship juts out of the shallows, its hull split wide open.");
            Console.WriteLine("A tattered flag still clings to the mast, snapping in the wind. The adventurers wade out and begin searching the wreck.");
            Console.WriteLine("Crates of supplies and glittering trinkets spill from the hold. Not a bad find.");
            Console.WriteLine("That is until a voice bellows from the rocks above. 'That is our treasure!' A pirate crew drops down and the ambush begins.");
        }
    }
}
