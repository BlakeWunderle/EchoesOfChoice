using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class StrangerTowerBattle : Battle
    {
        public StrangerTowerBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Stranger() { CharacterName = "The Stranger" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            Console.WriteLine();
            Console.WriteLine("The world fractures. Two crises demand attention:");
            Console.WriteLine("  [City]   The city center pulses with necrotic energy. The dead are rising.");
            Console.WriteLine("  [Wilds]  The wilderness writhes — trees twist and the ground bleeds darkness.");

            while (NextBattle == null)
            {
                Console.WriteLine("Please type 'City' or 'Wilds' and press enter.");
                var choice = (Console.ReadLine() ?? "").ToLower().Trim();
                switch (choice)
                {
                    case "city":
                        NextBattle = new CorruptedCityBattle(Units);
                        break;
                    case "wilds":
                        NextBattle = new CorruptedWildsBattle(Units);
                        break;
                    default:
                        Console.WriteLine("That's not a valid choice. Try again.");
                        break;
                }
            }
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The stranger staggers, dark energy bleeding from their wounds. But they don't fall.");
            Console.WriteLine("They press a hand to the wall and the sigils flare to life, every carved line burning white-hot.");
            Console.WriteLine("'This isn't over. The ritual is already complete.'");
            Console.WriteLine("The floor cracks open and shadow pours upward like smoke from a furnace. The stranger steps backward into the void and vanishes.");
            Console.WriteLine("The tower shudders. Dust rains from the ceiling and the stones groan.");
            Console.WriteLine("Outside, the sky has turned the color of ash. The horizon ripples like heat off a forge, but the air is cold.");
            Console.WriteLine("The world is breaking.");

            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The tower door stands open. Inside, the walls are covered in the same sigil from the forest — the circle with a slash through it — carved into every surface, floor to ceiling.");
            Console.WriteLine("The stranger stands at the center of the room, no longer pretending. No smile. No easy charm.");
            Console.WriteLine("'You served your purpose beautifully. Every battle, every mile — you carried my influence deeper into the wilds. The mirrors, the shadows, the chaos spreading across the land. All me.'");
            Console.WriteLine("The stranger's form shifts, darkness crackling around them like a storm contained in skin.");
            Console.WriteLine("'But I'm not done yet.'");
        }
    }
}
