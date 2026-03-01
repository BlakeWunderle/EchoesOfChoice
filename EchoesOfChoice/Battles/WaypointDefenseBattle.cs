using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class WaypointDefenseBattle : Battle
    {
        public WaypointDefenseBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Bandit() { CharacterName = "Riggs" });
            Enemies.Add(new Goblin() { CharacterName = "Snitch" });
            Enemies.Add(new Hound() { CharacterName = "Fang" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new ForestWaypoint(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The bandit scrambles out the back window and his goblin accomplice follows. The hound whimpers and bolts after them.");
            Console.WriteLine("The innkeeper steps out from behind the counter, shaken but unhurt. She thanks the party profusely.");
            Console.WriteLine("'You saved my life. Least I can do is open the storeroom.'");
            Console.WriteLine("Inside are supplies that seem almost too useful — rations, bandages, a few weapons in good condition — as though someone knew help would arrive.");
            Console.WriteLine("The stranger mentions quietly that they've been here before. They don't elaborate.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The party reaches a waypoint inn called 'The Wanderer's Rest' but something is wrong.");
            Console.WriteLine("The front door is smashed open. Inside, a bandit has the innkeeper cornered behind the counter while his goblin accomplice rifles through the shelves.");
            Console.WriteLine("A hound snarls at the doorway, hackles raised, blocking the exit.");
            Console.WriteLine("The party draws weapons. Time to clear the inn.");
        }
    }
}
