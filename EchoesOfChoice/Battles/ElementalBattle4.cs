using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ElementalBattle4 : Battle
    {
        public ElementalBattle4(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new AirElemental() { CharacterName = "Aero" });
            Enemies.Add(new FireElemental() { CharacterName = "Ember" });

            foreach (var enemy in Enemies)
            {
                enemy.Health += 14;
                enemy.MaxHealth += 14;
                enemy.PhysicalAttack += 2;
                enemy.MagicAttack += 2;
            }

            IsFinalBattle = true;
        }

        public override void DetermineNextBattle()
        {
            
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The last elemental crashes to the ground and the firestorm dies. Smoke drifts upward and the wind fades to nothing.");
            Console.WriteLine("One by one the citizens step out of their homes, coughing through the haze. Then the cheering starts.");
            Console.WriteLine("Despite the ash and the scorched buildings, the city is alive. A parade forms in the streets, carrying our heroes on their shoulders.");
            Console.WriteLine("They look at each other and can't help but grin. They actually pulled it off.");
            Console.WriteLine("The stranger watches from a rooftop, gives a single nod, and disappears.");
            Console.WriteLine("This chapter ends, but something tells our heroes the story isn't over. Not by a long shot.");
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The city is in ruins. Buildings crumble, market stalls are overturned, and citizens flee through the streets screaming.");
            Console.WriteLine("Two massive elementals tower above the skyline. A roaring cyclone of wind feeds an inferno that swallows entire city blocks.");
            Console.WriteLine("Embers spiral through the air like a blizzard made of fire. The heat is unbearable even from a distance.");
            Console.WriteLine("Everyone runs. Everyone except our heroes. They draw their weapons and charge.");
        }
    }
}
