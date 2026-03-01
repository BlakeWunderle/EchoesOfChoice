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
            Enemies.Add(new Ruffian() { CharacterName = "Jenna" });
            Enemies.Add(new Pickpocket() { CharacterName = "Ella" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new WolfForestBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The street gang scatters into the alleyways and the party dusts themselves off.");
            Console.WriteLine("The stranger nods approvingly. 'See? The darkness is already here, in the city itself. Imagine what waits beyond the walls.'");
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
