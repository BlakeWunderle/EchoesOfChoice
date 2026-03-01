using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class TempleBattle : Battle
    {
        public TempleBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Hellion() { CharacterName = "Ashara" });
            Enemies.Add(new Fiendling() { CharacterName = "Cinder" });
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
            Console.WriteLine("The hellfire dies and the temple goes dark. The stone cools slowly.");
            Console.WriteLine("Whatever portal was being opened here has collapsed — for now. But the stranger's influence runs deeper.");
            Console.WriteLine("One more threat must be dealt with before the final confrontation.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The old temple on the hill has been consumed by hellfire. Its walls glow red from within and the air shimmers with heat.");
            Console.WriteLine("Inside, a hellion stands at the altar channeling infernal energy while a fiendling scurries between the pews, setting everything ablaze.");
        }
    }
}
