using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class BlightBattle : Battle
    {
        public BlightBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Dragon() { CharacterName = "Vexaris" });
            Enemies.Add(new BlightedStag() { CharacterName = "Withered Crown" });
            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            Console.WriteLine();
            Console.WriteLine("The trail to the stranger narrows. Two paths remain:");
            Console.WriteLine("  [Gate]    The old city gate has been sealed by dark magic. An armored figure stands guard.");
            Console.WriteLine("  [Depths]  Below the city, something skitters in the tunnels. The stranger's last line of defense.");

            while (NextBattle == null)
            {
                Console.WriteLine("Please type 'Gate' or 'Depths' and press enter.");
                var choice = (Console.ReadLine() ?? "").ToLower().Trim();
                switch (choice)
                {
                    case "gate":
                        NextBattle = new GateBattle(Units);
                        break;
                    case "depths":
                        NextBattle = new DepthsBattle(Units);
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
            Console.WriteLine("The dragon crashes to the earth and the stag collapses. The blight begins to recede from the edges of the field, but the center remains poisoned.");
            Console.WriteLine("The stranger's power is waning, but they still have defenses.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The eastern fields have become a wasteland. Crops are ash, the ground cracked and oozing.");
            Console.WriteLine("A dragon circles overhead, scales dulled by corruption. Below it, a stag twice its natural size staggers forward, its antlers dripping with blight.");
            Console.WriteLine("Both have been twisted by the stranger's magic.");
        }
    }
}
