using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Enemies;
using System.Linq;

namespace EchoesOfChoice.Battles
{
    public class PortalBattle : Battle
    {
        public PortalBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Hellion() { CharacterName = "Abyzou" });
            Enemies.Add(new Fiendling() { CharacterName = "Malphas" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            Console.WriteLine();
            Console.WriteLine("With Hell behind them the adventurers take stock of their surroundings. Two paths lead away from the portal site.");
            Console.WriteLine("  - To the North, the air hums with static and something metallic glints on the horizon.");
            Console.WriteLine("  - To the South, the faint sound of marching boots and a barking voice echo across the plains.");

            while (NextBattle == null)
            {
                Console.WriteLine("Please type 'North' or 'South' and press enter.");
                var nextBattle = (Console.ReadLine() ?? "").ToLower().Trim();

                switch (nextBattle)
                {
                    case "north": NextBattle = new LabBattle(Units); break;
                    case "south": NextBattle = new ArmyBattle(Units); break;
                    default:
                        Console.WriteLine("That's not a valid direction. Try again.");
                        break;
                }
            }
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The demon falls and the hellscape shudders. Behind its remains the portal flickers back to life.");
            Console.WriteLine("The adventurers don't need to be told twice. They dive through and hit solid ground on the other side.");
            Console.WriteLine("Fresh air. Green trees. Never thought dirt would smell so good.");
            Console.WriteLine("Scattered around the portal's landing are items left behind by whoever came through before them.");
            var newUnits = new List<BaseFighter>();

            foreach (var unit in Units)
            {
                Console.WriteLine();
                Console.WriteLine($"{unit.CharacterName} the {unit.CharacterType} picks up something from the ground: ");
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
            Console.WriteLine("The portal snaps shut behind them and the world changes. The sky is a churning red and the ground is scorched black.");
            Console.WriteLine("The air reeks of sulfur and every breath burns. Wailing echoes from somewhere far below as rivers of molten rock carve through the landscape.");
            Console.WriteLine("This is not a place meant for the living.");
            Console.WriteLine("The ground cracks open and a towering figure pulls itself free, wreathed in hellfire and grinning with far too many teeth.");
            Console.WriteLine("No words. No warning. It charges.");
        }
    }
}
