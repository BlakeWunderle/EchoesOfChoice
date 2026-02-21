using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class SmokeBattle : Battle
    {
        public SmokeBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>()
            {
                new Imp() { CharacterName = "Vex" },
                new Imp() { CharacterName = "Gror" },
                new Imp() { CharacterName = "Pyx" }
            };

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new PortalBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("After defeating the imps, the flames die down to embers.");
            Console.WriteLine("Behind where the fire burned brightest, a shimmering portal pulses with a dark energy.");
            Console.WriteLine("With no other path forward, the adventurers steel themselves and step through.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("As the travelers journey toward the smoke they begin to notice lights flickering between the trees.");
            Console.WriteLine("Cackling and the sound of tiny feet fill the air. Three small beings huddle around a growing fire, feeding it anything they can grab.");
            Console.WriteLine("The warriors step out of the brush and the imps spin around with wicked grins. So much for a quiet approach.");
        }
    }
}
