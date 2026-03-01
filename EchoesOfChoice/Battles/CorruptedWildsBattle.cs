using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class CorruptedWildsBattle : Battle
    {
        public CorruptedWildsBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Demon() { CharacterName = "Bael" });
            Enemies.Add(new CorruptedTreant() { CharacterName = "Rothollow" });
            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            Console.WriteLine();
            Console.WriteLine("Two threats remain:");
            Console.WriteLine("  [Temple]  A corrupted temple on the hill radiates hellfire. Something infernal has moved in.");
            Console.WriteLine("  [Blight]  The eastern fields are rotting. A massive creature stalks the blighted land.");

            while (NextBattle == null)
            {
                Console.WriteLine("Please type 'Temple' or 'Blight' and press enter.");
                var choice = (Console.ReadLine() ?? "").ToLower().Trim();
                switch (choice)
                {
                    case "temple":
                        NextBattle = new TempleBattle(Units);
                        break;
                    case "blight":
                        NextBattle = new BlightBattle(Units);
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
            Console.WriteLine("The demon dissolves into smoke and the treant splinters apart. The corruption recedes slightly but the land remains scarred.");
            Console.WriteLine("Somewhere deeper, more darkness stirs. Survivors found sheltering in a cave point toward the next crisis.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The wilderness has turned against itself. Trees twist into unnatural shapes, their bark blackened and weeping sap.");
            Console.WriteLine("A demon perches on a corrupted treant as if riding a throne. The forest groans with every step the treant takes.");
        }
    }
}
