using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace EchoesOfChoice.Battles
{
    public class ForestWaypoint : Battle
    {
        public ForestWaypoint(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            IsFinalBattle = false;
            IsTownStop = true;
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("A small waypoint inn appears at a crossroads, barely holding itself together. The sign over the door reads 'The Wanderer's Rest.'");
            Console.WriteLine("The innkeeper, a weathered woman who looks like she hasn't slept in weeks, waves them inside.");
            Console.WriteLine("'You saved my inn. Least I can do is open the storeroom. Take what you need.'");
            Console.WriteLine();

            var newUnits = new List<BaseFighter>();

            foreach (var unit in Units)
            {
                Console.WriteLine();
                Console.WriteLine($"{unit.CharacterName} the {unit.CharacterType} searches the storeroom and finds: ");
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
            Console.WriteLine("The innkeeper leans on the counter. 'Three roads lead out from here. None of them are safe.'");
            Console.WriteLine("'West, the highlands. Raiders and worse up in those rocks.'");
            Console.WriteLine("'North, the old growth forest. Witch work — circles of stones and sticks. The trees don't feel right.'");
            Console.WriteLine("'East, the rocky shore. The singing from the water isn't safe. Never was.'");
            Console.WriteLine("She refills her cup. 'A stranger passed through last week. Paid in gold that turned out to be blank on one side. Said the source of it all was out here somewhere.'");
        }

        public override void PostBattleInteraction() { }

        public override void DetermineNextBattle()
        {
            Console.WriteLine();
            Console.WriteLine("Three paths lead out from the crossroads:");
            Console.WriteLine("  [West]   The trail climbs into wind-battered highlands. Cairns mark the way.");
            Console.WriteLine("  [North]  The trees grow older and darker. The light barely reaches the ground.");
            Console.WriteLine("  [East]   Salt in the air and the sound of surf. Rocky cliffs line the coast.");

            while (NextBattle == null)
            {
                Console.WriteLine("Please type 'West', 'North', or 'East' and press enter.");
                var nextBattle = (Console.ReadLine() ?? "").ToLower().Trim();

                switch (nextBattle)
                {
                    case "west":
                        NextBattle = new HighlandBattle(Units);
                        NextBattle.PreviousBattleName = GetType().Name;
                        break;
                    case "north":
                        NextBattle = new DeepForestBattle(Units);
                        NextBattle.PreviousBattleName = GetType().Name;
                        break;
                    case "east":
                        NextBattle = new ShoreBattle(Units);
                        NextBattle.PreviousBattleName = GetType().Name;
                        break;
                    default:
                        Console.WriteLine("That's not a valid path. Try again.");
                        break;
                }
            }
        }
    }
}
