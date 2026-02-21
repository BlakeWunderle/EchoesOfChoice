using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ElementalBattle3 : Battle
    {
        public ElementalBattle3(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new AirElemental() { CharacterName = "Aero" });
            Enemies.Add(new WaterElemental() { CharacterName = "Undine" });

            foreach (var enemy in Enemies)
            {
                enemy.Health -= 13;
                enemy.MaxHealth -= 13;
                enemy.PhysicalAttack -= 2;
                enemy.MagicAttack -= 2;
                enemy.DodgeChance -= 1;
            }

            IsFinalBattle = true;
        }

        public override void DetermineNextBattle()
        {
            
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The last elemental crashes to the ground and the winds die down to a breeze. The floodwaters drain through the cobblestones.");
            Console.WriteLine("One by one the citizens step out of their homes, blinking at the calm sky. Then the cheering starts.");
            Console.WriteLine("Despite the wreckage and the waterlogged streets, the city is alive. A parade forms, carrying our heroes on their shoulders.");
            Console.WriteLine("They look at each other and can't help but grin. They actually pulled it off.");
            Console.WriteLine("The stranger watches from a rooftop, gives a single nod, and disappears.");
            Console.WriteLine("This chapter ends, but something tells our heroes the story isn't over. Not by a long shot.");
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The city is in ruins. Buildings crumble, market stalls are overturned, and citizens flee through the streets screaming.");
            Console.WriteLine("Two massive elementals tower above the skyline. A howling gale rips through the city while a tidal wave crashes through the lower districts.");
            Console.WriteLine("The wind drives the water into a spiraling vortex that tears through anything standing.");
            Console.WriteLine("Everyone runs. Everyone except our heroes. They draw their weapons and charge.");
        }
    }
}
