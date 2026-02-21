using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ClearingBattle : Battle
    {
        public ClearingBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>()
            {
                new Satyr() { CharacterName = "Sylvan" },
                new Nymph() { CharacterName = "Ondine" },
                new Pixie() { CharacterName = "Jinx" }
            };

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new CaveBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("With the fey defeated the enchantment shatters. The clearing flickers and fades like a candle going out.");
            Console.WriteLine("Where the stage once stood there's nothing but moss-covered stone and a narrow path leading downhill.");
            Console.WriteLine("The path winds into a rocky hillside where a cave mouth waits, half-hidden by overgrown vines.");
            Console.WriteLine("Claw marks line the entrance. Whatever calls this cave home isn't small.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Upon entering the clearing music begins to play. Songs are sung of travelers past, all to an upbeat note or two.");
            Console.WriteLine("The melody is catchy. A little too catchy. The adventurers' feet start moving on their own, pulled toward a makeshift stage.");
            Console.WriteLine("Fireworks shoot off behind the performers but they don't fade. They twist into chains of light that wrap around the party's wrists.");
            Console.WriteLine("The band's smiles stretch a bit too wide. This isn't a concert, it's a trap. Time to break the enchantment the hard way.");
        }
    }
}
