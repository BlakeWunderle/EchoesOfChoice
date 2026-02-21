using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Enemies;

namespace EchoesOfChoice.Battles
{
    public class ArmyBattle : Battle
    {
        public ArmyBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Commander() { CharacterName = "Varro" });
            Enemies.Add(new Draconian() { CharacterName = "Theron" });
            Enemies.Add(new Chaplain() { CharacterName = "Cristole" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
                NextBattle = new MirrorBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The regiment scatters and the commander's voice goes silent. Tents flap in the wind, abandoned.");
            Console.WriteLine("Among the scattered supplies and overturned crates the party spots something that doesn't belong.");
            Console.WriteLine("A mirror, sitting upright in the dirt, untouched by the chaos around it. Its surface gleams like it's brand new.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("After returning from Hell our adventurers travel to the South West.");
            Console.WriteLine("They encounter a series of tents and hear a booming voice shouting orders.");
            Console.WriteLine("A regiment descends upon them and they try to fight through it.");
        }
    }
}
