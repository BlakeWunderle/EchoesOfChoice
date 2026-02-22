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
            NextBattle = new WildernessOutpost(Units);
            NextBattle.PreviousBattleName = GetType().Name;
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
            Console.WriteLine();
            Console.WriteLine("That was Hell. Actually, genuinely Hell.");
            Console.WriteLine("The stranger said to find the source of the darkness. A portal to a demon realm isn't nothing — but it felt more like a wound than an origin. Something out here is still wrong.");
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
