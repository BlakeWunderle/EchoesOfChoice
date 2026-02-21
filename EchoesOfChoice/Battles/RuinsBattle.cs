using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class RuinsBattle : Battle
    {
        public RuinsBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>()
            {
                new Shade() { CharacterName = "Umbra" },
                new Shade() { CharacterName = "Nyx" },
                new Shade() { CharacterName = "Vesper" }
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
            Console.WriteLine("As the last shade dissolves, the glow at the heart of the ruins intensifies.");
            Console.WriteLine("A shimmering portal pulses among the broken stones, beckoning the adventurers forward.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Following a faint glow to the southwest, the party finds crumbling stone ruins overtaken by vines.");
            Console.WriteLine("The air is cold here, colder than it should be. Every breath comes out as mist.");
            Console.WriteLine("Dark shapes rise from the broken stones, their forms flickering between shadow and something almost human.");
        }
    }
}
