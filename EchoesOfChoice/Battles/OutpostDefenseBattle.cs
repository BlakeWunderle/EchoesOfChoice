using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class OutpostDefenseBattle : Battle
    {
        public OutpostDefenseBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Shade() { CharacterName = "Umbra" });
            Enemies.Add(new Wraith() { CharacterName = "Revenant" });
            Enemies.Add(new Shade() { CharacterName = "Penumbra" });
            Enemies.Add(new Wraith() { CharacterName = "Specter" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new MirrorBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The shadows dissolve into wisps of dark smoke, but the unnatural cold lingers in the air.");
            Console.WriteLine("The outpost scouts return from the perimeter. They found something while the party fought — a mirror, propped against a tree at the edge of camp.");
            Console.WriteLine("Clean, polished, completely out of place. Its surface reflects the firelight but nothing else. No faces, no trees, no sky.");
            Console.WriteLine("Someone put it there. Someone who knew the party would come this way.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Night falls at the outpost and the temperature drops unnaturally fast. Breath turns to fog. The campfires gutter and dim as though something is pulling the warmth out of the air.");
            Console.WriteLine("Two shapes materialize from the darkness at the edge of the firelight. Not animals. Not people. Shadows with substance.");
            Console.WriteLine("They move without sound, drifting toward the camp with purpose. The first real sign that something beyond nature is at work.");
            Console.WriteLine("Weapons won't help much against things without bodies. But the party has to try.");
        }
    }
}
