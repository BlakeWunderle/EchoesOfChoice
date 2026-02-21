using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ElementalBattle1 : Battle
    {
        public ElementalBattle1(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new AirElemental() { CharacterName = "Aero" });
            Enemies.Add(new WaterElemental() { CharacterName = "Undine" });
            Enemies.Add(new FireElemental() { CharacterName = "Ember" });

            foreach (var enemy in Enemies)
            {
                enemy.Health -= 50;
                enemy.MaxHealth -= 50;
                enemy.PhysicalAttack -= 8;
                enemy.MagicAttack -= 8;
                enemy.PhysicalDefense -= 3;
                enemy.MagicDefense -= 3;
                enemy.Speed -= 4;
            }

            IsFinalBattle = true;
        }

        public override void DetermineNextBattle()
        {
            
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The last elemental crashes to the ground and the storm breaks apart. Sunlight cuts through the clouds for the first time in what feels like forever.");
            Console.WriteLine("One by one the citizens step out of their homes, blinking at the sky. Then the cheering starts.");
            Console.WriteLine("Despite the rubble and the flooding and the scorch marks, the city is alive. A parade forms in the streets, carrying our heroes on their shoulders.");
            Console.WriteLine("They look at each other and can't help but grin. They actually pulled it off.");
            Console.WriteLine("The stranger watches from a rooftop, gives a single nod, and disappears.");
            Console.WriteLine("This chapter ends, but something tells our heroes the story isn't over. Not by a long shot.");
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The city is in ruins. Buildings crumble, market stalls are overturned, and citizens flee through the streets screaming.");
            Console.WriteLine("Three massive elementals tower above the skyline. Wind tears the rooftops apart, water floods the lower streets, and fire engulfs everything it touches.");
            Console.WriteLine("The storm they create together is unlike anything the world has seen. Lightning, tidal waves, and fireballs rain down in all directions.");
            Console.WriteLine("Everyone runs. Everyone except our heroes. They draw their weapons and charge.");
        }
    }
}
