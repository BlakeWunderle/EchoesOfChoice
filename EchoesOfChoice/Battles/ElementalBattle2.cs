using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ElementalBattle2 : Battle
    {
        public ElementalBattle2(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new WaterElemental() { CharacterName = "Undine" });
            Enemies.Add(new FireElemental() { CharacterName = "Ember" });

            foreach (var enemy in Enemies)
            {
                enemy.Health -= 18;
                enemy.MaxHealth -= 18;
                enemy.PhysicalAttack -= 2;
                enemy.MagicAttack -= 3;
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
            Console.WriteLine("The last elemental crashes to the ground and the chaos subsides. Steam drifts through the streets as the fires die and the water recedes.");
            Console.WriteLine("One by one the citizens step out of their homes, blinking at the sky. Then the cheering starts.");
            Console.WriteLine("Despite the flooding and the scorch marks, the city is alive. A parade forms in the streets, carrying our heroes on their shoulders.");
            Console.WriteLine("They look at each other and can't help but grin. They actually pulled it off.");
            Console.WriteLine("The stranger watches from a rooftop, gives a single nod, and disappears.");
            Console.WriteLine("This chapter ends, but something tells our heroes the story isn't over. Not by a long shot.");
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The city is in ruins. Buildings crumble, market stalls are overturned, and citizens flee through the streets screaming.");
            Console.WriteLine("Two massive elementals tower above the skyline. Water surges through the streets in violent waves while fire consumes everything the flood doesn't reach.");
            Console.WriteLine("Steam erupts where the two forces collide, scalding the air and cracking the cobblestones.");
            Console.WriteLine("Everyone runs. Everyone except our heroes. They draw their weapons and charge.");
        }
    }
}
