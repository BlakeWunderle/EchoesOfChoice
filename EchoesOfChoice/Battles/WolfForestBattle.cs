using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class WolfForestBattle : Battle
    {
        public WolfForestBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Wolf() { CharacterName = "Greyfang" });
            Enemies.Add(new Boar() { CharacterName = "Tusker" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new WaypointDefenseBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The wolf limps away into the underbrush and the boar crashes off through the trees. Silence settles back over the camp.");
            Console.WriteLine("Inside the abandoned house the party finds the sigil they noticed earlier — a circle with a single slash through it, carved into the lid of a wooden chest.");
            Console.WriteLine("The wood around it is still warm to the touch, as though someone traced it minutes ago.");
            Console.WriteLine("The stranger glances at it but says nothing. If they recognize it, they aren't sharing.");
            Console.WriteLine("The road continues north. According to the stranger, a waypoint inn lies not far ahead.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The party follows the road deeper into the forest. The canopy thickens overhead until only slivers of moonlight reach the ground.");
            Console.WriteLine("As night falls they make camp near an abandoned house set back from the road. The door hangs open, the inside dark and still.");
            Console.WriteLine("Someone notices a strange sigil carved into a chest inside — a circle with a slash through it — but there's no time to investigate.");
            Console.WriteLine("During the night, growling and snorting wake the camp. A wolf and a boar emerge from the treeline, territorial and aggressive.");
            Console.WriteLine("No choice but to fight.");
        }
    }
}
