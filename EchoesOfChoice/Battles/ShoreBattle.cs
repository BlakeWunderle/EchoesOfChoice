using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ShoreBattle : Battle
    {
        public ShoreBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>()
            {
                new Siren() { CharacterName = "Lorelei" },
                new Siren() { CharacterName = "Thalassa" },
                new Siren() { CharacterName = "Ligeia" }
            };

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new BeachBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("With the sirens defeated, the singing fades and the tide recedes.");
            Console.WriteLine("A sandy beach stretches out ahead, and in the distance the wreck of a ship juts from the shallows.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The salt air hit them before the trees even thinned. Following it southeast, the forest gives way to rocky cliffs and the sound of surf crashing far below.");
            Console.WriteLine("A strange singing drifts across the water, beautiful enough to stop everyone in their tracks.");
            Console.WriteLine("Three figures emerge from the tide pools, their haunting melody turning hostile as the adventurers draw near.");
        }
    }
}
