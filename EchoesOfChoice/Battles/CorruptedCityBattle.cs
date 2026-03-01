using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class CorruptedCityBattle : Battle
    {
        public CorruptedCityBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Lich() { CharacterName = "Mortuus" });
            Enemies.Add(new Ghast() { CharacterName = "Putrefax" });
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
            Console.WriteLine("The lich crumbles to dust and the ghast collapses. The necrotic energy fades but doesn't disappear — it's being fed from somewhere else.");
            Console.WriteLine("Among the ruins, survivors huddle in a basement. They speak of more horrors spreading.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The city center has become a necropolis. The dead walk openly, drawn by a lich that has claimed the old market square as its throne.");
            Console.WriteLine("The ground is cracked and leaking dark energy. A ghast lurches forward, its bulk blocking the road.");
        }
    }
}
