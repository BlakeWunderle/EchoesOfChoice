using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class DeepForestBattle : Battle
    {
        public DeepForestBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>()
            {
                new Witch() { CharacterName = "Morwen" },
                new Wisp() { CharacterName = "Flicker" },
                new Sprite() { CharacterName = "Briar" }
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
            Console.WriteLine("With the witch and her minions defeated the forest goes still. Too still.");
            Console.WriteLine("Thunder rolls overhead and rain begins to pour through the canopy. Up ahead a cave mouth gapes open in the hillside.");
            Console.WriteLine("Claw marks line the entrance and old bones crunch underfoot. Whatever lives in there is big.");
            Console.WriteLine("The party ducks inside for cover, hoping the storm passes before the cave's occupant returns.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Everyone walks up on a circle of sticks, stones, and mud. Everything around them begins to shake and levitate.");
            Console.WriteLine("The sticks catch fire and a strike of lightning flashes across the sky.");
            Console.WriteLine("A cackle and two screeches fill the air as the adventurers prepare for battle.");
        }
    }
}
