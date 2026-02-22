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
            Console.WriteLine("Someone put it here on purpose. Someone who knew they'd be passing through.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Heading south, the landscape opens up into a wide plain. It should be empty. It isn't.");
            Console.WriteLine("Rows of canvas tents stretch out ahead, fires burning in careful formation. A booming voice cuts through the air, barking orders. This is no bandit camp — it's a regiment, moving with discipline.");
            Console.WriteLine("The scouts spot the party before they can pull back. A commander's voice rings out and the regiment wheels toward them.");
        }
    }
}
