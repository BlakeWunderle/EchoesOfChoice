using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Enemies;
namespace EchoesOfChoice.Battles
{
    public class BeachBattle : Battle
    {
        public BeachBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Captain() { CharacterName = "Greybeard" });
            Enemies.Add(new Pirate() { CharacterName = "Flint" });
            Enemies.Add(new Pirate() { CharacterName = "Bonny" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new WildernessOutpost(Units);
            NextBattle.PreviousBattleName = GetType().Name;
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("With the pirate crew defeated the adventurers claim the ship's hold for themselves.");
            Console.WriteLine("Among the crates and barrels they find supplies worth taking. Not treasure, but enough to keep going.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The beach opens up and a wrecked ship juts out of the shallows, its hull split wide open.");
            Console.WriteLine("A tattered flag still clings to the mast, snapping in the wind. The adventurers wade out and begin searching the wreck.");
            Console.WriteLine("Crates of supplies and glittering trinkets spill from the hold. Not a bad find.");
            Console.WriteLine("That is until a voice bellows from the rocks above. 'That is our treasure!' A pirate crew drops down and the ambush begins.");
        }
    }
}
