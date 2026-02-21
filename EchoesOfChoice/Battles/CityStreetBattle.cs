using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class CityStreetBattle : Battle
    {
        public CityStreetBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Thug() { CharacterName = "Alexander" });
            Enemies.Add(new Thug() { CharacterName = "Jenna" });
            Enemies.Add(new Thug() { CharacterName = "Ella" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new ForestBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The urchins scatter into the alleyways and our heroes dust themselves off.");
            Console.WriteLine("The stranger's words echo in their minds. Something evil waits beyond the forest and they intend to find it.");
            Console.WriteLine("They push through the city gate and the tree line swallows the road ahead.");
            foreach(var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Our newly formed party leaves the tavern happy and full of drink and food, ready to set out on an adventure.");
            Console.WriteLine("The city streets are quiet this late at night. Lanterns flicker along the cobblestone road toward the forest gate.");
            Console.WriteLine("A little too quiet. After walking a few blocks a handful of street urchins step out of the shadows and surround the party.");
            Console.WriteLine("Looks like the adventure is starting early.");
        }
    }
}
