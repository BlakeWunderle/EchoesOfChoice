using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ReturnToCityStreetBattle : Battle
    {
        public ReturnToCityStreetBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new RoyalGuard() { CharacterName = "Aldric" });
            Enemies.Add(new GuardSergeant() { CharacterName = "Brennan" });
            Enemies.Add(new GuardArcher() { CharacterName = "Tamsin" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new StrangerTowerBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The guards collapse, released from whatever held them. Their eyes clear and they stare at their own drawn weapons in confusion.");
            Console.WriteLine("The party pushes deeper into the city. Most doors are barred, most windows dark.");
            Console.WriteLine("At The Copper Mug tavern, the barkeep is hiding behind the counter. He peers over the edge when the door opens.");
            Console.WriteLine("'Your friend? The stranger? He went to the tower. Always paid in that weird coin — blank on one side. I should have known something was wrong.'");
            Console.WriteLine("The tower looms ahead, its peak lost in a sky that shouldn't be that dark this time of day.");

            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The party enters the city and finds it changed. The streets are empty, shops shuttered. Lanterns that once lit the cobblestone roads hang dark and cold.");
            Console.WriteLine("The royal guard — the city's protectors — block their path with weapons drawn. Their eyes are glazed, their movements mechanical. They don't speak. They don't blink.");
            Console.WriteLine("Someone is controlling them. The stranger is nowhere to be seen.");
        }
    }
}
